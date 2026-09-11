import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_tile.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: AppColors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ──
            Obx(() => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Name
                  Text(
                    controller.user.value?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Email
                  Text(
                    controller.user.value?.email ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            )),

            // ── Menu Items ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileMenuTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {},
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primaryLight,
                  ),
                  ProfileMenuTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'Wishlist',
                    onTap: () => Get.toNamed(AppRoutes.wishlist),
                    iconColor: const Color(0xFFE53935),
                    iconBgColor: const Color(0xFFFFEBEE),
                  ),
                  ProfileMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'My Address',
                    onTap: () {},
                    iconColor: const Color(0xFF3D5AFE),
                    iconBgColor: const Color(0xFFE8EAFF),
                  ),
                  ProfileMenuTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () {},
                    iconColor: const Color(0xFF4CAF50),
                    iconBgColor: const Color(0xFFE8F5E9),
                  ),
                  ProfileMenuTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                    iconColor: const Color(0xFFFF9800),
                    iconBgColor: const Color(0xFFFFF3E0),
                  ),
                  ProfileMenuTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: () {},
                    iconColor: const Color(0xFF9C27B0),
                    iconBgColor: const Color(0xFFF3E5F5),
                  ),
                  ProfileMenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Logout Button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}