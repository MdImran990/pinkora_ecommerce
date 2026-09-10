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
                  const SizedBox(height: 40),

                  // ── BAG ICON ──
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
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

                  // ── WELCOME TEXT ──
                  const Text(
                    'Welcome Back! 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sign in to continue shopping',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── EMAIL FIELD ──
                  AuthTextField(
                    controller: controller.emailController,
                    hint: 'Email or Phone',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    v!.isEmpty ? 'Email required' : null,
                  ),

                  const SizedBox(height: 16),

                  // ── PASSWORD FIELD ──
                  Obx(() => AuthTextField(
                    controller: controller.passwordController,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordHidden: controller.isPasswordHidden.value,
                    onTogglePassword: controller.togglePassword,
                    validator: (v) =>
                    v!.length < 6 ? 'Min 6 characters' : null,
                  )),

                  const SizedBox(height: 12),

                  // ── REMEMBER ME + FORGOT ──
                  Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: controller.toggleRemember,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
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
                        onTap: controller.goToForgotPassword,
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
                  )),

                  const SizedBox(height: 24),

                  // ── LOGIN BUTTON ──
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,
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
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),

                  const SizedBox(height: 28),

                  // ── OR CONTINUE WITH ──
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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

                  // ── SOCIAL BUTTONS ──
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

                  const SizedBox(height: 32),

                  // ── SIGN UP ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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