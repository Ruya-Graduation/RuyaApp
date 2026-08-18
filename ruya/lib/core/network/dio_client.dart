import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ruya/core/config/app_config.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/core/session/token_local_data_source.dart';

/// Singleton [Dio] client pre-configured for the Ruya backend.
///
/// Responsibilities:
/// - Base URL = [AppConfig.baseUrl] + `/api`
/// - Sane timeouts (15 s connect, 10 s receive)
/// - Auth interceptor: attaches `Authorization: Bearer <token>` when a token
///   is stored. This is a no-op for the public auth endpoints; it future-proofs
///   any authenticated calls without extra work per request.
/// - Error interceptor: normalises **both** backend error shapes into
///   [ApiException] so callers never touch raw Dio details:
///     1. Envelope `{success: false, message: "..."}` → [ApiException]
///     2. `ValidationProblemDetails` (ASP.NET model-validation short-circuit)
///        → [ApiException] with [ApiException.fieldErrors] populated
/// - Debug-only [LogInterceptor]: never logs in release builds (bodies contain
///   passwords).
class DioClient {
  DioClient._();

  static Dio? _instance;

  /// Returns (and lazily constructs) the singleton [Dio] instance.
  ///
  /// [tokenDataSource] must be the same singleton registered in the DI
  /// container so the auth interceptor reads the current token.
  static Dio getInstance(TokenLocalDataSource tokenDataSource) {
    _instance ??= _build(tokenDataSource);
    return _instance!;
  }

  static Dio _build(TokenLocalDataSource tokenDataSource) {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.baseUrl}/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        responseType: ResponseType.json,
        followRedirects: true,
        maxRedirects: 5,
      ),
    );

    // ── Auth interceptor ─────────────────────────────────────────────────────
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenDataSource.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // ── Error interceptor ────────────────────────────────────────────────────
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: _normalise(error),
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );

    // ── Debug-only logging ───────────────────────────────────────────────────
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (o) => debugPrint('[DioClient] $o'),
        ),
      );
    }

    return dio;
  }

  /// Converts a [DioException] into an [ApiException] by inspecting the
  /// response body and handling the two distinct backend error shapes.
  static ApiException _normalise(DioException error) {
    // No response at all (network/timeout/DNS failure)
    if (error.response == null) {
      return ApiException(
        statusCode: -1,
        message: _networkMessage(error),
      );
    }

    final statusCode = error.response!.statusCode ?? -1;
    final data = error.response!.data;

    // ── Shape 1: Business-rule envelope {success, message, data, errors} ─────
    if (data is Map<String, dynamic> && data.containsKey('success')) {
      final msg = data['message'] as String? ?? 'An unexpected error occurred.';
      return ApiException(statusCode: statusCode, message: msg);
    }

    // ── Shape 2: ASP.NET ValidationProblemDetails ────────────────────────────
    // Has a top-level "errors" map with field → [messages] entries.
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final rawErrors = data['errors'];
      Map<String, List<String>> fieldErrors = {};

      if (rawErrors is Map<String, dynamic>) {
        rawErrors.forEach((field, value) {
          if (value is List) {
            fieldErrors[field] = value.map((e) => e.toString()).toList();
          }
        });
      }

      // Flatten all field error messages into one readable summary.
      final allMessages = fieldErrors.values.expand((e) => e).toList();
      final summary = allMessages.isNotEmpty
          ? allMessages.join(' ')
          : (data['title'] as String? ?? 'Validation error.');

      return ApiException(
        statusCode: statusCode,
        message: summary,
        fieldErrors: fieldErrors,
      );
    }

    // ── Fallback ─────────────────────────────────────────────────────────────
    return ApiException(
      statusCode: statusCode,
      message: error.message ?? 'An unexpected error occurred.',
    );
  }

  static String _networkMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please check your connection and try again.';
      case DioExceptionType.connectionError:
        return 'Could not reach the server. Please check your internet connection.';
      default:
        return error.message ?? 'A network error occurred.';
    }
  }
}
