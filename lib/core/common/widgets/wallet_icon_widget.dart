import 'package:flutter/material.dart';
import 'package:ram/core/theme/app_colors.dart';

class WalletIconWidget extends StatelessWidget {
  final double size;

  const WalletIconWidget({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.22;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.walletGradientMid.withValues(alpha: 0.5),
            blurRadius: 36,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            // 3-stop gradient body — light gold top-left to deep amber bottom-right
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.walletGradientLight,
                      AppColors.walletGradientMid,
                      AppColors.walletGradientDark,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Top-centre shine for depth
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size * 0.32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.white.withValues(alpha: 0.28),
                      AppColors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Dark green flap — full-width, straight bottom edge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size * 0.30,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.walletFlapDark, AppColors.walletFlapLight],
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: size * 0.22,
                  height: size * 0.07,
                  decoration: BoxDecoration(
                    color: AppColors.walletFlapLock,
                    borderRadius: BorderRadius.circular(size * 0.04),
                  ),
                ),
              ),
            ),
            // ₹ symbol centred in the gold portion with a subtle drop-shadow
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: size * 0.20),
                child: Center(
                  child: Text(
                    '₹',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: size * 0.46,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      shadows: const [
                        Shadow(
                          color: AppColors.walletShadowDark,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
