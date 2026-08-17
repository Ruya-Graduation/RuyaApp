import 'package:flutter/material.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isAi = message.senderType == SenderType.ai;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAi) _AiAvatarSmall(isDark: isDark),
          Flexible(
            child: isAi
                ? _AiBubble(message: message, isDark: isDark)
                : _UserBubble(message: message),
          ),
          if (!isAi) const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ── Sub-widget: small AI avatar beside each AI bubble ───────────────────────
class _AiAvatarSmall extends StatelessWidget {
  final bool isDark;
  const _AiAvatarSmall({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(right: 10.0, top: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4A373), Color(0xFF8B6914)],
        ),
        border: Border.all(
          color: const Color(0xFFD4A373).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 14,
      ),
    );
  }
}

// ── Sub-widget: AI message bubble (white / dark card) ───────────────────────
class _AiBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const _AiBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = message.isWarning
        ? Colors.orange.withValues(alpha: 0.6)
        : (isDark ? Colors.white10 : Colors.black12);

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isWarning) _WarningLabel(),
          Text(
            message.text,
            style: TextStyle(fontSize: 14, height: 1.55, color: textColor),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widget: User message bubble (warm sand color + black text) ───────────
class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Color(0xFFD4A373),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Sub-widget: Warning label inside AI bubble ───────────────────────────────
class _WarningLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.orange, size: 13),
            const SizedBox(width: 4),
            Text(
              'Historically Debated',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
