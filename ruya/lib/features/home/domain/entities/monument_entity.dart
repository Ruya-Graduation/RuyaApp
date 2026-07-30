import 'package:equatable/equatable.dart';

class MonumentEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final String imagePath;
  final String crowdsLevel;

  const MonumentEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.imagePath,
    required this.crowdsLevel,
  });

  @override
  List<Object?> get props => [id, name, location, imagePath, crowdsLevel];
}
