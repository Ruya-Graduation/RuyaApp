import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for environment-driven configuration.
///
/// On native platforms (mobile/desktop):
/// - Reads from `.env` file (BASE_URL key)
///
/// On web:
/// - Tries `.env` first (if available)
/// - Falls back to query parameter: ?baseUrl=...
/// - Uses hardcoded default as final fallback
///
/// Example web URLs:
/// - https://ruya-graduation.github.io/RuyaApp/?baseUrl=http://ruya.runasp.net
/// - https://ruya-graduation.github.io/RuyaApp/?baseUrl=http%3A%2F%2Fruya.runasp.net (URL-encoded)
class AppConfig {
  AppConfig._();

  /// The backend base URL, e.g. `http://ruya.runasp.net`.
  ///
  /// Priority (in order):
  /// 1. `BASE_URL` from `.env` file (native + web if available)
  /// 2. `?baseUrl=...` query parameter (web only)
  /// 3. Hardcoded fallback (for demo/testing)
  static String get baseUrl {
    // Try 1: dotenv environment (.env file) - works on all platforms
    var raw = dotenv.env['BASE_URL'];

    // Try 2: Web query parameter - only on web if .env didn't provide a value
    if ((raw == null || raw.trim().isEmpty) && kIsWeb) {
      try {
        final queryParams = Uri.base.queryParameters;
        if (queryParams.containsKey('baseUrl') && queryParams['baseUrl']!.isNotEmpty) {
          raw = queryParams['baseUrl'];
        }
      } catch (e) {
        // Silently ignore query parameter parsing errors
      }
    }

    // Try 3: Hardcoded fallback
    // ⚠️ IMPORTANT: For production, replace this with your actual API URL
    // or ensure the query parameter is always provided
    raw ??= 'http://ruya.runasp.net';

    // Final validation
    if (raw.trim().isEmpty) {
      throw StateError(
        'BASE_URL is not configured.\n\n'
        'To fix this:\n'
        '  • Mobile/Desktop: Copy .env.example → .env and set BASE_URL\n'
        '  • Web: Add query parameter to URL: ?baseUrl=http://your.api.url\n'
        '  • Code: Update the hardcoded fallback in app_config.dart'
      );
    }

    return raw.trim().replaceAll(RegExp(r'/+$'), '');
  }
}