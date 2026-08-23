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

  // On web, BASE_URL is injected at BUILD TIME via --dart-define-from-file
  // (see .github/workflows/deploy-web.yml) and read as a compile-time
  // constant in AppConfig — no .env file exists or is fetched on web.
  // On mobile/desktop, load the real .env file from disk.
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Could not load .env file on mobile: $e');
      }
    }
  } else {
    // For web, we don't need to load anything - BASE_URL is available via AppConfig
    if (kDebugMode) {
      print('Running on web - using injected configuration');
    }
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.brandPrimaryLight,
            ),
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
