import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruya/features/booking/data/models/local_booking_model.dart';

abstract class BookingLocalDataSource {
  Future<List<LocalBookingModel>> getAll();
  Future<void> save(LocalBookingModel booking);
  Future<void> update(LocalBookingModel booking);
  Future<void> delete(String referenceNumber);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  static const String _key = 'local_bookings_v1';
  final SharedPreferences _prefs;

  BookingLocalDataSourceImpl(this._prefs);

  @override
  Future<List<LocalBookingModel>> getAll() async {
    final rawJson = _prefs.getString(_key);
    if (rawJson == null || rawJson.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(LocalBookingModel.fromJson)
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> save(LocalBookingModel booking) async {
    final list = await getAll();
    // Replace if exists, or append
    final index = list.indexWhere(
      (b) => b.referenceNumber == booking.referenceNumber,
    );
    if (index >= 0) {
      list[index] = booking;
    } else {
      list.add(booking);
    }
    await _persist(list);
  }

  @override
  Future<void> update(LocalBookingModel booking) async {
    final list = await getAll();
    final index = list.indexWhere(
      (b) => b.referenceNumber == booking.referenceNumber,
    );
    if (index >= 0) {
      list[index] = booking;
      await _persist(list);
    }
  }

  @override
  Future<void> delete(String referenceNumber) async {
    final list = await getAll();
    list.removeWhere((b) => b.referenceNumber == referenceNumber);
    await _persist(list);
  }

  Future<void> _persist(List<LocalBookingModel> list) async {
    final encoded = jsonEncode(list.map((b) => b.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
