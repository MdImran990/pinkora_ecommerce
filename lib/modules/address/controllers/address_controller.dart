import 'package:get/get.dart';

import '../../../data/model/address_model.dart';
import '../../../data/repositories/address_repository.dart';

/// Permanent controller: saved addresses are shared by the profile
/// "My Address" screen and the checkout address step.
class AddressController extends GetxController {
  final AddressRepository _repo = Get.find<AddressRepository>();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    addresses.assignAll(_repo.load());
  }

  /// The address marked as default, otherwise the first one.
  AddressModel? get defaultAddress {
    for (final address in addresses) {
      if (address.isDefault) return address;
    }

    return addresses.isEmpty ? null : addresses.first;
  }

  Future<AddressModel> save({
    String? id,
    required String label,
    required String name,
    required String phone,
    required String address,
    required bool isDefault,
  }) async {
    final makeDefault = isDefault || addresses.isEmpty;

    final saved = AddressModel(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      label: label,
      name: name.trim(),
      phone: phone.trim(),
      address: address.trim(),
      isDefault: makeDefault,
    );

    final list = addresses.toList();
    final index = list.indexWhere((a) => a.id == saved.id);

    if (index == -1) {
      list.add(saved);
    } else {
      list[index] = saved;
    }

    final normalized = makeDefault
        ? list
        .map((a) => a.id == saved.id ? a : a.copyWith(isDefault: false))
        .toList()
        : list;

    addresses.assignAll(normalized);

    await _repo.save(normalized);

    return saved;
  }

  Future<void> delete(String id) async {
    final list = addresses.where((a) => a.id != id).toList();

    final hasDefault = list.any((a) => a.isDefault);

    if (!hasDefault && list.isNotEmpty) {
      list[0] = list[0].copyWith(isDefault: true);
    }

    addresses.assignAll(list);

    await _repo.save(list);
  }

  Future<void> setDefault(String id) async {
    final list = addresses
        .map((a) => a.copyWith(isDefault: a.id == id))
        .toList();

    addresses.assignAll(list);

    await _repo.save(list);
  }
}
