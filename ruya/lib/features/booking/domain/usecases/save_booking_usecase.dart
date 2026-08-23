import 'package:ruya/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';

class SaveBookingUseCase {
  final BookingLocalDataSource _localDataSource;

  SaveBookingUseCase(this._localDataSource);

  Future<void> call(LocalBookingModel booking) {
    return _localDataSource.save(booking);
  }
}
