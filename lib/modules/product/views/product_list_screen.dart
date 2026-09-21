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
import '../../../widgets/skeletons.dart';

enum _SortOption {
  relevance('Relevance'),
  priceLow('Price: Low to High'),
  priceHigh('Price: High to Low'),
  rating('Top Rated'),
  discount('Biggest Discount');

  const _SortOption(this.label);

  final String label;
}

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

  _SortOption _sort = _SortOption.relevance;

  /// null = no price filter
  RangeValues? _priceRange;

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

  /// Lowest and highest price of the loaded products.
  RangeValues get _bounds {
    if (_products.isEmpty) return const RangeValues(0, 1);

    var low = _products.first.price;
    var high = _products.first.price;

    for (final p in _products) {
      if (p.price < low) low = p.price;
      if (p.price > high) high = p.price;
    }

    return RangeValues(low.floorToDouble(), high.ceilToDouble());
  }

  /// Products after the price filter and the sort option are applied.
  List<ProductModel> get _visible {
    final range = _priceRange;

    final list = _products.where((p) {
      if (range == null) return true;

      return p.price >= range.start && p.price <= range.end;
    }).toList();

    switch (_sort) {
      case _SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case _SortOption.discount:
        list.sort(
              (a, b) => b.discountPercent.compareTo(a.discountPercent),
        );
        break;
      case _SortOption.relevance:
        break;
    }

    return list;
  }

  void _openSort() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              for (final option in _SortOption.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: option == _sort
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: option == _sort
                          ? AppColors.primary
                          : AppColors.black,
                    ),
                  ),
                  trailing: option == _sort
                      ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                  )
                      : null,
                  onTap: () {
                    setState(() => _sort = option);
                    Get.back();
                  },
                ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void _openFilter() {
    final bounds = _bounds;

    if (bounds.end <= bounds.start) return;

    // Keep the saved range inside the current bounds (a new search can
    // change them).
    var current = bounds;

    final saved = _priceRange;

    if (saved != null) {
      final start = saved.start < bounds.start ? bounds.start : saved.start;
      final end = saved.end > bounds.end ? bounds.end : saved.end;

      if (start <= end) current = RangeValues(start, end);
    }

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheet) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '৳ ${current.start.toInt()}  -  ৳ ${current.end.toInt()}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  RangeSlider(
                    values: current,
                    min: bounds.start,
                    max: bounds.end,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setSheet(() => current = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _priceRange = null);
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _priceRange = current);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _toolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    if (_loading) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${_visible.length} items',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ),
          _toolbarButton(
            icon: Icons.swap_vert_rounded,
            label: _sort == _SortOption.relevance ? 'Sort' : _sort.label,
            active: _sort != _SortOption.relevance,
            onTap: _openSort,
          ),
          const SizedBox(width: 8),
          _toolbarButton(
            icon: Icons.tune_rounded,
            label: 'Filter',
            active: _priceRange != null,
            onTap: _openFilter,
          ),
        ],
      ),
    );
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
          _buildToolbar(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const ProductGridSkeleton();
    }

    final visible = _visible;

    if (visible.isEmpty) {
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
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final product = visible[index];

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