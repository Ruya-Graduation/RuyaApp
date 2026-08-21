import 'package:ruya/features/moments/domain/entities/moment_item.dart';

class MomentPhotoModel extends MomentPhoto {
  const MomentPhotoModel({
    required super.id,
    required super.imageUrl,
    super.caption,
    super.dayLabel,
    required super.createdAt,
  });

  factory MomentPhotoModel.fromJson(Map<String, dynamic> json) =>
      MomentPhotoModel(
        id: json['id'] as int,
        imageUrl: json['photoUrl'] as String? ?? '',
        caption: json['caption'] as String?,
        dayLabel: json['dayLabel'] as String?,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
      );
}
