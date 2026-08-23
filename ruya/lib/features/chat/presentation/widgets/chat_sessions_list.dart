import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_history_item.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// A scrollable list of past chat sessions.
class ChatSessionsList extends StatelessWidget {
  final List<ChatSession> sessions;
  final ValueChanged<ChatSession> onSessionTap;
  final void Function(ChatSession) onDelete;

  const ChatSessionsList({
    super.key,
    required this.sessions,
    required this.onSessionTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sessions.isEmpty) {
      return Container(
        color: AppColors.getBackground(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 48,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.noConversations,
                  style: TextStyle(
                    color: AppColors.getMutedText(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.getBackground(context),
      child: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return ChatHistoryItem(
            session: session,
            onTap: () => onSessionTap(session),
            onDelete: () => onDelete(session),
          );
        },
      ),
    );
  }
}
