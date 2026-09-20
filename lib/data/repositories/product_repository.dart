import '../mock/mock_data.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';

/// Products and categories.
/// Currently served from local mock data. When the backend is ready, only the
/// bodies of these methods change (controllers and screens stay the same).
class ProductRepository {
  Future<List<CategoryModel>> getCategories() async {
    return MockData.categories;
  }

  Future<List<ProductModel>> getProducts({
    String? category,
    String? query,
    bool flashSaleOnly = false,
  }) async {
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
}
