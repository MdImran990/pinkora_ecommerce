import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../core/constants/storage_keys.dart';
import '../model/cart_item_model.dart';

/// Keeps the cart on the device so it survives app restarts.
class CartRepository {
  final GetStorage _box = GetStorage();

  List<CartItemModel> load() {
    final raw = _box.read<String>(StorageKeys.cartItems);

    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List;

      return list
          .map(
            (e) => CartItemModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<CartItemModel> items) {
    return _box.write(
      StorageKeys.cartItems,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}
