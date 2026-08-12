abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

/// Failure produced when the backend returns a `ValidationProblemDetails`
/// response (i.e. ASP.NET model-validation short-circuit before controller
/// logic runs). Carries a field-level error map so the presentation layer can
/// show per-field messages rather than a single banner.
///
/// Keys are the field names as returned by the server (e.g. `"Email"`,
/// `"Password"`). Values are the list of error strings for that field.
class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  ValidationFailure(super.message, {required this.fieldErrors});
}

