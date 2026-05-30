// ─── Header delegate ──────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:ram/core/common/widgets/dot_background_painter.dart';
import 'package:ram/core/common/widgets/wallet_icon_widget.dart';
import 'package:ram/core/constants/app_constants.dart';
import 'package:ram/core/theme/app_colors.dart';
import 'package:ram/features/wallet/presentation/widgets/circle_icon_button.dart';

class WalletHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final double safeTop;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  WalletHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.safeTop,
    required this.onBack,
    required this.onSettings,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  // Builds a Hero shuttle that interpolates fontSize during the page transition
  static HeroFlightShuttleBuilder _textShuttle(
    String text,
    double fromSize,
    double toSize,
    FontWeight weight,
    double letterSpacing,
  ) =>
      (_, anim, dir, fromCtx, toCtx) => Material(
        type: MaterialType.transparency,
        child: AnimatedBuilder(
          animation: anim,
          builder: (_, child) {
            final t = dir == HeroFlightDirection.push
                ? anim.value
                : 1.0 - anim.value;
            return Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: TextStyle(
                color: AppColors.white,
                fontSize: fromSize + (toSize - fromSize) * t,
                fontWeight: weight,
                letterSpacing: letterSpacing,
                decoration: TextDecoration.none,
              ),
            );
          },
        ),
      );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (expandedHeight - collapsedHeight)).clamp(
      0.0,
      1.0,
    );
    final curved = Curves.easeInOut.transform(progress);

    // Expanded content fades out during scroll
    final expandedOpacity = (1.0 - progress * 1.9).clamp(0.0, 1.0);
    // Clean collapsed title fades in during scroll
    final collapsedOpacity = ((progress - 0.50) / 0.25).clamp(0.0, 1.0);

    // Brand block sizes — interpolate between expanded and collapsed values
    final walletSize = 90.0 - 58.0 * curved;
    final text1Size = AppConstants.introText1Size - 7.0 * curved;
    final text2Size = AppConstants.introText2Size - 26.0 * curved;
    final vertGap = 8.0 * (1.0 - curved);

    final blobHeight = walletSize + vertGap + text1Size * 1.3 + text2Size * 1.3;
    final visibleHeight = expandedHeight - shrinkOffset;
    final contentTop = ((visibleHeight / 2) - blobHeight / 2).clamp(
      0.0,
      double.infinity,
    );

    return ClipRect(
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: DotBackgroundPainter()),
          ),

          // Back button
          Positioned(
            top: safeTop + 8,
            left: 12,
            child: CircleIconButton(
              icon: Icons.arrow_back_ios_new,
              onTap: onBack,
            ),
          ),

          // Settings / replay button
          Positioned(
            top: safeTop + 8,
            right: 12,
            child: CircleIconButton(
              icon: Icons.settings_outlined,
              onTap: onSettings,
            ),
          ),

          // ── Expanded brand block: physically tracks the centre as header shrinks
          if (expandedOpacity > 0)
            Positioned(
              top: contentTop,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: expandedOpacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: AppConstants.heroTagWalletIcon,
                      child: WalletIconWidget(size: walletSize),
                    ),
                    SizedBox(height: vertGap),
                    Hero(
                      tag: AppConstants.heroTagFlickTV,
                      // Interpolates splashText1Size → introText1Size during flight
                      flightShuttleBuilder: _textShuttle(
                        AppConstants.blinkitText,
                        AppConstants.splashText1Size,
                        AppConstants.introText1Size,
                        FontWeight.w400,
                        1.0,
                      ),
                      child: Text(
                        AppConstants.blinkitText,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: text1Size,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(height: vertGap * 0.25),
                    Hero(
                      tag: AppConstants.heroTagAssignment,
                      // Interpolates splashText2Size → introText2Size during flight
                      flightShuttleBuilder: _textShuttle(
                        AppConstants.moneyText,
                        AppConstants.splashText2Size,
                        AppConstants.introText2Size,
                        FontWeight.w900,
                        1.5,
                      ),
                      child: Text(
                        AppConstants.moneyText,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: text2Size,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Collapsed title: clean, distinct design — no Heroes here
          if (collapsedOpacity > 0)
            Positioned(
              top: safeTop,
              left: 0,
              right: 0,
              height: kToolbarHeight,
              child: Opacity(
                opacity: collapsedOpacity,
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WalletIconWidget(size: 28),
                      SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.blinkitText,
                            style: TextStyle(
                              color: AppColors.collapsedSubtitleColor,
                              fontSize: AppConstants.collapsedText1Size,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.4,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            AppConstants.moneyText,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppConstants.collapsedText2Size,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(WalletHeaderDelegate old) =>
      expandedHeight != old.expandedHeight ||
      collapsedHeight != old.collapsedHeight ||
      safeTop != old.safeTop;
}
