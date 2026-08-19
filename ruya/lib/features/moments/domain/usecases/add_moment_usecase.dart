import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class AddMomentUseCase {
  final MomentsRepository repository;

  AddMomentUseCase(this.repository);

  Future<Either<Failure, MomentItem>> call(MomentItem moment) {
    return repository.addMoment(moment);
  }
}
