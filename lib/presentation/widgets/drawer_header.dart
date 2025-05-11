import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/themes/app_theme.dart';
import '../controllers/theme_controller.dart';
import 'theme_toggle_button.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final ThemeController themeController;

  const DrawerHeaderWidget({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final isDark = themeController.themeType.value == ThemeType.dark;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 27,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'service_booking_app'.tr,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'user@example.com',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: ThemeToggleButton(
                    isDark: isDark,
                    onTap: () {
                      themeController.changeTheme(
                        isDark ? ThemeType.light : ThemeType.dark,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
