import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/l10n/app_localizations.dart';

class TicketSelectionBottomSheet extends StatelessWidget {
  final int totalTickets;
  final int totalPrice;

  const TicketSelectionBottomSheet({
    super.key,
    required this.totalTickets,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.total} ($totalTickets ${l10n.tickets})',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  'EGP $totalPrice',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'PlayfairDisplay'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/booking-confirmation');
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
                  l10n.confirmProcessTicket,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
