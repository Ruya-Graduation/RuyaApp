import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/booking/data/services/ticket_export_service.dart';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:ruya/features/booking/presentation/widgets/confirmation_ticket_card.dart';
import 'package:ruya/l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final BookingEntity booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  late final TicketExportService _exportService;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _exportService = getIt<TicketExportService>();
  }

  Future<void> _handleSaveAsPdf() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    final l10n = AppLocalizations.of(context)!;

    final success =
        await _exportService.saveOrShareTicketAsPdf(widget.booking);
    if (!mounted) return;

    setState(() => _isExporting = false);
    if (success) {
      AppSnackBar.showSuccess(context, l10n.ticketSaved);
    } else {
      AppSnackBar.showError(context, l10n.ticketSaveFailed);
    }
  }

  Future<void> _handleSaveAsImage() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    final l10n = AppLocalizations.of(context)!;

    final success = await _exportService.saveTicketAsImage();
    if (!mounted) return;

    setState(() => _isExporting = false);
    if (success) {
      AppSnackBar.showSuccess(context, l10n.ticketSaved);
    } else {
      AppSnackBar.showError(context, l10n.ticketSaveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFFAF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.bookingConfirmed,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.bookingConfirmedSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Screenshot-wrapped Ticket Card
              Screenshot(
                controller: _exportService.screenshotController,
                child: ConfirmationTicketCard(booking: widget.booking),
              ),

              const SizedBox(height: 32),

              // Back to Discover Primary Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/home');
                  },
                  icon: const Icon(Icons.explore_outlined, size: 20),
                  label: Text(
                    l10n.backToDiscover,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A373),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Export Buttons Row (Save as PDF / Save as Image)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _isExporting ? null : _handleSaveAsPdf,
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 20,
                        ),
                        label: Text(
                          l10n.saveAsPdf,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD4A373),
                          side: const BorderSide(color: Color(0xFFD4A373)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _isExporting ? null : _handleSaveAsImage,
                        icon: const Icon(Icons.image_outlined, size: 20),
                        label: Text(
                          l10n.saveAsImage,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD4A373),
                          side: const BorderSide(color: Color(0xFFD4A373)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cancel Booking Button (purely local / client-side)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.cancelBooking,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
