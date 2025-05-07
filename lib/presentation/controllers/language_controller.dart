import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _box = GetStorage();
  final _key = 'languageCode';

  Locale? get locale {
    final code = _box.read(_key);
    if (code == null) return Get.deviceLocale;
    return Locale(code.split('_')[0], code.split('_')[1]);
  }

  void saveLanguage(String languageCode, String countryCode) {
    _box.write(_key, '${languageCode}_$countryCode');
  }

  void changeLanguage(String languageCode, String countryCode) {
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
    saveLanguage(languageCode, countryCode);
  }

  bool isCurrentLanguage(String languageCode, String countryCode) {
    final current = locale;
    if (current == null) return false;
    return current.languageCode == languageCode &&
        current.countryCode == countryCode;
  }
}
