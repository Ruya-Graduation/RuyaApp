import 'package:dio/dio.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/site_details/data/models/site_detail_model.dart';

abstract class SiteDetailRemoteDataSource {
  Future<SiteDetailModel> getSiteById(String id);
}

class SiteDetailRemoteDataSourceImpl implements SiteDetailRemoteDataSource {
  final Dio _dio;
  const SiteDetailRemoteDataSourceImpl(this._dio);

  @override
  Future<SiteDetailModel> getSiteById(String id) async {
    try {
      final response = await _dio.get('/AdminSites/$id');
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /AdminSites/{id}.',
        );
      }
      final rawData = body['data'];
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" to be an object in /AdminSites/{id} response.',
        );
      }
      return SiteDetailModel.fromJson(rawData);
    } on DioException catch (e) {
      throw e.error as ApiException? ??
          ApiException(statusCode: -1, message: e.message ?? 'Unknown error');
    }
  }
}
