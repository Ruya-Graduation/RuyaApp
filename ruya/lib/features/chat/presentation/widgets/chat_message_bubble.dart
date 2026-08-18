import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isPlayingTts;
  final VoidCallback? onPlayTts;
  final VoidCallback? onStopTts;
  final VoidCallback? onRetry;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.isPlayingTts = false,
    this.onPlayTts,
    this.onStopTts,
    this.onRetry,
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
                ? _AiBubble(
                    message: message,
                    isDark: isDark,
                    isPlayingTts: isPlayingTts,
                    onPlayTts: onPlayTts,
                    onStopTts: onStopTts,
                  )
                : _UserBubble(
                    message: message,
                    onRetry: onRetry,
                  ),
          ),
          if (!isAi) const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ── AI Avatar ─────────────────────────────────────────────────────────────────
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

// ── AI Message Bubble ─────────────────────────────────────────────────────────
class _AiBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final bool isPlayingTts;
  final VoidCallback? onPlayTts;
  final VoidCallback? onStopTts;

  const _AiBubble({
    required this.message,
    required this.isDark,
    required this.isPlayingTts,
    this.onPlayTts,
    this.onStopTts,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          if (message.usedVision)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A373).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.remove_red_eye_outlined,
                        color: Color(0xFF8B6914), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      l10n.visionBadge,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B6914),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Text(
            message.text,
            style: TextStyle(fontSize: 14, height: 1.55, color: textColor),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: isPlayingTts ? onStopTts : onPlayTts,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPlayingTts
                        ? const Color(0xFFD4A373).withValues(alpha: 0.2)
                        : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlayingTts
                            ? Icons.volume_up_rounded
                            : Icons.volume_down_outlined,
                        size: 14,
                        color: isPlayingTts
                            ? const Color(0xFFD4A373)
                            : (isDark ? Colors.white60 : Colors.black54),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.replayAudio,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPlayingTts
                              ? const Color(0xFFD4A373)
                              : (isDark ? Colors.white60 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── User Message Bubble ───────────────────────────────────────────────────────
class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onRetry;

  const _UserBubble({
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isError = message.status == MessageStatus.error;
    final isSending = message.status == MessageStatus.sending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isError
                ? const Color(0xFFE57373)
                : const Color(0xFFD4A373),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.imagePath != null && message.imagePath!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildBubbleImage(message.imagePath!),
                  ),
                ),
              if (message.text.isNotEmpty)
                Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        if (isSending)
          const Padding(
            padding: EdgeInsets.only(top: 4.0, right: 4.0),
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Color(0xFFD4A373),
              ),
            ),
          ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.failedToSendMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.refresh_rounded, color: Colors.red, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          l10n.retry,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBubbleImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
      );
    }
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 200,
        height: 150,
        fit: BoxFit.cover,
      );
    }
    return const Icon(Icons.image_not_supported, size: 40);
  }
}

// ── Warning Label ─────────────────────────────────────────────────────────────
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
