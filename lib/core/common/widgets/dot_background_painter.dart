import 'package:flutter/material.dart';
import 'package:ram/core/theme/app_colors.dart';

class DotBackgroundPainter extends CustomPainter {
  final Color gradientTop;
  final Color gradientBottom;

  const DotBackgroundPainter({
    this.gradientTop = AppColors.giftCardBg,
    this.gradientBottom = AppColors.mainBackground,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientTop, gradientBottom],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    const spacing = 16.0;
    const radius = 1.2;
    final dotPaint = Paint()..color = AppColors.dotColor;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(DotBackgroundPainter old) =>
      gradientTop != old.gradientTop || gradientBottom != old.gradientBottom;
}
