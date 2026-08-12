import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ruya/core/session/token_local_data_source.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

/// Reads the persisted JWT, decodes its claims, and checks expiry —
/// all **locally**, with no server round-trip.
///
/// There is no token-refresh or "validate token" endpoint on the backend,
/// so expiry is checked client-side using the standard `exp` claim.
class SessionService {
  final TokenLocalDataSource _tokenDataSource;

  const SessionService(this._tokenDataSource);

  /// Returns a [UserEntity] decoded from the stored JWT if the token exists
  /// and has not expired, or `null` otherwise.
  ///
  /// Side-effect: if a token IS present but IS expired, it is cleared from
  /// storage so the next call doesn't have to re-check.
  Future<UserEntity?> restoreSession() async {
    final token = await _tokenDataSource.getToken();
    if (token == null) return null;

    try {
      if (JwtDecoder.isExpired(token)) {
        await _tokenDataSource.clearToken();
        return null;
      }

      final claims = JwtDecoder.decode(token);
      return _claimsToEntity(claims);
    } catch (_) {
      // Malformed token — treat as no session.
      await _tokenDataSource.clearToken();
      return null;
    }
  }

  /// Decodes JWT claims into a [UserEntity].
  ///
  /// ASP.NET Core serialises the well-known claim types as their full URI
  /// form inside the token, e.g.:
  ///   - `nameidentifier` → `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier`
  ///   - `emailaddress`   → `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`
  ///   - `name`           → `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name`
  ///   - `PreferredLanguage` / `KnowledgeLevel` are custom claims stored as-is.
  static UserEntity _claimsToEntity(Map<String, dynamic> claims) {
    const nameIdKey =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';
    const emailKey =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress';
    const nameKey =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name';

    return UserEntity(
      id: claims[nameIdKey]?.toString() ?? '',
      email: claims[emailKey]?.toString() ?? '',
      name: claims[nameKey]?.toString() ?? '',
      preferredLanguage: claims['PreferredLanguage']?.toString() ?? 'en',
      knowledgeLevel: claims['KnowledgeLevel']?.toString() ?? 'beginner',
    );
  }
}
