import 'package:equatable/equatable.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<MonumentEntity> monuments;
  final String? errorMessage;
  final int selectedFilterIndex;

  const HomeState({
    this.status = HomeStatus.initial,
    this.monuments = const [],
    this.errorMessage,
    this.selectedFilterIndex = 0,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<MonumentEntity>? monuments,
    // Use a sentinel value so callers can explicitly clear the error.
    Object? errorMessage = _keep,
    int? selectedFilterIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      monuments: monuments ?? this.monuments,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
    );
  }

  @override
  List<Object?> get props =>
      [status, monuments, errorMessage, selectedFilterIndex];
}

/// Sentinel value used in [HomeState.copyWith] to distinguish
/// between "don't change" and "set to null".
const Object _keep = Object();
