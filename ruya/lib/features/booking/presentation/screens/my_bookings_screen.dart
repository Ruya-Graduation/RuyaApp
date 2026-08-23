import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';
import 'package:ruya/features/booking/domain/usecases/delete_booking_usecase.dart';
import 'package:ruya/features/booking/domain/usecases/get_bookings_usecase.dart';
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
            if (booking.reminderEnabled && booking.reminderDateTime != null) ...[
              const SizedBox(height: 12),
              Container(
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
                  ],
                ),
              ),
            ],
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
