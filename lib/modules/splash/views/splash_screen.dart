import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD6E5),
              Color(0xFFFFF5F8),
              Color(0xFFFF9FC4),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              const Spacer(),

              ScaleTransition(
                scale: _scaleAnimation,

                child: Container(
                  width: 110.w,
                  height: 110.w,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35.r),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),

                  child: Icon(
                    Icons.shopping_bag_rounded,
                    size: 55.sp,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              Text(
                'Pinkora',
                style: TextStyle(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPink,
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'Shop Your Happiness',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              Padding(
                padding: EdgeInsets.only(bottom: 45.h),

                child: SizedBox(
                  width: 45.w,
                  height: 45.w,

                  child: const CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}