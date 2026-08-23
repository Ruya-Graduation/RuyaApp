import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// Displays the scrollable list of chat messages.
class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final String? currentlyPlayingMessageId;
  final ValueChanged<ChatMessage>? onPlayTts;
  final VoidCallback? onStopTts;
  final ValueChanged<String>? onRetry;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    this.currentlyPlayingMessageId,
    this.onPlayTts,
    this.onStopTts,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brandColor = AppColors.getBrandPrimary(context);

    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandColor.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: brandColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noMessagesYet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.getMutedText(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isPlaying = message.id == currentlyPlayingMessageId;

        return ChatMessageBubble(
          message: message,
          isPlayingTts: isPlaying,
          onPlayTts: () => onPlayTts?.call(message),
          onStopTts: onStopTts,
          onRetry: () => onRetry?.call(message.id),
        );
      },
    );
  }
}
