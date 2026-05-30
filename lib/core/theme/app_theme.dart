import 'package:flutter/material.dart';
import 'package:ram/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.mainBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.addMoneyGreen,
          secondary: AppColors.walletGoldLight,
          surface: AppColors.cardBackground,
        ),
        useMaterial3: true,
      );
}
