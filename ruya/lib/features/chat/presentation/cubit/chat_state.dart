import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';

enum ChatStatus { initial, loading, loaded, sending, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatMessage> messages;
  final int? conversationId;
  final File? selectedImage;
  final String? errorMessage;
  final bool isSpeaking;
  final String? currentlyPlayingMessageId;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.conversationId,
    this.selectedImage,
    this.errorMessage,
    this.isSpeaking = false,
    this.currentlyPlayingMessageId,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    int? conversationId,
    bool clearConversationId = false,
    File? selectedImage,
    bool clearSelectedImage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSpeaking,
    String? currentlyPlayingMessageId,
    bool clearCurrentlyPlaying = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      conversationId: clearConversationId
          ? null
          : (conversationId ?? this.conversationId),
      selectedImage: clearSelectedImage
          ? null
          : (selectedImage ?? this.selectedImage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      isSpeaking: isSpeaking ?? this.isSpeaking,
      currentlyPlayingMessageId: clearCurrentlyPlaying
          ? null
          : (currentlyPlayingMessageId ?? this.currentlyPlayingMessageId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        conversationId,
        selectedImage,
        errorMessage,
        isSpeaking,
        currentlyPlayingMessageId,
      ];
}
