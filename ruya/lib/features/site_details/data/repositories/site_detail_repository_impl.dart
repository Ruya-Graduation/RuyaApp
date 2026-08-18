import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/site_details/data/datasources/site_detail_remote_data_source.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/features/site_details/domain/repositories/site_detail_repository.dart';

class SiteDetailRepositoryImpl implements SiteDetailRepository {
  final SiteDetailRemoteDataSource remoteDataSource;

  SiteDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SiteDetailEntity>> getSiteById(String id) async {
    try {
      final model = await remoteDataSource.getSiteById(id);
      return Right(model);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to load site details: ${e.toString()}'));
    }
  }

  Failure _toFailure(ApiException e) {
    if (e.isNetworkError) return NetworkFailure(e.message);
    return ServerFailure(e.message);
  }
}
