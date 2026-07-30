import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';

class AppAlertBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isError;

  const AppAlertBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isError
        ? AppColors.getErrorContainer(context)
        : AppColors.getSuccessContainer(context);
    final fgColor = isError
        ? AppColors.getOnErrorContainer(context)
        : AppColors.getOnSuccessContainer(context);
    final borderColor = isError ? AppColors.errorRed : AppColors.successGreen;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error : Icons.check_circle,
            color: fgColor,
            size: 24,
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: fgColor,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSpacing.fontSizeSm,
                  ),
                ),
                if (subtitle != null) ...[
                  AppSpacing.verticalGapXxs,
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: fgColor.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
