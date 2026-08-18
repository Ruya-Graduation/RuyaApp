import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:ruya/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final GetConversationsUseCase getConversationsUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;

  ChatHistoryCubit({
    required this.getConversationsUseCase,
    required this.deleteConversationUseCase,
  }) : super(const ChatHistoryState());

  /// Fetches all conversations from the backend.
  Future<void> loadConversations() async {
    emit(state.copyWith(status: ChatHistoryStatus.loading, clearErrorMessage: true));

    final result = await getConversationsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatHistoryStatus.error,
        errorMessage: failure.message,
      )),
      (sessions) => emit(state.copyWith(
        status: ChatHistoryStatus.loaded,
        sessions: sessions,
      )),
    );
  }

  /// Optimistically deletes a conversation session with rollback on failure.
  Future<bool> deleteConversation(ChatSession session) async {
    final convId = session.conversationId;
    if (convId == null) return false;

    final originalSessions = state.sessions;
    final updatedSessions =
        originalSessions.where((s) => s.id != session.id).toList();

    emit(state.copyWith(sessions: updatedSessions));

    final result = await deleteConversationUseCase(convId);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          sessions: originalSessions,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) => true,
    );
  }
}
