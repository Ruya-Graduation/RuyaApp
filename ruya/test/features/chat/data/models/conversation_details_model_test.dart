import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/features/chat/data/models/conversation_details_model.dart';
import 'package:ruya/features/chat/domain/entities/chat_message.dart';

void main() {
  group('ConversationDetailsModel', () {
    test('fromData parses wrapped messages map', () {
      final data = {
        'conversationId': 10,
        'title': 'Karnak Temple',
        'messages': [
          {
            'id': 1,
            'role': 'user',
            'text': 'Who built Karnak?',
            'timestamp': '2026-08-18T10:00:00.000Z',
          },
          {
            'id': 2,
            'role': 'assistant',
            'text': 'Karnak was built over 2,000 years.',
            'timestamp': '2026-08-18T10:00:05.000Z',
            'usedVision': false,
          }
        ],
      };

      final details = ConversationDetailsModel.fromData(data);

      expect(details.conversationId, 10);
      expect(details.title, 'Karnak Temple');
      expect(details.messages.length, 2);
      expect(details.messages[0].senderType, SenderType.user);
      expect(details.messages[0].text, 'Who built Karnak?');
      expect(details.messages[1].senderType, SenderType.ai);
      expect(details.messages[1].text, 'Karnak was built over 2,000 years.');
    });

    test('fromData parses direct list of messages', () {
      final data = [
        {
          'id': 'm1',
          'senderType': 'ai',
          'message': 'Hello traveler!',
          'timestamp': '2026-08-18T12:00:00.000Z',
        }
      ];

      final details = ConversationDetailsModel.fromData(data);

      expect(details.messages.length, 1);
      expect(details.messages.first.id, 'm1');
      expect(details.messages.first.senderType, SenderType.ai);
      expect(details.messages.first.text, 'Hello traveler!');
    });
  });
}
