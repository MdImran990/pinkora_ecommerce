import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void togglePassword() => isPasswordHidden.toggle();

  void toggleRemember(bool? val) {
    rememberMe.value = val ?? false;
  }

  // ── LOGIN ──
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final box = GetStorage();
    await box.write('isLoggedIn', true);

    isLoading.value = false;

    Get.offAllNamed(AppRoutes.home);
  }

  // ── REGISTER ──
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    await Future.delayed(
      const Duration(seconds: 2),
    );

    isLoading.value = false;

    Get.offAllNamed(AppRoutes.login);

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    Get.snackbar(
      'Account Created! 🎉',
      'Please login with your credentials',
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  // ── FORGOT PASSWORD ──
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email or phone number',
        backgroundColor: const Color(0xFFE91E63),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    // Temporary local delay.
    // API / OTP / email reset will be connected later.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    isLoading.value = false;

    Get.snackbar(
      'Reset Link Sent! 📩',
      'Please check your email or phone',
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  // ── NAVIGATION ──
  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.onClose();
  }
}