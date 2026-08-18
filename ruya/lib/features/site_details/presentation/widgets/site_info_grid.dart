import 'package:flutter/material.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/l10n/app_localizations.dart';

class SiteInfoGrid extends StatelessWidget {
  final SiteDetailEntity site;

  const SiteInfoGrid({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SiteInfoCard(
          icon: Icons.access_time,
          title: l10n.hours,
          value: site.hours.isNotEmpty ? site.hours : '—',
        ),
        _SiteInfoCard(
          icon: Icons.confirmation_number_outlined,
          title: l10n.adult,
          value: site.ticketRaw.isNotEmpty ? site.ticketRaw : '—',
        ),
        _SiteInfoCard(
          icon: Icons.location_on_outlined,
          title: l10n.location,
          value: l10n.viewMap,
        ),
        _SiteInfoCard(
          icon: Icons.people_outline,
          title: l10n.crowds,
          value: site.crowds.isNotEmpty ? site.crowds : '—',
        ),
      ],
    );
  }
}

class _SiteInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SiteInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFD4A373), size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
