import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/features/site_details/domain/repositories/site_detail_repository.dart';
import 'package:ruya/features/site_details/domain/usecases/get_site_by_id_usecase.dart';
import 'package:ruya/features/site_details/presentation/cubit/site_details_cubit.dart';
import 'package:ruya/features/site_details/presentation/cubit/site_details_state.dart';

class MockSiteDetailRepository implements SiteDetailRepository {
  Either<Failure, SiteDetailEntity>? response;

  @override
  Future<Either<Failure, SiteDetailEntity>> getSiteById(String id) async {
    return response!;
  }
}

void main() {
  group('SiteDetailsCubit', () {
    late MockSiteDetailRepository mockRepository;
    late GetSiteByIdUseCase useCase;
    late SiteDetailsCubit cubit;

    const testSite = SiteDetailEntity(
      id: '2',
      name: 'Grand Egyptian Museum (GEM)',
      city: 'Giza',
      country: 'Egypt',
      latitude: 29.9932,
      longitude: 31.1173,
      hours: '9:00 AM - 5:00 PM',
      ticketRaw: '400 EGP',
      ticketPrice: 400.0,
      ticketCurrency: 'EGP',
      crowds: 'Very High',
      description: 'A museum',
    );

    setUp(() {
      mockRepository = MockSiteDetailRepository();
      useCase = GetSiteByIdUseCase(mockRepository);
      cubit = SiteDetailsCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has SiteDetailsStatus.initial', () {
      expect(cubit.state.status, SiteDetailsStatus.initial);
      expect(cubit.state.site, isNull);
      expect(cubit.state.errorMessage, isNull);
    });

    test('emits [loading, loaded] when getSiteById succeeds', () async {
      mockRepository.response = const Right(testSite);

      final expectedStates = [
        const SiteDetailsState(status: SiteDetailsStatus.loading),
        const SiteDetailsState(
          status: SiteDetailsStatus.loaded,
          site: testSite,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadSite('2');
    });

    test('emits [loading, error] when getSiteById fails', () async {
      mockRepository.response = Left(ServerFailure('Site not found'));

      final expectedStates = [
        const SiteDetailsState(status: SiteDetailsStatus.loading),
        const SiteDetailsState(
          status: SiteDetailsStatus.error,
          errorMessage: 'Site not found',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadSite('999');
    });
  });
}
