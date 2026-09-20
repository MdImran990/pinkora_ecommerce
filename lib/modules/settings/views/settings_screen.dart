import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../widgets/pinkora_app_bar.dart';
import '../../auth/controllers/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String appVersion = '1.0.0';

  final GetStorage _box = GetStorage();

  late bool _pushEnabled;

  @override
  void initState() {
    super.initState();

    _pushEnabled = _box.read<bool>(StorageKeys.pushEnabled) ?? true;
  }

  Future<void> _setPush(bool value) async {
    setState(() => _pushEnabled = value);

    await _box.write(StorageKeys.pushEnabled, value);
  }

  void _showInfo(String title, String text) {
    Get.defaultDialog(
      title: title,
      middleText: text,
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: Get.back,
    );
  }

  void _confirmLogout() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar('Settings'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          const _SectionTitle('Account'),
          _Group(
            children: [
              _Tile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                onTap: () => Get.toNamed(AppRoutes.editProfile),
              ),
              _Tile(
                icon: Icons.location_on_outlined,
                title: 'Manage Addresses',
                onTap: () => Get.toNamed(AppRoutes.addresses),
              ),
              _Tile(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                onTap: () => Get.toNamed(AppRoutes.paymentMethods),
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Preferences'),
          _Group(
            children: [
              _Tile(
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                isLast: true,
                trailing: Switch(
                  value: _pushEnabled,
                  onChanged: _setPush,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('About'),
          _Group(
            children: [
              _Tile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () => Get.toNamed(AppRoutes.help),
              ),
              _Tile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => _showInfo(
                  'Privacy Policy',
                  'We only use your information to process your orders and '
                      'improve your shopping experience. We never sell your '
                      'personal data.',
                ),
              ),
              _Tile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () => _showInfo(
                  'Terms & Conditions',
                  'By using Pinkora you agree to our terms of service, '
                      'delivery and return policies.',
                ),
              ),
              const _Tile(
                icon: Icons.info_outline_rounded,
                title: 'App Version',
                isLast: true,
                trailing: Text(
                  appVersion,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _confirmLogout,
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                trailing ??
                    (onTap == null
                        ? const SizedBox.shrink()
                        : const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.grey,
                    )),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 62,
            color: AppColors.border,
          ),
      ],
    );
  }
}
