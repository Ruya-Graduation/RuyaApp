import 'package:ruya/features/chat/domain/entities/chat_message.dart';

class ConversationDetailsModel {
  final int conversationId;
  final String? title;
  final List<ChatMessage> messages;

  const ConversationDetailsModel({
    required this.conversationId,
    this.title,
    required this.messages,
  });

  factory ConversationDetailsModel.fromData(dynamic data) {
    if (data is List) {
      return ConversationDetailsModel(
        conversationId: 0,
        messages: data
            .whereType<Map<String, dynamic>>()
            .map(_parseMessage)
            .toList(),
      );
    }

    if (data is Map<String, dynamic>) {
      final rawMessages = data['messages'] ?? data['items'] ?? data['data'];
      final List<ChatMessage> parsedMessages = [];

      if (rawMessages is List) {
        for (final item in rawMessages) {
          if (item is Map<String, dynamic>) {
            parsedMessages.add(_parseMessage(item));
          }
        }
      }

      return ConversationDetailsModel(
        conversationId: (data['conversationId'] ?? data['id'] as num?)?.toInt() ?? 0,
        title: data['title'] as String?,
        messages: parsedMessages,
      );
    }

    return const ConversationDetailsModel(conversationId: 0, messages: []);
  }

  static ChatMessage _parseMessage(Map<String, dynamic> json) {
    final senderRaw = json['senderType']?.toString().toLowerCase() ??
        json['role']?.toString().toLowerCase() ??
        json['sender']?.toString().toLowerCase();

    final isUserBool = json['isUser'] as bool?;
    final isAi = senderRaw == 'ai' ||
        senderRaw == 'assistant' ||
        (isUserBool != null && !isUserBool);

    final image = json['imagePath'] as String? ?? json['imageUrl'] as String?;

    return ChatMessage(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      senderType: isAi ? SenderType.ai : SenderType.user,
      text: json['text'] as String? ??
          json['message'] as String? ??
          json['content'] as String? ??
          '',
      timestamp: DateTime.tryParse(
            json['timestamp']?.toString() ??
                json['createdAt']?.toString() ??
                json['createdDate']?.toString() ??
                '',
          ) ??
          DateTime.now(),
      isWarning: json['isWarning'] as bool? ?? false,
      contentType:
          image != null ? MessageContentType.image : MessageContentType.text,
      imagePath: image,
      status: MessageStatus.sent,
      usedVision: json['usedVision'] as bool? ?? false,
      currentArtifactId: (json['currentArtifactId'] as num?)?.toInt(),
    );
  }
}
