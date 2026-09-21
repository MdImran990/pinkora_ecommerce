import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../data/model/product_model.dart';
import '../../../data/model/review_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';
class ProductController extends GetxController {
  final Rxn<ProductModel> product = Rxn<ProductModel>();

  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxInt quantity = 1.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isWishlisted = false.obs;

  late final CartController _cartCtrl;
  late final WishlistController _wishCtrl;
  late final ProductRepository _repo;

  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxList<ProductModel> related = <ProductModel>[].obs;

  /// Lets the screen jump back to the top when another product is opened.
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    _cartCtrl = Get.find<CartController>();
    _wishCtrl = Get.find<WishlistController>();
    _repo = Get.find<ProductRepository>();

    _loadProduct();
  }

  void _loadProduct() {
    final argument = Get.arguments;

    final loadedProduct = argument is ProductModel
        ? argument
        : _fallbackProduct;

    _apply(loadedProduct);
  }

  /// Opens another product on the same screen (used by "You may also like").
  void showProduct(ProductModel next) {
    _apply(next);

    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _apply(ProductModel loadedProduct) {
    product.value = loadedProduct;

    selectedColor.value = loadedProduct.colors.isNotEmpty
        ? loadedProduct.colors.first
        : '';

    selectedSize.value = '';
    quantity.value = 1;
    currentImageIndex.value = 0;

    isWishlisted.value =
        _wishCtrl.isWished(loadedProduct.id);

    _loadExtras(loadedProduct);
  }

  Future<void> _loadExtras(ProductModel current) async {
    reviews.clear();
    related.clear();

    final loadedReviews = await _repo.getReviews(current.id);
    final loadedRelated = await _repo.getRelatedProducts(current);

    // Ignore the result if the screen was closed or another product opened.
    if (isClosed || product.value?.id != current.id) return;

    reviews.assignAll(loadedReviews);
    related.assignAll(loadedRelated);
  }

  /// Copies a short sharing text (a real share sheet needs the share_plus
  /// package and a product link from the backend).
  Future<void> shareProduct() async {
    final current = product.value;

    if (current == null) return;

    await Clipboard.setData(
      ClipboardData(
        text: 'Check out ${current.name} on Pinkora - '
            '৳${current.price.toInt()} (${current.discountPercent}% OFF)',
      ),
    );

    CustomSnackbar.success(
      'Copied!',
      'Product details copied. You can paste and share them.',
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  static final ProductModel _fallbackProduct = ProductModel(
    id: '1',
    name: 'Trendy Handbag',
    image: '',
    price: 2100,
    originalPrice: 3000,
    discountPercent: 30,
    rating: 4.8,
    reviewCount: 120,
    category: 'Fashion',
    colors: [
      '#FF6B9D',
      '#000000',
      '#D4A574',
      '#F5E6D3',
    ],
  );

  void selectColor(String color) {
    if (selectedColor.value == color) return;

    selectedColor.value = color;
  }

  void selectSize(String size) {
    if (selectedSize.value == size) return;

    selectedSize.value = size;
  }

  void toggleWishlist() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    final wished =
    _wishCtrl.isWished(currentProduct.id);

    if (wished) {
      _wishCtrl.removeItem(currentProduct);
      isWishlisted.value = false;
    } else {
      _wishCtrl.addItem(currentProduct);
      isWishlisted.value = true;
    }
  }

  void increaseQty() {
    quantity.value++;
  }

  void decreaseQty() {
    if (quantity.value <= 1) return;

    quantity.value--;
  }

  void changeImage(int index) {
    if (index < 0) return;
    if (currentImageIndex.value == index) return;

    currentImageIndex.value = index;
  }

  void addToCart() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    _cartCtrl.addToCart(
      currentProduct,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );

    Get.snackbar(
      '✅ Added!',
      '${currentProduct.name} added to your cart',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 800),
    );
  }

  void buyNow() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    _cartCtrl.addToCart(
      currentProduct,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );

    // Only this product goes to checkout (not the rest of the cart).
    _cartCtrl.selectOnly(
      currentProduct.id,
      selectedColor.value,
      selectedSize.value,
    );

    Get.toNamed(AppRoutes.checkout);
  }
}