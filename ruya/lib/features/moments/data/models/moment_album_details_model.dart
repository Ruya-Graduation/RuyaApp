import 'package:ruya/features/moments/data/models/moment_photo_model.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';

class MomentAlbumDetailsModel extends MomentItem {
  const MomentAlbumDetailsModel({
    required super.id,
    required super.title,
    required super.startDate,
    required super.coverImageUrl,
    required super.photoCount,
    required super.createdAt,
    required super.photos,
  });

  factory MomentAlbumDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'];
    final List<MomentPhoto> photos = [];
    if (rawPhotos is List) {
      photos.addAll(
        rawPhotos
            .whereType<Map<String, dynamic>>()
            .map((p) => MomentPhotoModel.fromJson(p)),
      );
    }

    return MomentAlbumDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      coverImageUrl: json['coverPhotoUrl'] as String?,
      photoCount: json['photoCount'] as int? ?? photos.length,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      photos: photos,
    );
  }
}
