import 'dart:math';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';

class CreateLocalBookingUseCase {
  /// Deterministic-enough local reference number: RY-{year}-{first 3 letters of site name, uppercased}-{4 random digits}.
  BookingEntity call({
    required SiteDetailEntity site,
    required DateTime visitDate,
    required String timeSlot,
    required int ticketCount,
  }) {
    final code =
        site.name.replaceAll(RegExp(r'[^A-Za-z]'), '').toUpperCase();
    final prefix =
        code.length >= 3 ? code.substring(0, 3) : code.padRight(3, 'X');
    final rand = Random().nextInt(9000) + 1000;
    final ref = 'RY-${visitDate.year}-$prefix-$rand';

    return BookingEntity(
      referenceNumber: ref,
      siteId: site.id,
      siteName: site.name,
      visitDate: visitDate,
      timeSlot: timeSlot,
      ticketCount: ticketCount,
      pricePerTicket: site.ticketPrice,
      currency: site.ticketCurrency,
      createdAt: DateTime.now(),
    );
  }
}
