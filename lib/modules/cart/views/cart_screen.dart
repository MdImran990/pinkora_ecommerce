import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/bottom_nav_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        centerTitle: true,

        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.offAllNamed(AppRoutes.home),
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

        title: Obx(
              () => Text(
            'My Cart (${ctrl.cartItems.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),

        actions: [
          Obx(
                () {
              if (ctrl.cartItems.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: ctrl.clearCart,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.black,
                ),
              );
            },
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: Obx(
            () {
          if (ctrl.cartItems.isEmpty) {
            return const _EmptyCart();
          }

          return CustomScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            cacheExtent: 600,
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  0,
                ),
              ),

              // ----------------------------------------------------
              // CART ITEMS
              // ----------------------------------------------------

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = ctrl.cartItems[index];

                      return RepaintBoundary(
                        key: ValueKey(item.key),
                        child: _CartItemCard(
                          item: item,
                          index: index,
                          controller: ctrl,
                        ),
                      );
                    },
                    childCount: ctrl.cartItems.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),

              // ----------------------------------------------------
              // SUMMARY
              // ----------------------------------------------------

              const SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _CartSummary(),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}

// ================================================================
// EMPTY CART
// ================================================================

class _EmptyCart extends StatefulWidget {
  const _EmptyCart();

  @override
  State<_EmptyCart> createState() => _EmptyCartState();
}

class _EmptyCartState extends State<_EmptyCart>
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
      duration: const Duration(milliseconds: 450),
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
      begin: 0.92,
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

  void _shopNow() {
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 52,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Add items to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _AnimatedShopButton(
                    onTap: _shopNow,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SHOP NOW BUTTON
// ================================================================

class _AnimatedShopButton extends StatefulWidget {
  const _AnimatedShopButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedShopButton> createState() =>
      _AnimatedShopButtonState();
}

class _AnimatedShopButtonState extends State<_AnimatedShopButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
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
    widget.onTap();
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
            disabledBackgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 34,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Shop Now',
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

// ================================================================
// CART ITEM
// ================================================================

class _CartItemCard extends StatefulWidget {
  const _CartItemCard({
    required this.item,
    required this.index,
    required this.controller,
  });

  final CartItemModel item;
  final int index;
  final CartController controller;

  @override
  State<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<_CartItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
      begin: const Offset(0.025, 0),
      end: Offset.zero,
    ).animate(curve);

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isMinimum = item.quantity <= 1;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --------------------------------------------------
              // CHECKBOX
              // --------------------------------------------------

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => widget.controller.toggleSelect(widget.index),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: item.isSelected
                          ? AppColors.primary
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: item.isSelected
                            ? AppColors.primary
                            : AppColors.grey,
                        width: 1.2,
                      ),
                    ),
                    child: item.isSelected
                        ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 13,
                    )
                        : null,
                  ),
                ),
              ),

              // --------------------------------------------------
              // PRODUCT IMAGE
              // --------------------------------------------------

              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),

              const SizedBox(width: 10),

              // --------------------------------------------------
              // PRODUCT INFO
              // --------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            widget.controller.removeItem(
                              widget.index,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    if (item.selectedSize.isNotEmpty)
                      Text(
                        'Size: ${item.selectedSize}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      )
                    else if (item.selectedColor.isNotEmpty)
                      Text(
                        'Color: ${item.selectedColor}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // ------------------------------------
                            // MINUS
                            // ------------------------------------

                            _QuantityButton(
                              icon: Icons.remove,
                              disabled: isMinimum,
                              onTap: isMinimum
                                  ? null
                                  : () {
                                widget.controller
                                    .decreaseQty(
                                  widget.index,
                                );
                              },
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                  milliseconds: 120,
                                ),
                                transitionBuilder:
                                    (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  '${item.quantity}',
                                  key: ValueKey(item.quantity),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),

                            // ------------------------------------
                            // PLUS
                            // ------------------------------------

                            _QuantityButton(
                              icon: Icons.add,
                              onTap: () {
                                widget.controller.increaseQty(
                                  widget.index,
                                );
                              },
                            ),
                          ],
                        ),

                        // ----------------------------------------
                        // TOTAL
                        // ----------------------------------------

                        AnimatedSwitcher(
                          duration: const Duration(
                            milliseconds: 120,
                          ),
                          transitionBuilder:
                              (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            '৳ ${item.totalPrice.toInt()}',
                            key: ValueKey(item.totalPrice),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// QUANTITY BUTTON
// ================================================================

class _QuantityButton extends StatefulWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  State<_QuantityButton> createState() =>
      _QuantityButtonState();
}

class _QuantityButtonState extends State<_QuantityButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
      reverseDuration: const Duration(milliseconds: 100),
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
    if (!widget.disabled) {
      _controller.forward();
    }
  }

  void _tapCancel() {
    _controller.reverse();
  }

  void _tapUp(TapUpDetails details) {
    if (widget.disabled) return;

    _controller.reverse();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.disabled
        ? AppColors.lightGrey
        : AppColors.primaryLight;

    final iconColor = widget.disabled
        ? AppColors.grey
        : AppColors.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _tapDown,
      onTapCancel: _tapCancel,
      onTapUp: _tapUp,
      child: RepaintBoundary(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              widget.icon,
              size: 14,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// CART SUMMARY
// ================================================================

class _CartSummary extends StatelessWidget {
  const _CartSummary();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Obx(
          () => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          18,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
            bottom: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----------------------------------------------------
            // COUPON
            // ----------------------------------------------------

            _CouponBox(controller: controller),

            const SizedBox(height: 14),

            const Divider(
              color: AppColors.border,
            ),

            const SizedBox(height: 8),

            _PriceRow(
              label: 'Subtotal',
              value:
              '৳ ${controller.subtotal.toInt()}',
            ),

            const SizedBox(height: 7),

            _PriceRow(
              label: 'Delivery Fee',
              value:
              '৳ ${controller.deliveryFee.toInt()}',
            ),

            if (controller.discountAmount > 0) ...[
              const SizedBox(height: 7),

              _PriceRow(
                label: 'Discount',
                value:
                '- ৳ ${controller.discountAmount.toInt()}',
                valueColor: AppColors.success,
              ),
            ],

            const SizedBox(height: 8),

            const Divider(
              color: AppColors.border,
            ),

            const SizedBox(height: 8),

            _PriceRow(
              label: 'Total',
              value:
              '৳ ${controller.total.toInt()}',
              isBold: true,
            ),

            const SizedBox(height: 14),

            _AnimatedCheckoutButton(
              onTap: controller.proceedToCheckout,
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// APPLY BUTTON
// ================================================================

class _AnimatedApplyButton extends StatefulWidget {
  const _AnimatedApplyButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedApplyButton> createState() =>
      _AnimatedApplyButtonState();
}

class _AnimatedApplyButtonState
    extends State<_AnimatedApplyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 110),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
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
    widget.onTap();
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
            disabledBackgroundColor: AppColors.primary,
            // The app theme gives every ElevatedButton an infinite minimum
            // width. Inside a Row that breaks layout, so reset it here.
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
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

// ================================================================
// CHECKOUT BUTTON
// ================================================================

class _AnimatedCheckoutButton extends StatefulWidget {
  const _AnimatedCheckoutButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedCheckoutButton> createState() =>
      _AnimatedCheckoutButtonState();
}

class _AnimatedCheckoutButtonState
    extends State<_AnimatedCheckoutButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.97,
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
    widget.onTap();
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
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// PRICE ROW
// ================================================================

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final fontSize = isBold ? 16.0 : 14.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold
                ? FontWeight.w700
                : FontWeight.w400,
            color: AppColors.darkGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold
                ? FontWeight.w700
                : FontWeight.w500,
            color: valueColor ??
                (isBold
                    ? AppColors.black
                    : AppColors.darkGrey),
          ),
        ),
      ],
    );
  }
}


// ================================================================
// COUPON BOX
// ================================================================

class _CouponBox extends StatefulWidget {
  const _CouponBox({
    required this.controller,
  });

  final CartController controller;

  @override
  State<_CouponBox> createState() => _CouponBoxState();
}

class _CouponBoxState extends State<_CouponBox> {
  // Owned by this widget, so it is disposed together with the screen.
  final TextEditingController _textController =
  TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _apply() {
    FocusScope.of(context).unfocus();

    final applied = widget.controller.applyCoupon(_textController.text);

    if (applied) _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _apply(),
                decoration: InputDecoration(
                  hintText: 'Apply Coupon Code',
                  hintStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            _AnimatedApplyButton(
              onTap: _apply,
            ),
          ],
        ),

        Obx(
              () {
            final code = widget.controller.couponCode.value;

            if (code.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      'Coupon $code applied',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: widget.controller.removeCoupon,
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
