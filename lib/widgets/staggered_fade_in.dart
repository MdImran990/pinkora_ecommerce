import 'package:flutter/material.dart';

/// Fades and slides a list/grid item in, with a small delay per index so
/// items appear one after another instead of all at once.
///
/// Wrap each item built by a ListView/GridView itemBuilder:
///
///   itemBuilder: (context, index) => StaggeredFadeIn(
///     index: index,
///     child: MyCard(...),
///   ),
class StaggeredFadeIn extends StatefulWidget {
  const StaggeredFadeIn({
    super.key,
    required this.index,
    required this.child,
    this.direction = AxisDirection.up,
    this.distance = 18,
  });

  final int index;
  final Widget child;

  /// Which way the item slides in from.
  final AxisDirection direction;
  final double distance;

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fade = curved;

    final dx = widget.direction == AxisDirection.left
        ? widget.distance
        : (widget.direction == AxisDirection.right ? -widget.distance : 0.0);
    final dy = widget.direction == AxisDirection.up
        ? widget.distance
        : (widget.direction == AxisDirection.down ? -widget.distance : 0.0);

    _slide = Tween<Offset>(
      begin: Offset(dx / 100, dy / 100),
      end: Offset.zero,
    ).animate(curved);

    // Cap the stagger so long lists don't feel slow to appear.
    final delay = Duration(
      milliseconds: (widget.index.clamp(0, 12)) * 45,
    );

    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: FractionalTranslation(
            translation: _slide.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
