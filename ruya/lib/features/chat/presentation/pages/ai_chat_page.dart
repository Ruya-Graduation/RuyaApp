import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_header.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_message_list.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ── Static mock conversation data ──────────────────────────────────────────
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      senderType: SenderType.user,
      text: 'Who built the Karnak Temple, and why is it so significant?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: '2',
      senderType: SenderType.ai,
      text:
          'Karnak was built over approximately 2,000 years by successive pharaohs, beginning around 2055 BCE during the Middle Kingdom. [Source: Egyptology Review, 2023] The complex served as the primary religious center of Thebes, dedicated primarily to Amun-Ra.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      id: '3',
      senderType: SenderType.ai,
      text:
          'The precise religious practices within the innermost sanctuaries remain debated among scholars — some evidence suggests nocturnal rites occurred, though this interpretation is contested.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      isWarning: true,
    ),
    ChatMessage(
      id: '4',
      senderType: SenderType.user,
      text: 'Which pharaoh contributed the most to its construction?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    ChatMessage(
      id: '5',
      senderType: SenderType.ai,
      text:
          'Ramesses II (1279–1213 BCE) is credited with the most dramatic expansions, including the Hypostyle Hall — 134 massive columns arranged in 16 rows. [Source: Oxford Handbook of Egyptology]',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Message logic ──────────────────────────────────────────────────────────
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderType: SenderType.user,
        text: text,
        timestamp: DateTime.now(),
      ));
      _textController.clear();
    });

    _scrollToBottom();

    // Simulate static AI reply
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderType: SenderType.ai,
          text:
              'That\'s a great question! As Ruya AI, I can share that Egyptian history spans thousands of years of remarkable civilization. This is a static reply — full AI integration is coming soon.',
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F4EE),
      appBar: _buildAppBar(context, isDark),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: _messages,
              scrollController: _scrollController,
            ),
          ),
          ChatInputBar(
            controller: _textController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  // ── AppBar builder ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor:
          isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAF6F0),
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? Colors.white : Colors.black87,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      title: const ChatHeader(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
    );
  }
}
