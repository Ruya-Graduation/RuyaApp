import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/home/data/datasources/monument_remote_data_source.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';
import 'package:ruya/features/home/domain/repositories/monument_repository.dart';

/// Concrete implementation of [MonumentRepository].
/// Delegates to [MonumentRemoteDataSource] and maps [ApiException] errors
/// to the appropriate [Failure] subtype — mirroring [AuthRepositoryImpl].
class MonumentRepositoryImpl implements MonumentRepository {
  final MonumentRemoteDataSource remoteDataSource;

  MonumentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MonumentEntity>>> getMonuments() async {
    try {
      final models = await remoteDataSource.getMonuments();
      // MonumentModel IS-A MonumentEntity, so it satisfies the return type.
      return Right(models);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to load monuments: ${e.toString()}'));
    }
  }

  Failure _toFailure(ApiException e) {
    if (e.isNetworkError) return NetworkFailure(e.message);
    return ServerFailure(e.message);
  }
}
