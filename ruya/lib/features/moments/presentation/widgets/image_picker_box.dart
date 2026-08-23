import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ImagePickerBox extends StatelessWidget {
  final File? selectedImage;
  final String? existingImageUrl;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;

  const ImagePickerBox({
    super.key,
    required this.selectedImage,
    this.existingImageUrl,
    required this.onTap,
    this.onClear,
    this.errorText,
  });

  Widget _buildExistingImage(BuildContext context) {
    if (existingImageUrl == null || existingImageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Image.network(
      existingImageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.getBrandPrimary(context),
            strokeWidth: 2,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade800,
        child: const Icon(Icons.broken_image, size: 40, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final hasImage = selectedImage != null ||
        (existingImageUrl != null && existingImageUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: errorText != null
                    ? AppColors.errorRed
                    : AppColors.getDivider(context),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      selectedImage != null
                          ? Image.file(selectedImage!, fit: BoxFit.cover)
                          : _buildExistingImage(context),
                      if (onClear != null)
                        PositionedDirectional(
                          top: 8,
                          end: 8,
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
                          color: AppColors.getMutedText(context),
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
