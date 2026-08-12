import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/data/models/otp_verification_result.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
    required String knowledgeLevel,
  });

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, OtpVerificationResult>> verifyOtp({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });

  Future<void> logout();
}

