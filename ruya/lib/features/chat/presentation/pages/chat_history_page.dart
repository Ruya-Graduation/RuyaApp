import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_sessions_list.dart';
import 'package:ruya/features/chat/presentation/widgets/start_conversation_button.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  // ── Static mock data ───────────────────────────────────────────────────────
  final List<ChatSession> _sessions = [
    ChatSession(
      id: '1',
      title: 'Karnak Temple Complex',
      previewText: 'Who built the Karnak Temple, and why is it so significant...',
      messageCount: 12,
      timestamp: DateTime.now(),
    ),
    ChatSession(
      id: '2',
      title: 'Great Pyramid of Giza',
      previewText: 'How were the pyramids built and what...',
      messageCount: 8,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 26)),
    ),
    ChatSession(
      id: '3',
      title: 'Valley of the Kings',
      previewText: 'Tell me about the royal tombs and their...',
      messageCount: 15,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ChatSession(
      id: '4',
      title: 'Philae Temple & Isis',
      previewText: 'What rituals were performed at Philae T...',
      messageCount: 6,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    ChatSession(
      id: '5',
      title: 'Egyptian Mythology',
      previewText: 'Explain the story of Osiris, Isis, and Horus.',
      messageCount: 20,
      timestamp: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ChatSession(
      id: '6',
      title: 'Ancient Egyptian Art',
      previewText: 'What are the artistic conventions of Egy...',
      messageCount: 9,
      timestamp: DateTime.now().subtract(const Duration(days: 31)),
    ),
    ChatSession(
      id: '7',
      title: 'Luxor Day 2 Planning',
      previewText: 'Help me plan a full day in Luxor visiting t...',
      messageCount: 11,
      timestamp: DateTime.now().subtract(const Duration(days: 32)),
    ),
  ];

  // ── Delete logic ───────────────────────────────────────────────────────────
  Future<void> _confirmDelete(ChatSession session) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteConfirmDialog(
        l10n: l10n,
        isDark: isDark,
      ),
    );

    if (shouldDelete == true && mounted) {
      setState(() {
        _sessions.removeWhere((s) => s.id == session.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAF6F0),
      appBar: _buildAppBar(l10n, isDark),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RecentConversationsLabel(l10n: l10n, isDark: isDark),
          Expanded(
            child: ChatSessionsList(
              sessions: _sessions,
              onDelete: _confirmDelete,
            ),
          ),
          StartConversationButton(
            label: l10n.startNewConversation,
            onPressed: () => context.push('/ai-chat'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations l10n, bool isDark) {
    return AppBar(
      title: Text(
        l10n.chatHistory,
        style: const TextStyle(
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    );
  }
}

// ── Private sub-widget: section label ─────────────────────────────────────────
class _RecentConversationsLabel extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;

  const _RecentConversationsLabel({required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Text(
        l10n.recentConversations,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white54 : Colors.black54,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

// ── Private sub-widget: confirm delete dialog ──────────────────────────────────
class _DeleteConfirmDialog extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;

  const _DeleteConfirmDialog({required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.deleteChatConfirmTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      content: Text(
        l10n.deleteChatConfirmBody,
        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
