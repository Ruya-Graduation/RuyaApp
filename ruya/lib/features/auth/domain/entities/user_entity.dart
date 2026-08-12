import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String preferredLanguage;
  final String knowledgeLevel;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredLanguage,
    required this.knowledgeLevel,
  });

  @override
  List<Object?> get props => [id, name, email, preferredLanguage, knowledgeLevel];
}

