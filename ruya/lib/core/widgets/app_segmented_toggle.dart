import 'package:flutter/material.dart';
import 'package:ruya/core/utils/app_spacing.dart';

/// Controls the visual style of [AppSegmentedToggle].
enum ToggleVariant {
  /// Amber golden selected pill on a semi-transparent dark background.
  /// Use on top of images/hero headers (e.g. EN/AR locale switcher).
  overlay,

  /// White selected pill on a light/neutral pill background.
  /// Use on the scaffold surface (e.g. Sign In / Create Account tabs).
  surface,
}

class AppSegmentedToggle<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final ToggleVariant variant;

  const AppSegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
    this.variant = ToggleVariant.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Resolve colors by variant ──────────────────────────────────────────
    final Color pillBg;
    final Color selectedBg;
    final Color selectedFg;
    final Color unselectedFg;
    final double fontSize;
    final EdgeInsets itemPadding;

    switch (variant) {
      case ToggleVariant.overlay:
        // Glass pill on hero image → amber selected, white text
        pillBg = const Color(0x66000000);
        selectedBg = const Color(0xFFD0A37A); // brand amber
        selectedFg = Colors.white;
        unselectedFg = const Color(0xCCFFFFFF);
        fontSize = 13;
        itemPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 5);

      case ToggleVariant.surface:
        // Light pill on scaffold → white selected pill, dark text
        pillBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEFEBE6);
        selectedBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;
        selectedFg = isDark ? Colors.white : Colors.black87;
        unselectedFg = isDark ? Colors.white54 : Colors.black45;
        fontSize = 14;
        itemPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
    }

    return Container(
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.xxl),
        boxShadow: variant == ToggleVariant.surface
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selected;
          return GestureDetector(
            onTap: () => onChanged(option),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: itemPadding,
              decoration: BoxDecoration(
                color: isSelected ? selectedBg : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.xxl),
                boxShadow: isSelected && variant == ToggleVariant.surface
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        )
                      ]
                    : [],
              ),
              child: Text(
                labelBuilder(option),
                style: TextStyle(
                  color: isSelected ? selectedFg : unselectedFg,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
