import 'dart:math' as math;

import '../mock/mock_data.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../model/review_model.dart';

/// Products, categories and reviews.
///
/// Currently served from local mock data. When the backend is ready, only the
/// bodies of these methods change (controllers and screens stay the same).
class ProductRepository {
  /// Mimics network time so loading skeletons are visible.
  /// Delete this when the real API is connected.
  Future<void> _simulateNetwork() {
    return Future.delayed(const Duration(milliseconds: 350));
  }

  Future<List<CategoryModel>> getCategories() async {
    await _simulateNetwork();

    return MockData.categories;
  }

  Future<List<ProductModel>> getProducts({
    String? category,
    String? query,
    bool flashSaleOnly = false,
  }) async {
    await _simulateNetwork();

    Iterable<ProductModel> result = MockData.products;

    if (category != null && category.isNotEmpty) {
      result = result.where(
            (p) => p.category.toLowerCase() == category.toLowerCase(),
      );
    }

    if (flashSaleOnly) {
      result = result.where((p) => p.isFlashSale);
    }

    final text = query?.trim().toLowerCase() ?? '';

    if (text.isNotEmpty) {
      result = result.where(
            (p) =>
        p.name.toLowerCase().contains(text) ||
            p.category.toLowerCase().contains(text),
      );
    }

    return result.toList();
  }

  Future<List<ProductModel>> getFlashSaleProducts() {
    return getProducts(flashSaleOnly: true);
  }

  Future<ProductModel?> getProductById(String id) async {
    for (final product in MockData.products) {
      if (product.id == id) return product;
    }
    return null;
  }

  /// Other products from the same category.
  Future<List<ProductModel>> getRelatedProducts(
      ProductModel product, {
        int limit = 8,
      }) async {
    final sameCategory = MockData.products
        .where((p) => p.id != product.id && p.category == product.category)
        .toList();

    if (sameCategory.length >= limit) {
      return sameCategory.take(limit).toList();
    }

    // Not enough in the category -> fill with other products.
    final others = MockData.products
        .where(
          (p) => p.id != product.id && p.category != product.category,
    )
        .toList();

    return [...sameCategory, ...others].take(limit).toList();
  }

  static const List<String> _reviewers = [
    'Rahim Uddin',
    'Nusrat Jahan',
    'Tanvir Ahmed',
    'Sadia Islam',
    'Imran Hossain',
    'Farhana Akter',
    'Mahmud Hasan',
    'Tania Sultana',
  ];

  static const Map<int, List<String>> _comments = {
    5: [
      'Excellent quality! Exactly like the pictures.',
      'Very happy with this purchase. Fast delivery too.',
      'Loved it. Totally worth the price.',
    ],
    4: [
      'Good product, packaging was nice.',
      'Looks great. Delivery took a little longer than expected.',
      'Nice quality for the price. Would buy again.',
    ],
    3: [
      'It is okay. Not exactly what I expected.',
      'Average quality, but it does the job.',
    ],
  };

  /// Sample reviews (same reviews every time for the same product).
  Future<List<ReviewModel>> getReviews(String productId) async {
    final seed = int.tryParse(productId) ?? productId.hashCode;
    final random = math.Random(seed);

    final now = DateTime.now();
    final reviews = <ReviewModel>[];

    for (var i = 0; i < 6; i++) {
      final rating = 3 + random.nextInt(3);
      final pool = _comments[rating] ?? _comments[5]!;

      reviews.add(
        ReviewModel(
          id: '$productId-$i',
          userName: _reviewers[(seed + i * 3) % _reviewers.length],
          rating: rating,
          comment: pool[random.nextInt(pool.length)],
          date: now.subtract(Duration(days: 2 + i * 5 + random.nextInt(4))),
        ),
      );
    }

    return reviews;
  }
}
