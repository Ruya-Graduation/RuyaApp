/// Result returned by [ProximityService.start] so callers can decide
/// how to surface the failure to the user without [ProximityService]
/// needing a [BuildContext].
enum LocationPermissionStatus {
  /// GPS stream started successfully.
  granted,

  /// User denied the permission prompt. Show a one-time explanation;
  /// do NOT re-prompt automatically.
  denied,

  /// User permanently denied location access (Android: "Don't ask again").
  /// Must direct the user to device Settings — the app cannot prompt again.
  deniedForever,

  /// Device location services (GPS/Network) are switched off at the OS level.
  /// Do not prompt for permission; prompt the user to enable location services.
  serviceDisabled,
}
