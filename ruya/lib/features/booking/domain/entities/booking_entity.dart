import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String referenceNumber; // e.g. "RY-2026-GEM-4821" — generated locally
  final String siteId;
  final String siteName;
  final DateTime visitDate;
  final String timeSlot; // e.g. "08:00 AM Entry"
  final int ticketCount;
  final double pricePerTicket;
  final String currency; // "EGP"
  final DateTime createdAt;

  double get totalPrice => ticketCount * pricePerTicket;

  const BookingEntity({
    required this.referenceNumber,
    required this.siteId,
    required this.siteName,
    required this.visitDate,
    required this.timeSlot,
    required this.ticketCount,
    required this.pricePerTicket,
    required this.currency,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        referenceNumber,
        siteId,
        siteName,
        visitDate,
        timeSlot,
        ticketCount,
        pricePerTicket,
        currency,
        createdAt,
      ];
}
