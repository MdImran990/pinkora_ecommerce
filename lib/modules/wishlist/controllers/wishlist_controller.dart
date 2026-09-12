import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../../data/model/product_model.dart';

class WishlistController extends GetxController {
  final _box = GetStorage();
  final wishlistItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _saveToStorage() {
    final data = wishlistItems.map((p) => {
      'id': p.id,
      'name': p.name,
      'image': p.image,
      'price': p.price,
      'originalPrice': p.originalPrice,
      'discountPercent': p.discountPercent,
      'rating': p.rating,
      'reviewCount': p.reviewCount,
      'category': p.category,
    }).toList();
    _box.write('wishlist_items', jsonEncode(data));
  }

  void _loadFromStorage() {
    final raw = _box.read<String>('wishlist_items');
    if (raw != null && raw.isNotEmpty) {
      try {
        final List list = jsonDecode(raw);
        wishlistItems.value = list.map((e) => ProductModel(
          id: e['id'],
          name: e['name'],
          image: e['image'] ?? '',
          price: (e['price'] as num).toDouble(),
          originalPrice: (e['originalPrice'] as num).toDouble(),
          discountPercent: e['discountPercent'],
          rating: (e['rating'] as num).toDouble(),
          reviewCount: e['reviewCount'],
          category: e['category'],
        )).toList();
      } catch (_) {
        wishlistItems.clear();
      }
    }
  }

  void addItem(ProductModel product) {
    if (!wishlistItems.any((e) => e.id == product.id)) {
      wishlistItems.add(product);
      _saveToStorage();
    }
  }

  void removeItem(ProductModel product) {
    wishlistItems.removeWhere((e) => e.id == product.id);
    _saveToStorage();
  }

  bool isWished(String id) =>
      wishlistItems.any((e) => e.id == id);

  bool get isEmpty => wishlistItems.isEmpty;
}