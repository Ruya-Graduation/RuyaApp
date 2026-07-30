import 'package:equatable/equatable.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

enum SignInStatus { initial, loading, success, error }

class SignInState extends Equatable {
  final SignInStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final Map<String, String?> fieldErrors;

  const SignInState({
    this.status = SignInStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  static const Object _keep = Object();

  SignInState copyWith({
    SignInStatus? status,
    UserEntity? user,
    // Sentinel pattern: pass null explicitly to clear the error.
    Object? errorMessage = _keep,
    Map<String, String?>? fieldErrors,
  }) {
    return SignInState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, fieldErrors];
}
