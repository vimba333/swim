import 'dart:math' as math;

import 'package:flutter/material.dart';
class LifeRing extends StatelessWidget {
  final String letter;

  const LifeRing({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: _LifeRingPainter(),
        child: Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFF4DA6FF).withOpacity(0.15),
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4DA6FF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class _LifeRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - 8;

    // 4 сектора чередующиеся красный/белый
    const sectorCount = 8;
    const sweepAngle = (2 * math.pi) / sectorCount;

    for (int i = 0; i < sectorCount; i++) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = i.isEven ? const Color(0xFFE53935) : Colors.white;

      final startAngle = i * sweepAngle - math.pi / 2;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      final holePath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: innerRadius));

      canvas.drawPath(
        Path.combine(PathOperation.difference, path, holePath),
        paint,
      );
    }

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1;

    canvas.drawCircle(center, outerRadius, borderPaint);
    canvas.drawCircle(center, innerRadius, borderPaint);
  }

  @override
  bool shouldRepaint(_LifeRingPainter old) => false;
}
