import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final isMinimum = quantity <= 1;

    return Row(
      children: [
        _StepBtn(
          icon: Icons.remove,
          onTap: onDecrease,
          isDisabled: isMinimum,
        ),

        const SizedBox(width: 16),

        // Smooth quantity change
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 140),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: SizedBox(
            key: ValueKey(quantity),
            width: 18,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        _StepBtn(
          icon: Icons.add,
          onTap: onIncrease,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
// ULTRA-SMOOTH STEP BUTTON
// ═══════════════════════════════════════════════════════

class _StepBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;

  const _StepBtn({
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  State<_StepBtn> createState() => _StepBtnState();
}

class _StepBtnState extends State<_StepBtn>
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
      begin: 1.0,
      end: 0.88,
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

  void _onTapDown(TapDownDetails details) {
    if (widget.isDisabled) return;

    _controller.forward();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isDisabled) return;

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
    final buttonColor = widget.isDisabled
        ? AppColors.lightGrey
        : AppColors.primaryLight;

    final iconColor = widget.isDisabled
        ? AppColors.grey
        : AppColors.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      child: RepaintBoundary(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}