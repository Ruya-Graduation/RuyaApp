import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/features/chat/data/models/chat_response_model.dart';
import 'package:ruya/features/chat/domain/entities/chat_response_entity.dart';

void main() {
  group('ChatResponseModel', () {
    test('is a subclass of ChatResponseEntity', () {
      const model = ChatResponseModel(
        conversationId: 101,
        assistantMessage: 'Welcome to Karnak!',
        currentArtifactId: 5,
        usedVision: true,
        needsNewFrame: false,
      );

      expect(model, isA<ChatResponseEntity>());
      expect(model.conversationId, 101);
      expect(model.assistantMessage, 'Welcome to Karnak!');
      expect(model.currentArtifactId, 5);
      expect(model.usedVision, isTrue);
      expect(model.needsNewFrame, isFalse);
    });

    test('fromJson parses server response accurately', () {
      final json = {
        'conversationId': 42,
        'assistantMessage': 'This statue represents Ramesses II.',
        'currentArtifactId': 12,
        'usedVision': true,
        'needsNewFrame': false,
      };

      final model = ChatResponseModel.fromJson(json);

      expect(model.conversationId, 42);
      expect(model.assistantMessage, 'This statue represents Ramesses II.');
      expect(model.currentArtifactId, 12);
      expect(model.usedVision, isTrue);
      expect(model.needsNewFrame, isFalse);
    });

    test('toJson serializes to the expected map', () {
      const model = ChatResponseModel(
        conversationId: 42,
        assistantMessage: 'Hello',
        currentArtifactId: 3,
        usedVision: false,
        needsNewFrame: false,
      );

      final json = model.toJson();

      expect(json['conversationId'], 42);
      expect(json['assistantMessage'], 'Hello');
      expect(json['currentArtifactId'], 3);
      expect(json['usedVision'], isFalse);
      expect(json['needsNewFrame'], isFalse);
    });
  });
}
