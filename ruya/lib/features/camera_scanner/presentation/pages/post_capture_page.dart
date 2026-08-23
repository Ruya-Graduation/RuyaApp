import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/camera_scanner/presentation/widgets/select_album_dialog.dart';
import 'package:ruya/l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_cubit.dart';

class PostCapturePage extends StatelessWidget {
  final File photoFile;

  const PostCapturePage({
    super.key,
    required this.photoFile,
  });

  void _onAddToMemories(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: getIt<MomentsCubit>(),
        child: SelectAlbumDialog(photoFile: photoFile),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? AppColors.getBrandPrimary(context)
              : AppColors.getDivider(context),
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? AppColors.getBrandPrimary(context).withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? AppColors.getBrandPrimary(context)
                        : (isDark ? Colors.white10 : AppColors.getBackground(context)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isPrimary
                        ? Colors.white
                        : AppColors.getBrandPrimary(context),
                  ),
                ),
                AppSpacing.horizontalGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      AppSpacing.verticalGapXxs,
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.getMutedText(context),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isRtl ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.getMutedText(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.postCaptureTitle,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding(context),
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Captured Image Preview Box
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(
                  photoFile,
                  fit: BoxFit.cover,
                ),
              ),
              AppSpacing.verticalGapLg,

              // Subtitle
              Text(
                l10n.postCaptureSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              AppSpacing.verticalGapLg,

              // Option 1: Ask AI in Chat
              _buildOptionCard(
                context,
                icon: Icons.chat_bubble_outline_rounded,
                title: l10n.addToChatOption,
                subtitle: l10n.addToChatOptionDesc,
                onTap: () {
                  // Navigate to AI Chat with photo
                  context.push('/ai-chat', extra: {'imageFile': photoFile});
                },
                isPrimary: true,
              ),
              AppSpacing.verticalGapMd,

              // Option 2: Add to Memories
              _buildOptionCard(
                context,
                icon: Icons.auto_stories_outlined,
                title: l10n.addToMemoriesOption,
                subtitle: l10n.addToMemoriesOptionDesc,
                onTap: () => _onAddToMemories(context),
                isPrimary: false,
              ),
              AppSpacing.verticalGapXl,
            ],
          ),
        ),
      ),
    );
  }
}
