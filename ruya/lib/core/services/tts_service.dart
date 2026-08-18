import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

/// Thin service wrapper around [FlutterTts] for auto-narration & replay.
class TtsService {
  FlutterTts? _flutterTts;
  TtsState _state = TtsState.stopped;
  final StreamController<TtsState> _stateController =
      StreamController<TtsState>.broadcast();

  TtsService({FlutterTts? flutterTts}) {
    if (flutterTts != null) {
      _flutterTts = flutterTts;
      _initTts(flutterTts);
    }
  }

  FlutterTts get _tts {
    _flutterTts ??= FlutterTts();
    _initTts(_flutterTts!);
    return _flutterTts!;
  }

  TtsState get state => _state;
  bool get isPlaying => _state == TtsState.playing;
  Stream<TtsState> get stateStream => _stateController.stream;

  void _initTts(FlutterTts tts) {
    tts.setStartHandler(() {
      _state = TtsState.playing;
      _stateController.add(_state);
    });

    tts.setCompletionHandler(() {
      _state = TtsState.stopped;
      _stateController.add(_state);
    });

    tts.setCancelHandler(() {
      _state = TtsState.stopped;
      _stateController.add(_state);
    });

    tts.setErrorHandler((msg) {
      debugPrint('[TtsService] Error: $msg');
      _state = TtsState.stopped;
      _stateController.add(_state);
    });
  }

  /// Speaks the given [text]. Maps language code ('ar' -> 'ar-EG', 'en' -> 'en-US').
  Future<void> speak(String text, {String? language}) async {
    if (text.trim().isEmpty) return;

    try {
      await stop();

      final langCode = language?.toLowerCase() ?? 'en';
      final ttsLang = langCode.startsWith('ar') ? 'ar-EG' : 'en-US';

      await _tts.setLanguage(ttsLang);
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      final result = await _tts.speak(text);
      if (result == 1) {
        _state = TtsState.playing;
        _stateController.add(_state);
      }
    } catch (e) {
      debugPrint('[TtsService] Exception while speaking: $e');
      _state = TtsState.stopped;
      _stateController.add(_state);
    }
  }

  /// Stops any currently playing speech.
  Future<void> stop() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts!.stop();
      }
    } catch (e) {
      debugPrint('[TtsService] Stop exception: $e');
    } finally {
      _state = TtsState.stopped;
      _stateController.add(_state);
    }
  }

  void dispose() {
    _stateController.close();
  }
}
