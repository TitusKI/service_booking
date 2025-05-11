import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../config/services/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/utils/size_config.dart';
import '../services/services_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: AppConstants.defaultAnimationDuration,
                  childAnimationBuilder:
                      (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                  children: [
                    SizedBox(height: getProportionateScreenHeight(40)),

                    Image.asset(
                      AssetConstants.logoImage,
                      height: getProportionateScreenHeight(100),
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.business_center_rounded,
                            size: getProportionateScreenHeight(80),
                            color: theme.colorScheme.primary,
                          ),
                    ),

                    SizedBox(height: getProportionateScreenHeight(20)),

                    Text(
                      'welcome_back'.tr,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: getProportionateScreenHeight(10)),

                    Text(
                      'login_to_continue'.tr,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: getProportionateScreenHeight(40)),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'email'.tr,
                              hintText: 'enter_your_email'.tr,
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.defaultRadius,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please_enter_email'.tr;
                              }
                              if (!GetUtils.isEmail(value)) {
                                return 'please_enter_valid_email'.tr;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: getProportionateScreenHeight(20)),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'password'.tr,
                              hintText: 'enter_your_password'.tr,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.defaultRadius,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please_enter_password'.tr;
                              }
                              if (value.length < 6) {
                                return 'password_too_short'.tr;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: getProportionateScreenHeight(20)),

                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                    Text('remember_me'.tr),
                                  ],
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Get.snackbar(
                                    'info'.tr,
                                    'forgot_password_not_implemented'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: Text('forgot_password'.tr),
                              ),
                            ],
                          ),

                          SizedBox(height: getProportionateScreenHeight(30)),

                          SizedBox(
                            width: double.infinity,
                            height: getProportionateScreenHeight(55),
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.defaultRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                'login'.tr,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: getProportionateScreenHeight(20)),

                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.defaultPadding,
                                ),
                                child: Text('or_sign_in_with'.tr),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),

                          SizedBox(height: getProportionateScreenHeight(20)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                icon: Icons.g_mobiledata_rounded,
                                color: Colors.red,
                                onTap: () => _handleSocialLogin('Google'),
                              ),
                              SizedBox(width: getProportionateScreenWidth(20)),
                              _buildSocialButton(
                                icon: Icons.facebook,
                                color: Colors.blue,
                                onTap: () => _handleSocialLogin('Facebook'),
                              ),
                              SizedBox(width: getProportionateScreenWidth(20)),
                              _buildSocialButton(
                                icon: Icons.apple,
                                color: Colors.black,
                                onTap: () => _handleSocialLogin('Apple'),
                              ),
                            ],
                          ),

                          SizedBox(height: getProportionateScreenHeight(30)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('dont_have_account'.tr),
                              TextButton(
                                onPressed: () {
                                  Get.snackbar(
                                    'info'.tr,
                                    'register_not_implemented'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: Text(
                                  'sign_up'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      StorageService().setBool('isLoggedIn', true);

      Get.snackbar(
        'success'.tr,
        'login_successful'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const ServicesListScreen());
    }
  }

  void _handleSocialLogin(String provider) {
    Get.snackbar(
      'info'.tr,
      '$provider ${'login_not_implemented'.tr}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
