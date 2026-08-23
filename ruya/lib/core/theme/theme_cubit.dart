import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _key = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final modeName = prefs.getString(_key);
    if (modeName == 'dark') {
      return ThemeMode.dark;
    } else if (modeName == 'light') {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    _prefs.setString(_key, mode.name);
    emit(mode);
  }

  void toggle() {
    setThemeMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
