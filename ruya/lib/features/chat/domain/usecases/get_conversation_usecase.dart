import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/repositories/chat_repository.dart';

class GetConversationUseCase {
  final ChatRepository repository;

  GetConversationUseCase(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(int conversationId) {
    return repository.getConversation(conversationId);
  }
}
