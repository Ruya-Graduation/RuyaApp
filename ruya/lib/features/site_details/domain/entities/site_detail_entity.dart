import 'package:equatable/equatable.dart';

class SiteDetailEntity extends Equatable {
  final String id;
  final String name;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String hours;
  final String ticketRaw; // e.g. "400 EGP" — exactly as backend returns it
  final double ticketPrice; // parsed numeric portion, e.g. 400.0 — 0.0 if unparseable
  final String ticketCurrency; // parsed trailing text, e.g. "EGP" — defaults to "EGP"
  final String crowds;
  final String description;
  final String? imageUrl; // always null today — kept for forward-compat, same pattern as MonumentEntity.imageUrl

  const SiteDetailEntity({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.hours,
    required this.ticketRaw,
    required this.ticketPrice,
    required this.ticketCurrency,
    required this.crowds,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        city,
        country,
        latitude,
        longitude,
        hours,
        ticketRaw,
        ticketPrice,
        ticketCurrency,
        crowds,
        description,
        imageUrl,
      ];
}
