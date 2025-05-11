import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/model/language_model.dart';
import '../../config/translations/language_list.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _box = GetStorage();
  final _key = 'languageCode';

  List<LanguageDataModel> get availableLanguages => languageList;

  Locale? get locale {
    final fullCode = _box.read<String?>(_key);
    if (fullCode == null) {
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null && deviceLocale.countryCode != null) {
        return Locale(deviceLocale.languageCode, deviceLocale.countryCode!);
      }
      return Get.deviceLocale;
    }

    final parts = fullCode.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else if (parts.length == 1) {
      return Locale(parts[0]);
    }

    final deviceLocale = Get.deviceLocale;
    if (deviceLocale != null && deviceLocale.countryCode != null) {
      return Locale(deviceLocale.languageCode, deviceLocale.countryCode!);
    }
    return const Locale('en', 'US');
  }

  void saveLanguage(String fullLanguageCode) {
    _box.write(_key, fullLanguageCode);
  }

  void changeLanguage(String fullLanguageCode) {
    final parts = fullLanguageCode.split('_');
    if (parts.length == 2) {
      final locale = Locale(parts[0], parts[1]);
      Get.updateLocale(locale);
      saveLanguage(fullLanguageCode);
    } else if (parts.length == 1) {
      final locale = Locale(parts[0]);
      Get.updateLocale(locale);
      saveLanguage(fullLanguageCode);
    } else {
      print(
        'Invalid fullLanguageCode format for changeLanguage: $fullLanguageCode',
      );
    }
  }

  bool isCurrentLanguage(String fullLanguageCode) {
    final current = locale;
    if (current == null) return false;

    final parts = fullLanguageCode.split('_');
    if (parts.length == 2) {
      return current.languageCode == parts[0] &&
          current.countryCode == parts[1];
    } else if (parts.length == 1) {
      return current.languageCode == parts[0] && current.countryCode == null;
    }
    return false;
  }

  String? getCurrentLocaleFullCode() {
    final current = locale;
    if (current == null) return null;

    if (current.countryCode != null) {
      return '${current.languageCode}_${current.countryCode}';
    }
    return current.languageCode;
  }
}
