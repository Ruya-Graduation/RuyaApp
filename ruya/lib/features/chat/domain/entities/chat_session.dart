import 'package:equatable/equatable.dart';

class ChatSession extends Equatable {
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

  int? get conversationId => int.tryParse(id);

  ChatSession copyWith({
    String? id,
    String? title,
    String? previewText,
    int? messageCount,
    DateTime? timestamp,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      previewText: previewText ?? this.previewText,
      messageCount: messageCount ?? this.messageCount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, title, previewText, messageCount, timestamp];
}
