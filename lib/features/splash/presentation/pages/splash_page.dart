import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ram/core/constants/app_constants.dart';
import 'package:ram/core/theme/app_colors.dart';
import 'package:ram/features/splash/presentation/widgets/confetti_painter.dart';
import 'package:ram/core/common/widgets/dot_background_painter.dart';
import 'package:ram/core/common/widgets/wallet_icon_widget.dart';
import 'package:ram/features/wallet/presentation/pages/wallet_intro_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _walletController;
  late final AnimationController _confettiController;
  late final AnimationController _textController;

  late final Animation<double> _walletY;
  late final Animation<double> _walletRotation;

  late final Animation<double> _text1Opacity;
  late final Animation<Offset> _text1Slide;
  late final Animation<double> _text2Opacity;
  late final Animation<Offset> _text2Slide;

  late final List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();

    _walletController = AnimationController(
      vsync: this,
      duration: AppConstants.walletFallDuration,
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: AppConstants.confettiDuration,
    );
    _textController = AnimationController(
      vsync: this,
      duration: AppConstants.textStageDuration,
    );

    // Wallet drops from above with a bounce
    _walletY = Tween<double>(begin: -0.38, end: 0.0).animate(
      CurvedAnimation(parent: _walletController, curve: Curves.bounceOut),
    );

    // Wobble as the wallet settles
    _walletRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -0.18, end: 0.10), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.10, end: -0.05), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 30),
    ]).animate(_walletController);

    final slideTween = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    );

    // 'FlickTV' enters first
    _text1Opacity = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.50, curve: Curves.easeIn),
    );
    _text1Slide = slideTween.animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOut),
      ),
    );

    // 'Assignment' enters with a staggered delay
    _text2Opacity = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.38, 0.88, curve: Curves.easeIn),
    );
    _text2Slide = slideTween.animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.38, 0.88, curve: Curves.easeOut),
      ),
    );

    _particles = generateConfettiParticles(40);
    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(AppConstants.splashInitialDelay);
    if (!mounted) return;
    unawaited(_walletController.forward());

    // Wait for the icon to finish its bounce before confetti fires
    await Future.delayed(AppConstants.confettiDuration);
    if (!mounted) return;
    unawaited(_confettiController.forward());

    await Future.delayed(AppConstants.splashTextDelay);
    if (!mounted) return;
    unawaited(_textController.forward());

    // Navigate once the last confetti flake fades at the icon bottom (~t=75 of animation)
    await Future.delayed(AppConstants.textStageDuration);
    if (!mounted) return;
    _navigateToIntro();
  }

  void _navigateToIntro() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: AppConstants.pageTransitionDuration,
        pageBuilder: (ctx, anim, secAnim) => const WalletIntroPage(),
        transitionsBuilder: (ctx, anim, secAnim, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _walletController.dispose();
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Dotted gradient background — matches intro screen aesthetic
          const Positioned.fill(
            child: CustomPaint(painter: DotBackgroundPainter()),
          ),
          // Confetti pops from icon level on both sides, arcs upward
          AnimatedBuilder(
            animation: _confettiController,
            builder: (_, child) => CustomPaint(
              painter: ConfettiPainter(
                particles: _particles,
                progress: _confettiController.value,
              ),
              size: Size(screenWidth, screenHeight),
            ),
          ),
          // Wallet icon + staggered texts — all wrapped in Hero for page transition
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _walletController,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(0, screenHeight * _walletY.value),
                    child: Transform.rotate(
                      angle: _walletRotation.value,
                      child: const Hero(
                        tag: AppConstants.heroTagWalletIcon,
                        child: WalletIconWidget(size: 130),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 'FlickTV' — Hero so it transitions to the intro header
                SlideTransition(
                  position: _text1Slide,
                  child: FadeTransition(
                    opacity: _text1Opacity,
                    child: const Hero(
                      tag: AppConstants.heroTagFlickTV,
                      child: Text(
                        AppConstants.blinkitText,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppConstants.splashText1Size,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                // 'Assignment' — Hero so it transitions to the intro header
                SlideTransition(
                  position: _text2Slide,
                  child: FadeTransition(
                    opacity: _text2Opacity,
                    child: const Hero(
                      tag: AppConstants.heroTagAssignment,
                      child: Text(
                        AppConstants.moneyText,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppConstants.splashText2Size,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
