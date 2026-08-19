import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class AddPhotoToMomentUseCase {
  final MomentsRepository repository;

  AddPhotoToMomentUseCase(this.repository);

  Future<Either<Failure, MomentItem>> call(String momentId, MomentPhoto photo) {
    return repository.addPhotoToMoment(momentId, photo);
  }
}
