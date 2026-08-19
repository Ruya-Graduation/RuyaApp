import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';

abstract class MomentsRepository {
  Future<Either<Failure, List<MomentItem>>> getMoments();
  Future<Either<Failure, MomentItem>> getMomentById(String id);
  Future<Either<Failure, MomentItem>> addMoment(MomentItem moment);
  Future<Either<Failure, MomentItem>> addPhotoToMoment(String momentId, MomentPhoto photo);
  Future<Either<Failure, MomentItem>> deletePhotoFromMoment(String momentId, String photoId);
}
