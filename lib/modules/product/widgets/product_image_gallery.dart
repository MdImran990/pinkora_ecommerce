import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../../../app/theme/app_colors.dart';

class ProductImageGallery extends GetView<ProductController> {
  const ProductImageGallery({super.key});

  static const List<Color> _thumbColors = [
    AppColors.primaryLight,
    Color(0xFFE8E8E8),
    Color(0xFFF5ECD7),
    Color(0xFFF0EEE8),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─────────────────────────────────────────────
        // MAIN IMAGE
        // ─────────────────────────────────────────────
        Obx(
              () {
            final product = controller.product.value;
            final imageIndex =
                controller.currentImageIndex.value;

            return RepaintBoundary(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                reverseDuration:
                const Duration(milliseconds: 160),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder:
                    (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.97,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey(imageIndex),
                  height: 280,
                  width: double.infinity,
                  color: AppColors.primaryLight,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          size: 140,
                          color: AppColors.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),

                      // ─────────────────────────────
                      // DISCOUNT BADGE
                      // ─────────────────────────────
                      Positioned(
                        top: 16,
                        left: 16,
                        child: RepaintBoundary(
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sale,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product?.discountPercent ?? 0}% OFF',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // ─────────────────────────────────────────────
        // THUMBNAILS
        // ─────────────────────────────────────────────
        Obx(
              () {
            final selectedIndex =
                controller.currentImageIndex.value;

            return SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                physics:
                const BouncingScrollPhysics(),
                cacheExtent: 200,
                itemCount: _thumbColors.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isSelected =
                      selectedIndex == index;

                  return RepaintBoundary(
                    key: ValueKey(index),
                    child: _ThumbnailItem(
                      color: _thumbColors[index],
                      isSelected: isSelected,
                      onTap: () =>
                          controller.changeImage(index),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
// ULTRA-SMOOTH THUMBNAIL
// ═══════════════════════════════════════════════════════

class _ThumbnailItem extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThumbnailItem({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ThumbnailItem> createState() =>
      _ThumbnailItemState();
}

class _ThumbnailItemState
    extends State<_ThumbnailItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration:
      const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _tapCancel() {
    _pressController.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _pressController.reverse();

    Future<void>.delayed(
      const Duration(milliseconds: 15),
          () {
        if (mounted) {
          widget.onTap();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _tapDown,
      onTapCancel: _tapCancel,
      onTapUp: _tapUp,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius:
            BorderRadius.circular(10),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : AppColors.border,
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: AnimatedScale(
            scale: widget.isSelected ? 1.08 : 1.0,
            duration:
            const Duration(milliseconds: 160),
            curve: Curves.easeOutBack,
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 28,
              color: AppColors.primary.withValues(
                alpha: widget.isSelected ? 0.55 : 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}