import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../widgets/avatar_picker_sheet.dart';
import '../../../widgets/custom_snackbar.dart';

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

  /// Lets the user pick a photo from their gallery, copies it into the
  /// app's own storage (so it survives cache clean-ups and app restarts),
  /// and saves that path as the avatar.
  ///
  /// Every pick is saved under a new file name. Flutter's Image.file caches
  /// a picture by its file path, so writing over the same path again would
  /// keep showing the old photo - a fresh path avoids that stale cache.
  Future<void> pickAvatarFromGallery() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (picked == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final extension = picked.path.split('.').last;
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/avatar_$stamp.$extension';
      final oldAvatar = user.value?.avatar ?? '';

      await File(picked.path).copy(savedPath);
      await changeAvatar(savedPath);

      // Clean up the previous photo now that the new one is saved.
      if (oldAvatar.startsWith('/') && oldAvatar != savedPath) {
        try {
          final oldFile = File(oldAvatar);

          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        } catch (_) {
          // Not critical if the old file can't be removed.
        }
      }
    } catch (_) {
      CustomSnackbar.error(
        'Could not set photo',
        'Please try choosing the image again.',
      );
    }
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
