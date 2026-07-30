import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:ruya/core/presentation/cubit/bottom_nav_cubit.dart';

// Auth — Data
import 'package:ruya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ruya/features/auth/data/repositories/auth_repository_impl.dart';

// Auth — Domain
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';
import 'package:ruya/features/auth/domain/usecases/register_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/sign_in_usecase.dart';

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
  // Core
  // ---------------------------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerFactory(() => BottomNavCubit());

  // ---------------------------------------------------------------------------
  // Auth Feature
  // ---------------------------------------------------------------------------

  // Data
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => FakeAuthRemoteDataSource(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  // Domain
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));

  // Presentation
  getIt.registerFactory(() => SignInCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => ForgetPasswordCubit());

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
