import 'package:equatable/equatable.dart';

/// Lightweight value object representing a site's geographic coordinates.
/// Used by [ProximityService] — carries only what it needs for Haversine
/// distance calculations, independent of [MonumentEntity].
class SiteLocation extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const SiteLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, name, latitude, longitude];
}
