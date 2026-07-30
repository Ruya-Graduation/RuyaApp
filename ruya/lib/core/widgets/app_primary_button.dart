import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final brandColor = AppColors.getBrandPrimary(context);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: brandColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
        ),
        child: _buildChild(context, brandColor),
      );
    }

    return FilledButton(
      onPressed: isDisabled ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: brandColor,
        disabledBackgroundColor: brandColor.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
      child: _buildChild(context, Colors.white),
    );
  }

  Widget _buildChild(BuildContext context, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppSpacing.fontSizeMd,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
