import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import '../../../config/services/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/size_config.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/build_lang_dropdown.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final LanguageController _languageController = Get.find<LanguageController>();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'welcome_to_service_booking',
      'description': 'discover_and_book_services',
      'animation': 'assets/animations/welcome.json',
    },
    {
      'title': 'find_perfect_service',
      'description': 'browse_variety_of_services',
      'animation': 'assets/animations/search.json',
    },
    {
      'title': 'choose_your_language',
      'description': 'select_preferred_language',
      'animation': 'assets/animations/language.json',
      'showLanguageSelector': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return AnimationLimiter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: AppConstants.defaultAnimationDuration,
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.largePadding,
                            ),
                            child: Lottie.asset(
                              _onboardingData[index]['animation'],
                              height: getProportionateScreenHeight(250),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          Text(
                            (_onboardingData[index]['title'] as String).tr,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.largePadding,
                            ),
                            child: Text(
                              (_onboardingData[index]['description'] as String)
                                  .tr,
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          if (_onboardingData[index]['showLanguageSelector'] ==
                              true)
                            buildLanguageDropdown(context),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomNavigation(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _completeOnboarding(),
            child: Text('skip'.tr),
          ),

          Row(
            children: List.generate(
              _onboardingData.length,
              (index) => AnimatedContainer(
                duration: AppConstants.defaultAnimationDuration,
                margin: const EdgeInsets.only(right: 5),
                height: 10,
                width: _currentPage == index ? 20 : 10,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              if (_currentPage == _onboardingData.length - 1) {
                _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: AppConstants.defaultAnimationDuration,
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: Icon(
              _currentPage == _onboardingData.length - 1
                  ? Icons.check
                  : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() {
    StorageService().setBool('onboardingCompleted', true);

    Get.offAll(() => const LoginScreen());
  }
}
