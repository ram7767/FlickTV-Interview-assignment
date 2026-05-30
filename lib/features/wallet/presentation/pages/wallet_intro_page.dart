import 'package:flutter/material.dart';
import 'package:ram/core/constants/app_constants.dart';
import 'package:ram/core/theme/app_colors.dart';
import 'package:ram/features/wallet/data/wallet_data.dart';
import 'package:ram/features/wallet/presentation/widgets/feature_card_widget.dart';
import 'package:ram/features/splash/presentation/pages/splash_page.dart';
import 'package:ram/features/wallet/presentation/widgets/wallet_header_delegate.dart';

class WalletIntroPage extends StatefulWidget {
  const WalletIntroPage({super.key});

  @override
  State<WalletIntroPage> createState() => _WalletIntroPageState();
}

class _WalletIntroPageState extends State<WalletIntroPage>
    with TickerProviderStateMixin {
  late final AnimationController _staggerController;

  late final Animation<double> _fade0;
  late final Animation<double> _fade1;
  late final Animation<double> _fade2;
  late final Animation<Offset> _slide0;
  late final Animation<Offset> _slide1;
  late final Animation<Offset> _slide2;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: AppConstants.introStaggerDuration,
    );

    // Each card occupies ~32% of the timeline with a small gap → clear
    // one-after-another reveal: card 0 is nearly done before card 1 starts.
    _fade0 = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.0, 0.32, curve: Curves.easeIn),
    );
    _fade1 = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.34, 0.66, curve: Curves.easeIn),
    );
    _fade2 = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.68, 1.0, curve: Curves.easeIn),
    );

    final slideTween = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    );

    _slide0 = slideTween.animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.32, curve: Curves.easeOut),
      ),
    );
    _slide1 = slideTween.animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.34, 0.66, curve: Curves.easeOut),
      ),
    );
    _slide2 = slideTween.animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.68, 1.0, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  void _goToSplash() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SplashPage()));
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final expandedHeight = MediaQuery.of(context).size.height * 0.44;
    final collapsedHeight = kToolbarHeight + safeTop;
    const features = WalletData.features;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: WalletHeaderDelegate(
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              safeTop: safeTop,
              onBack: () => Navigator.maybePop(context),
              onSettings: _goToSplash,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  FeatureCardWidget(
                    item: features[0],
                    fadeAnimation: _fade0,
                    slideAnimation: _slide0,
                  ),
                  const SizedBox(height: 12),
                  FeatureCardWidget(
                    item: features[1],
                    fadeAnimation: _fade1,
                    slideAnimation: _slide1,
                  ),
                  const SizedBox(height: 12),
                  FeatureCardWidget(
                    item: features[2],
                    fadeAnimation: _fade2,
                    slideAnimation: _slide2,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: _goToSplash,
                      child: const Text(
                        AppConstants.replayText,
                        style: TextStyle(
                          color: AppColors.walletGoldLight,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.addMoneyGreen,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        AppConstants.addMoneyText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.giftCardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.card_giftcard_rounded,
                          color: AppColors.amber,
                          size: 32,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppConstants.claimGiftCardTitle,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                AppConstants.claimGiftCardSub,
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.textGrey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(
                        AppConstants.enjoyText,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.2),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        AppConstants.enjoySubText,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.2),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
