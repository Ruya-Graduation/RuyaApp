import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class UpdateMomentUseCase {
  final MomentsRepository repository;

  UpdateMomentUseCase(this.repository);

  Future<Either<Failure, MomentItem>> call(MomentItem updatedMoment) {
    return repository.updateMoment(updatedMoment);
  }
}
