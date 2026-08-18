import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:ruya/core/location/location_permission_status.dart';
import 'package:ruya/core/location/proximity_event.dart';
import 'package:ruya/core/location/site_location.dart';

/// Foreground-only GPS proximity service.
///
/// ## Responsibilities
/// - Streams device position via [Geolocator.getPositionStream].
/// - Computes Haversine distance to every watched site on each position update.
/// - Emits a [ProximityEvent] when the user first enters a site's radius
///   within the current app session (once-per-site session dedupe).
/// - Exposes [start] / [stop] so callers can manage the foreground lifecycle.
///
/// ## Lifecycle contract
/// - Register as a **LazySingleton** in the DI container so the same instance
///   (and the same [_notifiedSiteIds] set) is shared across all callers.
/// - [start] is idempotent — calling it while already streaming is a no-op.
/// - [stop] cancels the subscription and nulls it so [start] can safely
///   re-subscribe later without leaking listeners.
/// - [updateSites] is safe to call before or after [start].
///
/// ## Foreground-only note
/// The stream is started from [HomePage] after the user lands there and
/// the site list has loaded. It is paused via [stop] whenever the app is
/// backgrounded ([AppLifecycleState.paused/inactive]), and resumed on
/// [AppLifecycleState.resumed] — see [HomePage.didChangeAppLifecycleState].
/// It is NOT stopped on tab-switches; it runs for the full foreground session
/// after Home has loaded (see comment in home_page.dart for rationale).
class ProximityService {
  /// Radius within which a site is considered "nearby".
  /// Named constant for easy future tuning — do NOT scatter the magic number.
  static const double _proximityRadiusMeters = 300.0;

  /// GPS position filter: only recompute distances after moving ≥ 25 m.
  /// Avoids flooding the distance loop on GPS micro-jitter.
  static const int _distanceFilterMeters = 25;

  // ignore: prefer_initializing_formals — _sites is non-final (mutable via updateSites)
  List<SiteLocation> _sites;

  final StreamController<ProximityEvent> _controller =
      StreamController<ProximityEvent>.broadcast();

  /// Site IDs for which a proximity snackbar has already been shown this
  /// session. In-memory only; resets on full app relaunch.
  final Set<String> _notifiedSiteIds = {};

  StreamSubscription<Position>? _positionSubscription;

  // ignore: prefer_initializing_formals
  ProximityService({List<SiteLocation> sites = const []}) : _sites = sites;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Broadcast stream of [ProximityEvent]s. Listen once from [HomePage] and
  /// keep the subscription alive for the foreground session.
  Stream<ProximityEvent> get events => _controller.stream;

  /// Replaces the watched site list. Safe to call at any time.
  void updateSites(List<SiteLocation> sites) {
    _sites = sites;
  }

  /// Starts the GPS position stream after checking/requesting permission.
  ///
  /// Returns a [LocationPermissionStatus] describing the outcome so the caller
  /// can surface meaningful UI feedback without this service needing a context.
  ///
  /// No-ops gracefully if:
  ///   - Already streaming (idempotent).
  ///   - [_sites] is empty (no sites to watch).
  ///   - Device location services are disabled.
  ///   - Permission is denied or permanently denied.
  Future<LocationPermissionStatus> start() async {
    // Guard: already streaming → no-op.
    if (_positionSubscription != null) return LocationPermissionStatus.granted;

    // Guard: no sites loaded yet → no point streaming.
    if (_sites.isEmpty) return LocationPermissionStatus.granted;

    // Check device-level location services first (GPS/Network off at OS level).
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionStatus.serviceDisabled;

    // Check / request runtime permission.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return LocationPermissionStatus.denied;
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    // Permission granted — start streaming.
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: _distanceFilterMeters,
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPosition,
      onError: (_) {
        // Silently swallow position errors (e.g. brief GPS signal loss).
        // The stream will recover on the next valid fix.
      },
      cancelOnError: false,
    );

    return LocationPermissionStatus.granted;
  }

  /// Stops the GPS position stream. Safe to call even if not streaming.
  /// After [stop], [start] can be called again without leaking listeners.
  void stop() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Disposes the broadcast controller. Call only when the service itself
  /// is being torn down (app shutdown). In normal use, call [stop] instead.
  void dispose() {
    stop();
    _controller.close();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _onPosition(Position position) {
    for (final site in _sites) {
      // Skip sites that have already triggered a notification this session.
      if (_notifiedSiteIds.contains(site.id)) continue;

      final distanceMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        site.latitude,
        site.longitude,
      );

      if (distanceMeters <= _proximityRadiusMeters) {
        // Mark as notified BEFORE emitting so re-entrant listeners can't
        // trigger a double-notification.
        _notifiedSiteIds.add(site.id);
        _controller.add(ProximityEvent(site));
      }
    }
  }
}
