import 'package:flutter/material.dart';

class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  // ===========================================================================
  // 1. MICRO SPACING (Fixed 8-Point Grid)
  // Best for small, precise layout gaps, button interiors, and form spacing.
  // ===========================================================================
  static const double xxs = 4.0;
  static const double xs  = 8.0;
  static const double sm  = 12.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;

  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;

  // Pre-built constant vertical gaps
  static const SizedBox verticalGapXxs = SizedBox(height: xxs);
  static const SizedBox verticalGapXs  = SizedBox(height: xs);
  static const SizedBox verticalGapSm  = SizedBox(height: sm);
  static const SizedBox verticalGapMd  = SizedBox(height: md);
  static const SizedBox verticalGapLg  = SizedBox(height: lg);
  static const SizedBox verticalGapXl  = SizedBox(height: xl);
  static const SizedBox verticalGapXxl = SizedBox(height: xxl);

  // Pre-built constant horizontal gaps
  static const SizedBox horizontalGapXxs = SizedBox(width: xxs);
  static const SizedBox horizontalGapXs  = SizedBox(width: xs);
  static const SizedBox horizontalGapSm  = SizedBox(width: sm);
  static const SizedBox horizontalGapMd  = SizedBox(width: md);
  static const SizedBox horizontalGapLg  = SizedBox(width: lg);
  static const SizedBox horizontalGapXl  = SizedBox(width: xl);

  // ===========================================================================
  // 2. ADAPTIVE MACRO SPACING (Responsive Page & Section Layouts)
  // Dynamically scales using percentage based on screen width + orientation.
  // ===========================================================================
  
  static double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;
  static bool isPortrait(BuildContext context) => MediaQuery.orientationOf(context) == Orientation.portrait;

  /// Main page horizontal margins. Keeps content centered with breathable edges.
  static double pagePadding(BuildContext context) {
    return isPortrait(context)
        ? (screenWidth(context) * 0.06).clamp(16.0, 36.0)
        : (screenWidth(context) * 0.12).clamp(32.0, 72.0);
  }

  /// Large gaps separating major sections (e.g., Header down to a Card grid/form).
  static double sectionGap(BuildContext context) {
    return isPortrait(context)
        ? (screenWidth(context) * 0.08).clamp(24.0, 48.0)
        : (screenWidth(context) * 0.04).clamp(12.0, 24.0);
  }

  /// Adaptive margins inside cards when you want cards to breath more on large screens.
  static double cardInnerPadding(BuildContext context) {
    return isPortrait(context)
        ? (screenWidth(context) * 0.045).clamp(12.0, 20.0)
        : (screenWidth(context) * 0.025).clamp(8.0, 16.0);
  }

  /// Adaptive spacing between dynamic list items (e.g., employee tile list).
  static double listItemGap(BuildContext context) {
    return isPortrait(context)
        ? (screenWidth(context) * 0.035).clamp(10.0, 16.0)
        : (screenWidth(context) * 0.02).clamp(8.0, 12.0);
  }

  // ===========================================================================
  // 3. MAX-WIDTH CONSTRAINTS (For Tablets, Foldables & Large Screens)
  // Ensures clean visual layouts without columns stretching excessively wide.
  // ===========================================================================
  
  /// Max width for small components like authentication forms.
  static const double maxAuthCardWidth = 420.0;

  /// Max width for standard mobile dashboard screens or general content tables.
  static const double maxContentWidth = 600.0;

  /// Max width for desktop/large tablet dashboard screens.
  static const double maxDesktopWidth = 1024.0;
}