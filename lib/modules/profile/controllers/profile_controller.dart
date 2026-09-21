import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../widgets/avatar_picker_sheet.dart';

class ProfileController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    user.value = _repo.currentUser ??
        UserModel(
          id: 'guest',
          name: 'Pinkora User',
          email: '',
        );
  }

  /// Opens the avatar chooser.
  void showAvatarPicker() {
    Get.bottomSheet(
      AvatarPickerSheet(controller: this),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<void> changeAvatar(String value) async {
    final current = user.value;

    if (current == null) return;

    final updated = current.copyWith(avatar: value);

    await _repo.updateProfile(updated);

    user.value = updated;
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.find<AuthController>().logout();
      },
    );
  }
}
