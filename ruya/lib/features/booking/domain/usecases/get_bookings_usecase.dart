import 'package:ruya/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';

class GetBookingsUseCase {
  final BookingLocalDataSource _localDataSource;

  GetBookingsUseCase(this._localDataSource);

  Future<List<LocalBookingModel>> call() async {
    final bookings = await _localDataSource.getAll();
    // Sort newest visit date / creation date first
    bookings.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    return bookings;
  }
}
