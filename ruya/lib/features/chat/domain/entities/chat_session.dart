class ChatSession {
  final String id;
  final String title;
  final String previewText;
  final int messageCount;
  final DateTime timestamp;

  const ChatSession({
    required this.id,
    required this.title,
    required this.previewText,
    required this.messageCount,
    required this.timestamp,
  });
}
