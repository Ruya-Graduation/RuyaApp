import 'package:ruya/features/home/domain/entities/monument_entity.dart';

/// Data model for Monument. Extends the domain entity and adds
/// JSON serialization. The data layer knows about this model;
/// the domain and presentation layers only know about [MonumentEntity].
class MonumentModel extends MonumentEntity {
  const MonumentModel({
    required super.id,
    required super.name,
    required super.location,
    required super.imagePath,
    required super.crowdsLevel,
  });

  factory MonumentModel.fromJson(Map<String, dynamic> json) {
    return MonumentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      imagePath: json['imagePath'] as String,
      crowdsLevel: json['crowdsLevel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imagePath': imagePath,
      'crowdsLevel': crowdsLevel,
    };
  }
}
