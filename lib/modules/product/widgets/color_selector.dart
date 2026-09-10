import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String selectedColor;
  final Function(String) onSelect;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelect,
  });

  Color _parseColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors.map((c) {
        final isSelected = selectedColor == c;
        final color = _parseColor(c);
        return GestureDetector(
          onTap: () => onSelect(c),
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
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded,
                color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}