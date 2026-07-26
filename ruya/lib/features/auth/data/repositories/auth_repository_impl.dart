import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password}) async {
    try {
      final userModel = await remoteDataSource.signIn(email: email, password: password);
      return Right(userModel);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password}) async {
    try {
      final userModel = await remoteDataSource.register(name: name, email: email, password: password);
      return Right(userModel);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
