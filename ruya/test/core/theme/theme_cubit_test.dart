import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruya/core/theme/theme_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    test('initial state defaults to ThemeMode.system when no pref stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(prefs);

      expect(cubit.state, ThemeMode.system);
    });

    test('initial state loads stored dark theme', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(prefs);

      expect(cubit.state, ThemeMode.dark);
    });

    test('setThemeMode updates state and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(prefs);

      cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);
      expect(prefs.getString('app_theme_mode'), 'dark');

      cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state, ThemeMode.light);
      expect(prefs.getString('app_theme_mode'), 'light');
    });

    test('toggle switches between light and dark', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(prefs);

      cubit.toggle();
      expect(cubit.state, ThemeMode.dark);

      cubit.toggle();
      expect(cubit.state, ThemeMode.light);
    });
  });
}
