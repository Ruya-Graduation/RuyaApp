import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruya/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late BookingLocalDataSourceImpl dataSource;

  final testBooking = LocalBookingModel(
    referenceNumber: 'RY-2026-TEST-001',
    siteId: '1',
    siteName: 'Giza Pyramids',
    visitDate: DateTime(2026, 9, 1),
    timeSlot: '08:00 AM Entry',
    ticketCount: 2,
    pricePerTicket: 200,
    currency: 'EGP',
    createdAt: DateTime(2026, 8, 23),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = BookingLocalDataSourceImpl(prefs);
  });

  group('BookingLocalDataSourceImpl', () {
    test('getAll returns empty list initially', () async {
      final list = await dataSource.getAll();
      expect(list, isEmpty);
    });

    test('save adds a booking and getAll retrieves it', () async {
      await dataSource.save(testBooking);
      final list = await dataSource.getAll();

      expect(list.length, 1);
      expect(list.first.referenceNumber, 'RY-2026-TEST-001');
      expect(list.first.totalPrice, 400);
    });

    test('update modifies existing booking', () async {
      await dataSource.save(testBooking);

      final updated = testBooking.copyWith(
        reminderEnabled: true,
        reminderDateTime: DateTime(2026, 9, 1, 7, 0),
        notificationId: 12345,
      );

      await dataSource.update(updated);
      final list = await dataSource.getAll();

      expect(list.length, 1);
      expect(list.first.reminderEnabled, isTrue);
      expect(list.first.notificationId, 12345);
    });

    test('delete removes booking by reference number', () async {
      await dataSource.save(testBooking);
      expect((await dataSource.getAll()).length, 1);

      await dataSource.delete('RY-2026-TEST-001');
      expect(await dataSource.getAll(), isEmpty);
    });
  });
}
