import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/moments/data/models/moment_album_details_model.dart';
import 'package:ruya/features/moments/data/models/moment_album_model.dart';

abstract class MomentsRemoteDataSource {
  Future<List<MomentAlbumModel>> getAlbums();
  Future<MomentAlbumDetailsModel> getAlbumById(int albumId);
  Future<MomentAlbumModel> createAlbum({
    required String title,
    required String startDate,
    File? coverPhoto,
  });
  Future<MomentAlbumDetailsModel> addPhoto(
    int albumId, {
    required File photo,
    String? caption,
    String? dayLabel,
  });
  Future<void> deletePhoto(int albumId, int photoId);
  Future<MomentAlbumModel> updateAlbum(
    int albumId, {
    String? title,
    String? startDate,
  });
  Future<void> deleteAlbum(int albumId);
}

class MomentsRemoteDataSourceImpl implements MomentsRemoteDataSource {
  final Dio _dio;

  const MomentsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MomentAlbumModel>> getAlbums() async {
    try {
      final response = await _dio.get('/Moments');
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Moments.',
        );
      }

      final rawData = body['data'];
      if (rawData is List) {
        return rawData
            .whereType<Map<String, dynamic>>()
            .map((item) => MomentAlbumModel.fromJson(item))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<MomentAlbumDetailsModel> getAlbumById(int albumId) async {
    try {
      final response = await _dio.get('/Moments/$albumId');
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Moments/{id}.',
        );
      }

      final rawData = body['data'];
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" object in /Moments/{id} response.',
        );
      }

      return MomentAlbumDetailsModel.fromJson(rawData);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<MomentAlbumModel> createAlbum({
    required String title,
    required String startDate,
    File? coverPhoto,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'Title': title,
        'StartDate': startDate,
      };

      if (coverPhoto != null) {
        final filename = coverPhoto.path.split(RegExp(r'[/\\]')).last;
        formMap['CoverPhoto'] = await MultipartFile.fromFile(
          coverPhoto.path,
          filename: filename,
        );
      }

      final formData = FormData.fromMap(formMap);
      final response = await _dio.post('/Moments', data: formData);

      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Moments.',
        );
      }

      final rawData = body['data'];
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" object in /Moments response.',
        );
      }

      return MomentAlbumModel.fromJson(rawData);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<MomentAlbumDetailsModel> addPhoto(
    int albumId, {
    required File photo,
    String? caption,
    String? dayLabel,
  }) async {
    try {
      final filename = photo.path.split(RegExp(r'[/\\]')).last;
      final Map<String, dynamic> formMap = {
        'Photo': await MultipartFile.fromFile(photo.path, filename: filename),
      };

      if (caption != null && caption.trim().isNotEmpty) {
        formMap['Caption'] = caption.trim();
      }
      if (dayLabel != null && dayLabel.trim().isNotEmpty) {
        formMap['DayLabel'] = dayLabel.trim();
      }

      final formData = FormData.fromMap(formMap);
      final response = await _dio.post(
        '/Moments/$albumId/photos',
        data: formData,
      );

      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Moments/{id}/photos.',
        );
      }

      final rawData = body['data'];
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" object in /Moments/{id}/photos response.',
        );
      }

      return MomentAlbumDetailsModel.fromJson(rawData);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<void> deletePhoto(int albumId, int photoId) async {
    try {
      await _dio.delete('/Moments/$albumId/photos/$photoId');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<MomentAlbumModel> updateAlbum(
    int albumId, {
    String? title,
    String? startDate,
  }) async {
    try {
      final Map<String, dynamic> formMap = {};
      if (title != null && title.trim().isNotEmpty) {
        formMap['Title'] = title.trim();
      }
      if (startDate != null && startDate.trim().isNotEmpty) {
        formMap['StartDate'] = startDate.trim();
      }

      final formData = FormData.fromMap(formMap);
      final response = await _dio.put('/Moments/$albumId', data: formData);

      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from PUT /Moments/{id}.',
        );
      }

      final rawData = body['data'];
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" object in PUT /Moments/{id} response.',
        );
      }

      return MomentAlbumModel.fromJson(rawData);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<void> deleteAlbum(int albumId) async {
    try {
      await _dio.delete('/Moments/$albumId');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  ApiException _wrap(DioException e) {
    return e.error as ApiException? ??
        ApiException(statusCode: -1, message: e.message ?? 'Unknown error');
  }
}
