import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../cart/views/cart_screen.dart';
import '../../category/views/category_screen.dart';
import '../../home/views/home_screen.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_screen.dart';
import '../../wishlist/views/wishlist_screen.dart';
import '../controllers/main_controller.dart';

/// Hosts the five bottom tabs. Tabs are created the first time you open them
/// and then kept alive, so switching is instant.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final MainController _main = Get.find<MainController>();

  /// Tabs that were opened at least once.
  final Set<int> _visited = <int>{};

  /// False until the controller has been told which tab this shell opened on.
  bool _synced = false;

  @override
  void initState() {
    super.initState();

    _visited.add(widget.initialIndex);

    // Changing observable values while the tree is being built makes other
    // Obx widgets fail ("setState() called during build"), so it is done
    // right after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _synced = true;
      _main.index.value = widget.initialIndex;

      // Show the current user's name/avatar on the profile tab.
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUser();
      }
    });
  }

  Widget _tab(int index) {
    if (!_visited.contains(index)) return const SizedBox.shrink();

    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CategoryScreen();
      case 2:
        return const CartScreen();
      case 3:
        return const WishlistScreen();
      default:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        final selected = _main.index.value;

        // Until the first frame is done, show the tab this shell was opened on.
        final current = _synced ? selected : widget.initialIndex;

        _visited.add(current);

        return PopScope(
          // Back on another tab returns to Home first.
          canPop: current == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _main.setIndex(0);
          },
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            body: IndexedStack(
              index: current,
              children: List.generate(5, _tab),
            ),
            bottomNavigationBar: PinkoraBottomNav(
              currentIndex: current,
              onTabSelected: _main.setIndex,
            ),
          ),
        );
      },
    );
  }
}
