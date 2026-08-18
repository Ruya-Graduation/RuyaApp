import 'package:ruya/features/chat/domain/entities/chat_session.dart';

class ConversationListItemModel {
  final int conversationId;
  final String title;
  final String previewText;
  final int messageCount;
  final DateTime timestamp;

  const ConversationListItemModel({
    required this.conversationId,
    required this.title,
    required this.previewText,
    required this.messageCount,
    required this.timestamp,
  });

  factory ConversationListItemModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['lastMessageAt'] ??
        json['updatedAt'] ??
        json['timestamp'] ??
        json['createdAt'] ??
        json['createdDate'];

    return ConversationListItemModel(
      conversationId:
          (json['conversationId'] ?? json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Conversation',
      previewText: json['lastMessage'] as String? ??
          json['previewText'] as String? ??
          json['preview'] as String? ??
          '',
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      timestamp: DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now(),
    );
  }

  ChatSession toEntity() {
    return ChatSession(
      id: conversationId.toString(),
      title: title,
      previewText: previewText,
      messageCount: messageCount,
      timestamp: timestamp,
    );
  }
}
