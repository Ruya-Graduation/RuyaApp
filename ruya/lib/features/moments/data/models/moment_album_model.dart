import 'package:ruya/features/moments/domain/entities/moment_item.dart';

class MomentAlbumModel extends MomentItem {
  const MomentAlbumModel({
    required super.id,
    required super.title,
    required super.startDate,
    required super.coverImageUrl,
    required super.photoCount,
    required super.createdAt,
    super.photos,
  });

  factory MomentAlbumModel.fromJson(Map<String, dynamic> json) =>
      MomentAlbumModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        startDate: json['startDate'] as String? ?? '',
        coverImageUrl: json['coverPhotoUrl'] as String?,
        photoCount: json['photoCount'] as int? ?? 0,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
      );
}
