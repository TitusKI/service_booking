import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/config/services/storage_service.dart';
import '../controllers/theme_controller.dart';
import '../screens/auth/login_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/services/add_edit_service.dart';
import 'drawer_header.dart';
import 'drawer_list_item.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Drawer(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            DrawerHeaderWidget(themeController: themeController),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerListItem(
                    icon: Icons.home,
                    title: 'home'.tr,
                    onTap: () => Navigator.pop(context),
                    index: 0,
                  ),
                  DrawerListItem(
                    icon: Icons.add_circle_outline,
                    title: 'add_service'.tr,
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(
                        () => const AddEditServiceScreen(),
                        transition: Transition.downToUp,
                      );
                    },
                    index: 1,
                  ),
                  DrawerListItem(
                    icon: Icons.settings,
                    title: 'settings'.tr,
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const SettingsScreen());
                    },
                    index: 2,
                  ),
                  const Divider(height: 24, thickness: 1),
                  DrawerListItem(
                    icon: Icons.logout,
                    title: 'logout'.tr,
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutConfirmation(context);
                    },
                    isDestructive: true,
                    index: 3,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final storageController = Get.find<StorageService>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'confirm_logout'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('are_you_sure_logout'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back();
              storageController.logout();

              Get.offAll(
                () => const LoginScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 500),
              );
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeOutQuad,
    );
  }
}
