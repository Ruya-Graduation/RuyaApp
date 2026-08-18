import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';
import 'package:ruya/features/chat/domain/repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<Either<Failure, ChatResponseEntity>> call({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  }) {
    return repository.sendMessage(
      conversationId: conversationId,
      message: message,
      language: language,
      mode: mode,
      image: image,
    );
  }
}
