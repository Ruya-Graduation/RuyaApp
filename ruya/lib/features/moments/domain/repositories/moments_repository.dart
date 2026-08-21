import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';

abstract class MomentsRepository {
  Future<Either<Failure, List<MomentItem>>> getMoments();
  Future<Either<Failure, MomentItem>> getMomentById(int id);
  Future<Either<Failure, MomentItem>> createMoment({
    required String title,
    required String startDate,
    File? coverPhoto,
  });
  Future<Either<Failure, MomentItem>> addPhotoToMoment(
    int momentId, {
    required File photo,
    String? caption,
    String? dayLabel,
  });
  Future<Either<Failure, Unit>> deletePhotoFromMoment(
    int momentId,
    int photoId,
  );
  Future<Either<Failure, MomentItem>> updateMoment(
    int momentId, {
    String? title,
    String? startDate,
  });
  Future<Either<Failure, Unit>> deleteMoment(int momentId);
}
