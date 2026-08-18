import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/domain/repositories/chat_repository.dart';
import 'package:ruya/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:ruya/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_history_cubit.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_history_state.dart';

class FakeChatHistoryRepository implements ChatRepository {
  Either<Failure, List<ChatSession>>? getConversationsResult;
  Either<Failure, void>? deleteConversationResult;

  @override
  Future<Either<Failure, List<ChatSession>>> getConversations() async {
    return getConversationsResult ?? const Right([]);
  }

  @override
  Future<Either<Failure, void>> deleteConversation(int conversationId) async {
    return deleteConversationResult ?? const Right(null);
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getConversation(
      int conversationId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, ChatResponseEntity>> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  }) async {
    return const Right(ChatResponseEntity(
      conversationId: 1,
      assistantMessage: '',
    ));
  }
}

void main() {
  late FakeChatHistoryRepository repository;
  late GetConversationsUseCase getConversationsUseCase;
  late DeleteConversationUseCase deleteConversationUseCase;
  late ChatHistoryCubit cubit;

  setUp(() {
    repository = FakeChatHistoryRepository();
    getConversationsUseCase = GetConversationsUseCase(repository);
    deleteConversationUseCase = DeleteConversationUseCase(repository);
    cubit = ChatHistoryCubit(
      getConversationsUseCase: getConversationsUseCase,
      deleteConversationUseCase: deleteConversationUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ChatHistoryCubit', () {
    test('initial state has empty sessions', () {
      expect(cubit.state.status, ChatHistoryStatus.initial);
      expect(cubit.state.sessions, isEmpty);
    });

    test('loadConversations populates state on success', () async {
      final sessions = [
        ChatSession(
          id: '1',
          title: 'Karnak Temple',
          previewText: 'Who built Karnak?',
          messageCount: 4,
          timestamp: DateTime.now(),
        ),
      ];

      repository.getConversationsResult = Right(sessions);

      await cubit.loadConversations();

      expect(cubit.state.status, ChatHistoryStatus.loaded);
      expect(cubit.state.sessions.length, 1);
      expect(cubit.state.sessions.first.title, 'Karnak Temple');
    });

    test('deleteConversation removes session optimistically', () async {
      final session1 = ChatSession(
        id: '1',
        title: 'Session 1',
        previewText: 'Preview',
        messageCount: 2,
        timestamp: DateTime.now(),
      );
      final session2 = ChatSession(
        id: '2',
        title: 'Session 2',
        previewText: 'Preview 2',
        messageCount: 3,
        timestamp: DateTime.now(),
      );

      repository.getConversationsResult = Right([session1, session2]);
      await cubit.loadConversations();
      expect(cubit.state.sessions.length, 2);

      final success = await cubit.deleteConversation(session1);

      expect(success, isTrue);
      expect(cubit.state.sessions.length, 1);
      expect(cubit.state.sessions.first.id, '2');
    });

    test('deleteConversation rolls back on failure', () async {
      final session = ChatSession(
        id: '1',
        title: 'Session 1',
        previewText: 'Preview',
        messageCount: 2,
        timestamp: DateTime.now(),
      );

      repository.getConversationsResult = Right([session]);
      await cubit.loadConversations();

      repository.deleteConversationResult =
          Left(ServerFailure('Delete failed'));

      final success = await cubit.deleteConversation(session);

      expect(success, isFalse);
      expect(cubit.state.sessions.length, 1);
      expect(cubit.state.errorMessage, 'Delete failed');
    });
  });
}
