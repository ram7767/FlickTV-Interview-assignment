import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ram/core/theme/app_colors.dart';
import 'package:ram/core/theme/app_theme.dart';
import 'package:ram/features/splash/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FlickTvAssignmentApp());
}

class FlickTvAssignmentApp extends StatelessWidget {
  const FlickTvAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ram',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashPage(),
    );
  }
}
