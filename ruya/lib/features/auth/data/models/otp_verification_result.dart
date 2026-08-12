/// Value object returned by the `/api/Auth/verify-otp` endpoint.
///
/// The [resetToken] is opaque and must be passed verbatim to
/// `/api/Auth/reset-password`. It expires in [expiresInSeconds] seconds
/// (typically 300 = 5 minutes).
class OtpVerificationResult {
  final String resetToken;
  final int expiresInSeconds;

  const OtpVerificationResult({
    required this.resetToken,
    required this.expiresInSeconds,
  });
}
