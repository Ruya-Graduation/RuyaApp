import 'package:ruya/core/session/session_service.dart';
import 'package:ruya/features/auth/domain/entities/user_entity.dart';

/// Restores a previously persisted session from the stored JWT.
///
/// Returns the decoded [UserEntity] if the stored token is present and
/// has not expired, or `null` otherwise. This is a local-only operation —
/// no network call is made (there is no token-refresh endpoint on the backend).
///
/// The return type is nullable [UserEntity] rather than
/// `Either<Failure, UserEntity?>` because a missing/expired session is not
/// an error — it is the normal "not logged in" state that the router handles
/// by redirecting to the auth page.
class RestoreSessionUseCase {
  final SessionService _sessionService;

  RestoreSessionUseCase(this._sessionService);

  Future<UserEntity?> call() {
    return _sessionService.restoreSession();
  }
}
