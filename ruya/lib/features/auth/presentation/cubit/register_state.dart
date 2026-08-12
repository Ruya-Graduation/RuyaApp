import 'package:equatable/equatable.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final Map<String, String?> fieldErrors;
  final String preferredLanguage;
  final String knowledgeLevel;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors = const {},
    this.preferredLanguage = 'en',
    this.knowledgeLevel = 'beginner',
  });

  static const Object _keep = Object();

  RegisterState copyWith({
    RegisterStatus? status,
    UserEntity? user,
    // Sentinel pattern: pass null explicitly to clear the error.
    Object? errorMessage = _keep,
    Map<String, String?>? fieldErrors,
    String? preferredLanguage,
    String? knowledgeLevel,
  }) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      knowledgeLevel: knowledgeLevel ?? this.knowledgeLevel,
    );
  }

  @override
  List<Object?> get props =>
      [status, user, errorMessage, fieldErrors, preferredLanguage, knowledgeLevel];
}

