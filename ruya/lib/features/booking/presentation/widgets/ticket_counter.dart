import 'package:flutter/material.dart';

class TicketCounter extends StatelessWidget {
  final String title;
  final String price;
  final int count;
  final ValueChanged<int> onChanged;

  const TicketCounter({
    super.key,
    required this.title,
    required this.price,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                onPressed: count > 0 ? () => onChanged(count - 1) : null,
              ),
              const SizedBox(width: 16),
              Text(
                '$count',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              _buildCounterButton(
                icon: Icons.add,
                onPressed: () => onChanged(count + 1),
                isActive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({required IconData icon, VoidCallback? onPressed, bool isActive = false}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onPressed != null ? const Color(0xFFD4A373).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? const Color(0xFFD4A373) : Colors.grey,
        ),
      ),
    );
  }
}
