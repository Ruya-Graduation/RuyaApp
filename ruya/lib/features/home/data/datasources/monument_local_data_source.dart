import 'package:ruya/features/home/data/models/monument_model.dart';

/// Abstract contract for monument local data access.
abstract class MonumentLocalDataSource {
  /// Returns a list of [MonumentModel] objects.
  /// Throws a [Exception] if something goes wrong.
  Future<List<MonumentModel>> getMonuments();
}

/// Fake local datasource that returns mock monument data.
///
/// This datasource is NO LONGER WIRED INTO DI — the app uses
/// [MonumentRemoteDataSource] for all production data.
/// Kept here for reference / offline testing purposes only.
class FakeMonumentLocalDataSource implements MonumentLocalDataSource {
  static const List<MonumentModel> _mockMonuments = [
    MonumentModel(
      id: '1',
      name: 'Karnak Temple Complex',
      location: 'Luxor, Upper Egypt',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Low Crowds',
      latitude: 25.7188,
      longitude: 32.6573,
    ),
    MonumentModel(
      id: '2',
      name: 'Great Pyramid of Giza',
      location: 'Giza, Greater Cairo',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Moderate',
      latitude: 29.9792,
      longitude: 31.1342,
    ),
    MonumentModel(
      id: '3',
      name: 'Abu Simbel Temples',
      location: 'Aswan, Upper Egypt',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Low Crowds',
      latitude: 22.3372,
      longitude: 31.6258,
    ),
    MonumentModel(
      id: '4',
      name: 'Egyptian Museum',
      location: 'Cairo, Greater Cairo',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'High Crowds',
      latitude: 30.0478,
      longitude: 31.2336,
    ),
    MonumentModel(
      id: '5',
      name: 'Valley of the Kings',
      location: 'Luxor, Upper Egypt',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Moderate',
      latitude: 25.7402,
      longitude: 32.6014,
    ),
  ];

  @override
  Future<List<MonumentModel>> getMonuments() async {
    // Simulate a short network / DB delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMonuments;
  }
}
