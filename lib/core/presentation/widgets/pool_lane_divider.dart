import 'package:flutter/material.dart';

class PoolLaneDivider extends StatelessWidget {
  final double buoySize;
  final double gap;
  final int buoysPerSection;

  final Color whiteColor;
  final Color blueColor;
  final Color redColor;

  final bool showRedEnds;

  final int redBuoysCount;

  const PoolLaneDivider({
    super.key,
    this.buoySize = 3,
    this.gap = 4,
    this.buoysPerSection = 4,
    this.whiteColor = Colors.white,
    this.blueColor = const Color(0xFF1565C0),
    this.redColor = const Color(0xFFD32F2F),
    this.showRedEnds = true,
    this.redBuoysCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buoySize + 2,
      width: double.infinity,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PoolLaneDividerPainter(
            buoySize: buoySize,
            gap: gap,
            buoysPerSection: buoysPerSection,
            whiteColor: whiteColor,
            blueColor: blueColor,
            redColor: redColor,
            showRedEnds: showRedEnds,
            redBuoysCount: redBuoysCount,
          ),
        ),
      ),
    );
  }
}

class _PoolLaneDividerPainter extends CustomPainter {
  final double buoySize;
  final double gap;
  final int buoysPerSection;

  final Color whiteColor;
  final Color blueColor;
  final Color redColor;

  final bool showRedEnds;
  final int redBuoysCount;

  _PoolLaneDividerPainter({
    required this.buoySize,
    required this.gap,
    required this.buoysPerSection,
    required this.whiteColor,
    required this.blueColor,
    required this.redColor,
    required this.showRedEnds,
    required this.redBuoysCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.black12;

    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.25);

    final step = buoySize + gap;
    final count = (size.width / step).ceil();

    for (int i = 0; i < count; i++) {
      Color color;

      if (showRedEnds &&
          (i < redBuoysCount || i >= count - redBuoysCount)) {
        color = redColor;
      } else {
        final section =
            ((i - (showRedEnds ? redBuoysCount : 0)) ~/ buoysPerSection);

        color = section.isEven ? whiteColor : blueColor;
      }

      final center = Offset(
        i * step + buoySize / 2,
        size.height / 2,
      );

      // Основной поплавок
      fillPaint.color = color;
      canvas.drawCircle(center, buoySize / 2, fillPaint);

      // Легкий блик сверху
      canvas.drawCircle(
        Offset(
          center.dx - buoySize * 0.12,
          center.dy - buoySize * 0.12,
        ),
        buoySize * 0.18,
        highlightPaint,
      );

      // Обводка
      canvas.drawCircle(
        center,
        buoySize / 2,
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PoolLaneDividerPainter oldDelegate) {
    return oldDelegate.buoySize != buoySize ||
        oldDelegate.gap != gap ||
        oldDelegate.buoysPerSection != buoysPerSection ||
        oldDelegate.whiteColor != whiteColor ||
        oldDelegate.blueColor != blueColor ||
        oldDelegate.redColor != redColor ||
        oldDelegate.showRedEnds != showRedEnds ||
        oldDelegate.redBuoysCount != redBuoysCount;
  }
}