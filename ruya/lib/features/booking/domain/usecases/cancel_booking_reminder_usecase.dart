import 'package:ruya/core/services/notification_service.dart';
import 'package:ruya/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';

class CancelBookingReminderUseCase {
  final BookingLocalDataSource _localDataSource;
  final NotificationService _notificationService;

  CancelBookingReminderUseCase(
    this._localDataSource,
    this._notificationService,
  );

  Future<void> call(LocalBookingModel booking) async {
    if (booking.notificationId != null) {
      await _notificationService.cancelReminder(booking.notificationId!);
    }
    final updated = booking.copyWith(
      reminderEnabled: false,
      reminderDateTime: null,
      notificationId: null,
    );
    await _localDataSource.update(updated);
  }
}
