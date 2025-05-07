import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service_booking/config/themes/app_theme.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'themeType';

  ThemeType get themeType {
    final value = _box.read(_key);
    if (value == null) return ThemeType.light;
    return ThemeType.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => ThemeType.light,
    );
  }

  ThemeData get theme => AppThemes.getThemeData(themeType);

  bool get isDarkMode => themeType == ThemeType.dark;

  void saveTheme(ThemeType themeType) => _box.write(_key, themeType.toString());

  void changeTheme(ThemeType themeType) {
    Get.changeTheme(AppThemes.getThemeData(themeType));
    saveTheme(themeType);
  }

  void toggleTheme() {
    final newTheme = isDarkMode ? ThemeType.light : ThemeType.dark;
    changeTheme(newTheme);
  }
}
