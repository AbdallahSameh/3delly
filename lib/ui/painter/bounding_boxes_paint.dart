import 'package:flutter/material.dart';

class BoundingBoxesPaint extends CustomPainter {
  final List<Map<String, dynamic>> boxes;
  final Size previewSize, modelSize, windowSize;

  BoundingBoxesPaint({
    required this.boxes,
    required this.previewSize,
    required this.windowSize,
    this.modelSize = const Size(640, 640),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Color(0xFF00FF00);

    final scaleX = windowSize.width / previewSize.width;
    final scaleY = windowSize.height / previewSize.height;

    for (var box in boxes) {
      final x1 = box['x1'] * scaleX;
      final y1 = box['y1'] * scaleY;
      final x2 = box['x2'] * scaleX;
      final y2 = box['y2'] * scaleY;

      final rect = Rect.fromLTRB(x1, y1, x2, y2);

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
