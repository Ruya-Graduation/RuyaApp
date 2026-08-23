import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/theme/app_text_styles.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MomentsHeader extends StatelessWidget {
  final int totalTrips;

  const MomentsHeader({
    super.key,
    required this.totalTrips,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding(context),
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourJourneyArchive.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: AppColors.getBrandPrimary(context),
            ),
          ),
          AppSpacing.verticalGapXs,
          Text(
            l10n.memoryVault,
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          AppSpacing.verticalGapXs,
          Text(
            l10n.tripsCount(totalTrips),
            style: AppTextStyles.body(context).copyWith(
              fontSize: AppSpacing.fontSizeSm,
              color: AppColors.getMutedText(context),
            ),
          ),
        ],
      ),
    );
  }
}
