import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String name, String email, String password) {
    return repository.register(name: name, email: email, password: password);
  }
}
