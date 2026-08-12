import 'package:flutter/material.dart';
import 'package:ruya/l10n/app_localizations.dart';

class CalendarMockWidget extends StatelessWidget {
  const CalendarMockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.selectDate} — January 2026',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Legend
              Row(
                children: [
                  _buildLegendDot(Colors.tealAccent[400]!, l10n.avail),
                  const SizedBox(width: 8),
                  _buildLegendDot(Colors.orange[300]!, l10n.filling),
                  const SizedBox(width: 8),
                  _buildLegendDot(Colors.red, l10n.sold),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mock Calendar Grid
          Image.asset(
            'assets/images/placeholder_calendar.png', // Fallback, could just use static text in real app if no image
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              alignment: Alignment.center,
              child: const Text('Calendar Placeholder (Static)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
