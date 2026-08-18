import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/core/services/speech_to_text_service.dart';
import 'package:ruya/core/services/tts_service.dart';
import 'package:ruya/features/chat/presentation/cubit/voice_input_cubit.dart';
import 'package:ruya/features/chat/presentation/cubit/voice_input_state.dart';

class FakeSpeechToTextService extends SpeechToTextService {
  bool available;
  bool isListeningState = false;

  FakeSpeechToTextService({this.available = true});

  @override
  Future<bool> initialize() async => available;

  @override
  bool get isAvailable => available;

  @override
  bool get isListening => isListeningState;

  @override
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    String? localeId,
  }) async {
    isListeningState = true;
    onResult('Partial speech', false);
    onResult('Final recognized speech', true);
  }

  @override
  Future<void> stopListening() async {
    isListeningState = false;
  }

  @override
  Future<void> cancelListening() async {
    isListeningState = false;
  }
}

class FakeTtsService extends TtsService {
  bool stopCalled = false;

  @override
  Future<void> stop() async {
    stopCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeSpeechToTextService fakeStt;
  late FakeTtsService fakeTts;
  late VoiceInputCubit cubit;

  setUp(() {
    fakeStt = FakeSpeechToTextService(available: true);
    fakeTts = FakeTtsService();
    cubit = VoiceInputCubit(
      speechToTextService: fakeStt,
      ttsService: fakeTts,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('VoiceInputCubit', () {
    test('initial state initializes availability correctly', () {
      expect(cubit.state.isAvailable, isTrue);
      expect(cubit.state.status, VoiceInputStatus.idle);
      expect(cubit.state.transcript, '');
    });

    test('cancelListening clears transcript and resets status', () async {
      await cubit.cancelListening();
      expect(cubit.state.status, VoiceInputStatus.idle);
      expect(cubit.state.transcript, '');
    });

    test('reset resets transcript and error', () {
      cubit.reset();
      expect(cubit.state.transcript, '');
      expect(cubit.state.errorMessage, isNull);
    });
  });
}
