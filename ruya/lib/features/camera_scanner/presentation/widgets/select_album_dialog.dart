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

class SelectAlbumDialog extends StatefulWidget {
  final File photoFile;

  const SelectAlbumDialog({super.key, required this.photoFile});

  @override
  State<SelectAlbumDialog> createState() => _SelectAlbumDialogState();
}

class _SelectAlbumDialogState extends State<SelectAlbumDialog> {
  bool _isUploading = false;

  Future<void> _confirmAndAddToAlbum(MomentItem album) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.confirmAddToAlbumTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.confirmAddToAlbumBody(album.title),
          style: TextStyle(color: AppColors.getMutedText(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.getMutedText(context)),
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

    if (confirmed == true && mounted) {
      final cubit = context.read<MomentsCubit>();
      setState(() => _isUploading = true);

      final success = await cubit.addPhotoToAlbum(
        album.id,
        photo: widget.photoFile,
        caption: 'Scanned Artifact',
        dayLabel: 'DAY 1',
      );

      if (!mounted) return;
      setState(() => _isUploading = false);

      if (success) {
        AppSnackBar.showSuccess(context, l10n.photoAddedSuccess);
        Navigator.pop(context); // Close sheet
        context.go('/memories'); // Navigate to memories
      } else {
        AppSnackBar.showError(context, 'Failed to add photo to album');
      }
    }
  }

  Widget _buildAlbumThumbnail(BuildContext context, String? url) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade900,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.getBrandPrimary(context),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade800,
          child: const Icon(Icons.image, size: 24, color: Colors.white54),
        ),
      );
    }
    return Container(
      color: Colors.grey.shade800,
      child: const Icon(Icons.image, size: 24, color: Colors.white54),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MomentsCubit, MomentsState>(
      builder: (context, state) {
        final albums = state.moments;

        return Stack(
          children: [
            AbsorbPointer(
              absorbing: _isUploading,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
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
                          color: AppColors.getDivider(context),
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
                        color: AppColors.getMutedText(context),
                      ),
                    ),
                    AppSpacing.verticalGapMd,

                    // List of Albums
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: albums.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  l10n.noPhotosAddedYet,
                                  style: TextStyle(
                                    color: AppColors.getMutedText(context),
                                  ),
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: albums.length,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1, color: AppColors.getDivider(context)),
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
                                      child: _buildAlbumThumbnail(
                                        context,
                                        album.coverImageUrl,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    album.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    album.startDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.getMutedText(context),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.getBrandPrimary(context),
                                  ),
                                  onTap: () => _confirmAndAddToAlbum(album),
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
                          context.push('/moments/add', extra: widget.photoFile);
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
              ),
            ),
            if (_isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.getBrandPrimary(context),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Uploading photo...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
