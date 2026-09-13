import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../app/routes/app_routes.dart';
import '../app/theme/app_colors.dart';
import '../data/model/cart_item_model.dart';
import '../modules/cart/controllers/cart_controller.dart';

class PinkoraBottomNav extends StatelessWidget {
  const PinkoraBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Material(
      color: AppColors.white,
      elevation: 12,
      shadowColor: Colors.black12,
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.border,
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Iconsax.home_2,
                activeIcon: Iconsax.home_25,
                label: 'Home',
                route: AppRoutes.home,
              ),

              _navItem(
                icon: Iconsax.category,
                activeIcon: Iconsax.category_2,
                label: 'Category',
                route: AppRoutes.category,
              ),

              _cartItem(cart),

              _navItem(
                icon: Iconsax.heart,
                activeIcon: Iconsax.heart5,
                label: 'Wishlist',
                route: AppRoutes.wishlist,
              ),

              _navItem(
                icon: Iconsax.user,
                activeIcon: Iconsax.user5,
                label: 'Profile',
                route: AppRoutes.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
  }) {
    final bool isActive = Get.currentRoute == route;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (Get.currentRoute != route) {
            Get.offAllNamed(route);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 22,
                color: isActive
                    ? AppColors.primary
                    : AppColors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartItem(CartController cart) {
    final bool isActive = Get.currentRoute == AppRoutes.cart;

    return Expanded(
      child: ValueListenableBuilder<List<CartItemModel>>(
        valueListenable: cart.cartItems,
        builder: (context, items, child) {
          return InkWell(
            onTap: () {
              if (Get.currentRoute != AppRoutes.cart) {
                Get.offAllNamed(AppRoutes.cart);
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        isActive ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
                        size: 22,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.grey,
                      ),

                      if (items.isNotEmpty)
                        Positioned(
                          right: -9,
                          top: -9,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 17,
                              minHeight: 17,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sale,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.white,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '${items.length}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}