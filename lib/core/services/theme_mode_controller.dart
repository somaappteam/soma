import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends ChangeNotifier {
  static const _storageKey = 'theme_mode';
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  String get modeSettingValue => serialize(_mode);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored != null) {
      _mode = parse(stored);
      notifyListeners();
    }
  }

  Future<void> setMode(final ThemeMode mode, {final bool persist = true}) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    if (persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, serialize(mode));
    }
  }

  Future<void> setModeFromSetting(final String value, {final bool persist = true}) {
    return setMode(parse(value), persist: persist);
  }

  static ThemeMode parse(final String value) {
    switch (value) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  static String serialize(final ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.system:
        return 'System';
    }
  }
}

final themeModeController = ThemeModeController();
