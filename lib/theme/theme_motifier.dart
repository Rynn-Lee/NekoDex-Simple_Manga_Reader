import 'package:flutter/material.dart';
import 'package:neko_dex/stores/preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    setTheme();
  }

  void setTheme() async {
    _themeMode = await loadTheme();
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    saveTheme(_themeMode);
    notifyListeners();
  }
}