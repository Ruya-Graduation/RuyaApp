import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for environment-driven configuration.
///
/// SECURITY:
/// - Environment variables are injected at BUILD TIME by GitHub Actions
/// - They are never stored in git or exposed in URLs
/// - They are never visible in the web app bundle
/// - The .env file is only used on mobile/desktop
///
/// On web:
/// - GitHub Actions injects BASE_URL into a config file at build time
/// - AppConfig reads it from dotenv (which was pre-populated during build)
/// - The value is used by DioClient to configure the API base URL
class AppConfig {
  AppConfig._();

  /// The backend base URL, e.g. `http://ruya.runasp.net`.
  ///
  /// SECURE FLOW:
  /// 1. GitHub Actions (deploy-web.yml) reads ENV_FILE secret
  /// 2. Creates .env file with BASE_URL during build (before web build starts)
  /// 3. Flutter build process loads .env into dotenv
  /// 4. This getter reads from dotenv.env['BASE_URL']
  /// 5. Value is never exposed in URLs or public configs
  static String get baseUrl {
    final raw = dotenv.env['BASE_URL'];
    
    if (raw == null || raw.trim().isEmpty) {
      throw StateError(
        'BASE_URL is not configured.\n\n'
        'SETUP:\n'
        '  1. Go to: GitHub Repo → Settings → Secrets and variables → Actions\n'
        '  2. Create secret "ENV_FILE" with content:\n'
        '     BASE_URL=http://your.api.url\n'
        '  3. Push to main - GitHub Actions will inject it at build time\n\n'
        'For more info, see deploy-web.yml in .github/workflows/'
      );
    }

    return raw.trim().replaceAll(RegExp(r'/+$'), '');
  }
}