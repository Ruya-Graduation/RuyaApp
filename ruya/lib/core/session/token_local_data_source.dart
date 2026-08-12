import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists and retrieves the JWT auth token using [FlutterSecureStorage].
///
/// FlutterSecureStorage stores data in the platform keychain (iOS) /
/// EncryptedSharedPreferences (Android), making it significantly harder to
/// extract than plain SharedPreferences. This is the preferred store for
/// security-sensitive values like auth tokens.
///
/// Note for future devs: SharedPreferences would also work but stores data
/// in plaintext on disk — anyone with physical or root access can read it.
class TokenLocalDataSource {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  const TokenLocalDataSource(this._storage);

  /// Persists [token] securely on the device.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Returns the stored token, or `null` if no token is present.
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// Deletes the stored token (e.g. on logout or session expiry).
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
