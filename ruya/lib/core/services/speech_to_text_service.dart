import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Thin service wrapper around the [SpeechToText] engine.
///
/// Encapsulates initialization, permission detection, listening state,
/// and streaming partial/final recognition results.
class SpeechToTextService {
  final SpeechToText _speechToText;
  bool _isInitialized = false;
  bool _isAvailable = false;

  SpeechToTextService({SpeechToText? speechToText})
      : _speechToText = speechToText ?? SpeechToText();

  bool get isInitialized => _isInitialized;
  bool get isAvailable => _isAvailable;
  bool get isListening => _speechToText.isListening;

  /// Initializes the underlying speech recognizer. Safe to call multiple times.
  Future<bool> initialize() async {
    if (_isInitialized) return _isAvailable;

    try {
      _isAvailable = await _speechToText.initialize(
        onError: (SpeechRecognitionError error) {
          debugPrint('[SpeechToTextService] Error: ${error.errorMsg} (permanent: ${error.permanent})');
        },
        onStatus: (String status) {
          debugPrint('[SpeechToTextService] Status: $status');
        },
      );
      _isInitialized = true;
      return _isAvailable;
    } catch (e) {
      debugPrint('[SpeechToTextService] Init exception: $e');
      _isInitialized = true;
      _isAvailable = false;
      return false;
    }
  }

  /// Starts listening and pipes partial & final transcripts to [onResult].
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    String? localeId,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_isAvailable) {
      debugPrint('[SpeechToTextService] Cannot start listening: STT unavailable on this device.');
      return;
    }

    if (_speechToText.isListening) {
      await _speechToText.stop();
    }

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
        localeId: localeId,
      ),
    );
  }

  /// Stops listening and commits the final recognized transcript.
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  /// Cancels listening and discards current audio buffer.
  Future<void> cancelListening() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
    }
  }
}
