import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:ruya/features/booking/domain/usecases/create_local_booking_usecase.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';

void main() {
  group('CreateLocalBookingUseCase', () {
    late CreateLocalBookingUseCase useCase;

    setUp(() {
      useCase = CreateLocalBookingUseCase();
    });

    const mockSite = SiteDetailEntity(
      id: '2',
      name: 'Grand Egyptian Museum (GEM)',
      city: 'Giza',
      country: 'Egypt',
      latitude: 29.9932,
      longitude: 31.1173,
      hours: '9:00 AM - 5:00 PM',
      ticketRaw: '400 EGP',
      ticketPrice: 400.0,
      ticketCurrency: 'EGP',
      crowds: 'Very High',
      description: 'Test description',
    );

    test('generates a valid BookingEntity with correct calculation and ref prefix', () {
      final visitDate = DateTime(2026, 4, 15);
      final booking = useCase(
        site: mockSite,
        visitDate: visitDate,
        timeSlot: '08:00 AM Entry',
        ticketCount: 3,
      );

      expect(booking, isA<BookingEntity>());
      expect(booking.siteId, '2');
      expect(booking.siteName, 'Grand Egyptian Museum (GEM)');
      expect(booking.visitDate, visitDate);
      expect(booking.timeSlot, '08:00 AM Entry');
      expect(booking.ticketCount, 3);
      expect(booking.pricePerTicket, 400.0);
      expect(booking.currency, 'EGP');
      expect(booking.totalPrice, 1200.0);
      expect(booking.referenceNumber, startsWith('RY-2026-GRA-'));
    });
  });
}
