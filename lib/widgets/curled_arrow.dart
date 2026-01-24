import 'dart:math' as Math;

import 'package:flutter/material.dart';

class CircularArrow extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  const CircularArrow({
    super.key,
    this.color = Colors.black,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircularArrowPainter(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _CircularArrowPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CircularArrowPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Simple quadratic curve (smooth and predictable)
    final path = Path()
      ..moveTo(w * 0.08, h * 0.2)
      ..quadraticBezierTo(
        w * 0.6,
        h * 0.1,
        w * 0.85,
        h * 0.75,
      );

    canvas.drawPath(path, paint);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return;
    }
    final metric = metrics.first;
    final tangent = metric.getTangentForOffset(metric.length);
    if (tangent == null) {
      return;
    }
    final end = tangent.position;
    final angle = tangent.angle + Math.pi - (60 * Math.pi / 180);
    final headLen = (w < h ? w : h) * 0.16;
    final left = Offset(
      end.dx - headLen * Math.cos(angle - 0.5),
      end.dy - headLen * Math.sin(angle - 0.5),
    );
    final right = Offset(
      end.dx - headLen * Math.cos(angle + 0.5),
      end.dy - headLen * Math.sin(angle + 0.5),
    );
    canvas.drawLine(end, left, paint);
    canvas.drawLine(end, right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
