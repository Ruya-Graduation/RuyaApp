import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class DeletePhotoFromMomentUseCase {
  final MomentsRepository repository;

  DeletePhotoFromMomentUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int momentId, int photoId) {
    return repository.deletePhotoFromMoment(momentId, photoId);
  }
}
