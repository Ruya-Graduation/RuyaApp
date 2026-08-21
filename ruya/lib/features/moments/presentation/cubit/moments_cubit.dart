import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/domain/usecases/add_photo_to_moment_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/create_moment_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/delete_album_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/delete_photo_from_moment_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/get_moment_by_id_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/get_moments_usecase.dart';
import 'package:ruya/features/moments/domain/usecases/update_moment_usecase.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_state.dart';

class MomentsCubit extends Cubit<MomentsState> {
  final GetMomentsUseCase getMomentsUseCase;
  final GetMomentByIdUseCase getMomentByIdUseCase;
  final CreateMomentUseCase createMomentUseCase;
  final AddPhotoToMomentUseCase addPhotoToMomentUseCase;
  final DeletePhotoFromMomentUseCase deletePhotoFromMomentUseCase;
  final UpdateMomentUseCase updateMomentUseCase;
  final DeleteAlbumUseCase deleteAlbumUseCase;

  MomentsCubit({
    required this.getMomentsUseCase,
    required this.getMomentByIdUseCase,
    required this.createMomentUseCase,
    required this.addPhotoToMomentUseCase,
    required this.deletePhotoFromMomentUseCase,
    required this.updateMomentUseCase,
    required this.deleteAlbumUseCase,
  }) : super(const MomentsState());

  Future<void> loadMoments() async {
    if (state.moments.isEmpty) {
      emit(state.copyWith(status: MomentsStatus.loading));
    }
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

  Future<void> loadMomentDetails(int id) async {
    final result = await getMomentByIdUseCase(id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: MomentsStatus.error,
        errorMessage: failure.message,
      )),
      (detailedMoment) {
        final updatedMoments = state.moments.map((m) {
          if (m.id == id) return detailedMoment;
          return m;
        }).toList();

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedMoments,
          selectedMoment: detailedMoment,
        ));
      },
    );
  }

  void selectMoment(MomentItem moment) {
    emit(state.copyWith(selectedMoment: moment));
  }

  Future<MomentItem?> createMoment({
    required String title,
    required String startDate,
    File? coverPhoto,
  }) async {
    final result = await createMomentUseCase(
      title: title,
      startDate: startDate,
      coverPhoto: coverPhoto,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return null;
      },
      (newMoment) {
        final updated = [newMoment, ...state.moments];
        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updated,
        ));
        return newMoment;
      },
    );
  }

  Future<bool> addPhotoToAlbum(
    int albumId, {
    required File photo,
    String? caption,
    String? dayLabel,
  }) async {
    final result = await addPhotoToMomentUseCase(
      albumId,
      photo: photo,
      caption: caption,
      dayLabel: dayLabel,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (updatedAlbum) {
        final updatedList = state.moments.map((m) {
          if (m.id == albumId) return updatedAlbum;
          return m;
        }).toList();

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedList,
          selectedMoment: state.selectedMoment?.id == albumId
              ? updatedAlbum
              : state.selectedMoment,
        ));
        return true;
      },
    );
  }

  Future<bool> deletePhotoFromAlbum(int albumId, int photoId) async {
    final result = await deletePhotoFromMomentUseCase(albumId, photoId);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        MomentItem? updatedSelected;
        if (state.selectedMoment?.id == albumId) {
          final updatedPhotos = state.selectedMoment!.photos
              .where((p) => p.id != photoId)
              .toList();
          updatedSelected = state.selectedMoment!.copyWith(
            photos: updatedPhotos,
            photoCount: updatedPhotos.length,
          );
        }

        final updatedList = state.moments.map((m) {
          if (m.id == albumId) {
            final newCount = m.photoCount > 0 ? m.photoCount - 1 : 0;
            final newPhotos = m.photos.where((p) => p.id != photoId).toList();
            return m.copyWith(
              photoCount: newCount,
              photos: newPhotos,
            );
          }
          return m;
        }).toList();

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedList,
          selectedMoment: updatedSelected ?? state.selectedMoment,
        ));
        return true;
      },
    );
  }

  Future<bool> updateAlbum(
    int albumId, {
    String? title,
    String? startDate,
  }) async {
    final result = await updateMomentUseCase(
      albumId,
      title: title,
      startDate: startDate,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (saved) {
        final updatedList = state.moments.map((m) {
          if (m.id == saved.id) {
            return m.copyWith(
              title: saved.title,
              startDate: saved.startDate,
              coverImageUrl: saved.coverImageUrl,
              photoCount: saved.photoCount,
            );
          }
          return m;
        }).toList();

        MomentItem? updatedSelected;
        if (state.selectedMoment?.id == saved.id) {
          updatedSelected = state.selectedMoment!.copyWith(
            title: saved.title,
            startDate: saved.startDate,
            coverImageUrl: saved.coverImageUrl,
            photoCount: saved.photoCount,
          );
        }

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedList,
          selectedMoment: updatedSelected ?? state.selectedMoment,
        ));
        return true;
      },
    );
  }

  Future<bool> deleteAlbum(int albumId) async {
    final result = await deleteAlbumUseCase(albumId);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: MomentsStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        final updatedList =
            state.moments.where((m) => m.id != albumId).toList();
        final clearSelected = state.selectedMoment?.id == albumId;

        emit(state.copyWith(
          status: MomentsStatus.loaded,
          moments: updatedList,
          clearSelectedMoment: clearSelected,
        ));
        return true;
      },
    );
  }
}
