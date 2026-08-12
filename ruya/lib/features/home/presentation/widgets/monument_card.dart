import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';

/// Displays a single monument as a card with an image, name, location,
/// and a crowd-level badge.
///
/// Accepts a [MonumentEntity] (domain layer) — NOT a data model —
/// keeping the presentation layer independent of the data layer.
class MonumentCard extends StatelessWidget {
  final MonumentEntity monument;

  const MonumentCard({super.key, required this.monument});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/site-details');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MonumentImage(imagePath: monument.imagePath),
            _MonumentDetails(monument: monument),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets — not exported; live here for locality of behaviour.
// ---------------------------------------------------------------------------

class _MonumentImage extends StatelessWidget {
  final String imagePath;
  const _MonumentImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.asset(
            imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border,
              color: AppColors.brandPrimaryLight,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _MonumentDetails extends StatelessWidget {
  final MonumentEntity monument;
  const _MonumentDetails({required this.monument});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monument.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        monument.location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _CrowdBadge(level: monument.crowdsLevel),
        ],
      ),
    );
  }
}

class _CrowdBadge extends StatelessWidget {
  final String level;
  const _CrowdBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = _crowdColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _crowdColor(String level) {
    final lower = level.toLowerCase();
    if (lower.contains('low')) return Colors.teal;
    if (lower.contains('moderate')) return Colors.orange;
    return Colors.red;
  }
}
