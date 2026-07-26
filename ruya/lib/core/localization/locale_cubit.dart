import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _localeKey = 'app_locale';
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs) : super(_loadInitialLocale(_prefs));

  static Locale _loadInitialLocale(SharedPreferences prefs) {
    final langCode = prefs.getString(_localeKey);
    if (langCode != null) {
      return Locale(langCode);
    }
    return const Locale('en'); // Default to English
  }

  void setLocale(Locale locale) {
    _prefs.setString(_localeKey, locale.languageCode);
    emit(locale);
  }

  void toggle() {
    if (state.languageCode == 'en') {
      setLocale(const Locale('ar'));
    } else {
      setLocale(const Locale('en'));
    }
  }
}
