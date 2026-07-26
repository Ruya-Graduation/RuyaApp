import 'package:flutter/material.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/theme/app_colors.dart';

class AppTextStyles {
  static TextStyle heroTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black87,
      height: 1.2,
    );
  }

  static TextStyle heroTagline(BuildContext context) {
    return TextStyle(
      fontSize: AppSpacing.fontSizeSm,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: AppColors.getBrandPrimary(context),
    );
  }

  static TextStyle heading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black87,
    );
  }

  static TextStyle body(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: AppSpacing.fontSizeMd,
      color: isDark ? Colors.white70 : Colors.black54,
    );
  }

  static TextStyle label(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: AppSpacing.fontSizeSm,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : Colors.black54,
    );
  }

  static TextStyle caption(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      color: isDark ? Colors.white60 : Colors.black45,
    );
  }
}
