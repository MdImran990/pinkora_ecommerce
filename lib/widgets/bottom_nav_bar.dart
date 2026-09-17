import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../app/theme/app_colors.dart';
import '../modules/cart/controllers/cart_controller.dart';

class PinkoraBottomNav extends StatelessWidget {
  const PinkoraBottomNav({
    super.key,
    this.currentIndex,
  });

  final int? currentIndex;

  void _goTo(String route) {
    if (Get.currentRoute == route) return;

    Get.offAllNamed(route);
  }

  int _resolveIndex() {
    if (currentIndex != null) {
      return currentIndex!;
    }

    switch (Get.currentRoute) {
      case AppRoutes.home:
        return 0;
      case AppRoutes.category:
        return 1;
      case AppRoutes.cart:
        return 2;
      case AppRoutes.wishlist:
        return 3;
      case AppRoutes.profile:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final selectedIndex = _resolveIndex();

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => _goTo(AppRoutes.home),
                ),
                _NavItem(
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category_rounded,
                  label: 'Category',
                  isSelected: selectedIndex == 1,
                  onTap: () => _goTo(AppRoutes.category),
                ),
                Obx(
                      () => _NavItem(
                    icon: Icons.shopping_cart_outlined,
                    activeIcon: Icons.shopping_cart_rounded,
                    label: 'Cart',
                    isSelected: selectedIndex == 2,
                    onTap: () => _goTo(AppRoutes.cart),
                    badge: cartController.cartItems.length,
                  ),
                ),
                _NavItem(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: 'Wishlist',
                  isSelected: selectedIndex == 3,
                  onTap: () => _goTo(AppRoutes.wishlist),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: selectedIndex == 4,
                  onTap: () => _goTo(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 68,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 28,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 140),
                        reverseDuration:
                        const Duration(milliseconds: 100),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          isSelected ? activeIcon : icon,
                          key: ValueKey(isSelected),
                          size: 24,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey,
                        ),
                      ),
                      if (badge > 0)
                        Positioned(
                          right: -10,
                          top: -7,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 160),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutBack,
                                ),
                                child: child,
                              );
                            },
                            child: Container(
                              key: ValueKey(badge),
                              constraints: const BoxConstraints(
                                minWidth: 17,
                                minHeight: 17,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.sale,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                badge > 99 ? '99+' : '$badge',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.grey,
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}