import 'package:ruya/core/location/site_location.dart';

/// Emitted by [ProximityService] when the user first enters a site's radius
/// within the current app session. The "once per session" rule is enforced
/// inside [ProximityService] — consumers do not need to dedupe.
class ProximityEvent {
  final SiteLocation site;

  const ProximityEvent(this.site);
}
