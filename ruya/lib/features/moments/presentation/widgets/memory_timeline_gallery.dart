import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MemoryTimelineGallery extends StatelessWidget {
  final List<MomentPhoto> photos;
  final void Function(MomentPhoto photo)? onDeletePhoto;

  const MemoryTimelineGallery({
    super.key,
    required this.photos,
    this.onDeletePhoto,
  });

  Future<void> _confirmAndDelete(
    BuildContext context,
    MomentPhoto photo,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deletePhotoConfirmTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          l10n.deletePhotoConfirmBody,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      onDeletePhoto?.call(photo);
    }
  }

  Widget _buildPhotoTile(BuildContext context, MomentPhoto photo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget imageWidget;
    if (photo.isAsset) {
      imageWidget = Image.asset(
        photo.imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade400,
          child: const Icon(Icons.image, color: Colors.white70),
        ),
      );
    } else {
      final file = File(photo.imagePath);
      imageWidget = file.existsSync()
          ? Image.file(
              file,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          : Container(
              color: Colors.grey.shade400,
              child: const Icon(Icons.broken_image, color: Colors.white70),
            );
    }

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE8DCCF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Image
              Expanded(child: imageWidget),
              // Caption and Day label
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (photo.caption != null && photo.caption!.isNotEmpty)
                      Text(
                        photo.caption!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : const Color(0xFFD4A373),
                        ),
                      ),
                    if (photo.dayLabel != null && photo.dayLabel!.isNotEmpty)
                      Text(
                        photo.dayLabel!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (onDeletePhoto != null)
            Positioned(
              top: 6,
              right: 6,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: Colors.white,
                  ),
                  onPressed: () => _confirmAndDelete(context, photo),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding(context),
          ),
          child: Text(
            l10n.routeTimeline,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppColors.getBrandPrimary(context),
            ),
          ),
        ),
        AppSpacing.verticalGapSm,
        // Horizontal scroll list of photos
        SizedBox(
          height: 180,
          child: photos.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding(context),
                  ),
                  child: Center(
                    child: Text(
                      l10n.noPhotosAddedYet,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding(context),
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return _buildPhotoTile(context, photos[index]);
                  },
                ),
        ),
      ],
    );
  }
}
