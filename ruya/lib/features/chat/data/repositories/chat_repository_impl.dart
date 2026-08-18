import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ChatResponseEntity>> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  }) async {
    try {
      final response = await remoteDataSource.sendMessage(
        conversationId: conversationId,
        message: message,
        language: language,
        mode: mode,
        image: image,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getConversation(
      int conversationId) async {
    try {
      final messages = await remoteDataSource.getConversation(conversationId);
      return Right(messages);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<ChatSession>>> getConversations() async {
    try {
      final sessions = await remoteDataSource.getConversations();
      return Right(sessions);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(int conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  Failure _toFailure(ApiException e) {
    if (e.isNetworkError) return NetworkFailure(e.message);
    if (e.isValidationError) {
      return ValidationFailure(e.message, fieldErrors: e.fieldErrors ?? {});
    }
    return ServerFailure(e.message);
  }
}
