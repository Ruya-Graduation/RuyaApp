import 'package:flutter/material.dart';
import 'package:ruya/core/utils/app_spacing.dart';

/// A styled search bar displayed at the top of the Home page.
class HomeSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.xl),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ),
    );
  }
}
