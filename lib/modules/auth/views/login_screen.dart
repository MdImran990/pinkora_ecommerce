import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import '../../../app/theme/app_colors.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AnimatedLoginBody(
      controller: controller,
    );
  }
}

class _AnimatedLoginBody extends StatefulWidget {
  const _AnimatedLoginBody({
    required this.controller,
  });

  final AuthController controller;

  @override
  State<_AnimatedLoginBody> createState() => _AnimatedLoginBodyState();
}

class _AnimatedLoginBodyState extends State<_AnimatedLoginBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;

  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  late final Animation<double> _socialFade;
  late final Animation<Offset> _socialSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.30,
        curve: Curves.easeOutCubic,
      ),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.30,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.15,
        0.45,
        curve: Curves.easeOutCubic,
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.15,
          0.45,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _formFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.28,
        0.65,
        curve: Curves.easeOutCubic,
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.28,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _buttonFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.48,
        0.78,
        curve: Curves.easeOutCubic,
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.48,
          0.78,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _socialFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.62,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    _socialSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.62,
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
                  const SizedBox(height: 40),

                  // ─────────────────────────────
                  // LOGO
                  // ─────────────────────────────
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

                  // ─────────────────────────────
                  // WELCOME TEXT
                  // ─────────────────────────────
                  _animatedSection(
                    fade: _titleFade,
                    slide: _titleSlide,
                    child: const Column(
                      children: [
                        Text(
                          'Welcome Back! 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to continue shopping',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ─────────────────────────────
                  // FORM
                  // ─────────────────────────────
                  _animatedSection(
                    fade: _formFade,
                    slide: _formSlide,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: controller.emailController,
                          hint: 'Email or Phone',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                          v!.isEmpty ? 'Email required' : null,
                        ),

                        const SizedBox(height: 16),

                        Obx(
                              () => AuthTextField(
                            controller: controller.passwordController,
                            hint: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordHidden:
                            controller.isPasswordHidden.value,
                            onTogglePassword:
                            controller.togglePassword,
                            validator: (v) =>
                            v!.length < 6
                                ? 'Min 6 characters'
                                : null,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Obx(
                              () => Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: controller.toggleRemember,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                ),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap:
                                controller.goToForgotPassword,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─────────────────────────────
                  // LOGIN BUTTON
                  // ─────────────────────────────
                  _animatedSection(
                    fade: _buttonFade,
                    slide: _buttonSlide,
                    child: Obx(
                          () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                            AppColors.primary.withValues(
                              alpha: 0.65,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: AnimatedSwitcher(
                            duration:
                            const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: controller.isLoading.value
                                ? const SizedBox(
                              key: ValueKey('loading'),
                              width: 22,
                              height: 22,
                              child:
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Login',
                              key: ValueKey('login'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─────────────────────────────
                  // OR
                  // ─────────────────────────────
                  _animatedSection(
                    fade: _socialFade,
                    slide: _socialSlide,
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
                              padding: EdgeInsets.symmetric(
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

                        // ─────────────────────────
                        // SOCIAL BUTTONS
                        // ─────────────────────────
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
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4285F4),
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
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1877F2),
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
                                color: AppColors.black,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─────────────────────────────
                  // SIGN UP
                  // ─────────────────────────────
                  _animatedSection(
                    fade: _socialFade,
                    slide: _socialSlide,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.goToRegister,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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