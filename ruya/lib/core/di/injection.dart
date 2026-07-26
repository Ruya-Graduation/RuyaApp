import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruya/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ruya/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';
import 'package:ruya/features/auth/domain/usecases/register_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ruya/features/auth/presentation/cubit/register_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/sign_in_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => FakeAuthRemoteDataSource());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  
  getIt.registerFactory(() => SignInCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
}
