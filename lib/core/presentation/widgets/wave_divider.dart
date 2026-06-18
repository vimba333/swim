import 'package:flutter/material.dart';
import 'dart:math' as math;


class WaveDivider extends StatefulWidget {

  final double squareSize;
  final double gap;
  final Color color;
  final Color? alternateColor;
  final double borderRadius;
  final bool animated;
  final Duration animationDuration;

  const WaveDivider({
    super.key,
    this.squareSize = 8,
    this.gap = 4,
    this.color = const Color(0xFF5C6BC0),
    this.alternateColor,
    this.borderRadius = 2,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1800),
  });

  @override
  State<WaveDivider> createState() => _WaveDividerState();
}

class _WaveDividerState extends State<WaveDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    if (widget.animated) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.squareSize,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SquareDividerPainter(
              squareSize: widget.squareSize,
              gap: widget.gap,
              color: widget.color,
              alternateColor: widget.alternateColor,
              borderRadius: widget.borderRadius,
              animationValue: widget.animated ? _controller.value : null,
            ),
          );
        },
      ),
    );
  }
}

class _SquareDividerPainter extends CustomPainter {
  final double squareSize;
  final double gap;
  final Color color;
  final Color? alternateColor;
  final double borderRadius;
  final double? animationValue; // null = без анимации

  _SquareDividerPainter({
    required this.squareSize,
    required this.gap,
    required this.color,
    this.alternateColor,
    required this.borderRadius,
    this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final step = squareSize + gap;
    final count = (size.width / step).ceil() + 1;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final x = i * step;
      double yOffset = 0;
      double scale = 0.3;
      if (animationValue != null) {
        final phase = animationValue! - (i / count);
        final wave = math.sin(phase * 2 * math.pi);
        yOffset = wave * squareSize * 0.1;
        scale = 0.7 + 0.3 * ((wave + 1) / 2); 
      }
      Color squareColor;
      if (animationValue != null) {
        final phase = animationValue! - (i / count);
        final t = (math.sin(phase * 2 * math.pi) + 1) / 2;
        squareColor = Color.lerp(
          color.withOpacity(0.35),
          alternateColor ?? color,
          t,
        )!;
      } else {
        
        squareColor = (alternateColor != null && i.isOdd)
            ? alternateColor!
            : color;
      }

      paint.color = squareColor;

      final scaledSize = squareSize * scale;
      final dx = x + (squareSize - scaledSize) / 2;
      final dy = (size.height - scaledSize) / 2 + yOffset;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(dx, dy, scaledSize, scaledSize),
        Radius.circular(borderRadius * scale),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_SquareDividerPainter old) =>
      old.animationValue != animationValue ||
      old.color != color ||
      old.squareSize != squareSize;
}