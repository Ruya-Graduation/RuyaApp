import 'package:dio/dio.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/home/data/models/monument_model.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

/// Data source that fetches monument/site data from the remote API.
///
/// Implementations call `GET /AdminSites` and return a list of
/// [MonumentModel] objects. Errors are intentionally NOT caught here —
/// [DioClient]'s error interceptor normalises all [DioException]s into
/// [ApiException] before they reach this layer, and the repository
/// ([MonumentRepositoryImpl]) converts those into the appropriate [Failure].
abstract class MonumentRemoteDataSource {
  /// Fetches the full list of sites from the API.
  Future<List<MonumentModel>> getMonuments();
}

// ---------------------------------------------------------------------------
// Real implementation
// ---------------------------------------------------------------------------

class MonumentRemoteDataSourceImpl implements MonumentRemoteDataSource {
  final Dio _dio;

  const MonumentRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MonumentModel>> getMonuments() async {
    try {
      final response = await _dio.get('/AdminSites');

      // The backend wraps all responses in:
      //   { "success": true, "message": "...", "data": [...] }
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /AdminSites.',
        );
      }

      final rawData = body['data'];
      if (rawData == null) return [];

      if (rawData is! List) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" to be a list in /AdminSites response.',
        );
      }

      return rawData
          .whereType<Map<String, dynamic>>()
          .map(MonumentModel.fromJson)
          .toList();
    } on DioException catch (e) {
      // Re-throw the ApiException that DioClient's interceptor attached.
      throw e.error as ApiException? ??
          ApiException(statusCode: -1, message: e.message ?? 'Unknown error');
    }
  }
}
