import 'package:flutter/material.dart';

class AppColors {
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color successContainerLight = Color(
    0xFFECFDF5,
  ); // Light green bg
  static const Color onSuccessContainerLight = Color(
    0xFF047857,
  ); // Dark green text/icon

  static const Color errorContainerLight = Color(0xFFFEF2F2); // Light red bg
  static const Color onErrorContainerLight = Color(
    0xFFB91C1C,
  ); // Dark red text/icon

  // --- DARK CONTAINER TOKENS ---
  static const Color successContainerDark = Color(0x2810B981);
  static const Color onSuccessContainerDark = Color(0xFF6EE7B7);

  static const Color errorContainerDark = Color(0x28EF4444);
  static const Color onErrorContainerDark = Color(0xFFFF8888);

  // --- BRAND & BACKGROUND TOKENS ---
  static const Color brandPrimaryLight = Color(0xFFD0A37A);
  static const Color brandPrimaryDark = Color(0xFFE2B488);

  static const Color backgroundCream = Color(0xFFFAF9F6);
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface color for cards/containers (one step above the page background).
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // --- DIVIDER & BORDER TOKENS ---
  static const Color dividerLight = Color(0xFFEEEEEE); // Matches Colors.grey[200]
  static const Color dividerDark = Color(0xFF424242); // Matches Colors.grey[800]

  // --- MUTED TEXT TOKENS ---
  static const Color mutedTextLight = Color(0xFF757575); // Matches Colors.grey[600]
  static const Color mutedTextDark = Color(0xFF9E9E9E); // Matches Colors.grey[400]

  static Color getBrandPrimary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? brandPrimaryDark : brandPrimaryLight;
  }

  static Color getBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? backgroundDark : backgroundCream;
  }

  /// Returns the card / container surface color (one step lighter than page bg).
  static Color getSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surfaceDark : surfaceLight;
  }

  /// Returns the divider / border color for card outlines and separators.
  static Color getDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dividerDark : dividerLight;
  }

  /// Returns the secondary / muted text color.
  static Color getMutedText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? mutedTextDark : mutedTextLight;
  }

  static Color getSuccessContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? successContainerDark : successContainerLight;
  }

  /// Returns the foreground icon/text color for Success (Approve)
  static Color getOnSuccessContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? onSuccessContainerDark : onSuccessContainerLight;
  }

  /// Returns the background container color for Error/Reject
  static Color getErrorContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? errorContainerDark : errorContainerLight;
  }

  /// Returns the foreground icon/text color for Error/Reject
  static Color getOnErrorContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? onErrorContainerDark : onErrorContainerLight;
  }
}
