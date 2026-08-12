import 'package:flutter/material.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ConfirmationTicketCard extends StatelessWidget {
  const ConfirmationTicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Green Checkmark where the QR code used to be
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Color(0xFF1ABC9C),
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.scanAtGate,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Details
          _buildDetailRow(l10n.refNum, 'RY-2026-KT-8847'),
          _buildDetailRow(l10n.site, 'Karnak Temple Complex'),
          _buildDetailRow(l10n.date, 'January 18, 2026'),
          _buildDetailRow(l10n.timeSlot, '08:00 AM Entry'),
          _buildDetailRow(l10n.tickets, '2 Adult, 1 Student'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
