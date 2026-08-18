import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/features/booking/domain/usecases/create_local_booking_usecase.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/l10n/app_localizations.dart';

class TicketSelectionBottomSheet extends StatelessWidget {
  final SiteDetailEntity site;
  final DateTime? selectedDate;
  final int ticketCount;
  final double totalPrice;

  const TicketSelectionBottomSheet({
    super.key,
    required this.site,
    required this.selectedDate,
    required this.ticketCount,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isButtonEnabled = selectedDate != null && ticketCount > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.total} ($ticketCount ${l10n.tickets})',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  '${site.ticketCurrency} ${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        final booking = getIt<CreateLocalBookingUseCase>()(
                          site: site,
                          visitDate: selectedDate!,
                          timeSlot: '08:00 AM Entry',
                          ticketCount: ticketCount,
                        );
                        context.push('/booking-confirmation', extra: booking);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A373),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      isDark ? Colors.grey[800] : Colors.grey[300],
                  disabledForegroundColor:
                      isDark ? Colors.grey[600] : Colors.grey[500],
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
