import 'package:get/get.dart';
import 'package:service_booking/config/themes/app_theme.dart';
import '../../config/themes/theme_service.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _themeService = ThemeService();

  Rx<ThemeType> themeType = ThemeType.light.obs;

  @override
  void onInit() {
    super.onInit();
    themeType.value = _themeService.themeType;
  }

  bool get isDarkMode => _themeService.isDarkMode;

  void changeTheme(ThemeType type) {
    themeType.value = type;
    _themeService.changeTheme(type);
  }

  void toggleTheme() {
    _themeService.toggleTheme();
    themeType.value = _themeService.themeType;
  }
}
