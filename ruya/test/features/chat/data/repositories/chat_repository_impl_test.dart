import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ruya/features/chat/data/models/chat_response_model.dart';
import 'package:ruya/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';

class FakeChatRemoteDataSource implements ChatRemoteDataSource {
  ChatResponseModel? sendResult;
  List<ChatMessage>? conversationResult;
  List<ChatSession>? conversationsResult;
  bool shouldThrowApi = false;
  bool shouldThrowNetwork = false;

  @override
  Future<ChatResponseModel> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  }) async {
    if (shouldThrowNetwork) {
      throw const ApiException(statusCode: -1, message: 'Network unreachable');
    }
    if (shouldThrowApi) {
      throw const ApiException(statusCode: 500, message: 'Server error');
    }
    return sendResult ??
        const ChatResponseModel(
          conversationId: 88,
          assistantMessage: 'Hello traveler!',
        );
  }

  @override
  Future<List<ChatMessage>> getConversation(int conversationId) async {
    if (shouldThrowApi) {
      throw const ApiException(statusCode: 404, message: 'Not found');
    }
    return conversationResult ?? [];
  }

  @override
  Future<List<ChatSession>> getConversations() async {
    if (shouldThrowApi) {
      throw const ApiException(statusCode: 500, message: 'Error');
    }
    return conversationsResult ?? [];
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    if (shouldThrowApi) {
      throw const ApiException(statusCode: 500, message: 'Delete failed');
    }
  }
}

void main() {
  late FakeChatRemoteDataSource remoteDataSource;
  late ChatRepositoryImpl repository;

  setUp(() {
    remoteDataSource = FakeChatRemoteDataSource();
    repository = ChatRepositoryImpl(remoteDataSource);
  });

  group('ChatRepositoryImpl', () {
    test('sendMessage returns Right(ChatResponseEntity) on success', () async {
      final result = await repository.sendMessage(message: 'Hi');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (response) => expect(response.conversationId, 88),
      );
    });

    test('sendMessage maps network ApiException to NetworkFailure', () async {
      remoteDataSource.shouldThrowNetwork = true;

      final result = await repository.sendMessage(message: 'Hi');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('getConversation returns Right(List<ChatMessage>) on success', () async {
      final messages = [
        ChatMessage(
          id: '1',
          senderType: SenderType.user,
          text: 'Question',
          timestamp: DateTime.now(),
        ),
      ];
      remoteDataSource.conversationResult = messages;

      final result = await repository.getConversation(12);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list.length, 1),
      );
    });

    test('deleteConversation returns Right(null) on success', () async {
      final result = await repository.deleteConversation(5);

      expect(result.isRight(), isTrue);
    });
  });
}
