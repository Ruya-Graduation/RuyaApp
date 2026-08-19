import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class GetMomentsUseCase {
  final MomentsRepository repository;

  GetMomentsUseCase(this.repository);

  Future<Either<Failure, List<MomentItem>>> call() {
    return repository.getMoments();
  }
}
