import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ruya/core/network/api_exception.dart';
import 'package:ruya/features/chat/data/models/chat_response_model.dart';
import 'package:ruya/features/chat/data/models/conversation_details_model.dart';
import 'package:ruya/features/chat/data/models/conversation_list_item_model.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';

abstract class ChatRemoteDataSource {
  Future<ChatResponseModel> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  });

  Future<List<ChatMessage>> getConversation(int conversationId);

  Future<List<ChatSession>> getConversations();

  Future<void> deleteConversation(int conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  const ChatRemoteDataSourceImpl(this._dio);

  @override
  Future<ChatResponseModel> sendMessage({
    int? conversationId,
    required String message,
    String? language,
    String? mode,
    File? image,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'Message': message,
        'Language': language ?? 'en',
        'Mode': mode ?? 'story',
      };

      if (conversationId != null && conversationId > 0) {
        formMap['ConversationId'] = conversationId;
      }

      if (image != null) {
        final filename = image.path.split(RegExp(r'[/\\]')).last;
        formMap['Image'] = await MultipartFile.fromFile(
          image.path,
          filename: filename,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio.post('/Chat/message', data: formData);

      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Chat/message.',
        );
      }

      final rawData = body['data'];
      if (rawData is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Expected "data" object in /Chat/message response.',
        );
      }

      return ChatResponseModel.fromJson(rawData);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<List<ChatMessage>> getConversation(int conversationId) async {
    try {
      final response = await _dio.get('/Chat/$conversationId');
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Chat/{id}.',
        );
      }

      final rawData = body['data'];
      final details = ConversationDetailsModel.fromData(rawData);
      return details.messages;
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<List<ChatSession>> getConversations() async {
    try {
      final response = await _dio.get('/Chat');
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException(
          statusCode: 200,
          message: 'Unexpected response format from /Chat.',
        );
      }

      final rawData = body['data'];
      if (rawData is List) {
        return rawData
            .whereType<Map<String, dynamic>>()
            .map((item) => ConversationListItemModel.fromJson(item).toEntity())
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    try {
      await _dio.delete('/Chat/$conversationId');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  ApiException _wrap(DioException e) {
    return e.error as ApiException? ??
        ApiException(statusCode: -1, message: e.message ?? 'Unknown error');
  }
}
