import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getDivider(context)),
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
                style: TextStyle(
                  color: AppColors.getMutedText(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildCounterButton(
                context,
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
                context,
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

  Widget _buildCounterButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onPressed,
    bool isActive = false,
  }) {
    final brandColor = AppColors.getBrandPrimary(context);
    final muted = AppColors.getMutedText(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onPressed != null
              ? brandColor.withValues(alpha: 0.2)
              : muted.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? brandColor : muted,
        ),
      ),
    );
  }
}
