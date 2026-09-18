import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/product_model.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';
import '../../../widgets/bottom_nav_bar.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  static final List<ProductModel> products = [
    ProductModel(
      id: '1',
      name: 'Trendy Handbag',
      image: '',
      price: 2100,
      originalPrice: 3000,
      discountPercent: 30,
      rating: 4.8,
      reviewCount: 120,
      category: 'Fashion',
      colors: ['#FF6B9D', '#000000'],
    ),
    ProductModel(
      id: '2',
      name: 'Sport Shoes',
      image: '',
      price: 3200,
      originalPrice: 4300,
      discountPercent: 25,
      rating: 4.6,
      reviewCount: 98,
      category: 'Shoes',
    ),
    ProductModel(
      id: '3',
      name: 'Smart Watch',
      image: '',
      price: 4500,
      originalPrice: 7500,
      discountPercent: 40,
      rating: 4.7,
      reviewCount: 86,
      category: 'Watches',
    ),
    ProductModel(
      id: '4',
      name: 'Lipstick Set',
      image: '',
      price: 850,
      originalPrice: 1200,
      discountPercent: 29,
      rating: 4.5,
      reviewCount: 210,
      category: 'Beauty',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    final wishCtrl = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
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
        title: const Text(
          'All Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          16,
        ),
        physics: const BouncingScrollPhysics(),
        cacheExtent: 700,
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return RepaintBoundary(
            key: ValueKey(product.id),
            child: _ProductGridCard(
              product: product,
              cartCtrl: cartCtrl,
              wishCtrl: wishCtrl,
              index: index,
            ),
          );
        },
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}

class _ProductGridCard extends StatefulWidget {
  const _ProductGridCard({
    required this.product,
    required this.cartCtrl,
    required this.wishCtrl,
    required this.index,
  });

  final ProductModel product;
  final CartController cartCtrl;
  final WishlistController wishCtrl;
  final int index;

  @override
  State<_ProductGridCard> createState() =>
      _ProductGridCardState();
}

class _ProductGridCardState extends State<_ProductGridCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
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

  void _onCardTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onCardTapCancel() {
    _pressController.reverse();
  }

  void _onCardTapUp(TapUpDetails details) {
    _pressController.reverse();

    Future<void>.delayed(
      const Duration(milliseconds: 15),
          () {
        if (!mounted) return;

        Get.toNamed(
          AppRoutes.productDetail,
          arguments: widget.product,
        );
      },
    );
  }

  void _addToCart() {
    widget.cartCtrl.addToCart(widget.product);

    Get.snackbar(
      'Added! 🛒',
      '${widget.product.name} added to cart',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
    );
  }

  void _toggleWishlist() {
    final isWished =
    widget.wishCtrl.isWished(widget.product.id);

    if (isWished) {
      widget.wishCtrl.removeItem(widget.product);
    } else {
      widget.wishCtrl.addItem(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onCardTapDown,
      onTapCancel: _onCardTapCancel,
      onTapUp: _onCardTapUp,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  RepaintBoundary(
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 56,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sale,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discountPercent}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Obx(
                          () {
                        final isWished =
                        widget.wishCtrl.isWished(
                          product.id,
                        );

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _toggleWishlist,
                          child: AnimatedScale(
                            scale: isWished ? 1.08 : 1.0,
                            duration:
                            const Duration(milliseconds: 140),
                            curve: Curves.easeOutBack,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.08),
                                    blurRadius: 4,
                                  ),
                                ],
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
                                  isWished
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey(isWished),
                                  size: 14,
                                  color: isWished
                                      ? AppColors.primary
                                      : AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          '৳ ${product.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '৳ ${product.originalPrice.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.grey,
                            decoration:
                            TextDecoration.lineThrough,
                            decorationColor:
                            AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.star,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _addToCart,
                          child: const _AnimatedCartButton(),
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

class _AnimatedCartButton extends StatefulWidget {
  const _AnimatedCartButton();

  @override
  State<_AnimatedCartButton> createState() =>
      _AnimatedCartButtonState();
}

class _AnimatedCartButtonState
    extends State<_AnimatedCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.88,
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _tapDown,
      onTapCancel: _tapCancel,
      onTapUp: _tapUp,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.add_shopping_cart_rounded,
            size: 16,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}