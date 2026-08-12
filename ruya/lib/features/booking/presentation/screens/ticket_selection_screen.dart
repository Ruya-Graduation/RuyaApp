import 'package:flutter/material.dart';
import 'package:ruya/features/booking/presentation/widgets/calendar_mock_widget.dart';
import 'package:ruya/features/booking/presentation/widgets/ticket_counter.dart';
import 'package:ruya/features/booking/presentation/widgets/ticket_selection_bottom_sheet.dart';
import 'package:ruya/l10n/app_localizations.dart';

class TicketSelectionScreen extends StatefulWidget {
  const TicketSelectionScreen({super.key});

  @override
  State<TicketSelectionScreen> createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen> {
  int adultTickets = 2;
  int studentTickets = 1;
  int foreignerTickets = 0;
  int localTickets = 0;

  final int adultPrice = 450;
  final int studentPrice = 150;
  final int foreignerPrice = 600;
  final int localPrice = 80;

  int get totalTickets => adultTickets + studentTickets + foreignerTickets + localTickets;
  int get totalPrice => (adultTickets * adultPrice) +
      (studentTickets * studentPrice) +
      (foreignerTickets * foreignerPrice) +
      (localTickets * localPrice);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.reserveEntry,
          style: const TextStyle(color: Color(0xFFD4A373), fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Karnak Temple',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 24),
            
            const CalendarMockWidget(),
            
            const SizedBox(height: 24),

            // Ticket Counters
            TicketCounter(
              title: l10n.adult,
              price: 'EGP $adultPrice',
              count: adultTickets,
              onChanged: (val) => setState(() => adultTickets = val),
            ),
            const SizedBox(height: 12),
            TicketCounter(
              title: l10n.student,
              price: 'EGP $studentPrice',
              count: studentTickets,
              onChanged: (val) => setState(() => studentTickets = val),
            ),
            const SizedBox(height: 12),
            TicketCounter(
              title: l10n.foreigner,
              price: 'EGP $foreignerPrice',
              count: foreignerTickets,
              onChanged: (val) => setState(() => foreignerTickets = val),
            ),
            const SizedBox(height: 12),
            TicketCounter(
              title: l10n.local,
              price: 'EGP $localPrice',
              count: localTickets,
              onChanged: (val) => setState(() => localTickets = val),
            ),
            
            const SizedBox(height: 100), // Space for bottom sheet
          ],
        ),
      ),
      bottomSheet: TicketSelectionBottomSheet(
        totalTickets: totalTickets,
        totalPrice: totalPrice,
      ),
    );
  }
}
