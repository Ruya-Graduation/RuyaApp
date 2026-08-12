import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/data/models/otp_verification_result.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, OtpVerificationResult>> call({
    required String email,
    required String code,
  }) {
    return repository.verifyOtp(email: email, code: code);
  }
}
