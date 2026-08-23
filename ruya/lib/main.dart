import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/localization/locale_cubit.dart';
import 'package:ruya/core/routing/app_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env BEFORE configuring dependencies so AppConfig.baseUrl is available
  // during DI setup. On web, .env might not exist (it's not bundled in the build),
  // so we handle the exception gracefully.
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ Warning: Could not load .env file: $e');
      print('ℹ️ On web deployment, this is expected. Using fallback configuration.');
    }
    // On web, .env doesn't exist in the deployed build.
    // AppConfig will fall back to query parameters or defaults.
  }
  
  await configureDependencies();
  runApp(
    BlocProvider(
      create: (context) => LocaleCubit(getIt()),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          title: 'Ruya',
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brandPrimaryLight),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.brandPrimaryDark,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}