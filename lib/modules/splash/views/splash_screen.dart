import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashAnimatedView();
  }
}

class _SplashAnimatedView extends StatefulWidget {
  const _SplashAnimatedView();

  @override
  State<_SplashAnimatedView> createState() => _SplashAnimatedViewState();
}

class _SplashAnimatedViewState extends State<_SplashAnimatedView>
    with TickerProviderStateMixin {
  late AnimationController _waveCtrl;
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _bottomCtrl;
  late AnimationController _progressCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _bottomFade;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _logoCtrl.forward();

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _textCtrl.forward();
    });

    _bottomCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bottomCtrl, curve: Curves.easeIn),
    );
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _bottomCtrl.forward();
    });

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) _progressCtrl.forward();
    });
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _bottomCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFAE8F1),
      body: Stack(
        children: [
          // ── Blobs ──
          AnimatedBuilder(
            animation: _waveCtrl,
            builder: (_, __) {
              final t = _waveCtrl.value * 2 * math.pi;
              return Stack(
                children: [
                  // Top-left blob
                  Positioned(
                    top: -sh * 0.10 + math.sin(t) * 6,
                    left: -sw * 0.18 + math.cos(t) * 5,
                    child: Container(
                      width: sw * 0.62,
                      height: sw * 0.62,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2AECE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Top-right blob
                  Positioned(
                    top: -sh * 0.06 + math.sin(t + 1) * 6,
                    right: -sw * 0.15 + math.cos(t + 1) * 4,
                    child: Container(
                      width: sw * 0.48,
                      height: sw * 0.48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7CEDE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Mid-right blob
                  Positioned(
                    top: sh * 0.32 + math.sin(t + 2) * 8,
                    right: -sw * 0.10,
                    child: Container(
                      width: sw * 0.28,
                      height: sw * 0.28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2AECE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Bottom-right blob
                  Positioned(
                    bottom: -sh * 0.18 + math.cos(t) * 8,
                    right: -sw * 0.26,
                    child: Container(
                      width: sw * 0.85,
                      height: sw * 0.85,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEE96C1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Bottom-left blob
                  Positioned(
                    bottom: sh * 0.06 + math.sin(t + 3) * 6,
                    left: -sw * 0.10,
                    child: Container(
                      width: sw * 0.32,
                      height: sw * 0.32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7CEDE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Main Content ──
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: sh * 0.13),

                  // ── Bag Logo ──
                  AnimatedBuilder(
                    animation: _logoCtrl,
                    builder: (_, __) => FadeTransition(
                      opacity: _logoFade,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: SizedBox(
                          width: sw * 0.42,
                          height: sw * 0.42,
                          child: CustomPaint(
                            painter: _PinkoraBagPainter(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.030),

                  // ── Pinkora ──
                  AnimatedBuilder(
                    animation: _textCtrl,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: FadeTransition(
                        opacity: _textFade,
                        child: Text(
                          'Pinkora',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: sw * 0.112,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE0187C),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.004),

                  // ── Shop Your Happiness ──
                  AnimatedBuilder(
                    animation: _textCtrl,
                    builder: (_, __) => FadeTransition(
                      opacity: _textFade,
                      child: Text(
                        'Shop Your Happiness',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: sw * 0.037,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF444444),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ── Bottom Section ──
                  FadeTransition(
                    opacity: _bottomFade,
                    child: Column(
                      children: [
                        Text(
                          'Trendy Products\nFor A Brighter You',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: sw * 0.033,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE0187C),
                            height: 1.65,
                          ),
                        ),
                        SizedBox(height: sh * 0.020),

                        // ── Progress Bar ──
                        AnimatedBuilder(
                          animation: _progressCtrl,
                          builder: (_, __) => Container(
                            width: sw * 0.36,
                            height: 3.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0187C).withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _progress.value,
                              child: Container(
                                height: 3.5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0187C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: sh * 0.065),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BAG PAINTER
// ─────────────────────────────────────────────────────────────
class _PinkoraBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final pink = Paint()
      ..color = const Color(0xFFE91E8C)
      ..style = PaintingStyle.fill;

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // ── Handle ──
    final handlePaint = Paint()
      ..color = const Color(0xFFE91E8C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round;

    final handlePath = Path()
      ..moveTo(w * 0.295, h * 0.355)
      ..cubicTo(
        w * 0.295, h * 0.075,
        w * 0.705, h * 0.075,
        w * 0.705, h * 0.355,
      );
    canvas.drawPath(handlePath, handlePaint);

    // ── Bag Body ──
    final double bL = w * 0.03;
    final double bR = w * 0.97;
    final double bT = h * 0.34;
    final double bB = h * 0.96;
    final double bRad = w * 0.13;

    final bagPath = Path()
      ..moveTo(bL + bRad, bT)
      ..lineTo(bR - bRad, bT)
      ..quadraticBezierTo(bR, bT, bR, bT + bRad)
      ..lineTo(bR, bB - bRad)
      ..quadraticBezierTo(bR, bB, bR - bRad, bB)
      ..lineTo(bL + bRad, bB)
      ..quadraticBezierTo(bL, bB, bL, bB - bRad)
      ..lineTo(bL, bT + bRad)
      ..quadraticBezierTo(bL, bT, bL + bRad, bT)
      ..close();
    canvas.drawPath(bagPath, pink);

    // ── White Heart ──
    _heart(canvas, Offset(w * 0.50, h * 0.675), w * 0.185, white);

    // ── Floating Hearts ──
    final fPink = Paint()
      ..color = const Color(0xFFE91E8C)
      ..style = PaintingStyle.fill;
    final fLight = Paint()
      ..color = const Color(0xFFE91E8C).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    _heart(canvas, Offset(w * 0.805, h * 0.085), w * 0.105, fPink);
    _heart(canvas, Offset(w * 0.685, h * 0.025), w * 0.072, fLight);
    _heart(canvas, Offset(w * 0.935, h * 0.205), w * 0.055, fLight);
  }

  void _heart(Canvas canvas, Offset c, double s, Paint paint) {
    final p = Path();
    p.moveTo(c.dx, c.dy + s * 0.55);
    p.cubicTo(
      c.dx - s * 1.18, c.dy - s * 0.08,
      c.dx - s * 1.18, c.dy - s * 1.08,
      c.dx, c.dy - s * 0.38,
    );
    p.cubicTo(
      c.dx + s * 1.18, c.dy - s * 1.08,
      c.dx + s * 1.18, c.dy - s * 0.08,
      c.dx, c.dy + s * 0.55,
    );
    p.close();
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}