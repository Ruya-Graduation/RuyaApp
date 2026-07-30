import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';

/// Abstract contract for monument data access. The data layer implements this.
abstract class MonumentRepository {
  Future<Either<Failure, List<MonumentEntity>>> getMonuments();
}
