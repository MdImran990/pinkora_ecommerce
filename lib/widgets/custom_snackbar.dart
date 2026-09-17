import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme/app_colors.dart';

class CustomSnackbar {
  CustomSnackbar._();

  static void success(
      String title,
      String message,
      ) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
      ),
    );
  }

  static void error(
      String title,
      String message,
      ) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      icon: const Icon(
        Icons.error_rounded,
        color: Colors.white,
      ),
    );
  }

  static void info(
      String title,
      String message,
      ) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.primary,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    Widget? icon,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: icon,
      animationDuration: const Duration(milliseconds: 250),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}