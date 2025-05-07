import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_booking/app_binding.dart';
import 'package:service_booking/config/themes/app_theme.dart';
import 'config/translations/app_translations.dart';
import 'core/utils/size_config.dart';
import 'presentation/controllers/language_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/screens/services/services_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();

  Get.put<ThemeController>(ThemeController());
  Get.put<LanguageController>(LanguageController());

  runApp(const ServiceBookingApp());
}

class ServiceBookingApp extends StatelessWidget {
  const ServiceBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig for responsive design
    SizeConfig().init(context);

    //GetBuilder - updates for the entire MaterialApp
    return GetBuilder<LanguageController>(
      init: Get.find<LanguageController>(),
      builder: (langController) {
        return GetBuilder<ThemeController>(
          init: Get.find<ThemeController>(),
          builder: (themeController) {
            return GetMaterialApp(
              title: 'app_name'.tr,
              debugShowCheckedModeBanner: false,
              theme: _updateFonts(
                AppThemes.getThemeData(themeController.themeType.value),
              ),
              locale: langController.locale,
              fallbackLocale: const Locale('en', 'US'),
              translations: AppTranslations(),
              defaultTransition: Transition.cupertino,
              transitionDuration: const Duration(milliseconds: 300),
              initialBinding: AppBinding(),
              home: const ServicesListScreen(),
            );
          },
        );
      },
    );
  }

  ThemeData _updateFonts(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(theme.textTheme),
      primaryTextTheme: GoogleFonts.poppinsTextTheme(theme.primaryTextTheme),
    );
  }
}
