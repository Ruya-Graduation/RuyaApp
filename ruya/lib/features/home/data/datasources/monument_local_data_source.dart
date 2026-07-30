import 'package:ruya/features/home/data/models/monument_model.dart';

/// Abstract contract for monument local data access.
abstract class MonumentLocalDataSource {
  /// Returns a list of [MonumentModel] objects.
  /// Throws a [Exception] if something goes wrong.
  Future<List<MonumentModel>> getMonuments();
}

/// Fake local datasource that returns mock monument data.
/// Replace this with a real API/database implementation later.
class FakeMonumentLocalDataSource implements MonumentLocalDataSource {
  static const List<MonumentModel> _mockMonuments = [
    MonumentModel(
      id: '1',
      name: 'Karnak Temple Complex',
      location: 'Luxor, Upper Egypt',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Low Crowds',
    ),
    MonumentModel(
      id: '2',
      name: 'Great Pyramid of Giza',
      location: 'Giza, Greater Cairo',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Moderate',
    ),
    MonumentModel(
      id: '3',
      name: 'Abu Simbel Temples',
      location: 'Aswan, Upper Egypt',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Low Crowds',
    ),
    MonumentModel(
      id: '4',
      name: 'Egyptian Museum',
      location: 'Cairo, Greater Cairo',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'High Crowds',
    ),
    MonumentModel(
      id: '5',
      name: 'Valley of the Kings',
      location: 'Luxor, Upper Egypt',
      imagePath: 'assets/images/egyptian_pyramids.png',
      crowdsLevel: 'Moderate',
    ),
  ];

  @override
  Future<List<MonumentModel>> getMonuments() async {
    // Simulate a short network / DB delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMonuments;
  }
}
