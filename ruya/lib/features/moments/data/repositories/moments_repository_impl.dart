import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/moments/data/datasources/moments_remote_data_source.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class MomentsRepositoryImpl implements MomentsRepository {
  final MomentsRemoteDataSource remoteDataSource;

  MomentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MomentItem>>> getMoments() async {
    try {
      final items = await remoteDataSource.getAlbums();
      return Right(items);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to load moments: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> getMomentById(int id) async {
    try {
      final item = await remoteDataSource.getAlbumById(id);
      return Right(item);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to load album details: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> createMoment({
    required String title,
    required String startDate,
    File? coverPhoto,
  }) async {
    try {
      final item = await remoteDataSource.createAlbum(
        title: title,
        startDate: startDate,
        coverPhoto: coverPhoto,
      );
      return Right(item);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to create album: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> addPhotoToMoment(
    int momentId, {
    required File photo,
    String? caption,
    String? dayLabel,
  }) async {
    try {
      final item = await remoteDataSource.addPhoto(
        momentId,
        photo: photo,
        caption: caption,
        dayLabel: dayLabel,
      );
      return Right(item);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to add photo: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePhotoFromMoment(
    int momentId,
    int photoId,
  ) async {
    try {
      await remoteDataSource.deletePhoto(momentId, photoId);
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to delete photo: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MomentItem>> updateMoment(
    int momentId, {
    String? title,
    String? startDate,
  }) async {
    try {
      final item = await remoteDataSource.updateAlbum(
        momentId,
        title: title,
        startDate: startDate,
      );
      return Right(item);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to update album: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMoment(int momentId) async {
    try {
      await remoteDataSource.deleteAlbum(momentId);
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to delete album: ${e.toString()}'));
    }
  }

  Failure _toFailure(ApiException e) {
    if (e.isNetworkError) return NetworkFailure(e.message);
    return ServerFailure(e.message);
  }
}
