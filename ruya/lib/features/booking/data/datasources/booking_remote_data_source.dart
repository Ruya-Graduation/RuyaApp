import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class BookingRemoteDataSource {
  Future<int?> createReservation({
    required String museumName,
    required DateTime reservationDate,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio _dio;

  BookingRemoteDataSourceImpl(this._dio);

  @override
  Future<int?> createReservation({
    required String museumName,
    required DateTime reservationDate,
  }) async {
    try {
      final response = await _dio.post(
        '/Reservations',
        data: {
          'museumName': museumName,
          'reservationDate': reservationDate.toIso8601String(),
        },
      );

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic> && data.containsKey('id')) {
          return (data['id'] as num).toInt();
        }
      }
      return null;
    } catch (e) {
      debugPrint(
        '[BookingRemoteDataSource] Remote reservation sync error (non-blocking): $e',
      );
      return null;
    }
  }
}
