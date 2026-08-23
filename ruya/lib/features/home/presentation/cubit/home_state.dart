import 'package:equatable/equatable.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<MonumentEntity> monuments;
  final String? errorMessage;
  final int selectedFilterIndex;
  final String searchQuery;

  const HomeState({
    this.status = HomeStatus.initial,
    this.monuments = const [],
    this.errorMessage,
    this.selectedFilterIndex = 0,
    this.searchQuery = '',
  });

  /// Filtered monuments based on selected city filter and search query.
  List<MonumentEntity> get filteredMonuments {
    var list = monuments;

    // Apply city / region filters
    if (selectedFilterIndex == 1) {
      // Giza / الجيزة
      list = list.where((m) {
        final loc = m.location.toLowerCase();
        final name = m.name.toLowerCase();
        return loc.contains('giza') ||
            loc.contains('جيزة') ||
            name.contains('giza') ||
            name.contains('جيزة');
      }).toList();
    } else if (selectedFilterIndex == 2) {
      // Luxor / الأقصر
      list = list.where((m) {
        final loc = m.location.toLowerCase();
        final name = m.name.toLowerCase();
        return loc.contains('luxor') ||
            loc.contains('أقصر') ||
            loc.contains('اقصر') ||
            name.contains('luxor') ||
            name.contains('أقصر') ||
            name.contains('اقصر');
      }).toList();
    } else if (selectedFilterIndex == 3) {
      // Aswan / أسوان
      list = list.where((m) {
        final loc = m.location.toLowerCase();
        final name = m.name.toLowerCase();
        return loc.contains('aswan') ||
            loc.contains('أسوان') ||
            loc.contains('اسوان') ||
            name.contains('aswan') ||
            name.contains('أسوان') ||
            name.contains('اسوان');
      }).toList();
    } else if (selectedFilterIndex == 4) {
      // Cairo / القاهرة
      list = list.where((m) {
        final loc = m.location.toLowerCase();
        final name = m.name.toLowerCase();
        return loc.contains('cairo') ||
            loc.contains('قاهرة') ||
            name.contains('cairo') ||
            name.contains('قاهرة');
      }).toList();
    }

    // Apply search query
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      list = list.where((m) {
        return m.name.toLowerCase().contains(query) ||
            m.location.toLowerCase().contains(query) ||
            m.crowdsLevel.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  HomeState copyWith({
    HomeStatus? status,
    List<MonumentEntity>? monuments,
    Object? errorMessage = _keep,
    int? selectedFilterIndex,
    String? searchQuery,
  }) {
    return HomeState(
      status: status ?? this.status,
      monuments: monuments ?? this.monuments,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [status, monuments, errorMessage, selectedFilterIndex, searchQuery];
}

/// Sentinel value used in [HomeState.copyWith] to distinguish
/// between "don't change" and "set to null".
const Object _keep = Object();
