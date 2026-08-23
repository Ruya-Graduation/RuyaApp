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

  /// Compile-time value baked in for web builds via
  /// `--dart-define-from-file=env.json` (or `--dart-define=BASE_URL=...`).
  /// Empty string when not provided (e.g. on non-web platforms, or a web
  /// build run without the define).
  static const String _webBaseUrl = String.fromEnvironment('BASE_URL');

  /// The backend base URL, e.g. `http://ruya.runasp.net`.
  static String get baseUrl {
    final raw = kIsWeb ? _webBaseUrl : dotenv.env['BASE_URL'];

    if (raw == null || raw.trim().isEmpty) {
      throw StateError(
        kIsWeb
            ? 'BASE_URL is not configured.\n\n'
              'SETUP (web):\n'
              '  1. Go to: GitHub Repo → Settings → Secrets and variables → Actions\n'
              '  2. Create secret "WEB_BASE_URL" with the raw URL, e.g.:\n'
              '     http://ruya.runasp.net\n'
              '  3. Push to main - GitHub Actions builds with '
              '--dart-define-from-file so BASE_URL is compiled in.\n\n'
              'For local web dev, create ruya/env.json (gitignored) with:\n'
              '  {"BASE_URL": "http://your.api.url"}\n'
              'and run: flutter run -d chrome --dart-define-from-file=env.json'
            : 'BASE_URL is not configured.\n\n'
              'SETUP (mobile/desktop):\n'
              '  1. Copy .env.example to .env in the ruya/ directory\n'
              '  2. Set BASE_URL=http://your.api.url\n'
              '  3. Re-run the app',
      );
    }

    return raw.trim().replaceAll(RegExp(r'/+$'), '');
  }
}