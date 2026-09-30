import 'package:flutter/material.dart';

/// Wraps anything tappable with a soft "press" animation: it shrinks a
/// little while a finger is down, then springs back when released.
///
/// Use it instead of a bare GestureDetector so every card, chip and button
/// in the app reacts to touch in the same smooth way.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.93,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Size while pressed (1.0 = no change). Smaller = stronger effect.
  final double scale;
  final HitTestBehavior behavior;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 320),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      // A small overshoot on release is what makes it feel springy.
      reverseCurve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down(TapDownDetails details) => _controller.forward();

  void _up(TapUpDetails details) => _controller.reverse();

  void _cancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _cancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        child: widget.child,
        builder: (context, child) {
          final value = 1 - ((1 - widget.scale) * _animation.value);

          return Transform.scale(scale: value, child: child);
        },
      ),
    );
  }
}
