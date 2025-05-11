import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/config/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../controllers/theme_controller.dart';
import '../../widgets/build_lang_dropdown.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildSectionHeader(context, 'theme'.tr),
          const SizedBox(height: AppConstants.smallPadding),

          Obx(
            () => Column(
              children: [
                _buildThemeOption(
                  context,
                  title: 'light_mode'.tr,
                  icon: Icons.light_mode,
                  isSelected:
                      themeController.themeType.value == ThemeType.light,
                  onTap: () => themeController.changeTheme(ThemeType.light),
                ),
                _buildThemeOption(
                  context,
                  title: 'dark_mode'.tr,
                  icon: Icons.dark_mode,
                  isSelected: themeController.themeType.value == ThemeType.dark,
                  onTap: () => themeController.changeTheme(ThemeType.dark),
                ),
                _buildThemeOption(
                  context,
                  title: 'purple_theme'.tr,
                  icon: Icons.color_lens,
                  color: Colors.purple,
                  isSelected:
                      themeController.themeType.value == ThemeType.purple,
                  onTap: () => themeController.changeTheme(ThemeType.purple),
                ),
                _buildThemeOption(
                  context,
                  title: 'teal_theme'.tr,
                  icon: Icons.color_lens,
                  color: Colors.teal,
                  isSelected: themeController.themeType.value == ThemeType.teal,
                  onTap: () => themeController.changeTheme(ThemeType.teal),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.largePadding),

          _buildSectionHeader(context, 'language'.tr),
          const SizedBox(height: AppConstants.smallPadding),

          buildLanguageDropdown(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Divider(color: theme.dividerColor, thickness: 1),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: color ?? theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing:
          isSelected
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
      tileColor:
          isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 4,
      ),
    );
  }
}
