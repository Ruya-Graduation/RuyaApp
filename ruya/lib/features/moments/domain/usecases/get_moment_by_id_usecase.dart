import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class GetMomentByIdUseCase {
  final MomentsRepository repository;

  GetMomentByIdUseCase(this.repository);

  Future<Either<Failure, MomentItem>> call(int id) {
    return repository.getMomentById(id);
  }
}
