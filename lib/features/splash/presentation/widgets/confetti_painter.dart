import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ram/core/theme/app_colors.dart';

class ConfettiParticle {
  final double x;
  final double y;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final double width;
  final double height;

  const ConfettiParticle({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.width,
    required this.height,
  });
}

List<ConfettiParticle> generateConfettiParticles(int count) {
  final rng = Random();

  return List.generate(count, (i) {
    final fromLeft = i % 2 == 0;

    // Well off-screen so pixel-cull hides them at t = 0
    final xStart = fromLeft
        ? -(0.1 + rng.nextDouble() * 0.2) // −0.15 … −0.25 (off left)
        : 1.1 + rng.nextDouble() * 0.2; //  1.15 …  1.25 (off right)

    const yStart = 0.6;

    // Inward velocity carries each flake toward the icon centre as it falls
    final vxMag = 0.006 + rng.nextDouble() * 0.005;
    final vx = fromLeft ? vxMag : -vxMag;

    // Upward blast: min vy = −0.027 already puts peak above screen top
    final vy = -(0.035 + rng.nextDouble() * 0.011);

    final rsSign = rng.nextBool()
        ? 1.5
        : -1.5; // Clockwise or counterclockwise spin

    return ConfettiParticle(
      x: xStart,
      y: yStart,
      velocityX: vx,
      velocityY: vy,
      rotation: rng.nextDouble() * 2 * pi,
      rotationSpeed: rsSign * rng.nextDouble() * 0.12,
      color: AppColors
          .confettiColors[rng.nextInt(AppColors.confettiColors.length)],
      width: 5.0 + rng.nextDouble() * 9.0,
      height: 2.5 + rng.nextDouble() * 4.0,
    );
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  const ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const gravity = 0.0012;
    const iconBottomY = 0.52;
    const yStart = 0.60; // matches particle yStart in generateConfettiParticles
    final paint = Paint();
    final t = progress * 100;
    for (final p in particles) {
      final normalizedY = p.y + p.velocityY * t + 0.5 * gravity * t * t;
      final currentX = (p.x + p.velocityX * t) * size.width;
      final currentY = normalizedY * size.height;

      if (currentY < -40 || currentY > size.height + 40) continue;
      if (currentX < -40 || currentX > size.width + 40) continue;

      // Fade out only on the way DOWN (past peak) as the flake sinks below icon
      final tPeak = -p.velocityY / gravity;
      double alpha = 1.0;
      if (t > tPeak && normalizedY > iconBottomY) {
        alpha = ((yStart - normalizedY) / (yStart - iconBottomY)).clamp(
          0.0,
          1.0,
        );
      }

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(p.rotation + p.rotationSpeed * t);
      paint.color = p.color.withValues(alpha: alpha);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.width, height: p.height),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter old) => old.progress != progress;
}
