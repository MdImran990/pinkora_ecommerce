import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';

/// Which bottom-tab is open:
/// 0 Home, 1 Category, 2 Cart, 3 Wishlist, 4 Profile.
///
/// Permanent controller: tab changes are instant and every tab keeps its
/// state (scroll position, loaded data) while you switch.
class MainController extends GetxController {
  final RxInt index = 0.obs;

  void setIndex(int value) {
    if (value == index.value) return;

    index.value = value;

    // Profile data may have changed (login, edit profile).
    if (value == 4 && Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().loadUser();
    }
  }
}
