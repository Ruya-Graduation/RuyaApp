import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for environment-driven configuration.
///
/// Call [AppConfig.baseUrl] anywhere in the app. If the `.env` file is
/// missing the `BASE_URL` key (e.g. a developer forgot to copy
/// `.env.example` → `.env`), this throws a descriptive [StateError]
/// immediately instead of producing a silent null / empty-string URL.
class AppConfig {
  AppConfig._();

  /// The backend base URL, e.g. `http://ruya.runasp.net`.
  ///
  /// Sourced from the `BASE_URL` key in `.env`.
  /// Trailing slashes are stripped so callers can safely append paths.
  static String get baseUrl {
    final raw = dotenv.env['BASE_URL'];
    if (raw == null || raw.trim().isEmpty) {
      throw StateError(
        'BASE_URL is not set in .env. '
        'Copy .env.example → .env and fill in the value.',
      );
    }
    return raw.trim().replaceAll(RegExp(r'/+$'), '');
  }
}
