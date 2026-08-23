import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/l10n/app_localizations.dart';

class HorizontalImageList extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAddPressed;
  final ValueChanged<int> onRemovePressed;

  const HorizontalImageList({
    super.key,
    required this.images,
    required this.onAddPressed,
    required this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.photosSectionTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: onAddPressed,
              icon: Icon(
                Icons.add_photo_alternate,
                size: 18,
                color: AppColors.getBrandPrimary(context),
              ),
              label: Text(
                l10n.addPhotosButton,
                style: TextStyle(
                  color: AppColors.getBrandPrimary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalGapXs,
        SizedBox(
          height: 110,
          child: images.isEmpty
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.getDivider(context),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: onAddPressed,
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.getBrandPrimary(context),
                            size: 20,
                          ),
                          AppSpacing.horizontalGapXs,
                          Text(
                            l10n.addPhotosButton,
                            style: TextStyle(
                              color: AppColors.getMutedText(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == images.length) {
                      // Add more card
                      return Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: AppColors.getSurface(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.getBrandPrimary(context),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: InkWell(
                          onTap: onAddPressed,
                          borderRadius: BorderRadius.circular(12),
                          child: Icon(
                            Icons.add,
                            size: 28,
                            color: AppColors.getBrandPrimary(context),
                          ),
                        ),
                      );
                    }

                    final file = images[index];
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            file,
                            fit: BoxFit.cover,
                          ),
                          PositionedDirectional(
                            top: 4,
                            end: 4,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black.withValues(alpha: 0.65),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                onPressed: () => onRemovePressed(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
