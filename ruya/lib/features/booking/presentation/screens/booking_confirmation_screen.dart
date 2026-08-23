import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/services/notification_service.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';
import 'package:ruya/features/booking/data/services/ticket_export_service.dart';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:ruya/features/booking/domain/usecases/save_booking_usecase.dart';
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
  bool _reminderEnabled = false;
  late TimeOfDay _reminderTime;
  LocalBookingModel? _localModel;

  @override
  void initState() {
    super.initState();
    _exportService = getIt<TicketExportService>();
    _initDefaultReminderTime();
    _loadExistingBooking();
  }

  void _initDefaultReminderTime() {
    final now = DateTime.now();
    final visitDate = widget.booking.visitDate;
    final isToday = visitDate.year == now.year &&
        visitDate.month == now.month &&
        visitDate.day == now.day;

    if (isToday) {
      final nextHour = now.hour + 1;
      if (nextHour < 24) {
        _reminderTime = TimeOfDay(hour: nextHour, minute: 0);
      } else {
        _reminderTime = TimeOfDay(hour: now.hour, minute: (now.minute + 15) % 60);
      }
    } else {
      _reminderTime = const TimeOfDay(hour: 8, minute: 0);
    }
  }

  Future<void> _loadExistingBooking() async {
    final list = await getIt<BookingLocalDataSource>().getAll();
    final match = list.where(
      (b) => b.referenceNumber == widget.booking.referenceNumber,
    );
    if (match.isNotEmpty && mounted) {
      final found = match.first;
      setState(() {
        _localModel = found;
        _reminderEnabled = found.reminderEnabled;
        if (found.reminderDateTime != null) {
          _reminderTime = TimeOfDay(
            hour: found.reminderDateTime!.hour,
            minute: found.reminderDateTime!.minute,
          );
        }
      });
    }
  }

  int get _deterministicNotifId =>
      widget.booking.referenceNumber.hashCode & 0x7FFFFFFF;

  Future<void> _handleReminderToggle(bool enabled) async {
    final l10n = AppLocalizations.of(context)!;
    if (enabled) {
      var scheduledDateTime = DateTime(
        widget.booking.visitDate.year,
        widget.booking.visitDate.month,
        widget.booking.visitDate.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      // If default/current reminder time is in the past, prompt time picker
      if (scheduledDateTime.isBefore(DateTime.now())) {
        final now = DateTime.now();
        final initial = widget.booking.visitDate.day == now.day &&
                widget.booking.visitDate.month == now.month &&
                widget.booking.visitDate.year == now.year
            ? TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30)))
            : _reminderTime;

        final picked = await showTimePicker(
          context: context,
          initialTime: initial,
          helpText: l10n.pickAFutureTime,
        );

        if (picked == null || !mounted) {
          setState(() => _reminderEnabled = false);
          return;
        }

        _reminderTime = picked;
        scheduledDateTime = DateTime(
          widget.booking.visitDate.year,
          widget.booking.visitDate.month,
          widget.booking.visitDate.day,
          _reminderTime.hour,
          _reminderTime.minute,
        );

        if (scheduledDateTime.isBefore(DateTime.now())) {
          if (mounted) {
            AppSnackBar.showError(context, l10n.pickAFutureTime);
            setState(() => _reminderEnabled = false);
          }
          return;
        }
      }

      await getIt<NotificationService>().requestPermission();

      await getIt<NotificationService>().scheduleBookingReminder(
        notificationId: _deterministicNotifId,
        title: l10n.bookingReminderNotifTitle,
        body: l10n.bookingReminderNotifBody(
          widget.booking.siteName,
          widget.booking.referenceNumber,
        ),
        scheduledDateTime: scheduledDateTime,
      );

      final updated = (_localModel ??
              LocalBookingModel(
                referenceNumber: widget.booking.referenceNumber,
                siteId: widget.booking.siteId,
                siteName: widget.booking.siteName,
                visitDate: widget.booking.visitDate,
                timeSlot: widget.booking.timeSlot,
                ticketCount: widget.booking.ticketCount,
                pricePerTicket: widget.booking.pricePerTicket,
                currency: widget.booking.currency,
                createdAt: widget.booking.createdAt,
              ))
          .copyWith(
        reminderEnabled: true,
        reminderDateTime: scheduledDateTime,
        notificationId: _deterministicNotifId,
      );

      await getIt<SaveBookingUseCase>()(updated);

      if (mounted) {
        setState(() {
          _reminderEnabled = true;
          _localModel = updated;
        });
        AppSnackBar.showSuccess(context, l10n.reminderScheduled);
      }
    } else {
      await getIt<NotificationService>().cancelReminder(_deterministicNotifId);

      final updated = (_localModel ??
              LocalBookingModel(
                referenceNumber: widget.booking.referenceNumber,
                siteId: widget.booking.siteId,
                siteName: widget.booking.siteName,
                visitDate: widget.booking.visitDate,
                timeSlot: widget.booking.timeSlot,
                ticketCount: widget.booking.ticketCount,
                pricePerTicket: widget.booking.pricePerTicket,
                currency: widget.booking.currency,
                createdAt: widget.booking.createdAt,
              ))
          .copyWith(
        reminderEnabled: false,
        clearReminderDateTime: true,
        clearNotificationId: true,
      );
      await getIt<SaveBookingUseCase>()(updated);
      _localModel = updated;

      if (mounted) {
        setState(() => _reminderEnabled = false);
        AppSnackBar.showSuccess(context, l10n.reminderCancelled);
      }
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && mounted) {
      final scheduledDateTime = DateTime(
        widget.booking.visitDate.year,
        widget.booking.visitDate.month,
        widget.booking.visitDate.day,
        picked.hour,
        picked.minute,
      );

      if (scheduledDateTime.isBefore(DateTime.now())) {
        AppSnackBar.showError(
          context,
          AppLocalizations.of(context)!.pickAFutureTime,
        );
        return;
      }

      setState(() => _reminderTime = picked);
      if (_reminderEnabled) {
        await _handleReminderToggle(true);
      }
    }
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

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
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
                  color: AppColors.getMutedText(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Screenshot-wrapped Ticket Card
              Screenshot(
                controller: _exportService.screenshotController,
                child: ConfirmationTicketCard(booking: widget.booking),
              ),

              const SizedBox(height: 24),

              // --- Reminder Settings Card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.getDivider(context),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.getBrandPrimary(context)
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _reminderEnabled
                                ? Icons.notifications_active
                                : Icons.notifications_none_outlined,
                            color: AppColors.getBrandPrimary(context),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.setReminder,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                l10n.remindMeOnVisitDay,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.getMutedText(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _reminderEnabled,
                          onChanged: _handleReminderToggle,
                          activeThumbColor: AppColors.getBrandPrimary(context),
                        ),
                      ],
                    ),
                    if (_reminderEnabled) ...[
                      Divider(
                        height: 24,
                        color: AppColors.getDivider(context),
                      ),
                      InkWell(
                        onTap: _pickReminderTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.reminderTime,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _reminderTime.format(context),
                                    style: TextStyle(
                                      color: AppColors.getBrandPrimary(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: AppColors.getMutedText(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                    backgroundColor: AppColors.getBrandPrimary(context),
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
                          foregroundColor: AppColors.getBrandPrimary(context),
                          side: BorderSide(
                            color: AppColors.getBrandPrimary(context),
                          ),
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
                          foregroundColor: AppColors.getBrandPrimary(context),
                          side: BorderSide(
                            color: AppColors.getBrandPrimary(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
