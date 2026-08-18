import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/chat/domain/repositories/chat_repository.dart';

class DeleteConversationUseCase {
  final ChatRepository repository;

  DeleteConversationUseCase(this.repository);

  Future<Either<Failure, void>> call(int conversationId) {
    return repository.deleteConversation(conversationId);
  }
}
