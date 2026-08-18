import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/l10n/app_localizations.dart';

class SiteBottomSheet extends StatelessWidget {
  final SiteDetailEntity site;

  const SiteBottomSheet({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              context.push('/ticket-selection', extra: site);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A373),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.bookEntryTicket,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
