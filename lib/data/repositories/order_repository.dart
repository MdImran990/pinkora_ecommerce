import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../core/constants/storage_keys.dart';
import '../model/order_model.dart';

class OrderRepository {
  final GetStorage _box = GetStorage();

  List<OrderModel> load() {
    final raw = _box.read<String>(StorageKeys.orders);

    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List;

      return list
          .map(
            (e) => OrderModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<OrderModel> orders) {
    return _box.write(
      StorageKeys.orders,
      jsonEncode(orders.map((e) => e.toJson()).toList()),
    );
  }
}
