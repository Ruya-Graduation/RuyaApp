import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ImagePickerBox extends StatelessWidget {
  final File? selectedImage;
  final String? existingImagePath;
  final bool existingIsAsset;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;

  const ImagePickerBox({
    super.key,
    required this.selectedImage,
    this.existingImagePath,
    this.existingIsAsset = false,
    required this.onTap,
    this.onClear,
    this.errorText,
  });

  Widget _buildExistingImage() {
    if (existingImagePath == null || existingImagePath!.isEmpty) {
      return const SizedBox.shrink();
    }
    if (existingIsAsset) {
      return Image.asset(existingImagePath!, fit: BoxFit.cover);
    }
    return Image.file(File(existingImagePath!), fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText != null
                    ? AppColors.errorRed
                    : (isDark ? Colors.white12 : const Color(0xFFE2D6C5)),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: selectedImage != null || existingImagePath != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      selectedImage != null
                          ? Image.file(selectedImage!, fit: BoxFit.cover)
                          : _buildExistingImage(),
                      if (onClear != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.6,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: onClear,
                            ),
                          ),
                        ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.getBrandPrimary(
                            context,
                          ).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 32,
                          color: AppColors.getBrandPrimary(context),
                        ),
                      ),
                      AppSpacing.verticalGapSm,
                      Text(
                        l10n.tapToSelectCover,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (errorText != null) ...[
          AppSpacing.verticalGapXxs,
          Text(
            errorText!,
            style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
