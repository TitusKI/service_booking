import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

enum ThemeType { light, dark, purple, teal }

class AppThemes {
  static ThemeData getThemeData(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        return LightTheme.themeData;
      case ThemeType.dark:
        return DarkTheme.themeData;
      case ThemeType.purple:
        return _getPurpleTheme();
      case ThemeType.teal:
        return _getTealTheme();
      default:
        return LightTheme.themeData;
    }
  }

  static ThemeData _getPurpleTheme() {
    return LightTheme.themeData.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData _getTealTheme() {
    return LightTheme.themeData.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
    );
  }
}
