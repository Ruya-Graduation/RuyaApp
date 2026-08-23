import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/widgets/app_language_toggle.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        const _ChatAiAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: _ChatHeaderTitleSection(l10n: l10n, isDark: isDark),
        ),
        const AppLanguageToggle(),
      ],
    );
  }
}

// ── Sub-widget: Avatar circle with golden gradient ──────────────────────────
class _ChatAiAvatar extends StatelessWidget {
  const _ChatAiAvatar();

  @override
  Widget build(BuildContext context) {
    final brandColor = AppColors.getBrandPrimary(context);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4A373), Color(0xFF8B6914)],
        ),
        border: Border.all(
          color: brandColor.withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: brandColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

// ── Sub-widget: Title + active mode row ─────────────────────────────────────
class _ChatHeaderTitleSection extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;

  const _ChatHeaderTitleSection({
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ruya AI',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              l10n.activeKarnakMode,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.black54,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
