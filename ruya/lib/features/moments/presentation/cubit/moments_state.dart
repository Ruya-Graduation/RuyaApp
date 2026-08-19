import 'package:equatable/equatable.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';

enum MomentsStatus { initial, loading, loaded, error }

class MomentsState extends Equatable {
  final MomentsStatus status;
  final List<MomentItem> moments;
  final MomentItem? selectedMoment;
  final String? errorMessage;

  const MomentsState({
    this.status = MomentsStatus.initial,
    this.moments = const [],
    this.selectedMoment,
    this.errorMessage,
  });

  MomentsState copyWith({
    MomentsStatus? status,
    List<MomentItem>? moments,
    MomentItem? selectedMoment,
    String? errorMessage,
  }) {
    return MomentsState(
      status: status ?? this.status,
      moments: moments ?? this.moments,
      selectedMoment: selectedMoment ?? this.selectedMoment,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, moments, selectedMoment, errorMessage];
}
