import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../app/theme/app_colors.dart';
import '../app/routes/app_routes.dart';

class PinkoraBottomNav extends StatelessWidget {
  const PinkoraBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Iconsax.home,
                activeIcon: Iconsax.home_15,
                label: 'Home',
                isActive: Get.currentRoute == AppRoutes.home,
                onTap: () => Get.offAllNamed(AppRoutes.home),
              ),
              _NavItem(
                icon: Iconsax.category,
                activeIcon: Iconsax.category5,
                label: 'Category',
                isActive:
                Get.currentRoute == AppRoutes.category,
                onTap: () =>
                    Get.offAllNamed(AppRoutes.category),
              ),
              _NavItem(
                icon: Iconsax.shopping_cart,
                activeIcon: Iconsax.shopping_cart5,
                label: 'Cart',
                isActive: Get.currentRoute == AppRoutes.cart,
                onTap: () => Get.offAllNamed(AppRoutes.cart),
                badge: 3,
              ),
              _NavItem(
                icon: Iconsax.heart,
                activeIcon: Iconsax.heart5,
                label: 'Wishlist',
                isActive:
                Get.currentRoute == AppRoutes.wishlist,
                onTap: () =>
                    Get.offAllNamed(AppRoutes.wishlist),
              ),
              _NavItem(
                icon: Iconsax.user,
                activeIcon: Iconsax.user5,
                label: 'Profile',
                isActive:
                Get.currentRoute == AppRoutes.profile,
                onTap: () =>
                    Get.offAllNamed(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? AppColors.primary
                    : AppColors.grey,
                size: 24,
              ),
              if (badge != null)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.sale,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: isActive
                  ? AppColors.primary
                  : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}