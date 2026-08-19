import 'package:equatable/equatable.dart';

class MomentItem extends Equatable {
  final String id;
  final String title;
  final String monthYear; // e.g. "Jan 2026"
  final String coverImagePath;
  final bool isCoverAsset;
  final List<MomentPhoto> photos;

  const MomentItem({
    required this.id,
    required this.title,
    required this.monthYear,
    required this.coverImagePath,
    this.isCoverAsset = true,
    this.photos = const [],
  });

  MomentItem copyWith({
    String? id,
    String? title,
    String? monthYear,
    String? coverImagePath,
    bool? isCoverAsset,
    List<MomentPhoto>? photos,
  }) {
    return MomentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      monthYear: monthYear ?? this.monthYear,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      isCoverAsset: isCoverAsset ?? this.isCoverAsset,
      photos: photos ?? this.photos,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        monthYear,
        coverImagePath,
        isCoverAsset,
        photos,
      ];
}

class MomentPhoto extends Equatable {
  final String id;
  final String imagePath;
  final bool isAsset;
  final String? caption;
  final String? dayLabel; // e.g. "DAY 1"

  const MomentPhoto({
    required this.id,
    required this.imagePath,
    this.isAsset = true,
    this.caption,
    this.dayLabel,
  });

  @override
  List<Object?> get props => [id, imagePath, isAsset, caption, dayLabel];
}
