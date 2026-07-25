import 'dart:ui';

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
