import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for environment-driven configuration.
///
/// - On web: `BASE_URL` is injected at BUILD TIME via `--dart-define-from-file`
///   (see `.github/workflows/deploy-web.yml`). It becomes a compile-time
///   constant baked into main.dart.js. There is no `.env` file involved on
///   web at all — nothing is ever fetched at runtime.
/// - On mobile/desktop: `BASE_URL` is read from the local `.env` file via
///   flutter_dotenv, loaded in `main.dart` before `runApp`.
class AppConfig {
  AppConfig._();

  /// Compile-time value baked in via `--dart-define` or `--dart-define-from-file`.
  /// Works across all platforms (Web, Android, iOS, Desktop, Tests).
  static const String _envBaseUrl = String.fromEnvironment('BASE_URL');

  /// The backend base URL, e.g. `https://ruya.runasp.net`.
  static String get baseUrl {
    // 1. Check compile-time environment define first (Web & Mobile when defined)
    if (_envBaseUrl.trim().isNotEmpty) {
      return _cleanUrl(_envBaseUrl);
    }

    // 2. Fall back to flutter_dotenv if initialized (Mobile / Desktop)
    if (dotenv.isInitialized) {
      final dotEnvValue = dotenv.maybeGet('BASE_URL');
      if (dotEnvValue != null && dotEnvValue.trim().isNotEmpty) {
        return _cleanUrl(dotEnvValue);
      }
    }

    // 3. Clear, descriptive setup instructions if BASE_URL is not configured
    throw StateError(
      kIsWeb
          ? 'BASE_URL is not configured.\n\n'
              'SETUP (web):\n'
              '  1. Go to: GitHub Repo → Settings → Secrets and variables → Actions\n'
              '  2. Create secret "WEB_BASE_URL" with the raw URL, e.g.:\n'
              '     https://ruya.runasp.net\n'
              '  3. Push to main - GitHub Actions builds with '
              '--dart-define-from-file so BASE_URL is compiled in.\n\n'
              'For local web dev, create ruya/env.json (gitignored) with:\n'
              '  {"BASE_URL": "https://your.api.url"}\n'
              'and run: flutter run -d chrome --dart-define-from-file=env.json'
          : 'BASE_URL is not configured.\n\n'
              'SETUP (mobile/desktop):\n'
              '  1. Copy .env.example to .env in the ruya/ directory\n'
              '  2. Set BASE_URL=https://your.api.url\n'
              '  3. Make sure ".env" is listed under assets in pubspec.yaml\n'
              '  4. Re-run the app',
    );
  }

  static String _cleanUrl(String url) {
    return url.trim().replaceAll(RegExp(r'/+$'), '');
  }
}
