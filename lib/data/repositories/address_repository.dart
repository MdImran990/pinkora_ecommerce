import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../core/constants/storage_keys.dart';
import '../model/address_model.dart';

class AddressRepository {
  final GetStorage _box = GetStorage();

  List<AddressModel> load() {
    final raw = _box.read<String>(StorageKeys.addresses);

    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List;

      return list
          .map(
            (e) => AddressModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<AddressModel> addresses) {
    return _box.write(
      StorageKeys.addresses,
      jsonEncode(addresses.map((e) => e.toJson()).toList()),
    );
  }
}
