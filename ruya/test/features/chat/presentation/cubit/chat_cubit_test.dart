import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/services/tts_service.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/domain/repositories/chat_repository.dart';
import 'package:ruya/features/chat/domain/usecases/get_conversation_usecase.dart';
import 'package:ruya/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_state.dart';

class FakeChatRepository implements ChatRepository {
  Either<Failure, ChatResponseEntity>? sendMessageResult;
  Either<Failure, List<ChatMessage>>? getConversationResult;

  @override
  Future<Either<Failure, ChatResponseEntity>> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  }) async {
    return sendMessageResult ??
        const Right(ChatResponseEntity(
          conversationId: 99,
          assistantMessage: 'AI Response',
        ));
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getConversation(
      int conversationId) async {
    return getConversationResult ?? const Right([]);
  }

  @override
  Future<Either<Failure, List<ChatSession>>> getConversations() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> deleteConversation(int conversationId) async {
    return const Right(null);
  }
}

class FakeTtsService extends TtsService {
  String? lastSpokenText;

  @override
  Future<void> speak(String text, {String? language}) async {
    lastSpokenText = text;
  }

  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeChatRepository fakeRepository;
  late FakeTtsService fakeTts;
  late SendChatMessageUseCase sendUseCase;
  late GetConversationUseCase getUseCase;
  late ChatCubit cubit;

  setUp(() {
    fakeRepository = FakeChatRepository();
    fakeTts = FakeTtsService();
    sendUseCase = SendChatMessageUseCase(fakeRepository);
    getUseCase = GetConversationUseCase(fakeRepository);
    cubit = ChatCubit(
      sendChatMessageUseCase: sendUseCase,
      getConversationUseCase: getUseCase,
      ttsService: fakeTts,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ChatCubit', () {
    test('initial state has empty messages and null conversationId', () {
      expect(cubit.state.status, ChatStatus.initial);
      expect(cubit.state.messages, isEmpty);
      expect(cubit.state.conversationId, isNull);
    });

    test('sendMessage sends message and appends AI response on success', () async {
      fakeRepository.sendMessageResult = const Right(ChatResponseEntity(
        conversationId: 55,
        assistantMessage: 'The Sphinx is in Giza.',
        currentArtifactId: null,
        usedVision: false,
      ));

      await cubit.sendMessage(text: 'Where is the Sphinx?');

      expect(cubit.state.status, ChatStatus.loaded);
      expect(cubit.state.conversationId, 55);
      expect(cubit.state.messages.length, 2);

      final userBubble = cubit.state.messages[0];
      final aiBubble = cubit.state.messages[1];

      expect(userBubble.senderType, SenderType.user);
      expect(userBubble.text, 'Where is the Sphinx?');
      expect(userBubble.status, MessageStatus.sent);

      expect(aiBubble.senderType, SenderType.ai);
      expect(aiBubble.text, 'The Sphinx is in Giza.');
    });

    test('sendMessage marks user message as error on failure', () async {
      fakeRepository.sendMessageResult =
          Left(ServerFailure('Backend connection error'));

      await cubit.sendMessage(text: 'Hello');

      expect(cubit.state.status, ChatStatus.error);
      expect(cubit.state.messages.length, 1);
      expect(cubit.state.messages.first.status, MessageStatus.error);
      expect(cubit.state.errorMessage, 'Backend connection error');
    });

    test('voice message triggers auto-TTS on response', () async {
      fakeRepository.sendMessageResult = const Right(ChatResponseEntity(
        conversationId: 55,
        assistantMessage: 'Spoken reply here',
      ));

      await cubit.sendMessage(
        text: 'Voice question',
        isVoice: true,
        language: 'en',
      );

      expect(fakeTts.lastSpokenText, 'Spoken reply here');
    });

    test('loadConversation populates history from usecase', () async {
      final history = [
        ChatMessage(
          id: '1',
          senderType: SenderType.user,
          text: 'Previous question',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          senderType: SenderType.ai,
          text: 'Previous answer',
          timestamp: DateTime.now(),
        ),
      ];

      fakeRepository.getConversationResult = Right(history);

      await cubit.loadConversation(12);

      expect(cubit.state.status, ChatStatus.loaded);
      expect(cubit.state.conversationId, 12);
      expect(cubit.state.messages.length, 2);
    });
  });
}
