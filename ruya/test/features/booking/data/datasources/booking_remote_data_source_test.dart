import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/features/booking/data/datasources/booking_remote_data_source.dart';

class MockDio extends Fake implements Dio {
  int callCount = 0;
  bool shouldThrow = false;
  Map<String, dynamic>? responseData;

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    callCount++;
    if (shouldThrow) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Connection error',
      );
    }
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: (responseData ??
          {
            'success': true,
            'message': 'Reservation created successfully.',
            'data': {'id': 42},
          }) as T,
      statusCode: 200,
    );
  }
}

void main() {
  group('BookingRemoteDataSourceImpl', () {
    test('createReservation returns reservation id on success', () async {
      final mockDio = MockDio();
      final dataSource = BookingRemoteDataSourceImpl(mockDio);

      final result = await dataSource.createReservation(
        museumName: 'Karnak Temple',
        reservationDate: DateTime(2026, 9, 15),
      );

      expect(mockDio.callCount, 1);
      expect(result, 42);
    });

    test('createReservation catches exception and returns null gracefully', () async {
      final mockDio = MockDio()..shouldThrow = true;
      final dataSource = BookingRemoteDataSourceImpl(mockDio);

      final result = await dataSource.createReservation(
        museumName: 'Karnak Temple',
        reservationDate: DateTime(2026, 9, 15),
      );

      expect(mockDio.callCount, 1);
      expect(result, isNull);
    });
  });
}
