import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';

/// Data model for Site Details. Extends [SiteDetailEntity] and adds
/// JSON deserialization and serialization.
///
/// Maps from the API response object `GET /api/AdminSites/{id}`:
/// ```json
/// {
///   "id": 2,
///   "name": "Grand Egyptian Museum (GEM)",
///   "city": "Giza",
///   "country": "Egypt",
///   "latitude": 29.9932,
///   "longitude": 31.1173,
///   "hours": "9:00 AM - 5:00 PM",
///   "ticket": "400 EGP",
///   "crowds": "Very High",
///   "description": "..."
/// }
/// ```
class SiteDetailModel extends SiteDetailEntity {
  const SiteDetailModel({
    required super.id,
    required super.name,
    required super.city,
    required super.country,
    required super.latitude,
    required super.longitude,
    required super.hours,
    required super.ticketRaw,
    required super.ticketPrice,
    required super.ticketCurrency,
    required super.crowds,
    required super.description,
    super.imageUrl,
  });

  factory SiteDetailModel.fromJson(Map<String, dynamic> json) {
    final rawTicket = json['ticket'];
    final ticketRaw = rawTicket?.toString() ?? '';
    double ticketPrice = 0.0;
    String ticketCurrency = 'EGP';

    if (rawTicket is num) {
      ticketPrice = rawTicket.toDouble();
    } else if (ticketRaw.isNotEmpty) {
      final numMatch = RegExp(r'([\d,.]+)').firstMatch(ticketRaw);
      if (numMatch != null) {
        final numStr = numMatch.group(1)?.replaceAll(',', '') ?? '';
        ticketPrice = double.tryParse(numStr) ?? 0.0;
        final currencyPart = ticketRaw.replaceFirst(numMatch.group(0)!, '').trim();
        if (currencyPart.isNotEmpty) {
          ticketCurrency = currencyPart;
        }
      }
    }

    final rawImageUrl = json['imageUrl'] as String?;
    final imageUrl =
        (rawImageUrl != null && rawImageUrl.trim().isNotEmpty) ? rawImageUrl : null;

    return SiteDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      hours: json['hours'] as String? ?? '',
      ticketRaw: ticketRaw,
      ticketPrice: ticketPrice,
      ticketCurrency: ticketCurrency,
      crowds: json['crowds'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'hours': hours,
      'ticket': ticketRaw,
      'crowds': crowds,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
