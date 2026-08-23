import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/booking/presentation/widgets/booking_calendar_widget.dart';
import 'package:ruya/features/booking/presentation/widgets/ticket_counter.dart';
import 'package:ruya/features/booking/presentation/widgets/ticket_selection_bottom_sheet.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/l10n/app_localizations.dart';

class TicketSelectionScreen extends StatefulWidget {
  final SiteDetailEntity site;

  const TicketSelectionScreen({super.key, required this.site});

  @override
  State<TicketSelectionScreen> createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen> {
  DateTime? selectedDate;
  int ticketCount = 1;

  double get totalPrice => ticketCount * widget.site.ticketPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.reserveEntry,
          style: TextStyle(
            color: AppColors.getBrandPrimary(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.site.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 24),

            // Interactive Calendar
            BookingCalendarWidget(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),

            if (selectedDate == null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  l10n.selectVisitDateHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Single Ticket Counter
            TicketCounter(
              title: l10n.numberOfTickets,
              price:
                  '${widget.site.ticketCurrency} ${widget.site.ticketPrice.toStringAsFixed(0)}',
              count: ticketCount,
              onChanged: (val) {
                if (val >= 1) {
                  setState(() => ticketCount = val);
                }
              },
            ),

            const SizedBox(height: 100), // Space for bottom sheet
          ],
        ),
      ),
      bottomSheet: TicketSelectionBottomSheet(
        site: widget.site,
        selectedDate: selectedDate,
        ticketCount: ticketCount,
        totalPrice: totalPrice,
      ),
    );
  }
}
