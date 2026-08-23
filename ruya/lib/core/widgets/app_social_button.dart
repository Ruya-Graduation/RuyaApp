import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';

class AppSocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const AppSocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSpacing.xxl),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.getDivider(context)),
          borderRadius: BorderRadius.circular(AppSpacing.xxl),
        ),
        child: icon,
      ),
    );
  }
}
