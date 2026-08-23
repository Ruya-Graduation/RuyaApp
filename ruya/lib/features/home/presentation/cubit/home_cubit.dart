import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/home/domain/usecases/get_monuments_usecase.dart';
import 'package:ruya/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetMonumentsUseCase _getMonumentsUseCase;

  HomeCubit(this._getMonumentsUseCase) : super(const HomeState());

  /// Fetches the list of monuments. Call this when the page mounts or language changes.
  Future<void> loadMonuments({bool force = false}) async {
    if (!force && state.status == HomeStatus.loading) return;

    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getMonumentsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (monuments) => emit(
        state.copyWith(
          status: HomeStatus.loaded,
          monuments: monuments,
          errorMessage: null,
        ),
      ),
    );
  }

  /// Updates the search query filter.
  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  /// Updates the selected filter chip index.
  void selectFilter(int index) {
    if (state.selectedFilterIndex == index) return;
    emit(state.copyWith(selectedFilterIndex: index));
  }
}
