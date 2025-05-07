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
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  static ThemeData _getTealTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
