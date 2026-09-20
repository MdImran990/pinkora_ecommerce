import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

const SystemUiOverlayStyle _authOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Color(0xFFFFD6EC),
  systemNavigationBarIconBrightness: Brightness.dark,
);

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

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

    _backFade = _interval(0.0, 0.25);
    _backSlide = _slide(
      const Offset(-0.08, 0),
      0.0,
      0.25,
    );

    _logoFade = _interval(0.08, 0.38);
    _logoSlide = _slide(
      const Offset(0, 0.14),
      0.08,
      0.38,
    );

    _titleFade = _interval(0.22, 0.50);
    _titleSlide = _slide(
      const Offset(0, 0.10),
      0.22,
      0.50,
    );

    _formFade = _interval(0.34, 0.72);
    _formSlide = _slide(
      const Offset(0, 0.08),
      0.34,
      0.72,
    );

    _buttonFade = _interval(0.50, 0.82);
    _buttonSlide = _slide(
      const Offset(0, 0.07),
      0.50,
      0.82,
    );

    _bottomFade = _interval(0.65, 1.0);
    _bottomSlide = _slide(
      const Offset(0, 0.05),
      0.65,
      1.0,
    );

    _animationController.forward();
  }

  Animation<double> _interval(double begin, double end) {
    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Animation<Offset> _slide(
      Offset begin,
      double start,
      double end,
      ) {
    return Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _authOverlayStyle,
        child: Container(
        width: double.infinity,
        height: double.infinity,
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
              key: _formKey,
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

                  const SizedBox(height: 24),

                  // LOGO
                  _animatedSection(
                    fade: _logoFade,
                    slide: _logoSlide,
                    child: const RepaintBoundary(
                      child: _RegisterLogo(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TITLE
                  _animatedSection(
                    fade: _titleFade,
                    slide: _titleSlide,
                    child: const RepaintBoundary(
                      child: Column(
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
                  ),

                  const SizedBox(height: 32),

                  // FORM
                  _animatedSection(
                    fade: _formFade,
                    slide: _formSlide,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          hint: 'Full Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        AuthTextField(
                          controller: _emailController,
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

                        const SizedBox(height: 16),

                        Obx(
                              () => AuthTextField(
                            controller:
                            _passwordController,
                            hint: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordHidden:
                            authController.isPasswordHidden.value,
                            onTogglePassword:
                            authController.togglePassword,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Min 6 characters';
                              }
                              return null;
                            },
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
                          () {
                        final isLoading =
                            authController.isLoading.value;

                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      authController.register(
                                        name: _nameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
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
                              duration: const Duration(
                                milliseconds: 220,
                              ),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              child: isLoading
                                  ? const SizedBox(
                                key: ValueKey(
                                  'register_loading',
                                ),
                                width: 22,
                                height: 22,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
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
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // SOCIAL + LOGIN
                  _animatedSection(
                    fade: _bottomFade,
                    slide: _bottomSlide,
                    child: const _RegisterBottomSection(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _RegisterLogo extends StatelessWidget {
  const _RegisterLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
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
    );
  }
}

class _RegisterBottomSection extends StatelessWidget {
  const _RegisterBottomSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.border,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
              onTap: () => Get.find<AuthController>().socialLogin('Google'),
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
              onTap: () => Get.find<AuthController>().socialLogin('Facebook'),
            ),
            const SizedBox(width: 16),
            SocialLoginButton(
              label: 'Apple',
              icon: const Icon(
                Icons.apple,
                size: 28,
                color: AppColors.black,
              ),
              onTap: () => Get.find<AuthController>().socialLogin('Apple'),
            ),
          ],
        ),

        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.offAllNamed(AppRoutes.login),
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
      ],
    );
  }
}