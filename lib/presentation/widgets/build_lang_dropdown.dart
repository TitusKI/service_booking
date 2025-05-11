import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/size_config.dart';
import '../controllers/language_controller.dart';

Widget buildLanguageDropdown(BuildContext context) {
  final theme = Theme.of(context);
  final languageController = Get.find<LanguageController>();

  final currentLocaleFullCode = languageController.getCurrentLocaleFullCode();

  final initialValue =
      languageController.availableLanguages
          .firstWhereOrNull(
            (lang) => lang.fullLanguageCode == currentLocaleFullCode,
          )
          ?.fullLanguageCode;

  return Container(
    width: getProportionateScreenWidth(300),
    padding: const EdgeInsets.symmetric(
      horizontal: AppConstants.defaultPadding,
      vertical: AppConstants.smallPadding,
    ),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'select_language'.tr,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),

      value: initialValue,
      items:
          languageController.availableLanguages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang.fullLanguageCode,
              child: Row(
                children: [
                  if (lang.flag != null)
                    Image.asset(
                      lang.flag!,
                      width: 24,
                      height: 24,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.flag_outlined, size: 24),
                    ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(lang.name!.tr),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          languageController.changeLanguage(value);
        }
      },
    ),
  );
}
