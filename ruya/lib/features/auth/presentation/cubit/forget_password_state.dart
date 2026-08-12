import 'package:equatable/equatable.dart';

enum ForgetPasswordStatus { initial, loading, success, error }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStatus status;
  final String? errorMessage;
  final String email;

  /// The opaque reset token returned by `/api/Auth/verify-otp`.
  /// Null until OTP verification succeeds. Must be sent to `/api/Auth/reset-password`.
  final String? resetToken;

  /// Seconds remaining in the client-side resend cooldown (0 = can resend).
  final int resendCooldownSeconds;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.errorMessage,
    this.email = '',
    this.resetToken,
    this.resendCooldownSeconds = 0,
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
    Object? resetToken = _keep,
    int? resendCooldownSeconds,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      email: email ?? this.email,
      resetToken:
          resetToken == _keep ? this.resetToken : resetToken as String?,
      resendCooldownSeconds:
          resendCooldownSeconds ?? this.resendCooldownSeconds,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, email, resetToken, resendCooldownSeconds];
}

