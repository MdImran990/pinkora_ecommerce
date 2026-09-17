import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String selectedColor;
  final ValueChanged<String> onSelect;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelect,
  });

  static Color _parseColor(String hex) {
    try {
      final value = hex.replaceAll('#', '');

      if (value.length == 6) {
        return Color(
          int.parse('FF$value', radix: 16),
        );
      }

      if (value.length == 8) {
        return Color(
          int.parse(value, radix: 16),
        );
      }

      return AppColors.primary;
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final colorCode in colors)
          _ColorItem(
            key: ValueKey(colorCode),
            colorCode: colorCode,
            color: _parseColor(colorCode),
            isSelected: selectedColor == colorCode,
            onTap: () => onSelect(colorCode),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
// ULTRA-SMOOTH COLOR ITEM
// ═══════════════════════════════════════════════════════

class _ColorItem extends StatefulWidget {
  final String colorCode;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorItem({
    super.key,
    required this.colorCode,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ColorItem> createState() => _ColorItemState();
}

class _ColorItemState extends State<_ColorItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  late final Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration:
      const Duration(milliseconds: 120),
    );

    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.90,
    ).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();

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
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      child: ScaleTransition(
        scale: _pressScale,
        child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.only(right: 10),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(
                    alpha: widget.isSelected ? 0.50 : 0.40,
                  ),
                  blurRadius:
                  widget.isSelected ? 8 : 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 140),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder:
                  (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: widget.isSelected
                  ? const Icon(
                Icons.check_rounded,
                key: ValueKey('selected'),
                color: Colors.white,
                size: 16,
              )
                  : const SizedBox(
                key: ValueKey('unselected'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}