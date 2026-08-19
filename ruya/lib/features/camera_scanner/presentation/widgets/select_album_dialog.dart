import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_cubit.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_state.dart';
import 'package:ruya/l10n/app_localizations.dart';

class SelectAlbumDialog extends StatelessWidget {
  final File photoFile;

  const SelectAlbumDialog({
    super.key,
    required this.photoFile,
  });

  Future<void> _confirmAndAddToAlbum(
    BuildContext context,
    MomentItem album,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.confirmAddToAlbumTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          l10n.confirmAddToAlbumBody(album.title),
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
              backgroundColor: AppColors.getBrandPrimary(context),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final newPhoto = MomentPhoto(
        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
        imagePath: photoFile.path,
        isAsset: false,
        caption: 'Scanned Artifact',
        dayLabel: 'DAY 1',
      );

      final success =
          await context.read<MomentsCubit>().addPhotoToAlbum(album.id, newPhoto);

      if (context.mounted) {
        if (success) {
          AppSnackBar.showSuccess(context, l10n.photoAddedSuccess);
          Navigator.pop(context); // Close sheet
          context.go('/memories'); // Navigate to memories
        } else {
          AppSnackBar.showError(context, 'Failed to add photo to album');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MomentsCubit, MomentsState>(
      builder: (context, state) {
        final albums = state.moments;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                l10n.selectAlbum,
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              AppSpacing.verticalGapXxs,
              Text(
                l10n.selectAlbumToAddTo,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              AppSpacing.verticalGapMd,

              // List of Albums
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: albums.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final album = albums[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: album.isCoverAsset
                              ? Image.asset(
                                  album.coverImagePath,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(album.coverImagePath),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      title: Text(
                        album.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        album.monthYear,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.getBrandPrimary(context),
                      ),
                      onTap: () => _confirmAndAddToAlbum(context, album),
                    );
                  },
                ),
              ),
              AppSpacing.verticalGapMd,

              // Or Create New Album Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                    context.push('/moments/add', extra: photoFile);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.createNewAlbum),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.getBrandPrimary(context),
                    side: BorderSide(
                      color: AppColors.getBrandPrimary(context),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalGapSm,
            ],
          ),
        );
      },
    );
  }
}
