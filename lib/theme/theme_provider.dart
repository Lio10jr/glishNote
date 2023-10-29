import 'package:fastenglish/theme/dark_theme.dart';
import 'package:fastenglish/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
  void toggleTheme(bool modo) {
    if (modo == true) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}