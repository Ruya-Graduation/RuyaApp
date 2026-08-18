import 'package:equatable/equatable.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';

enum ChatHistoryStatus { initial, loading, loaded, error }

class ChatHistoryState extends Equatable {
  final ChatHistoryStatus status;
  final List<ChatSession> sessions;
  final String? errorMessage;

  const ChatHistoryState({
    this.status = ChatHistoryStatus.initial,
    this.sessions = const [],
    this.errorMessage,
  });

  ChatHistoryState copyWith({
    ChatHistoryStatus? status,
    List<ChatSession>? sessions,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatHistoryState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, sessions, errorMessage];
}
