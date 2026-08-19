import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/usecases/add_moment_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/add_photo_to_moment_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/delete_photo_from_moment_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/get_moments_usecase.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_state.dart';

class MomentsCubit extends Cubit<MomentsState> {
  final GetMomentsUseCase getMomentsUseCase;
  final AddMomentUseCase addMomentUseCase;
  final AddPhotoToMomentUseCase addPhotoToMomentUseCase;
  final DeletePhotoFromMomentUseCase deletePhotoFromMomentUseCase;

  MomentsCubit({
    required this.getMomentsUseCase,
    required this.addMomentUseCase,
    required this.addPhotoToMomentUseCase,
    required this.deletePhotoFromMomentUseCase,
  }) : super(const MomentsState());

  Future<void> loadMoments() async {
    emit(state.copyWith(status: MomentsStatus.loading));
    final result = await getMomentsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: MomentsStatus.error,
        errorMessage: failure.message,
      )),
      (moments) => emit(state.copyWith(
        status: MomentsStatus.loaded,
        moments: moments,
      )),
    );
  }

  void selectMoment(MomentItem moment) {
    emit(state.copyWith(selectedMoment: moment));
  }

  Future<bool> createMoment(MomentItem moment) async {
    final result = await addMomentUseCase(moment);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (newMoment) {
        final updated = [newMoment, ...state.moments];
        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updated,
        ));
        return true;
      },
    );
  }

  Future<bool> addPhotoToAlbum(String albumId, MomentPhoto photo) async {
    final result = await addPhotoToMomentUseCase(albumId, photo);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (updatedMoment) {
        final updatedList = state.moments.map((m) {
          if (m.id == albumId) return updatedMoment;
          return m;
        }).toList();

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedList,
          selectedMoment: state.selectedMoment?.id == albumId
              ? updatedMoment
              : state.selectedMoment,
        ));
        return true;
      },
    );
  }

  Future<bool> deletePhotoFromAlbum(String albumId, String photoId) async {
    final result = await deletePhotoFromMomentUseCase(albumId, photoId);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (updatedMoment) {
        final updatedList = state.moments.map((m) {
          if (m.id == albumId) return updatedMoment;
          return m;
        }).toList();

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedList,
          selectedMoment: state.selectedMoment?.id == albumId
              ? updatedMoment
              : state.selectedMoment,
        ));
        return true;
      },
    );
  }
}
