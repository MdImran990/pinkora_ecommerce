import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/theme/app_colors.dart';

class CustomSnackbar {
  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle_rounded,
          color: Colors.white),
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.error_rounded, color: Colors.white),
    );
  }

  static void info(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}