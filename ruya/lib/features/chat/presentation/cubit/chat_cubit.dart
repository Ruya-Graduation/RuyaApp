import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/services/tts_service.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/usecases/get_conversation_usecase.dart';
import 'package:ruya/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendChatMessageUseCase sendChatMessageUseCase;
  final GetConversationUseCase getConversationUseCase;
  final TtsService ttsService;
  StreamSubscription<TtsState>? _ttsSubscription;

  ChatCubit({
    required this.sendChatMessageUseCase,
    required this.getConversationUseCase,
    required this.ttsService,
    int? initialConversationId,
  }) : super(ChatState(conversationId: initialConversationId)) {
    _ttsSubscription = ttsService.stateStream.listen((ttsState) {
      if (ttsState == TtsState.stopped && state.isSpeaking) {
        emit(state.copyWith(
          isSpeaking: false,
          clearCurrentlyPlaying: true,
        ));
      }
    });

    if (initialConversationId != null && initialConversationId > 0) {
      loadConversation(initialConversationId);
    }
  }

  /// Loads previous messages for an existing conversation session.
  Future<void> loadConversation(int conversationId) async {
    emit(state.copyWith(
      status: ChatStatus.loading,
      conversationId: conversationId,
    ));

    final result = await getConversationUseCase(conversationId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      )),
      (messages) => emit(state.copyWith(
        status: ChatStatus.loaded,
        messages: messages,
        conversationId: conversationId,
      )),
    );
  }

  /// Attaches or clears an image selection before sending.
  void selectImage(File? image) {
    emit(state.copyWith(
      selectedImage: image,
      clearSelectedImage: image == null,
    ));
  }

  void clearImage() {
    emit(state.copyWith(clearSelectedImage: true));
  }

  /// Sends a typed or voice-transcribed message.
  Future<void> sendMessage({
    required String text,
    File? image,
    bool isVoice = false,
    String? language,
    String? mode,
  }) async {
    final cleanText = text.trim();
    final attachedImage = image ?? state.selectedImage;

    if (cleanText.isEmpty && attachedImage == null) return;

    final actualText = cleanText.isNotEmpty
        ? cleanText
        : (language == 'ar'
            ? 'ماذا يمكنك أن تخبرني عن هذا المعلم؟'
            : 'What can you tell me about this?');

    final userMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final userMessage = ChatMessage(
      id: userMessageId,
      senderType: SenderType.user,
      text: actualText,
      timestamp: DateTime.now(),
      contentType: attachedImage != null
          ? MessageContentType.image
          : MessageContentType.text,
      imagePath: attachedImage?.path,
      status: MessageStatus.sending,
      isVoiceOriginated: isVoice,
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMessage);

    emit(state.copyWith(
      status: ChatStatus.sending,
      messages: updatedMessages,
      clearSelectedImage: true,
      clearErrorMessage: true,
    ));

    final result = await sendChatMessageUseCase(
      conversationId: state.conversationId,
      message: actualText,
      language: language,
      mode: mode,
      image: attachedImage,
    );

    result.fold(
      (failure) {
        final markedFailedMessages = state.messages.map((m) {
          if (m.id == userMessageId) {
            return m.copyWith(status: MessageStatus.error);
          }
          return m;
        }).toList();

        emit(state.copyWith(
          status: ChatStatus.error,
          messages: markedFailedMessages,
          errorMessage: failure.message,
        ));
      },
      (response) {
        final markedSentMessages = state.messages.map((m) {
          if (m.id == userMessageId) {
            return m.copyWith(status: MessageStatus.sent);
          }
          return m;
        }).toList();

        final aiMessageId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
        final aiMessage = ChatMessage(
          id: aiMessageId,
          senderType: SenderType.ai,
          text: response.assistantMessage,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
          usedVision: response.usedVision,
          currentArtifactId: response.currentArtifactId,
        );

        final withAiMessages = List<ChatMessage>.from(markedSentMessages)..add(aiMessage);

        emit(state.copyWith(
          status: ChatStatus.loaded,
          messages: withAiMessages,
          conversationId: response.conversationId,
        ));

        // Auto-play TTS only if the user message originated from voice input
        if (isVoice && response.assistantMessage.isNotEmpty) {
          playTts(aiMessage, language: language);
        }
      },
    );
  }

  /// Retries a failed user message.
  Future<void> retryMessage(String messageId, {String? language, String? mode}) async {
    final index = state.messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final failedMessage = state.messages[index];
    if (failedMessage.senderType != SenderType.user) return;

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..[index] = failedMessage.copyWith(status: MessageStatus.sending);

    emit(state.copyWith(
      status: ChatStatus.sending,
      messages: updatedMessages,
      clearErrorMessage: true,
    ));

    File? imageFile;
    if (failedMessage.imagePath != null && failedMessage.imagePath!.isNotEmpty) {
      final file = File(failedMessage.imagePath!);
      if (file.existsSync()) {
        imageFile = file;
      }
    }

    final result = await sendChatMessageUseCase(
      conversationId: state.conversationId,
      message: failedMessage.text,
      language: language,
      mode: mode,
      image: imageFile,
    );

    result.fold(
      (failure) {
        final markedFailed = state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(status: MessageStatus.error);
          }
          return m;
        }).toList();

        emit(state.copyWith(
          status: ChatStatus.error,
          messages: markedFailed,
          errorMessage: failure.message,
        ));
      },
      (response) {
        final markedSent = state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(status: MessageStatus.sent);
          }
          return m;
        }).toList();

        final aiMessageId = (DateTime.now().millisecondsSinceEpoch + 1).toString();
        final aiMessage = ChatMessage(
          id: aiMessageId,
          senderType: SenderType.ai,
          text: response.assistantMessage,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
          usedVision: response.usedVision,
          currentArtifactId: response.currentArtifactId,
        );

        final withAi = List<ChatMessage>.from(markedSent)..add(aiMessage);

        emit(state.copyWith(
          status: ChatStatus.loaded,
          messages: withAi,
          conversationId: response.conversationId,
        ));

        if (failedMessage.isVoiceOriginated && response.assistantMessage.isNotEmpty) {
          playTts(aiMessage, language: language);
        }
      },
    );
  }

  /// Starts speaking an AI message text via TTS.
  Future<void> playTts(ChatMessage message, {String? language}) async {
    if (message.text.trim().isEmpty) return;

    emit(state.copyWith(
      isSpeaking: true,
      currentlyPlayingMessageId: message.id,
    ));

    await ttsService.speak(message.text, language: language);
  }

  /// Stops current TTS audio.
  Future<void> stopTts() async {
    await ttsService.stop();
    emit(state.copyWith(
      isSpeaking: false,
      clearCurrentlyPlaying: true,
    ));
  }

  @override
  Future<void> close() {
    _ttsSubscription?.cancel();
    ttsService.stop();
    return super.close();
  }
}
