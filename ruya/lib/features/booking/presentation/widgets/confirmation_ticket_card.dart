import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ConfirmationTicketCard extends StatelessWidget {
  final BookingEntity booking;

  const ConfirmationTicketCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final formattedDate =
        DateFormat('MMMM d, yyyy').format(booking.visitDate);
    final ticketText =
        '${booking.ticketCount} ${booking.ticketCount == 1 ? "ticket" : "tickets"}';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Green Checkmark icon badge
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Color(0xFF1ABC9C),
                size: 70,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.scanAtGate,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 28),

          // Dynamic Booking Details
          _buildDetailRow(l10n.refNum, booking.referenceNumber),
          _buildDetailRow(l10n.site, booking.siteName),
          _buildDetailRow(l10n.date, formattedDate),
          _buildDetailRow(l10n.timeSlot, booking.timeSlot),
          _buildDetailRow(l10n.tickets, ticketText),
          _buildDetailRow(
            l10n.total,
            '${booking.currency} ${booking.totalPrice.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
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
