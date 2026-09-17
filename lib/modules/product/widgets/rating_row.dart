import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class RatingRow extends StatefulWidget {
  final double rating;
  final int reviewCount;

  const RatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  State<RatingRow> createState() => _RatingRowState();
}

class _RatingRowState extends State<RatingRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullStars = widget.rating.floor();
    final hasHalfStar =
        widget.rating > fullStars && fullStars < 5;

    return RepaintBoundary(
      child: Row(
        children: [
          // ─────────────────────────────────────────
          // STARS
          // ─────────────────────────────────────────
          for (int i = 0; i < 5; i++)
            _AnimatedStar(
              index: i,
              isFull: i < fullStars,
              isHalf:
              i == fullStars && hasHalfStar,
              animation: _scaleAnimation,
            ),

          const SizedBox(width: 6),

          // ─────────────────────────────────────────
          // RATING
          // ─────────────────────────────────────────
          Text(
            '${widget.rating}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(width: 4),

          // ─────────────────────────────────────────
          // REVIEWS
          // ─────────────────────────────────────────
          Text(
            '(${widget.reviewCount} reviews)',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SMOOTH STAR
// ═══════════════════════════════════════════════════════

class _AnimatedStar extends StatelessWidget {
  final int index;
  final bool isFull;
  final bool isHalf;
  final Animation<double> animation;

  const _AnimatedStar({
    required this.index,
    required this.isFull,
    required this.isHalf,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: Icon(
        isFull
            ? Icons.star_rounded
            : (isHalf
            ? Icons.star_half_rounded
            : Icons.star_outline_rounded),
        color: AppColors.star,
        size: 18,
      ),
      builder: (context, child) {
        final delay = index * 0.08;
        final value = ((animation.value - delay) /
            (1 - delay))
            .clamp(0.0, 1.0);

        final curvedValue = Curves.easeOutBack.transform(
          value,
        );

        return Transform.scale(
          scale: curvedValue,
          child: child,
        );
      },
    );
  }
}