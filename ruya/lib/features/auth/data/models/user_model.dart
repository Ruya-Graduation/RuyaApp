import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

/// Data-layer representation of a user.
///
/// On login/register the backend returns only a JWT string — there is no
/// separate user object in the response body. [UserModel.fromJwt] decodes
/// the token's claims to reconstruct the user, using ASP.NET Core's full-URI
/// claim key format.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.preferredLanguage,
    required super.knowledgeLevel,
  });

  /// Decodes a raw JWT string into a [UserModel].
  ///
  /// ASP.NET Core serialises `ClaimTypes.*` as their full namespace URI:
  ///   - `ClaimTypes.NameIdentifier` → `…/nameidentifier`
  ///   - `ClaimTypes.Email`          → `…/emailaddress`
  ///   - `ClaimTypes.Name`           → `…/name`
  ///
  /// Custom claims (`PreferredLanguage`, `KnowledgeLevel`) are stored
  /// verbatim without a namespace prefix.
  factory UserModel.fromJwt(String token) {
    final claims = JwtDecoder.decode(token);

    const nameIdKey =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';
    const emailKey =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress';
    const nameKey =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name';

    return UserModel(
      id: claims[nameIdKey]?.toString() ?? '',
      email: claims[emailKey]?.toString() ?? '',
      name: claims[nameKey]?.toString() ?? '',
      preferredLanguage: claims['PreferredLanguage']?.toString() ?? 'en',
      knowledgeLevel: claims['KnowledgeLevel']?.toString() ?? 'beginner',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      preferredLanguage: json['preferredLanguage']?.toString() ?? 'en',
      knowledgeLevel: json['knowledgeLevel']?.toString() ?? 'beginner',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'preferredLanguage': preferredLanguage,
      'knowledgeLevel': knowledgeLevel,
    };
  }
}

