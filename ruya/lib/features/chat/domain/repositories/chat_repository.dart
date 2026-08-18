import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';

abstract class ChatRepository {
  /// Sends a user message (with optional image) to `/api/Chat/message`.
  Future<Either<Failure, ChatResponseEntity>> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  });

  /// Retrieves the message history for a specific conversation from `GET /api/Chat/{conversationId}`.
  Future<Either<Failure, List<ChatMessage>>> getConversation(int conversationId);

  /// Retrieves the list of conversation sessions from `GET /api/Chat`.
  Future<Either<Failure, List<ChatSession>>> getConversations();

  /// Deletes a conversation session via `DELETE /api/Chat/{conversationId}`.
  Future<Either<Failure, void>> deleteConversation(int conversationId);
}
