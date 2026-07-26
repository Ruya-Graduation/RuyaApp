import 'package:equatable/equatable.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final Map<String, String?> fieldErrors;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  RegisterState copyWith({
    RegisterStatus? status,
    UserEntity? user,
    String? errorMessage,
    Map<String, String?>? fieldErrors,
  }) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, fieldErrors];
}
