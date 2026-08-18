import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit that persists the user's "GPS Narration" toggle state across restarts.
///
/// Registered as a **LazySingleton** in the DI container so both [HomePage]
/// and [AppPreferencesCard] read/write the same instance.
///
/// Key: [_key] in [SharedPreferences]. Default: `true` (enabled on first run).
class LocationSettingsCubit extends Cubit<bool> {
  static const String _key = 'gps_narration_enabled';

  final SharedPreferences _prefs;

  LocationSettingsCubit(this._prefs)
      : super(_prefs.getBool(_key) ?? true /* default: enabled */);

  /// Toggles GPS narration on or off and persists the new value immediately.
  Future<void> setGpsEnabled(bool enabled) async {
    await _prefs.setBool(_key, enabled);
    emit(enabled);
  }
}
