import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/moments/domain/repositories/moments_repository.dart';

class DeleteAlbumUseCase {
  final MomentsRepository repository;

  DeleteAlbumUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int albumId) {
    return repository.deleteMoment(albumId);
  }
}
