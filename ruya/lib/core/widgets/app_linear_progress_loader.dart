import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';

class AppLinearProgressLoader extends StatelessWidget {
  final String caption;

  const AppLinearProgressLoader({super.key, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            backgroundColor: AppColors.getBrandPrimary(context).withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.successGreen),
            minHeight: 4,
          ),
        ),
        AppSpacing.verticalGapSm,
        Text(
          caption,
          style: TextStyle(
            color: AppColors.getMutedText(context),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
