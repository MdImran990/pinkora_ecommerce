import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent: GetX must not delete this controller when a route that
    // was replaced with Get.offAllNamed() gets disposed.
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(),
        permanent: true,
      );
    }
  }
}
