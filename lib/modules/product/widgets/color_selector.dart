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
        return Color(int.parse('FF$value', radix: 16));
      }

      if (value.length == 8) {
        return Color(int.parse(value, radix: 16));
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

class _ColorItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: RepaintBoundary(
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isSelected
              ? const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 16,
          )
              : null,
        ),
      ),
    );
  }
}