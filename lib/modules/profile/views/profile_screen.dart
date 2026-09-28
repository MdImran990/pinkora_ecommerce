import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_tile.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../widgets/avatar_view.dart';
import '../../main/controllers/main_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _SettingsButton(),
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SingleChildScrollView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ==================================================
            // PROFILE HEADER
            // ==================================================
            Obx(
                  () {
                final user = controller.user.value;

                return _AnimatedProfileHeader(
                  avatar: user?.avatar ?? '',
                  onAvatarTap: controller.showAvatarPicker,
                  name: user?.name ?? 'User',
                  email: (user == null || user.email.isNotEmpty)
                      ? (user?.email ?? '')
                      : user.phone,
                );
              },
            ),

            // ==================================================
            // MENU
            // ==================================================
            RepaintBoundary(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileMenuTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      onTap: () => Get.toNamed(AppRoutes.orders),
                      iconColor: AppColors.primary,
                      iconBgColor:
                      AppColors.primaryLight,
                    ),

                    ProfileMenuTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Wishlist',
                      onTap: () => Get.find<MainController>().setIndex(3),
                      iconColor:
                      const Color(0xFFE53935),
                      iconBgColor:
                      const Color(0xFFFFEBEE),
                    ),

                    ProfileMenuTile(
                      icon: Icons.location_on_outlined,
                      title: 'My Address',
                      onTap: () => Get.toNamed(AppRoutes.addresses),
                      iconColor:
                      const Color(0xFF3D5AFE),
                      iconBgColor:
                      const Color(0xFFE8EAFF),
                    ),

                    ProfileMenuTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Payment Methods',
                      onTap: () => Get.toNamed(AppRoutes.paymentMethods),
                      iconColor:
                      const Color(0xFF4CAF50),
                      iconBgColor:
                      const Color(0xFFE8F5E9),
                    ),

                    ProfileMenuTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () => Get.toNamed(AppRoutes.notifications),
                      iconColor:
                      const Color(0xFFFF9800),
                      iconBgColor:
                      const Color(0xFFFFF3E0),
                    ),

                    ProfileMenuTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      onTap: () => Get.toNamed(AppRoutes.help),
                      iconColor:
                      const Color(0xFF9C27B0),
                      iconBgColor:
                      const Color(0xFFF3E5F5),
                    ),

                    ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () => Get.toNamed(AppRoutes.settings),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // LOGOUT
            // ==================================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: _AnimatedLogoutButton(
                onTap: controller.logout,
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

    );
  }
}

// ============================================================
// SETTINGS BUTTON
// ============================================================

class _SettingsButton extends StatefulWidget {
  const _SettingsButton();

  @override
  State<_SettingsButton> createState() =>
      _SettingsButtonState();
}

class _SettingsButtonState extends State<_SettingsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration:
      const Duration(milliseconds: 130),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.92,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapCancel() {
    _controller.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();

    Get.toNamed(AppRoutes.settings);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _tapDown,
      onTapCancel: _tapCancel,
      onTapUp: _tapUp,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: const Icon(
            Icons.settings_outlined,
            color: AppColors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE HEADER
// ============================================================

class _AnimatedProfileHeader extends StatefulWidget {
  const _AnimatedProfileHeader({
    required this.avatar,
    required this.onAvatarTap,
    required this.name,
    required this.email,
  });

  final String avatar;
  final VoidCallback onAvatarTap;
  final String name;
  final String email;

  @override
  State<_AnimatedProfileHeader> createState() =>
      _AnimatedProfileHeaderState();
}

class _AnimatedProfileHeaderState
    extends State<_AnimatedProfileHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              24,
            ),
            child: Column(
              children: [
                // ============================================
                // AVATAR
                // ============================================
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onAvatarTap,
                  child: RepaintBoundary(
                  child: Stack(
                    children: [
                      AvatarView(
                        avatar: widget.avatar,
                        name: widget.name,
                        size: 90,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration:
                          const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),

                const SizedBox(height: 14),

                // ============================================
                // NAME
                // ============================================
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 4),

                // ============================================
                // EMAIL
                // ============================================
                Text(
                  widget.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LOGOUT BUTTON
// ============================================================

class _AnimatedLogoutButton extends StatefulWidget {
  const _AnimatedLogoutButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedLogoutButton> createState() =>
      _AnimatedLogoutButtonState();
}

class _AnimatedLogoutButtonState
    extends State<_AnimatedLogoutButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration:
      const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.97,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapCancel() {
    _controller.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();

    Future<void>.delayed(
      const Duration(milliseconds: 15),
          () {
        if (mounted) {
          widget.onTap();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _tapDown,
      onTapCancel: _tapCancel,
      onTapUp: _tapUp,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
              disabledForegroundColor:
              AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}