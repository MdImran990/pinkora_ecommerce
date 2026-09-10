import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen - Coming Soon')),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}