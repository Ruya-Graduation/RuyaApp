import 'package:flutter/material.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_history_item.dart';

/// A scrollable list of past chat sessions.
class ChatSessionsList extends StatelessWidget {
  final List<ChatSession> sessions;
  final void Function(ChatSession) onDelete;

  const ChatSessionsList({
    super.key,
    required this.sessions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF121212) : Colors.white,
      child: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return ChatHistoryItem(
            session: session,
            onDelete: () => onDelete(session),
          );
        },
      ),
    );
  }
}
