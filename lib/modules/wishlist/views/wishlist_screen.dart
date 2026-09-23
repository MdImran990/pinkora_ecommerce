import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/product_image.dart';
import '../../main/controllers/main_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: Obx(
            () {
          final items = controller.wishlistItems;

          if (items.isEmpty) {
            return const _EmptyWishlist();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            cacheExtent: 700,
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];

              return RepaintBoundary(
                key: ValueKey(product.id),
                child: _WishlistItem(
                  product: product,
                  index: index,
                  onRemove: () {
                    controller.removeItem(product);
                  },
                ),
              );
            },
          );
        },
      ),

    );
  }
}

// ============================================================
// EMPTY WISHLIST
// ============================================================

class _EmptyWishlist extends StatefulWidget {
  const _EmptyWishlist();

  @override
  State<_EmptyWishlist> createState() =>
      _EmptyWishlistState();
}

class _EmptyWishlistState extends State<_EmptyWishlist>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    _scaleAnimation = Tween<double>(
      begin: 0.90,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Your wishlist is empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Save items you love here',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),

                const SizedBox(height: 28),
                const _AnimatedStartShoppingButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// START SHOPPING BUTTON
// ============================================================

class _AnimatedStartShoppingButton
    extends StatefulWidget {
  const _AnimatedStartShoppingButton();

  @override
  State<_AnimatedStartShoppingButton> createState() =>
      _AnimatedStartShoppingButtonState();
}

class _AnimatedStartShoppingButtonState
    extends State<_AnimatedStartShoppingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration:
      const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
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
      const Duration(milliseconds: 15),
          () {
        if (mounted) {
          Get.find<MainController>().setIndex(0);
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
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor:
            AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Start Shopping',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// WISHLIST ITEM
// ============================================================

class _WishlistItem extends StatefulWidget {
  const _WishlistItem({
    required this.product,
    required this.index,
    required this.onRemove,
  });

  final dynamic product;
  final int index;
  final VoidCallback onRemove;

  @override
  State<_WishlistItem> createState() =>
      _WishlistItemState();
}

class _WishlistItemState extends State<_WishlistItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    final curve = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.03, 0),
      end: Offset.zero,
    ).animate(curve);

    Future<void>.delayed(
      Duration(milliseconds: 35 * widget.index),
          () {
        if (mounted) {
          _entryController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.toNamed(
            AppRoutes.productDetail,
            arguments: product,
          ),
          child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.05,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ──────────────────────────────────────
              // PRODUCT IMAGE
              // ──────────────────────────────────────
              RepaintBoundary(
                child: ProductImage(
                  url: product.image,
                  width: 80,
                  height: 80,
                  iconSize: 36,
                  radius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(width: 12),

              // ──────────────────────────────────────
              // PRODUCT INFO
              // ──────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '৳ ${product.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ──────────────────────────────────────
              // DELETE BUTTON
              // ──────────────────────────────────────
              _AnimatedDeleteButton(
                onTap: widget.onRemove,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

// ============================================================
// DELETE BUTTON
// ============================================================

class _AnimatedDeleteButton extends StatefulWidget {
  const _AnimatedDeleteButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedDeleteButton> createState() =>
      _AnimatedDeleteButtonState();
}

class _AnimatedDeleteButtonState
    extends State<_AnimatedDeleteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration:
      const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.86,
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
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.sale,
          size: 22,
        ),
      ),
    );
  }
}