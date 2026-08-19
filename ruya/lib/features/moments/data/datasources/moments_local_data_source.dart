import 'package:ruya/features/moments/domain/entities/moment_item.dart';

abstract class MomentsLocalDataSource {
  Future<List<MomentItem>> getMoments();
  Future<MomentItem> getMomentById(String id);
  Future<MomentItem> addMoment(MomentItem moment);
  Future<MomentItem> addPhotoToMoment(String momentId, MomentPhoto photo);
  Future<MomentItem> deletePhotoFromMoment(String momentId, String photoId);
  Future<MomentItem> updateMoment(MomentItem updatedMoment);
}

class MomentsLocalDataSourceImpl implements MomentsLocalDataSource {
  // Prepopulated static mock memories as shown in design
  final List<MomentItem> _moments = [
    const MomentItem(
      id: 'luxor-2026',
      title: 'Luxor & Valley of the Kings',
      monthYear: 'Jan 2026',
      coverImagePath: 'assets/images/egyptian_pyramids.png',
      isCoverAsset: true,
      photos: [
        MomentPhoto(
          id: 'p1',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Karnak',
          dayLabel: 'DAY 1',
        ),
        MomentPhoto(
          id: 'p2',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Luxor',
          dayLabel: 'DAY 2',
        ),
        MomentPhoto(
          id: 'p3',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Valley',
          dayLabel: 'DAY 2',
        ),
      ],
    ),
    const MomentItem(
      id: 'giza-2025',
      title: 'Giza Pyramid Complex',
      monthYear: 'Nov 2025',
      coverImagePath: 'assets/images/egyptian_pyramids.png',
      isCoverAsset: true,
      photos: [
        MomentPhoto(
          id: 'p4',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Great Pyramid',
          dayLabel: 'DAY 1',
        ),
        MomentPhoto(
          id: 'p5',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Sphinx',
          dayLabel: 'DAY 1',
        ),
      ],
    ),
    const MomentItem(
      id: 'aswan-2025',
      title: 'Aswan & Philae Temple',
      monthYear: 'Sep 2025',
      coverImagePath: 'assets/images/egyptian_pyramids.png',
      isCoverAsset: true,
      photos: [
        MomentPhoto(
          id: 'p6',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Philae',
          dayLabel: 'DAY 1',
        ),
      ],
    ),
    const MomentItem(
      id: 'cairo-2025',
      title: 'Cairo Museum Tour',
      monthYear: 'Jul 2025',
      coverImagePath: 'assets/images/egyptian_pyramids.png',
      isCoverAsset: true,
      photos: [
        MomentPhoto(
          id: 'p7',
          imagePath: 'assets/images/egyptian_pyramids.png',
          isAsset: true,
          caption: 'Tahrir Museum',
          dayLabel: 'DAY 1',
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
  Future<MomentItem> getMomentById(String id) async {
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
  Future<MomentItem> addPhotoToMoment(String momentId, MomentPhoto photo) async {
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
  Future<MomentItem> deletePhotoFromMoment(
      String momentId, String photoId) async {
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
