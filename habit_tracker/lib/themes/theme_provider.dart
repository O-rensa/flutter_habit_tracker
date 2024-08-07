import "package:flutter/material.dart";
import "package:habit_tracker/themes/dark_mode.dart";
import "package:habit_tracker/themes/light_mode.dart";

class ThemeProvider extends ChangeNotifier {
  // initially, light mode
  ThemeData _themeData = lightMode;

  // themedata getter
  ThemeData get themeData => _themeData;

  // is darkmode getter
  bool get isDarkMode => _themeData == darkMode;
  
  // themedata setter
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}