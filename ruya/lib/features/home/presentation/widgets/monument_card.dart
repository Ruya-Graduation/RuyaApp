import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';
import 'package:ruya/features/home/presentation/widgets/monument_image.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// Displays a single monument as a card with an image, name, location,
/// and a crowd-level badge.
///
/// Accepts a [MonumentEntity] (domain layer) — NOT a data model —
/// keeping the presentation layer independent of the data layer.
///
/// Image rendering is delegated to [MonumentImage], which handles the
/// remote-URL / local-asset fallback logic.
class MonumentCard extends StatelessWidget {
  final MonumentEntity monument;

  const MonumentCard({super.key, required this.monument});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/site-details/${monument.id}');
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
            _MonumentImageSection(imageUrl: monument.imageUrl),
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

class _MonumentImageSection extends StatelessWidget {
  final String? imageUrl;
  const _MonumentImageSection({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: MonumentImage(imageUrl: imageUrl, height: 180),
        ),
        PositionedDirectional(
          top: 12,
          end: 12,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              color: AppColors.getBrandPrimary(context),
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
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.getMutedText(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        monument.location,
                        style: TextStyle(
                          color: AppColors.getMutedText(context),
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
    final displayLabel = _localizedCrowd(context, level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayLabel,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _localizedCrowd(BuildContext context, String rawLevel) {
    final l10n = AppLocalizations.of(context)!;
    final lower = rawLevel.toLowerCase();
    if (lower.contains('low') || lower.contains('قليل') || lower.contains('منخفض')) {
      return l10n.crowdLow;
    } else if (lower.contains('moderate') || lower.contains('medium') || lower.contains('متوسط')) {
      return l10n.crowdModerate;
    } else if (lower.contains('high') || lower.contains('عالي') || lower.contains('شديد') || lower.contains('كبير')) {
      return l10n.crowdHigh;
    }
    return rawLevel.isNotEmpty ? rawLevel : l10n.crowdLow;
  }

  Color _crowdColor(String level) {
    final lower = level.toLowerCase();
    if (lower.contains('low') || lower.contains('قليل') || lower.contains('منخفض')) return Colors.teal;
    if (lower.contains('moderate') || lower.contains('medium') || lower.contains('متوسط')) return Colors.orange;
    return Colors.red;
  }
}
