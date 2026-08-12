import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:ruya/core/presentation/cubit/bottom_nav_cubit.dart';
import 'package:ruya/core/network/dio_client.dart';
import 'package:ruya/core/session/token_local_data_source.dart';
import 'package:ruya/core/session/session_service.dart';

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
import 'package:ruya/features/home/data/datasources/monument_local_data_source.dart';
import 'package:ruya/features/home/data/repositories/monument_repository_impl.dart';

// Home — Domain
import 'package:ruya/features/home/domain/repositories/monument_repository.dart';
import 'package:ruya/features/home/domain/usecases/get_monuments_usecase.dart';

// Home — Presentation
import 'package:ruya/features/home/presentation/cubit/home_cubit.dart';

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

  // Data
  getIt.registerLazySingleton<MonumentLocalDataSource>(
    () => FakeMonumentLocalDataSource(),
  );
  getIt.registerLazySingleton<MonumentRepository>(
    () => MonumentRepositoryImpl(getIt()),
  );

  // Domain
  getIt.registerLazySingleton(() => GetMonumentsUseCase(getIt()));

  // Presentation
  getIt.registerFactory(() => HomeCubit(getIt()));
}
