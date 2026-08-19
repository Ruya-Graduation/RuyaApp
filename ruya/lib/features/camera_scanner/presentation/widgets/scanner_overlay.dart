import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return CustomPaint(
          painter: _ScannerPainter(rotationValue: _animController.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ScannerPainter extends CustomPainter {
  final double rotationValue;

  _ScannerPainter({required this.rotationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 100.0;

    final cyanPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final faintCyanPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Outer subtle guide circle
    canvas.drawCircle(center, radius + 20, faintCyanPaint);

    // Rotating cyan brackets / arcs around the target
    final angleOffset = rotationValue * 2 * math.pi;

    for (int i = 0; i < 4; i++) {
      final startAngle = angleOffset + (i * math.pi / 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        math.pi / 6,
        false,
        cyanPaint,
      );
    }

    // Inner pulsing target dot
    final dotPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.7 + 0.3 * math.sin(rotationValue * 2 * math.pi))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 7, dotPaint);

    final innerRingPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 24, innerRingPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
  }
}
