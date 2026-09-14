import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AnimatedRegisterBody(
      controller: controller,
    );
  }
}

class _AnimatedRegisterBody extends StatefulWidget {
  const _AnimatedRegisterBody({
    required this.controller,
  });

  final AuthController controller;

  @override
  State<_AnimatedRegisterBody> createState() =>
      _AnimatedRegisterBodyState();
}

class _AnimatedRegisterBodyState extends State<_AnimatedRegisterBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _backFade;
  late final Animation<Offset> _backSlide;

  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;

  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  late final Animation<double> _bottomFade;
  late final Animation<Offset> _bottomSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _backFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.25,
        curve: Curves.easeOutCubic,
      ),
    );

    _backSlide = Tween<Offset>(
      begin: const Offset(-0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.25,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.08,
        0.38,
        curve: Curves.easeOutCubic,
      ),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.08,
          0.38,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.22,
        0.50,
        curve: Curves.easeOutCubic,
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.22,
          0.50,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _formFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.34,
        0.72,
        curve: Curves.easeOutCubic,
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.34,
          0.72,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _buttonFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.50,
        0.82,
        curve: Curves.easeOutCubic,
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.50,
          0.82,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _bottomFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.65,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.65,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _animatedSection({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F7),
              Color(0xFFFFD6EC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _animatedSection(
                      fade: _backFade,
                      slide: _backSlide,
                      child: GestureDetector(
                        onTap: () =>
                            Get.offAllNamed(AppRoutes.login),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LOGO
                  _animatedSection(
                    fade: _logoFade,
                    slide: _logoSlide,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TITLE
                  _animatedSection(
                    fade: _titleFade,
                    slide: _titleSlide,
                    child: const Column(
                      children: [
                        Text(
                          'Create Account 🎉',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign up to start shopping',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // FORM
                  _animatedSection(
                    fade: _formFade,
                    slide: _formSlide,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: controller.nameController,
                          hint: 'Full Name',
                          prefixIcon:
                          Icons.person_outline,
                          validator: (v) =>
                          v!.isEmpty
                              ? 'Name required'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        AuthTextField(
                          controller: controller.emailController,
                          hint: 'Email or Phone',
                          prefixIcon:
                          Icons.email_outlined,
                          keyboardType:
                          TextInputType.emailAddress,
                          validator: (v) =>
                          v!.isEmpty
                              ? 'Email required'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        Obx(
                              () => AuthTextField(
                            controller:
                            controller.passwordController,
                            hint: 'Password',
                            prefixIcon:
                            Icons.lock_outline,
                            isPassword: true,
                            isPasswordHidden: controller
                                .isPasswordHidden.value,
                            onTogglePassword:
                            controller.togglePassword,
                            validator: (v) =>
                            v!.length < 6
                                ? 'Min 6 characters'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // SIGN UP BUTTON
                  _animatedSection(
                    fade: _buttonFade,
                    slide: _buttonSlide,
                    child: Obx(
                          () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed:
                          controller.isLoading.value
                              ? null
                              : controller.register,
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.primary,
                            disabledBackgroundColor:
                            AppColors.primary
                                .withValues(alpha: 0.65),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 220,
                            ),
                            switchInCurve:
                            Curves.easeOutCubic,
                            switchOutCurve:
                            Curves.easeInCubic,
                            child:
                            controller.isLoading.value
                                ? const SizedBox(
                              key: ValueKey(
                                'register_loading',
                              ),
                              width: 22,
                              height: 22,
                              child:
                              CircularProgressIndicator(
                                color:
                                Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Sign Up',
                              key: ValueKey(
                                'register_text',
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // SOCIAL + LOGIN
                  _animatedSection(
                    fade: _bottomFade,
                    slide: _bottomSlide,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.border,
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'OR CONTINUE WITH',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.border,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            SocialLoginButton(
                              label: 'Google',
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.w700,
                                  color:
                                  Color(0xFF4285F4),
                                ),
                              ),
                              onTap: () {},
                            ),

                            const SizedBox(width: 16),

                            SocialLoginButton(
                              label: 'Facebook',
                              icon: const Text(
                                'f',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight:
                                  FontWeight.w700,
                                  color:
                                  Color(0xFF1877F2),
                                ),
                              ),
                              onTap: () {},
                            ),

                            const SizedBox(width: 16),

                            SocialLoginButton(
                              label: 'Apple',
                              icon: const Icon(
                                Icons.apple,
                                size: 28,
                                color:
                                AppColors.black,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                AppColors.darkGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Get.offAllNamed(
                                    AppRoutes.login,
                                  ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                  AppColors.primary,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}