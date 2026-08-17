enum SenderType { user, ai }

class ChatMessage {
  final String id;
  final SenderType senderType;
  final String text;
  final DateTime timestamp;
  final bool isWarning;

  const ChatMessage({
    required this.id,
    required this.senderType,
    required this.text,
    required this.timestamp,
    this.isWarning = false,
  });
}
