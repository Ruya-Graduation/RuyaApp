import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';
import 'package:ruya/features/home/domain/repositories/monument_repository.dart';

/// Use case that retrieves the list of monuments from the repository.
class GetMonumentsUseCase {
  final MonumentRepository repository;

  GetMonumentsUseCase(this.repository);

  Future<Either<Failure, List<MonumentEntity>>> call() {
    return repository.getMonuments();
  }
}
