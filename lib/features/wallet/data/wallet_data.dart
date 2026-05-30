import 'package:ram/core/constants/app_constants.dart';
import 'package:ram/features/wallet/domain/entities/feature_item.dart';

class WalletData {
  static const List<FeatureItem> features = [
    FeatureItem(
      title: 'Single tap payments',
      description: 'Enjoy seamless payments without the wait for OTPs',
      iconType: AppConstants.walletTapText,
    ),
    FeatureItem(
      title: 'Zero failures',
      description: 'Zero payment failures ensure you never miss an order',
      iconType: AppConstants.walletWifiText,
    ),
    FeatureItem(
      title: 'Real-time refunds',
      description:
          'No need to wait for refunds. Blinkit Money refunds are instant!',
      iconType: AppConstants.walletRefundText,
    ),
  ];
}
