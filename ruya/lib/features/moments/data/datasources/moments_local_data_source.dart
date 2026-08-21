import 'package:ruya/features/moments/domain/entities/moment_item.dart';

abstract class MomentsLocalDataSource {
  Future<List<MomentItem>> getMoments();
  Future<MomentItem> getMomentById(int id);
  Future<MomentItem> addMoment(MomentItem moment);
  Future<MomentItem> addPhotoToMoment(int momentId, MomentPhoto photo);
  Future<MomentItem> deletePhotoFromMoment(int momentId, int photoId);
  Future<MomentItem> updateMoment(MomentItem updatedMoment);
}

class MomentsLocalDataSourceImpl implements MomentsLocalDataSource {
  // Prepopulated static mock memories as shown in design
  final List<MomentItem> _moments = [
    MomentItem(
      id: 1,
      title: 'Luxor & Valley of the Kings',
      startDate: 'Jan 2026',
      coverImageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
      photoCount: 3,
      createdAt: DateTime(2026, 1, 1),
      photos: [
        MomentPhoto(
          id: 101,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Karnak',
          dayLabel: 'DAY 1',
          createdAt: DateTime(2026, 1, 1),
        ),
        MomentPhoto(
          id: 102,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Luxor',
          dayLabel: 'DAY 2',
          createdAt: DateTime(2026, 1, 2),
        ),
        MomentPhoto(
          id: 103,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Valley',
          dayLabel: 'DAY 2',
          createdAt: DateTime(2026, 1, 2),
        ),
      ],
    ),
    MomentItem(
      id: 2,
      title: 'Giza Pyramid Complex',
      startDate: 'Nov 2025',
      coverImageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
      photoCount: 2,
      createdAt: DateTime(2025, 11, 1),
      photos: [
        MomentPhoto(
          id: 104,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Great Pyramid',
          dayLabel: 'DAY 1',
          createdAt: DateTime(2025, 11, 1),
        ),
        MomentPhoto(
          id: 105,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Sphinx',
          dayLabel: 'DAY 1',
          createdAt: DateTime(2025, 11, 1),
        ),
      ],
    ),
    MomentItem(
      id: 3,
      title: 'Aswan & Philae Temple',
      startDate: 'Sep 2025',
      coverImageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
      photoCount: 1,
      createdAt: DateTime(2025, 9, 1),
      photos: [
        MomentPhoto(
          id: 106,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Philae',
          dayLabel: 'DAY 1',
          createdAt: DateTime(2025, 9, 1),
        ),
      ],
    ),
    MomentItem(
      id: 4,
      title: 'Cairo Museum Tour',
      startDate: 'Jul 2025',
      coverImageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
      photoCount: 1,
      createdAt: DateTime(2025, 7, 1),
      photos: [
        MomentPhoto(
          id: 107,
          imageUrl: 'https://res.cloudinary.com/demo/image/upload/sample.jpg',
          caption: 'Tahrir Museum',
          dayLabel: 'DAY 1',
          createdAt: DateTime(2025, 7, 1),
        ),
      ],
    ),
  ];

  @override
  Future<List<MomentItem>> getMoments() async {
    // Simulate lightweight async fetch
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_moments);
  }

  @override
  Future<MomentItem> getMomentById(int id) async {
    final moment = _moments.firstWhere(
      (m) => m.id == id,
      orElse: () => _moments.first,
    );
    return moment;
  }

  @override
  Future<MomentItem> addMoment(MomentItem moment) async {
    _moments.insert(0, moment);
    return moment;
  }

  @override
  Future<MomentItem> addPhotoToMoment(int momentId, MomentPhoto photo) async {
    final index = _moments.indexWhere((m) => m.id == momentId);
    if (index != -1) {
      final existing = _moments[index];
      final updatedPhotos = List<MomentPhoto>.from(existing.photos)..add(photo);
      final updatedMoment = existing.copyWith(photos: updatedPhotos);
      _moments[index] = updatedMoment;
      return updatedMoment;
    }
    throw Exception('Moment not found');
  }

  @override
  Future<MomentItem> deletePhotoFromMoment(int momentId, int photoId) async {
    final index = _moments.indexWhere((m) => m.id == momentId);
    if (index != -1) {
      final existing = _moments[index];
      final updatedPhotos =
          existing.photos.where((p) => p.id != photoId).toList();
      final updatedMoment = existing.copyWith(photos: updatedPhotos);
      _moments[index] = updatedMoment;
      return updatedMoment;
    }
    throw Exception('Moment not found');
  }

  @override
  Future<MomentItem> updateMoment(MomentItem updatedMoment) async {
    final index = _moments.indexWhere((m) => m.id == updatedMoment.id);
    if (index != -1) {
      _moments[index] = updatedMoment;
      return updatedMoment;
    }
    throw Exception('Moment not found');
  }
}
