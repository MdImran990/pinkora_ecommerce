import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/color_selector.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/rating_row.dart';
import '../widgets/product_extras.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';

class ProductDetailScreen extends GetView<ProductController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds when another product is opened from "You may also like".
    return Obx(
          () {
        final p = controller.product.value;

        if (p == null) {
          return const Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return _buildScreen(context, p);
      },
    );
  }

  Widget _buildScreen(BuildContext context, ProductModel p) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: controller.scrollController,
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        cacheExtent: 800,
        slivers: [

          // APP BAR
          SliverAppBar(
            backgroundColor: AppColors.scaffoldBg,
            elevation: 0,
            pinned: true,

            leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: Get.back,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: AppColors.black,
                ),
              ),
            ),

            actions: [

              // WISHLIST
              Obx(
                    () {
                  final isWishlisted =
                      controller.isWishlisted.value;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: controller.toggleWishlist,
                    child: AnimatedScale(
                      scale: isWishlisted ? 1.08 : 1.0,
                      duration:
                      const Duration(milliseconds: 140),
                      curve: Curves.easeOutBack,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                          BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration:
                          const Duration(milliseconds: 120),
                          transitionBuilder:
                              (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(isWishlisted),
                            color: isWishlisted
                                ? AppColors.primary
                                : AppColors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // SHARE
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.shareProduct,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),

          // PRODUCT IMAGE
          const SliverToBoxAdapter(
            child: RepaintBoundary(
              child: ProductImageGallery(),
            ),
          ),

          // PRODUCT INFO
          SliverToBoxAdapter(
            child: RepaintBoundary(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // RATING
                    RepaintBoundary(
                      child: RatingRow(
                        rating: p.rating,
                        reviewCount: p.reviewCount,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // PRICE
                    RepaintBoundary(
                      child: Row(
                        children: [
                          Text(
                            '৳ ${p.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            '৳ ${p.originalPrice.toInt()}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.grey,
                              decoration:
                              TextDecoration.lineThrough,
                              decorationColor: AppColors.grey,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${p.discountPercent}% OFF',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(
                      color: AppColors.border,
                    ),

                    const SizedBox(height: 16),

                    // COLOR
                    if (p.colors.isNotEmpty) ...[
                      const Text(
                        'Color',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Obx(
                            () => RepaintBoundary(
                          child: ColorSelector(
                            colors: p.colors,
                            selectedColor:
                            controller.selectedColor.value,
                            onSelect:
                            controller.selectColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],

                    // QUANTITY
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),

                        Obx(
                              () => RepaintBoundary(
                            child: QuantityStepper(
                              quantity:
                              controller.quantity.value,
                              onIncrease:
                              controller.increaseQty,
                              onDecrease:
                              controller.decreaseQty,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: _AnimatedActionButton(
                            onTap: controller.addToCart,
                            outlined: true,
                            icon: Icons.shopping_cart_outlined,
                            label: 'Add to Cart',
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: _AnimatedActionButton(
                            onTap: controller.buyNow,
                            outlined: false,
                            label: 'Buy Now',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // DESCRIPTION, REVIEWS, RELATED PRODUCTS
          SliverToBoxAdapter(
            child: ProductExtras(
              controller: controller,
              product: p,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }
}

// ULTRA-SMOOTH ACTION BUTTON

class _AnimatedActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool outlined;
  final IconData? icon;
  final String label;

  const _AnimatedActionButton({
    required this.onTap,
    required this.outlined,
    required this.label,
    this.icon,
  });

  @override
  State<_AnimatedActionButton> createState() =>
      _AnimatedActionButtonState();
}

class _AnimatedActionButtonState
    extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 130),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapCancel() {
    _controller.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();

    Future<void>.delayed(
      const Duration(milliseconds: 20),
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
        child: widget.outlined
            ? OutlinedButton.icon(
          onPressed: null,
          icon: Icon(
            widget.icon,
            size: 18,
          ),
          label: Text(widget.label),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            disabledForegroundColor:
            AppColors.primary,
            side: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
            padding:
            const EdgeInsets.symmetric(
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            : ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor:
            AppColors.primary,
            padding:
            const EdgeInsets.symmetric(
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}