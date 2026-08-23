import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';
import 'package:ruya/core/services/notification_service.dart';
import 'package:ruya/features/booking/domain/usecases/cancel_booking_reminder_usecase.dart';
import 'package:ruya/features/booking/domain/usecases/delete_booking_usecase.dart';
import 'package:ruya/features/booking/domain/usecases/get_bookings_usecase.dart';
import 'package:ruya/features/booking/domain/usecases/save_booking_usecase.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool _isLoading = true;
  List<LocalBookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    final list = await getIt<GetBookingsUseCase>()();
    if (mounted) {
      setState(() {
        _bookings = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCancelBooking(LocalBookingModel booking) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.getSurface(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.cancelBookingConfirmTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.cancelBookingConfirmBody(booking.siteName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.back,
              style: TextStyle(color: AppColors.getMutedText(ctx)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.cancelBooking),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await getIt<DeleteBookingUseCase>()(booking);
      if (mounted) {
        AppSnackBar.showSuccess(context, l10n.bookingCancelled);
        _loadBookings();
      }
    }
  }

  Future<void> _handleToggleReminder(LocalBookingModel booking) async {
    final l10n = AppLocalizations.of(context)!;
    if (booking.reminderEnabled) {
      final action = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppColors.getSurface(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: AppColors.getBrandPrimary(ctx),
                  ),
                  title: Text(l10n.reminderTime),
                  subtitle: Text(
                    booking.reminderDateTime != null
                        ? DateFormat.jm().format(booking.reminderDateTime!)
                        : '',
                  ),
                  trailing: const Icon(Icons.edit, size: 18),
                  onTap: () => Navigator.pop(ctx, 'edit'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notifications_off_outlined,
                    color: AppColors.errorRed,
                  ),
                  title: Text(
                    l10n.reminderCancelled,
                    style: const TextStyle(color: AppColors.errorRed),
                  ),
                  onTap: () => Navigator.pop(ctx, 'cancel'),
                ),
              ],
            ),
          ),
        ),
      );

      if (action == 'cancel') {
        await getIt<CancelBookingReminderUseCase>()(booking);
        if (mounted) {
          AppSnackBar.showSuccess(context, l10n.reminderCancelled);
          _loadBookings();
        }
      } else if (action == 'edit') {
        await _pickAndSaveReminder(booking);
      }
    } else {
      await _pickAndSaveReminder(booking);
    }
  }

  Future<void> _pickAndSaveReminder(LocalBookingModel booking) async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final isToday = booking.visitDate.year == now.year &&
        booking.visitDate.month == now.month &&
        booking.visitDate.day == now.day;

    final initialTime = booking.reminderDateTime != null
        ? TimeOfDay.fromDateTime(booking.reminderDateTime!)
        : (isToday
            ? TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30)))
            : const TimeOfDay(hour: 8, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: l10n.pickAFutureTime,
    );

    if (picked == null || !mounted) return;

    final scheduled = DateTime(
      booking.visitDate.year,
      booking.visitDate.month,
      booking.visitDate.day,
      picked.hour,
      picked.minute,
    );

    if (scheduled.isBefore(DateTime.now())) {
      AppSnackBar.showError(context, l10n.pickAFutureTime);
      return;
    }

    await getIt<NotificationService>().requestPermission();

    final notifId = booking.referenceNumber.hashCode & 0x7FFFFFFF;
    await getIt<NotificationService>().scheduleBookingReminder(
      notificationId: notifId,
      title: l10n.bookingReminderNotifTitle,
      body: l10n.bookingReminderNotifBody(
        booking.siteName,
        booking.referenceNumber,
      ),
      scheduledDateTime: scheduled,
    );

    final updated = booking.copyWith(
      reminderEnabled: true,
      reminderDateTime: scheduled,
      notificationId: notifId,
    );

    await getIt<SaveBookingUseCase>()(updated);

    if (mounted) {
      AppSnackBar.showSuccess(context, l10n.reminderScheduled);
      _loadBookings();
    }
  }

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
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.myBookings,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 64,
                        color: AppColors.getMutedText(context),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noBookingsYet,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.getMutedText(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return _buildBookingCard(booking);
                  },
                ),
    );
  }

  Widget _buildBookingCard(LocalBookingModel booking) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final dateFormatted = DateFormat.yMMMd().format(booking.visitDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getDivider(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.siteName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.getBrandPrimary(context)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.referenceNumber,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getBrandPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: AppColors.getDivider(context)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.getMutedText(context),
                ),
                const SizedBox(width: 8),
                Text(
                  '$dateFormatted · ${booking.timeSlot}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.getMutedText(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: AppColors.getMutedText(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${booking.ticketCount} ${l10n.tickets}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.getMutedText(context),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${booking.currency} ${booking.totalPrice.toStringAsFixed(0)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.getBrandPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (booking.reminderEnabled && booking.reminderDateTime != null)
              InkWell(
                onTap: () => _handleToggleReminder(booking),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.getSuccessContainer(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_active,
                        size: 14,
                        color: AppColors.getOnSuccessContainer(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${l10n.reminderTime}: ${DateFormat.jm().format(booking.reminderDateTime!)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getOnSuccessContainer(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit,
                        size: 12,
                        color: AppColors.getOnSuccessContainer(context),
                      ),
                    ],
                  ),
                ),
              )
            else if (!booking.visitDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)))
              InkWell(
                onTap: () => _handleToggleReminder(booking),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.getBrandPrimary(context).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.getBrandPrimary(context).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notification_add_outlined,
                        size: 14,
                        color: AppColors.getBrandPrimary(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.setReminder,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getBrandPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _handleCancelBooking(booking),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 16,
                    color: AppColors.errorRed,
                  ),
                  label: Text(
                    l10n.cancelBooking,
                    style: const TextStyle(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
