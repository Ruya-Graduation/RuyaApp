import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/core/session/token_local_data_source.dart';
import 'package:ruya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ruya/features/auth/data/models/otp_verification_result.dart';
import 'package:ruya/features/auth/data/models/user_model.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

/// Repository that bridges the auth data source and the domain layer.
///
/// On successful sign-in / register, the raw JWT returned by the API is:
///  1. Decoded into a [UserModel] via [UserModel.fromJwt].
///  2. Persisted to [TokenLocalDataSource] for session restoration on
///     the next app launch.
///
/// Error mapping converts [ApiException] to the appropriate [Failure]
/// sub-type so the presentation layer never handles raw Dio/HTTP details.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenLocalDataSource tokenDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenDataSource,
  });

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // signInRaw returns the raw JWT string so we can both persist it
      // and decode claims from it — two responsibilities the repository owns.
      final rawToken =
          await remoteDataSource.signInRaw(email: email, password: password);
      await tokenDataSource.saveToken(rawToken);
      return Right(UserModel.fromJwt(rawToken));
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
    required String knowledgeLevel,
  }) async {
    try {
      final rawToken = await remoteDataSource.registerRaw(
        name: name,
        email: email,
        password: password,
        preferredLanguage: preferredLanguage,
        knowledgeLevel: knowledgeLevel,
      );
      await tokenDataSource.saveToken(rawToken);
      return Right(UserModel.fromJwt(rawToken));
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, OtpVerificationResult>> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(email: email, code: code);
      return Right(result);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<void> logout() async {
    await tokenDataSource.clearToken();
  }

  // ---------------------------------------------------------------------------
  // Error mapping
  // ---------------------------------------------------------------------------

  Failure _toFailure(ApiException e) {
    if (e.isNetworkError) return NetworkFailure(e.message);
    if (e.isValidationError) {
      return ValidationFailure(e.message, fieldErrors: e.fieldErrors!);
    }
    return ServerFailure(e.message);
  }
}
