import 'dart:math';

import 'package:flutter/material.dart';

class Snowflake extends StatelessWidget {
  final double size;
  final double strokeWidth;
  const Snowflake({Key? key, this.size = 100, this.strokeWidth = 2.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size), // Set desired size
      painter: SnowflakePainter(strokeWidth: strokeWidth),
    );
  }
}

class SnowflakePainter extends CustomPainter {
  final double strokeWidth;
  SnowflakePainter({this.strokeWidth = 2.0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 169, 228, 255)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw snowflake
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (3.141592653589793 / 180);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
      drawBranch(canvas, paint, center, Offset(x, y), angle);
    }
  }

  void drawBranch(
      Canvas canvas, Paint paint, Offset start, Offset end, double angle) {
    final branchLength = (end - start).distance / 3;
    for (int i = 1; i < 3; i++) {
      final branchStart = Offset(
        start.dx + (end.dx - start.dx) * i / 3,
        start.dy + (end.dy - start.dy) * i / 3,
      );
      final branchAngle1 = angle + 45 * (3.141592653589793 / 180);
      final branchAngle2 = angle - 45 * (3.141592653589793 / 180);
      final branchEnd1 = Offset(
        branchStart.dx + branchLength * cos(branchAngle1),
        branchStart.dy + branchLength * sin(branchAngle1),
      );
      final branchEnd2 = Offset(
        branchStart.dx + branchLength * cos(branchAngle2),
        branchStart.dy + branchLength * sin(branchAngle2),
      );
      canvas.drawLine(branchStart, branchEnd1, paint);
      canvas.drawLine(branchStart, branchEnd2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
