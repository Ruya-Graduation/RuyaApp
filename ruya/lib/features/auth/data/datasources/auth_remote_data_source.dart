import 'package:dio/dio.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/auth/data/models/otp_verification_result.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

/// Data source for auth-related HTTP calls.
///
/// `signInRaw` and `registerRaw` return the raw JWT string from the server
/// so the repository can both persist it AND decode it — two responsibilities
/// that belong to the repository, not the data source.
///
/// The three forgot-password methods map to the three backend endpoints:
/// `forgot-password` → `verify-otp` → `reset-password`.
abstract class AuthRemoteDataSource {
  /// Returns the raw JWT string from `/api/Auth/login`.
  Future<String> signInRaw({
    required String email,
    required String password,
  });

  /// Returns the raw JWT string from `/api/Auth/register`.
  Future<String> registerRaw({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
    required String knowledgeLevel,
  });

  /// POST `/api/Auth/forgot-password` — always succeeds server-side even if
  /// the email doesn't exist (backend response is intentionally ambiguous).
  Future<void> forgotPassword({required String email});

  /// POST `/api/Auth/verify-otp` — returns [OtpVerificationResult] containing
  /// the opaque `resetToken` needed for the final reset step.
  Future<OtpVerificationResult> verifyOtp({
    required String email,
    required String code,
  });

  /// POST `/api/Auth/reset-password`.
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });
}

// ---------------------------------------------------------------------------
// Real implementation
// ---------------------------------------------------------------------------

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<String> signInRaw({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/login',
        data: {'email': email, 'password': password},
      );
      return _extractToken(response.data, 'login');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<String> registerRaw({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
    required String knowledgeLevel,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/register',
        data: {
          'userName': name,
          'email': email,
          'password': password,
          'preferredLanguage': preferredLanguage,
          'knowledgeLevel': knowledgeLevel,
        },
      );
      return _extractToken(response.data, 'register');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _dio.post('/Auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<OtpVerificationResult> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/verify-otp',
        data: {'email': email, 'code': code},
      );
      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from verify-otp.',
        );
      }
      return OtpVerificationResult(
        resetToken: data['resetToken']?.toString() ?? '',
        expiresInSeconds: (data['expiresInSeconds'] as num?)?.toInt() ?? 300,
      );
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _dio.post(
        '/Auth/reset-password',
        data: {
          'email': email,
          'resetToken': resetToken,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Extracts the raw JWT string from the `data` field of the response envelope.
  /// Throws [ApiException] if the shape is unexpected (would indicate a
  /// backend contract change).
  String _extractToken(dynamic body, String operation) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is String && data.isNotEmpty) return data;
    }
    throw ApiException(
      statusCode: 200,
      message: 'Unexpected response format from $operation: '
          'expected data to be a non-empty string (JWT).',
    );
  }

  /// Unwraps the [ApiException] previously attached by [DioClient]'s error
  /// interceptor, or creates a generic one if it's missing.
  ApiException _wrap(DioException e) {
    return e.error as ApiException? ??
        ApiException(statusCode: -1, message: e.message ?? 'Unknown error');
  }
}
