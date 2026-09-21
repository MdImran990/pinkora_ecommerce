import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _navigationTimer = Timer(
      const Duration(milliseconds: 2200),
      _goNext,
    );
  }

  void _goNext() {
    if (!mounted) return;

    final isLoggedIn = GetStorage().read<bool>('isLoggedIn') ?? false;

    Get.offAllNamed(
      isLoggedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFFFFB3D9),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
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
                Color(0xFFFFB3D9),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo: shopping bag with a heart
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 120,
                      color: AppColors.primary,
                      shadows: [
                        Shadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 26),
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Text(
                  'Pinkora',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Shop Your Happiness',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 44),

                // Sliding progress bar
                AnimatedBuilder(
                  animation: _dotController,
                  builder: (context, child) {
                    return Container(
                      width: 150,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment(
                          -1 + 2 * _dotController.value,
                          0,
                        ),
                        widthFactor: 0.35,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 3),

                const Text(
                  'Trendy Products\nFor A Brighter You',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
