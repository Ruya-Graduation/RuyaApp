import 'package:equatable/equatable.dart';

enum ForgetPasswordStatus { initial, loading, success, error }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStatus status;
  final String? errorMessage;
  final String email;
  final String otp;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.errorMessage,
    this.email = '',
    this.otp = '',
  });

  /// Sentinel value used to distinguish "keep old value" from "set to null".
  static const Object _keep = Object();

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    // Using [Object?] + sentinel so callers can explicitly pass null
    // to clear the error message (errorMessage ?? this.errorMessage would
    // not allow clearing back to null).
    Object? errorMessage = _keep,
    String? email,
    String? otp,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, email, otp];
}
