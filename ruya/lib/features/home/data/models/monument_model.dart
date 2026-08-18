import 'package:ruya/features/home/domain/entities/monument_entity.dart';

/// Data model for Monument. Extends the domain entity and adds
/// JSON serialization. The data layer knows about this model;
/// the domain and presentation layers only know about [MonumentEntity].
///
/// Maps from the real `SiteDto` shape returned by `GET /api/AdminSites`:
/// ```json
/// {
///   "id":        1,
///   "name":      "Karnak Temple Complex",
///   "city":      "Luxor",
///   "country":   "Egypt",
///   "latitude":  25.7188,
///   "longitude": 32.6573,
///   "hours":     "6 AM – 5:30 PM",
///   "ticket":    50,
///   "crowds":    "Low Crowds",
///   "description": "..."
/// }
/// ```
/// Note: the backend does **not** currently return an `imageUrl` field.
/// When/if it does, [imageUrl] will pick it up automatically; until then
/// it will be null and widgets fall back to [imagePath].
class MonumentModel extends MonumentEntity {
  const MonumentModel({
    required super.id,
    required super.name,
    required super.location,
    required super.imagePath,
    super.imageUrl,
    required super.crowdsLevel,
    required super.latitude,
    required super.longitude,
  });

  factory MonumentModel.fromJson(Map<String, dynamic> json) {
    // Combine city + country to match the "Luxor, Upper Egypt" UI style.
    final city = json['city'] as String? ?? '';
    final country = json['country'] as String? ?? '';
    final location = city.isNotEmpty && country.isNotEmpty
        ? '$city, $country'
        : city.isNotEmpty
            ? city
            : country;

    // imageUrl: the backend does not return this field yet; guard against
    // null, missing key, and empty string so the fallback path is always clean.
    final rawImageUrl = json['imageUrl'] as String?;
    final imageUrl =
        (rawImageUrl != null && rawImageUrl.trim().isNotEmpty) ? rawImageUrl : null;

    return MonumentModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      location: location,
      // Local fallback asset — always set; widget layer prefers imageUrl when present.
      imagePath: 'assets/images/egyptian_pyramids.png',
      imageUrl: imageUrl,
      crowdsLevel: json['crowds'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'crowdsLevel': crowdsLevel,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
