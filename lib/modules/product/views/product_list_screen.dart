import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/category_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/product_image.dart';

/// Product grid. Accepts optional Get.arguments:
///  - CategoryModel                 -> only that category
///  - {'flashSale': true}           -> flash sale products
///  - {'focusSearch': true}         -> opens with the search field focused
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductRepository _repo = Get.find<ProductRepository>();
  final CartController _cartCtrl = Get.find<CartController>();
  final WishlistController _wishCtrl = Get.find<WishlistController>();

  final TextEditingController _searchController =
  TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<ProductModel> _products = [];

  String _title = 'All Products';
  String? _category;
  bool _flashSaleOnly = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    var focusSearch = false;
    final argument = Get.arguments;

    if (argument is CategoryModel) {
      _category = argument.name;
      _title = argument.name;
    } else if (argument is Map) {
      if (argument['flashSale'] == true) {
        _flashSaleOnly = true;
        _title = 'Flash Sale';
      }

      focusSearch = argument['focusSearch'] == true;
    }

    _load();

    if (focusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await _repo.getProducts(
      category: _category,
      flashSaleOnly: _flashSaleOnly,
      query: _searchController.text,
    );

    if (!mounted) return;

    setState(() {
      _products = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          _title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              textInputAction: TextInputAction.search,
              onChanged: (_) => _load(),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.grey,
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _load();
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_products.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No products found',
        message: 'Try a different search or category.',
      );
    }

    return GridView.builder(
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
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];

        return RepaintBoundary(
          key: ValueKey(product.id),
          child: _ProductGridCard(
            product: product,
            cartCtrl: _cartCtrl,
            wishCtrl: _wishCtrl,
            index: index,
          ),
        );
      },
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
                    child: ProductImage(
                      url: product.image,
                      width: double.infinity,
                      height: 120,
                      iconSize: 56,
                      radius: const BorderRadius.vertical(
                        top: Radius.circular(16),
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