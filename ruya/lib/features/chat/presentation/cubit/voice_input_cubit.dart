import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ruya/core/services/speech_to_text_service.dart';
import 'package:ruya/core/services/tts_service.dart';
import 'package:ruya/features/chat/presentation/cubit/voice_input_state.dart';

class VoiceInputCubit extends Cubit<VoiceInputState> {
  final SpeechToTextService speechToTextService;
  final TtsService ttsService;

  VoiceInputCubit({
    required this.speechToTextService,
    required this.ttsService,
  }) : super(const VoiceInputState()) {
    _initAvailability();
  }

  Future<void> _initAvailability() async {
    final available = await speechToTextService.initialize();
    emit(state.copyWith(
      isAvailable: available,
      status: available ? VoiceInputStatus.idle : VoiceInputStatus.unavailable,
    ));
  }

  /// Request permissions and starts audio transcription if granted.
  Future<void> startListening({String? languageCode}) async {
    // 1. Immediately cut off any playing TTS so audio doesn't overlap
    await ttsService.stop();

    // 2. Check mic permission
    final micStatus = await Permission.microphone.request();
    if (micStatus.isPermanentlyDenied) {
      emit(state.copyWith(status: VoiceInputStatus.permissionPermanentlyDenied));
      return;
    }
    if (micStatus.isDenied) {
      emit(state.copyWith(status: VoiceInputStatus.permissionDenied));
      return;
    }

    // 3. Check speech permission if required by platform
    final speechStatus = await Permission.speech.request();
    if (speechStatus.isPermanentlyDenied) {
      emit(state.copyWith(status: VoiceInputStatus.permissionPermanentlyDenied));
      return;
    }
    if (speechStatus.isDenied) {
      emit(state.copyWith(status: VoiceInputStatus.permissionDenied));
      return;
    }

    // 4. Initialize STT if needed
    final available = await speechToTextService.initialize();
    if (!available) {
      emit(state.copyWith(
        isAvailable: false,
        status: VoiceInputStatus.unavailable,
      ));
      return;
    }

    // 5. Start listening
    emit(state.copyWith(
      status: VoiceInputStatus.listening,
      transcript: '',
      clearErrorMessage: true,
    ));

    final localeId = languageCode?.startsWith('ar') == true ? 'ar_EG' : 'en_US';

    try {
      await speechToTextService.startListening(
        localeId: localeId,
        onResult: (text, isFinal) {
          emit(state.copyWith(
            transcript: text,
            status: isFinal
                ? VoiceInputStatus.processing
                : VoiceInputStatus.listening,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Stops speech listening and returns the finalized transcript.
  Future<String> stopListening() async {
    await speechToTextService.stopListening();
    final finalTranscript = state.transcript.trim();
    emit(state.copyWith(status: VoiceInputStatus.idle));
    return finalTranscript;
  }

  /// Cancels listening and clears current transcript.
  Future<void> cancelListening() async {
    await speechToTextService.cancelListening();
    emit(state.copyWith(
      status: VoiceInputStatus.idle,
      transcript: '',
    ));
  }

  /// Resets back to idle.
  void reset() {
    emit(state.copyWith(
      status: state.isAvailable
          ? VoiceInputStatus.idle
          : VoiceInputStatus.unavailable,
      transcript: '',
      clearErrorMessage: true,
    ));
  }

  @override
  Future<void> close() {
    speechToTextService.cancelListening();
    return super.close();
  }
}
