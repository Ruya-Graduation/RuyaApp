import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) {
    return repository.resetPassword(
      email: email,
      resetToken: resetToken,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
