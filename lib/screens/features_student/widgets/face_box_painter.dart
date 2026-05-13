import 'package:flutter/material.dart';

class FaceBoxPainter extends CustomPainter {
  final List<Rect> faces;
  final Size imageSize;
  final bool isFrontCamera;

  FaceBoxPainter(
      {required this.faces,
      required this.imageSize,
      required this.isFrontCamera});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final scaleX = size.width / imageSize.height;
    final scaleY = size.height / imageSize.width;

    for (final face in faces) {
      double left = face.left * scaleX;
      double top = face.top * scaleY;
      double right = face.right * scaleX;
      double bottom = face.bottom * scaleY;

      if (isFrontCamera) {
        left = size.width - (face.right * scaleX);
        right = size.width - (face.left * scaleX);
      }
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
