import 'package:fastenglish/theme/dark_theme.dart';
import 'package:fastenglish/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    if (isDarkMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
  }
  
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(bool modo) {
    _isDarkMode = modo;

    if (modo == true) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }

    _saveThemeMode(modo);
  }

  Future<void> _saveThemeMode(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
  }
}