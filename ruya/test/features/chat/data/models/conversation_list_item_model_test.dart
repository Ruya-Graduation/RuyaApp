import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/features/chat/data/models/conversation_list_item_model.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';

void main() {
  group('ConversationListItemModel', () {
    test('fromJson and toEntity map backend chat summary correctly', () {
      final json = {
        'conversationId': 7,
        'title': 'Valley of the Kings',
        'lastMessage': 'Tell me about Tutankhamun',
        'messageCount': 8,
        'lastMessageAt': '2026-08-18T14:30:00.000Z',
      };

      final model = ConversationListItemModel.fromJson(json);

      expect(model.conversationId, 7);
      expect(model.title, 'Valley of the Kings');
      expect(model.previewText, 'Tell me about Tutankhamun');
      expect(model.messageCount, 8);

      final entity = model.toEntity();
      expect(entity, isA<ChatSession>());
      expect(entity.id, '7');
      expect(entity.conversationId, 7);
      expect(entity.title, 'Valley of the Kings');
      expect(entity.previewText, 'Tell me about Tutankhamun');
      expect(entity.messageCount, 8);
    });
  });
}
