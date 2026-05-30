class AppConstants {
  // App labels
  static const String blinkitText = 'FlickTV';
  static const String moneyText = 'Assignment';
  static const String addMoneyText = 'Add Money';
  static const String claimGiftCardTitle = 'Claim Gift Card';
  static const String claimGiftCardSub =
      'Enter gift card details to claim your gift card';
  static const String replayText = '↺  Watch animation again';
  static const String enjoyText = 'Enjoy seamless';
  static const String enjoySubText = 'one tap payments';

  // Hero animation tags
  static const String heroTagWalletIcon = 'wallet-icon';
  static const String heroTagFlickTV = 'text-flicktv';
  static const String heroTagAssignment = 'text-assignment';

  // Feature icon type keys (must match WalletData.features iconType values)
  static const String walletTapText = 'tap';
  static const String walletWifiText = 'wifi';
  static const String walletRefundText = 'refund';

  // Splash screen animation timing
  static const Duration splashInitialDelay = Duration(milliseconds: 200);
  static const Duration walletFallDuration = Duration(milliseconds: 1200);
  static const Duration confettiDuration = Duration(milliseconds: 1600);
  static const Duration splashTextDelay = Duration(milliseconds: 250);
  static const Duration textStageDuration = Duration(milliseconds: 1200);
  static const Duration pageTransitionDuration = Duration(milliseconds: 700);

  // Wallet intro screen animation timing
  static const Duration introStaggerDuration = Duration(milliseconds: 1500);

  // Hero transition font sizes — shared between splash and intro header
  static const double splashText1Size = 22.0;
  static const double splashText2Size = 48.0;
  static const double introText1Size = 18.0;
  static const double introText2Size = 44.0;

  // Collapsed header font sizes
  static const double collapsedText1Size = 11.0;
  static const double collapsedText2Size = 17.0;
}
