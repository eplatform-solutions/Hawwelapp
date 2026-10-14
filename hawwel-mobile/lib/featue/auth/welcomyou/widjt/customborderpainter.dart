import 'package:flutter/material.dart';
import 'package:usdt/constans/app_branding.dart';

class CustomBorderPainter extends CustomPainter {
  final double leftGap;
  final double rightGap;
  CustomBorderPainter({this.leftGap = 40, this.rightGap = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final branding = appBrandingNotifier.value;
    final paint = Paint()
      ..color = branding.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width - rightGap, 0);
    path.lineTo(leftGap, 0);
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomBorderPainter oldDelegate) =>
      leftGap != oldDelegate.leftGap || rightGap != oldDelegate.rightGap;
}
