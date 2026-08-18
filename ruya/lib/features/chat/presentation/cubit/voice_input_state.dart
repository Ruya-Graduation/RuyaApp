import 'package:equatable/equatable.dart';

enum VoiceInputStatus {
  idle,
  listening,
  processing,
  permissionDenied,
  permissionPermanentlyDenied,
  unavailable,
  error,
}

class VoiceInputState extends Equatable {
  final VoiceInputStatus status;
  final String transcript;
  final bool isAvailable;
  final String? errorMessage;

  const VoiceInputState({
    this.status = VoiceInputStatus.idle,
    this.transcript = '',
    this.isAvailable = true,
    this.errorMessage,
  });

  bool get isListening => status == VoiceInputStatus.listening;

  VoiceInputState copyWith({
    VoiceInputStatus? status,
    String? transcript,
    bool? isAvailable,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return VoiceInputState(
      status: status ?? this.status,
      transcript: transcript ?? this.transcript,
      isAvailable: isAvailable ?? this.isAvailable,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, transcript, isAvailable, errorMessage];
}
