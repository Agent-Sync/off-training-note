import 'package:flutter/material.dart';

class DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.grey.shade400.withValues(alpha: 0.6);
    const spacing = 20.0;
    const radius = 1.2;

    for (double y = 0; y <= size.height; y += spacing) {
      for (double x = 0; x <= size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
