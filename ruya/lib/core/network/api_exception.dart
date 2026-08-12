/// Internal exception that bridges Dio/HTTP errors to the domain layer.
///
/// This type never escapes the `data/` layer — repositories catch it and
/// convert it to the appropriate [Failure] subtype. It deliberately avoids
/// carrying Dio types so that `domain/` and `presentation/` stay clean.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  /// Non-null only when the backend returned a `ValidationProblemDetails`
  /// response (missing/malformed fields). Maps field names → list of errors,
  /// e.g. `{'Email': ['Invalid email address format.']}`.
  final Map<String, List<String>>? fieldErrors;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.fieldErrors,
  });

  bool get isNetworkError => statusCode == -1;
  bool get isValidationError => fieldErrors != null && fieldErrors!.isNotEmpty;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, '
      'fieldErrors: $fieldErrors)';
}
