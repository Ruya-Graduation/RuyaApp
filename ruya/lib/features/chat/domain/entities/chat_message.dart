import 'package:equatable/equatable.dart';

enum SenderType { user, ai }

enum MessageStatus { sending, sent, error }

enum MessageContentType { text, image }

class ChatMessage extends Equatable {
  final String id;
  final SenderType senderType;
  final String text;
  final DateTime timestamp;
  final bool isWarning;
  final MessageContentType contentType;
  final String? imagePath;
  final MessageStatus status;
  final bool usedVision;
  final int? currentArtifactId;
  final bool isVoiceOriginated;

  const ChatMessage({
    required this.id,
    required this.senderType,
    required this.text,
    required this.timestamp,
    this.isWarning = false,
    this.contentType = MessageContentType.text,
    this.imagePath,
    this.status = MessageStatus.sent,
    this.usedVision = false,
    this.currentArtifactId,
    this.isVoiceOriginated = false,
  });

  ChatMessage copyWith({
    String? id,
    SenderType? senderType,
    String? text,
    DateTime? timestamp,
    bool? isWarning,
    MessageContentType? contentType,
    String? imagePath,
    MessageStatus? status,
    bool? usedVision,
    int? currentArtifactId,
    bool? isVoiceOriginated,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isWarning: isWarning ?? this.isWarning,
      contentType: contentType ?? this.contentType,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      usedVision: usedVision ?? this.usedVision,
      currentArtifactId: currentArtifactId ?? this.currentArtifactId,
      isVoiceOriginated: isVoiceOriginated ?? this.isVoiceOriginated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderType,
        text,
        timestamp,
        isWarning,
        contentType,
        imagePath,
        status,
        usedVision,
        currentArtifactId,
        isVoiceOriginated,
      ];
}
