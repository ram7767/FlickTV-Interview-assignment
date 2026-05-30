import 'package:flutter/material.dart';
import 'package:ram/core/constants/app_constants.dart';
import 'package:ram/features/wallet/domain/entities/feature_item.dart';
import 'package:ram/core/theme/app_colors.dart';

class FeatureCardWidget extends StatelessWidget {
  final FeatureItem item;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const FeatureCardWidget({
    super.key,
    required this.item,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _FeatureIcon(iconType: item.iconType),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final String iconType;
  const _FeatureIcon({required this.iconType});

  @override
  Widget build(BuildContext context) {
    final icon = switch (iconType) {
      AppConstants.walletTapText => Icons.touch_app_rounded,
      AppConstants.walletWifiText => Icons.wifi_rounded,
      AppConstants.walletRefundText => Icons.currency_rupee_rounded,
      _ => Icons.check_circle_rounded,
    };
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.featureIconBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.walletGoldLight, size: 30),
    );
  }
}
