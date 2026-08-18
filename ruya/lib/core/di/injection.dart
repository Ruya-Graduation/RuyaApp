import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:ruya/core/presentation/cubit/bottom_nav_cubit.dart';
import 'package:ruya/core/network/dio_client.dart';
import 'package:ruya/core/session/token_local_data_source.dart';
import 'package:ruya/core/session/session_service.dart';

// Core — Location
import 'package:ruya/core/location/location_settings_cubit.dart';
import 'package:ruya/core/location/proximity_service.dart';

// Auth — Data
import 'package:ruya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ruya/features/auth/data/repositories/auth_repository_impl.dart';

// Auth — Domain
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';
import 'package:ruya/features/auth/domain/usecases/register_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/logout_usecase.dart';

// Auth — Presentation
import 'package:ruya/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/register_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/sign_in_cubit.dart';

// Home — Data
import 'package:ruya/features/home/data/datasources/monument_remote_data_source.dart';
import 'package:ruya/features/home/data/repositories/monument_repository_impl.dart';

// Home — Domain
import 'package:ruya/features/home/domain/repositories/monument_repository.dart';
import 'package:ruya/features/home/domain/usecases/get_monuments_usecase.dart';

// Home — Presentation
import 'package:ruya/features/home/presentation/cubit/home_cubit.dart';

// Site Details — Data
import 'package:ruya/features/site_details/data/datasources/site_detail_remote_data_source.dart';
import 'package:ruya/features/site_details/data/repositories/site_detail_repository_impl.dart';

// Site Details — Domain
import 'package:ruya/features/site_details/domain/repositories/site_detail_repository.dart';
import 'package:ruya/features/site_details/domain/usecases/get_site_by_id_usecase.dart';

// Site Details — Presentation
import 'package:ruya/features/site_details/presentation/cubit/site_details_cubit.dart';

// Booking — Data / Service
import 'package:ruya/features/booking/data/services/ticket_export_service.dart';

// Booking — Domain
import 'package:ruya/features/booking/domain/usecases/create_local_booking_usecase.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ---------------------------------------------------------------------------
  // Core — Platform
  // ---------------------------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton(() => secureStorage);

  getIt.registerFactory(() => BottomNavCubit());

  // ---------------------------------------------------------------------------
  // Core — Session
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<TokenLocalDataSource>(
    () => TokenLocalDataSource(getIt()),
  );
  getIt.registerLazySingleton<SessionService>(
    () => SessionService(getIt()),
  );

  // ---------------------------------------------------------------------------
  // Core — Network
  // ---------------------------------------------------------------------------
  // Build the Dio singleton. TokenLocalDataSource must be registered first
  // because DioClient reads the token in its auth interceptor.
  getIt.registerLazySingleton<Dio>(
    () => DioClient.getInstance(getIt()),
  );

  // ---------------------------------------------------------------------------
  // Core — Location
  // ---------------------------------------------------------------------------

  // LazySingleton: the same cubit instance is shared between AppPreferencesCard
  // and HomePage so the toggle state and stream lifecycle stay in sync.
  getIt.registerLazySingleton<LocationSettingsCubit>(
    () => LocationSettingsCubit(getIt<SharedPreferences>()),
  );

  // LazySingleton: the same ProximityService instance is shared between
  // HomePage (lifecycle management) and the logout handler so that:
  //   1. The _notifiedSiteIds dedupe set is session-scoped (not per-widget).
  //   2. stop() called from the logout button actually stops the stream
  //      that HomePage started.
  getIt.registerLazySingleton<ProximityService>(
    () => ProximityService(),
  );

  // ---------------------------------------------------------------------------
  // Auth Feature
  // ---------------------------------------------------------------------------

  // Data
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      tokenDataSource: getIt(),
    ),
  );

  // Domain — Use Cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ResendOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => RestoreSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

  // Presentation — Cubits
  getIt.registerFactory(() => SignInCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => ForgetPasswordCubit(
        forgotPasswordUseCase: getIt(),
        verifyOtpUseCase: getIt(),
        resetPasswordUseCase: getIt(),
        resendOtpUseCase: getIt(),
      ));

  // ---------------------------------------------------------------------------
  // Home Feature
  // ---------------------------------------------------------------------------

  // Data — Real remote source (replaces FakeMonumentLocalDataSource).
  // FakeMonumentLocalDataSource is kept on disk but no longer wired into DI.
  getIt.registerLazySingleton<MonumentRemoteDataSource>(
    () => MonumentRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MonumentRepository>(
    () => MonumentRepositoryImpl(getIt<MonumentRemoteDataSource>()),
  );

  // Domain
  getIt.registerLazySingleton(() => GetMonumentsUseCase(getIt()));

  // Presentation — Factory so each HomePage entry gets a fresh cubit.
  getIt.registerFactory(() => HomeCubit(getIt()));

  // ---------------------------------------------------------------------------
  // Site Details Feature
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<SiteDetailRemoteDataSource>(
    () => SiteDetailRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<SiteDetailRepository>(
    () => SiteDetailRepositoryImpl(getIt<SiteDetailRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => GetSiteByIdUseCase(getIt()));
  getIt.registerFactory(() => SiteDetailsCubit(getIt()));

  // ---------------------------------------------------------------------------
  // Booking Feature
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton(() => CreateLocalBookingUseCase());
  getIt.registerFactory(() => TicketExportService());
}
