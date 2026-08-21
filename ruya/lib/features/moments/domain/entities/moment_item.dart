import 'package:equatable/equatable.dart';

class MomentItem extends Equatable {
  final int id;
  final String title;
  final String startDate; // e.g. "Jan 2026" — free text, matches backend StartDate
  final String? coverImageUrl; // Cloudinary URL, nullable
  final int photoCount;
  final DateTime createdAt;
  final List<MomentPhoto> photos; // empty for list view, populated for details view

  const MomentItem({
    required this.id,
    required this.title,
    required this.startDate,
    required this.coverImageUrl,
    required this.photoCount,
    required this.createdAt,
    this.photos = const [],
  });

  MomentItem copyWith({
    int? id,
    String? title,
    String? startDate,
    String? coverImageUrl,
    int? photoCount,
    DateTime? createdAt,
    List<MomentPhoto>? photos,
  }) {
    return MomentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      photoCount: photoCount ?? this.photoCount,
      createdAt: createdAt ?? this.createdAt,
      photos: photos ?? this.photos,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, startDate, coverImageUrl, photoCount, createdAt, photos];
}

class MomentPhoto extends Equatable {
  final int id;
  final String imageUrl; // Cloudinary URL
  final String? caption;
  final String? dayLabel;
  final DateTime createdAt;

  const MomentPhoto({
    required this.id,
    required this.imageUrl,
    this.caption,
    this.dayLabel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, imageUrl, caption, dayLabel, createdAt];
}
