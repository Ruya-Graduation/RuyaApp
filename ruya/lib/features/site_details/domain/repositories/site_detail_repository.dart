import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';

abstract class SiteDetailRepository {
  Future<Either<Failure, SiteDetailEntity>> getSiteById(String id);
}
