import 'package:ruya/core/services/notification_service.dart';
import 'package:ruya/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';

class DeleteBookingUseCase {
  final BookingLocalDataSource _localDataSource;
  final NotificationService? _notificationService;

  DeleteBookingUseCase(
    this._localDataSource, [
    this._notificationService,
  ]);

  Future<void> call(dynamic bookingOrRef) async {
    if (bookingOrRef is LocalBookingModel) {
      if (bookingOrRef.notificationId != null && _notificationService != null) {
        await _notificationService.cancelReminder(bookingOrRef.notificationId!);
      }
      await _localDataSource.delete(bookingOrRef.referenceNumber);
    } else if (bookingOrRef is String) {
      await _localDataSource.delete(bookingOrRef);
    }
  }
}
