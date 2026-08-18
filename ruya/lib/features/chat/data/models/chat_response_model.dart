import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';

class ChatResponseModel extends ChatResponseEntity {
  const ChatResponseModel({
    required super.conversationId,
    required super.assistantMessage,
    super.currentArtifactId,
    super.usedVision = false,
    super.needsNewFrame = false,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      conversationId: (json['conversationId'] as num?)?.toInt() ?? 0,
      assistantMessage: json['assistantMessage'] as String? ?? '',
      currentArtifactId: (json['currentArtifactId'] as num?)?.toInt(),
      usedVision: json['usedVision'] as bool? ?? false,
      needsNewFrame: json['needsNewFrame'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'assistantMessage': assistantMessage,
      'currentArtifactId': currentArtifactId,
      'usedVision': usedVision,
      'needsNewFrame': needsNewFrame,
    };
  }
}
