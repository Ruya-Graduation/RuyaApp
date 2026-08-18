import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/site_details/domain/usecases/get_site_by_id_usecase.dart';
import 'package:ruya/features/site_details/presentation/cubit/site_details_state.dart';

class SiteDetailsCubit extends Cubit<SiteDetailsState> {
  final GetSiteByIdUseCase _getSiteByIdUseCase;

  SiteDetailsCubit(this._getSiteByIdUseCase) : super(const SiteDetailsState());

  Future<void> loadSite(String id) async {
    emit(state.copyWith(status: SiteDetailsStatus.loading, errorMessage: null));
    final result = await _getSiteByIdUseCase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SiteDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (site) => emit(
        state.copyWith(
          status: SiteDetailsStatus.loaded,
          site: site,
          errorMessage: null,
        ),
      ),
    );
  }
}
