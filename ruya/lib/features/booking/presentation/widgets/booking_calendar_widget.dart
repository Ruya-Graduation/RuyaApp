import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

enum DayAvailability { avail, filling, sold }

class BookingCalendarWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const BookingCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<BookingCalendarWidget> createState() => _BookingCalendarWidgetState();
}

class _BookingCalendarWidgetState extends State<BookingCalendarWidget> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(covariant BookingCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && widget.selectedDate != oldWidget.selectedDate) {
      _focusedDay = widget.selectedDate!;
    }
  }

  DayAvailability _availabilityFor(DateTime day) {
    // Deterministic pseudo-availability so the same date always shows the
    // same status in a session — NOT random per rebuild.
    final seed = day.year * 10000 + day.month * 100 + day.day;
    final bucket = seed % 10;
    if (bucket == 0) return DayAvailability.sold; // ~10% sold out
    if (bucket <= 3) return DayAvailability.filling; // ~30% filling
    return DayAvailability.avail; // ~60% available
  }

  Color _colorForAvailability(DayAvailability availability) {
    switch (availability) {
      case DayAvailability.avail:
        return Colors.tealAccent[400]!;
      case DayAvailability.filling:
        return Colors.orange[300]!;
      case DayAvailability.sold:
        return AppColors.errorRed;
    }
  }

  bool _isDayEnabled(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(day.year, day.month, day.day);
    if (targetDay.isBefore(today)) return false;
    return _availabilityFor(day) != DayAvailability.sold;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final brandColor = AppColors.getBrandPrimary(context);

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, now.day);
    final lastDay = firstDay.add(const Duration(days: 90));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.selectDate,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Legend
              Row(
                children: [
                  _buildLegendDot(context, Colors.tealAccent[400]!, l10n.avail),
                  const SizedBox(width: 8),
                  _buildLegendDot(context, Colors.orange[300]!, l10n.filling),
                  const SizedBox(width: 8),
                  _buildLegendDot(context, AppColors.errorRed, l10n.sold),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          TableCalendar<void>(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay.isBefore(firstDay)
                ? firstDay
                : (_focusedDay.isAfter(lastDay) ? lastDay : _focusedDay),
            currentDay: now,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(
                isRtl ? Icons.chevron_right : Icons.chevron_left,
                color: isDark ? Colors.white : Colors.black,
              ),
              rightChevronIcon: Icon(
                isRtl ? Icons.chevron_left : Icons.chevron_right,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: brandColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: BoxDecoration(
                color: brandColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              disabledTextStyle: TextStyle(
                color: AppColors.getMutedText(context),
              ),
            ),
            selectedDayPredicate: (day) => isSameDay(widget.selectedDate, day),
            enabledDayPredicate: _isDayEnabled,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              widget.onDateSelected(selectedDay);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final avail = _availabilityFor(day);
                final dotColor = _colorForAvailability(avail);
                return _buildCellWithDot(
                  day: day.day,
                  textColor: isDark ? Colors.white : Colors.black87,
                  dotColor: dotColor,
                );
              },
              disabledBuilder: (context, day, focusedDay) {
                final isSold = _availabilityFor(day) == DayAvailability.sold;
                return _buildCellWithDot(
                  day: day.day,
                  textColor: AppColors.getMutedText(context),
                  dotColor: isSold ? AppColors.errorRed.withValues(alpha: 0.5) : null,
                );
              },
              todayBuilder: (context, day, focusedDay) {
                if (isSameDay(widget.selectedDate, day)) return null;
                final avail = _availabilityFor(day);
                final dotColor = _colorForAvailability(avail);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: _buildCellWithDot(
                    day: day.day,
                    textColor: isDark ? Colors.white : Colors.black,
                    dotColor: dotColor,
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                final avail = _availabilityFor(day);
                final dotColor = _colorForAvailability(avail);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: brandColor,
                    shape: BoxShape.circle,
                  ),
                  child: _buildCellWithDot(
                    day: day.day,
                    textColor: Colors.white,
                    dotColor: dotColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCellWithDot({
    required int day,
    required Color textColor,
    Color? dotColor,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$day',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          if (dotColor != null)
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildLegendDot(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.getMutedText(context)),
        ),
      ],
    );
  }
}
