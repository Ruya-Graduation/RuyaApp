import 'package:equatable/equatable.dart';

class MonumentEntity extends Equatable {
  final String id;
  final String name;
  final String location;

  /// Local asset path used as a fallback when [imageUrl] is absent/broken.
  /// Always `'assets/images/egyptian_pyramids.png'` until the backend
  /// starts returning real image URLs.
  final String imagePath;

  /// Remote image URL returned by the API. Null (or empty) when the backend
  /// does not yet provide an image for this site. Widgets must check this
  /// before deciding which image source to render — see [MonumentImage].
  final String? imageUrl;

  final String crowdsLevel;

  /// Geographic coordinates — populated from the API and used by
  /// [ProximityService] to compute Haversine distance per site.
  final double latitude;
  final double longitude;

  const MonumentEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.imagePath,
    this.imageUrl,
    required this.crowdsLevel,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props =>
      [id, name, location, imagePath, imageUrl, crowdsLevel, latitude, longitude];
}
