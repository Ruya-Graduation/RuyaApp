import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/home/data/datasources/monument_local_data_source.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';
import 'package:ruya/features/home/domain/repositories/monument_repository.dart';

/// Concrete implementation of [MonumentRepository].
/// Delegates to [MonumentLocalDataSource] and wraps results in [Either].
class MonumentRepositoryImpl implements MonumentRepository {
  final MonumentLocalDataSource localDataSource;

  MonumentRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<MonumentEntity>>> getMonuments() async {
    try {
      final models = await localDataSource.getMonuments();
      // MonumentModel IS-A MonumentEntity, so it satisfies the return type.
      return Right(models);
    } catch (e) {
      return Left(ServerFailure('Failed to load monuments: ${e.toString()}'));
    }
  }
}
