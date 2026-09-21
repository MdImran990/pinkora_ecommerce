import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

/// Bottom sheet to choose a profile avatar.
///
/// Uploading a real photo needs the backend (image upload), so for now the
/// user picks a preset avatar or uses the first letter of the name.
class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  static const List<String> presets = [
    '🌸', '🦋', '🐱', '🐼', '🌟', '💖',
    '🎀', '🍓', '🌈', '🦄', '🐰', '🌷',
  ];

  @override
  Widget build(BuildContext context) {
    final current = controller.user.value?.avatar ?? '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your avatar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: presets.map((emoji) {
                final selected = emoji == current;

                return GestureDetector(
                  onTap: () {
                    controller.changeAvatar(emoji);
                    Get.back();
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {
                  controller.changeAvatar('');
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Use my initial letter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
