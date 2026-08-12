import 'package:ruya/features/auth/domain/repositories/auth_repository.dart';

/// Clears the persisted JWT and ends the current session.
///
/// After calling this use case, [RestoreSessionUseCase] will return `null`,
/// and the router should redirect the user back to the auth page.
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
