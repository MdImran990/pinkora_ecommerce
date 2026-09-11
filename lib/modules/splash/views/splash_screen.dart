import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── LOGO ──
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 58,
              ),
            ),

            const SizedBox(height: 24),

            // ── APP NAME ──
            const Text(
              'Pinkora',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // ── TAGLINE ──
            const Text(
              'Shop Your Happiness',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.darkGrey,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 80),

            // ── LOADING DOTS ──
            AnimatedBuilder(
              animation: _dotController,
              builder: (_, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final delay = i * 0.3;
                    final value =
                    (_dotController.value - delay).clamp(0.0, 1.0);
                    final opacity =
                    (value < 0.5 ? value * 2 : (1 - value) * 2)
                        .clamp(0.3, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: opacity),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Trendy Products\nFor A Brighter You',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}