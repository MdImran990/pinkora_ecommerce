import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE91E8C);
  static const Color primaryLight = Color(0xFFFF6BB5);
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color primaryPale = Color(0xFFFCE4EC);

  static const Color bgLight = Color(0xFFFFF0F6);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgGrey = Color(0xFFF5F5F5);

  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMedium = Color(0xFF6B6B6B);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textLight = Color(0xFFBDBDBD);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color star = Color(0xFFFFC107);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE0E0E0);

  // Gradient
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF0F6),
      Color(0xFFFFD6E8),
      Color(0xFFFFC2DC),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6BB5), Color(0xFFE91E8C)],
  );
}