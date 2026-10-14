import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hawwel/constans/app_branding.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Color? color;
  final double dashWidth;
  final double dashGap;
  final double borderRadius;
  final EdgeInsets padding;
  final double height;
  final double width;
  final Color backgroundColor;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.strokeWidth = 2.0,
    this.color,
    this.dashWidth = 6.0,
    this.dashGap = 4.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(12.0),
    this.height = 120,
    this.width = 300,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? appBrandingNotifier.value.primaryText;
    final double h = height;
    final double w = width;

    return CustomPaint(
      foregroundPainter: _DashRRectPainter(
        strokeWidth: strokeWidth,
        color: resolvedColor,
        dashWidth: dashWidth,
        dashGap: dashGap,
        radius: borderRadius,
      ),
      child: Container(
        height: h,
        width: w,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

class _DashRRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double radius;

  _DashRRectPainter({
    required this.strokeWidth,
    required this.color,
    required this.dashWidth,
    required this.dashGap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0 + strokeWidth / 2, 0 + strokeWidth / 2,
          size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );

    final Path fullPath = Path()..addRRect(rrect);

    final PathMetrics metrics = fullPath.computeMetrics();

    for (final PathMetric metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashWidth;
        final double end = next < metric.length ? next : metric.length;
        final Path extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance = end + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
