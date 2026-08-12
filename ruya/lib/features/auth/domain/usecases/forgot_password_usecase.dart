import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) {
    return repository.forgotPassword(email);
  }
}
