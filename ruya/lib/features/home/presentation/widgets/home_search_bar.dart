import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(AppSpacing.xl),
          border: Border.all(
            color: AppColors.getDivider(context),
          ),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.getMutedText(context),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.getMutedText(context),
            ),
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
