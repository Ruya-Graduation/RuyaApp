import 'package:equatable/equatable.dart';

class ChatResponseEntity extends Equatable {
  final int conversationId;
  final String assistantMessage;
  final int? currentArtifactId;
  final bool usedVision;
  final bool needsNewFrame;

  const ChatResponseEntity({
    required this.conversationId,
    required this.assistantMessage,
    this.currentArtifactId,
    this.usedVision = false,
    this.needsNewFrame = false,
  });

  @override
  List<Object?> get props => [
        conversationId,
        assistantMessage,
        currentArtifactId,
        usedVision,
        needsNewFrame,
      ];
}
