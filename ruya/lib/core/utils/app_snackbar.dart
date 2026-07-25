// lib/core/utils/app_snackbar.dart

import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';

abstract class AppSnackBar {
  /// Base snackbar builder bound strictly to app spacing, decorations, and color tokens
  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          margin: const EdgeInsets.all(AppSpacing.md),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          content: Row(
            children: [
              Icon(icon, color: foregroundColor, size: AppSpacing.iconSm),
              AppSpacing.horizontalGapSm,
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: AppSpacing.fontSizeSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  /// Displays an error alert using `AppColors` error tokens
  static void showError(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _show(
      context,
      message: message,
      icon: Icons.error_outline_rounded,
      backgroundColor: isDark
          ? AppColors.errorContainerDark
          : AppColors.errorRed,
      foregroundColor: isDark
          ? AppColors.onErrorContainerDark
          : AppColors.lightSurface,
    );
  }

  /// Displays a success alert using `AppColors` success tokens
  static void showSuccess(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      backgroundColor: isDark
          ? AppColors.successContainerDark
          : AppColors.successGreen,
      foregroundColor: isDark
          ? AppColors.onSuccessContainerDark
          : AppColors.lightSurface,
    );
  }

  /// Displays an informational alert using `AppColors` info tokens

}
