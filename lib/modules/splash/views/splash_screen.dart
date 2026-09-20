import 'dart:async';

import 'package:flutter/material.dart';
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
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pinkora Logo
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    size: 58,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Pinkora',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Shop Your Happiness',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 45),

              AnimatedBuilder(
                animation: _dotController,
                builder: (context, child) {
                  final value = _dotController.value;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                          (index) {
                        final active =
                            ((value * 3).floor() % 3) == index;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          width: active ? 10 : 7,
                          height: active ? 10 : 7,
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white
                                : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}