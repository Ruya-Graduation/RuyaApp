import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ConfirmationTicketCard extends StatelessWidget {
  final BookingEntity booking;

  const ConfirmationTicketCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final formattedDate =
        DateFormat('MMMM d, yyyy').format(booking.visitDate);
    final ticketText =
        '${booking.ticketCount} ${booking.ticketCount == 1 ? "ticket" : "tickets"}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.getDivider(context),
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
              color: AppColors.getSuccessContainer(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                Icons.check_circle_outline,
                color: AppColors.getOnSuccessContainer(context),
                size: 70,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.scanAtGate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.getMutedText(context),
            ),
          ),
          const SizedBox(height: 28),

          // Dynamic Booking Details
          _buildDetailRow(context, l10n.refNum, booking.referenceNumber),
          _buildDetailRow(context, l10n.site, booking.siteName),
          _buildDetailRow(context, l10n.date, formattedDate),
          _buildDetailRow(context, l10n.timeSlot, booking.timeSlot),
          _buildDetailRow(context, l10n.tickets, ticketText),
          _buildDetailRow(
            context,
            l10n.total,
            '${booking.currency} ${booking.totalPrice.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.getMutedText(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
