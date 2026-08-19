import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/data/datasources/moments_local_data_source.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class MomentsRepositoryImpl implements MomentsRepository {
  final MomentsLocalDataSource localDataSource;

  MomentsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<MomentItem>>> getMoments() async {
    try {
      final items = await localDataSource.getMoments();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> getMomentById(String id) async {
    try {
      final item = await localDataSource.getMomentById(id);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> addMoment(MomentItem moment) async {
    try {
      final item = await localDataSource.addMoment(moment);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> addPhotoToMoment(
      String momentId, MomentPhoto photo) async {
    try {
      final item = await localDataSource.addPhotoToMoment(momentId, photo);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> deletePhotoFromMoment(
      String momentId, String photoId) async {
    try {
      final item =
          await localDataSource.deletePhotoFromMoment(momentId, photoId);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> updateMoment(
      MomentItem updatedMoment) async {
    try {
      final item = await localDataSource.updateMoment(updatedMoment);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
