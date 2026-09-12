import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../app/theme/app_colors.dart';
import '../app/routes/app_routes.dart';
import '../modules/cart/controllers/cart_controller.dart';

class PinkoraBottomNav extends StatelessWidget {
  const PinkoraBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final current = Get.currentRoute;

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
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _item(
                icon: current == AppRoutes.home
                    ? Iconsax.home_15
                    : Iconsax.home,
                label: 'Home',
                isActive: current == AppRoutes.home,
                onTap: () => Get.offAllNamed(AppRoutes.home),
              ),

              // Category
              _item(
                icon: current == AppRoutes.category
                    ? Iconsax.category5
                    : Iconsax.category,
                label: 'Category',
                isActive: current == AppRoutes.category,
                onTap: () => Get.offAllNamed(AppRoutes.category),
              ),

              // Cart with badge
              GestureDetector(
                onTap: () => Get.offAllNamed(AppRoutes.cart),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          current == AppRoutes.cart
                              ? Iconsax.shopping_cart5
                              : Iconsax.shopping_cart,
                          color: current == AppRoutes.cart
                              ? AppColors.primary
                              : AppColors.grey,
                          size: 24,
                        ),
                        Obx(() {
                          final count = cart.cartItems.length;
                          if (count == 0) return const SizedBox();
                          return Positioned(
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
                                  '$count',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: current == AppRoutes.cart
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: current == AppRoutes.cart
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Wishlist
              _item(
                icon: current == AppRoutes.wishlist
                    ? Iconsax.heart5
                    : Iconsax.heart,
                label: 'Wishlist',
                isActive: current == AppRoutes.wishlist,
                onTap: () => Get.offAllNamed(AppRoutes.wishlist),
              ),

              // Profile
              _item(
                icon: current == AppRoutes.profile
                    ? Iconsax.user5
                    : Iconsax.user,
                label: 'Profile',
                isActive: current == AppRoutes.profile,
                onTap: () => Get.offAllNamed(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight:
              isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}