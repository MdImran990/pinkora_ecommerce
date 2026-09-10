import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final formKey = GlobalKey<FormState>();

  void togglePassword() => isPasswordHidden.toggle();
  void toggleRemember(bool? val) => rememberMe.value = val ?? false;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    final box = GetStorage();
    box.write('isLoggedIn', true);
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    final box = GetStorage();
    box.write('isLoggedIn', true);
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);
  void goToLogin() => Get.back();
  void goToForgotPassword() => Get.toNamed(AppRoutes.forgotPassword);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}