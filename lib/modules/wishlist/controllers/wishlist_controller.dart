import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/storage_keys.dart';
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
    _box.write(
      StorageKeys.wishlistItems,
      jsonEncode(wishlistItems.map((p) => p.toJson()).toList()),
    );
  }

  void _loadFromStorage() {
    final raw = _box.read<String>(StorageKeys.wishlistItems);

    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List;

      wishlistItems.assignAll(
        list
            .map(
              (e) => ProductModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
            .toList(),
      );
    } catch (_) {
      wishlistItems.clear();
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

  bool isWished(String id) => wishlistItems.any((e) => e.id == id);

  bool get isEmpty => wishlistItems.isEmpty;
}
