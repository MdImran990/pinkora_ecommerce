import '../../../app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import '../../../app/theme/app_colors.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF0F7), Color(0xFFFFD6EC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ── BACK BUTTON ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.offAllNamed(AppRoutes.login),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── LOGO ──
                  Container(
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
                  ),

                  const SizedBox(height: 24),

                  // ── TITLE ──
                  const Text(
                    'Create Account 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sign up to start shopping',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── NAME ──
                  AuthTextField(
                    controller: controller.nameController,
                    hint: 'Full Name',
                    prefixIcon: Icons.person_outline,
                    validator: (v) =>
                    v!.isEmpty ? 'Name required' : null,
                  ),

                  const SizedBox(height: 16),

                  // ── EMAIL ──
                  AuthTextField(
                    controller: controller.emailController,
                    hint: 'Email or Phone',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    v!.isEmpty ? 'Email required' : null,
                  ),

                  const SizedBox(height: 16),

                  // ── PASSWORD ──
                  Obx(() => AuthTextField(
                    controller: controller.passwordController,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordHidden:
                    controller.isPasswordHidden.value,
                    onTogglePassword: controller.togglePassword,
                    validator: (v) => v!.length < 6
                        ? 'Min 6 characters'
                        : null,
                  )),

                  const SizedBox(height: 28),

                  // ── SIGN UP BUTTON ──
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),

                  const SizedBox(height: 28),

                  // ── DIVIDER ──
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.border)),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── SOCIAL ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        label: 'Google',
                        icon: const Text('G',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4285F4),
                            )),
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        label: 'Facebook',
                        icon: const Text('f',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1877F2),
                            )),
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        label: 'Apple',
                        icon: const Icon(Icons.apple,
                            size: 28, color: AppColors.black),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── LOGIN LINK ──
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
                      GestureDetector(
                        onTap: () =>
                            Get.offAllNamed(AppRoutes.login),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
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