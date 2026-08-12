import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/domain/usecases/forgot_password_usecase.dart';

/// Resends the OTP by re-calling the same `forgot-password` endpoint.
///
/// The backend does NOT have a dedicated `/resend-otp` endpoint —
/// calling `forgot-password` again with the same email is the correct way
/// to trigger a new OTP. This use case is a thin, named alias over
/// [ForgotPasswordUseCase] so cubits have a semantically clear call site.
class ResendOtpUseCase {
  final ForgotPasswordUseCase _forgotPassword;

  ResendOtpUseCase(this._forgotPassword);

  Future<Either<Failure, void>> call(String email) {
    return _forgotPassword(email);
  }
}
