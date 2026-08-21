import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class CreateMomentUseCase {
  final MomentsRepository repository;

  CreateMomentUseCase(this.repository);

  Future<Either<Failure, MomentItem>> call({
    required String title,
    required String startDate,
    File? coverPhoto,
  }) {
    return repository.createMoment(
      title: title,
      startDate: startDate,
      coverPhoto: coverPhoto,
    );
  }
}
