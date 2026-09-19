import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AnimatedForgotPasswordBody(
      controller: controller,
    );
  }
}

class _AnimatedForgotPasswordBody extends StatefulWidget {
  const _AnimatedForgotPasswordBody({
    required this.controller,
  });

  final AuthController controller;

  @override
  State<_AnimatedForgotPasswordBody> createState() =>
      _AnimatedForgotPasswordBodyState();
}

class _AnimatedForgotPasswordBodyState
    extends State<_AnimatedForgotPasswordBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _backFade;
  late final Animation<Offset> _backSlide;

  late final Animation<double> _iconFade;
  late final Animation<Offset> _iconSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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

    _iconFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.10,
        0.40,
        curve: Curves.easeOutCubic,
      ),
    );

    _iconSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.10,
          0.40,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.25,
        0.55,
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
          0.25,
          0.55,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _formFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.40,
        1.0,
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
          0.40,
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

  void _goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final authController = widget.controller;

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
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: authController.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _animatedSection(
                      fade: _backFade,
                      slide: _backSlide,
                      child: RepaintBoundary(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _goToLogin,
                            borderRadius: BorderRadius.circular(12),
                            splashColor:
                            AppColors.primary.withValues(alpha: 0.08),
                            highlightColor:
                            AppColors.primary.withValues(alpha: 0.04),
                            child: Ink(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
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
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ICON
                  _animatedSection(
                    fade: _iconFade,
                    slide: _iconSlide,
                    child: RepaintBoundary(
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
                          Icons.lock_reset_rounded,
                          color: Colors.white,
                          size: 46,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // TITLE
                  _animatedSection(
                    fade: _titleFade,
                    slide: _titleSlide,
                    child: const RepaintBoundary(
                      child: Column(
                        children: [
                          Text(
                            'Forgot Password?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Enter your email or phone to reset your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // FORM
                  _animatedSection(
                    fade: _formFade,
                    slide: _formSlide,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: authController.emailController,
                          hint: 'Email or Phone',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        Obx(
                              () {
                            final isLoading =
                                authController.isLoading.value;

                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : authController.forgotPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  disabledBackgroundColor:
                                  AppColors.primary.withValues(
                                    alpha: 0.65,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 220,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    key: ValueKey('forgot_loading'),
                                    width: 22,
                                    height: 22,
                                    child:
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                      : const Text(
                                    'Reset Password',
                                    key: ValueKey('forgot_text'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        RepaintBoundary(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Remember your password? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _goToLogin,
                                  borderRadius: BorderRadius.circular(6),
                                  splashColor: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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