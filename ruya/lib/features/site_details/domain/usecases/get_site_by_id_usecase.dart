import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/features/site_details/domain/repositories/site_detail_repository.dart';

class GetSiteByIdUseCase {
  final SiteDetailRepository repository;

  GetSiteByIdUseCase(this.repository);

  Future<Either<Failure, SiteDetailEntity>> call(String id) =>
      repository.getSiteById(id);
}
