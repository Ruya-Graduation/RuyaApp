import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';

class MemoryHeroHeader extends StatelessWidget {
  final MomentItem moment;

  const MemoryHeroHeader({
    super.key,
    required this.moment,
  });

  Widget _buildImage() {
    if (moment.isCoverAsset) {
      return Image.asset(
        moment.coverImagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade800,
          child: const Icon(Icons.image, size: 64, color: Colors.white54),
        ),
      );
    } else {
      final file = File(moment.coverImagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
      return Container(
        color: Colors.grey.shade800,
        child: const Icon(Icons.broken_image, size: 64, color: Colors.white54),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final headerHeight = screenHeight * 0.46;

    return Stack(
      children: [
        // Cover Photo Hero Background
        SizedBox(
          height: headerHeight,
          width: double.infinity,
          child: _buildImage(),
        ),
        // Dark Gradient for contrast
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        // Bottom Title & Pill Badge
        Positioned(
          left: AppSpacing.pagePadding(context),
          right: AppSpacing.pagePadding(context),
          bottom: AppSpacing.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Keepsake pill badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A373).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFD4A373).withValues(alpha: 0.8),
                    width: 1,
                  ),
                ),
                child: Text(
                  'AI KEEPSAKE · ${moment.title.toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFFFAF6F0),
                  ),
                ),
              ),
              AppSpacing.verticalGapSm,
              // Title — Month Year
              Text(
                '${moment.title} — ${moment.monthYear}',
                style: const TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
