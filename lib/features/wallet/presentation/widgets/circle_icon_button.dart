import 'package:flutter/material.dart';
import 'package:ram/core/theme/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.circleButtonBackground,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}
