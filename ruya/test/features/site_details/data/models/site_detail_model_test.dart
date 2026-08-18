import 'package:flutter_test/flutter_test.dart';
import 'package:ruya/features/site_details/data/models/site_detail_model.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';

void main() {
  group('SiteDetailModel', () {
    test('is a subclass of SiteDetailEntity', () {
      const model = SiteDetailModel(
        id: '2',
        name: 'Grand Egyptian Museum (GEM)',
        city: 'Giza',
        country: 'Egypt',
        latitude: 29.9932,
        longitude: 31.1173,
        hours: '9:00 AM - 5:00 PM',
        ticketRaw: '400 EGP',
        ticketPrice: 400.0,
        ticketCurrency: 'EGP',
        crowds: 'Very High',
        description: 'A museum of ancient Egyptian antiquities.',
      );

      expect(model, isA<SiteDetailEntity>());
    });

    test('fromJson parses standard backend API response format correctly', () {
      final json = {
        'id': 2,
        'name': 'Grand Egyptian Museum (GEM)',
        'city': 'Giza',
        'country': 'Egypt',
        'latitude': 29.9932,
        'longitude': 31.1173,
        'hours': '9:00 AM - 5:00 PM',
        'ticket': '400 EGP',
        'crowds': 'Very High',
        'description': 'A world-class museum.',
      };

      final model = SiteDetailModel.fromJson(json);

      expect(model.id, '2');
      expect(model.name, 'Grand Egyptian Museum (GEM)');
      expect(model.city, 'Giza');
      expect(model.country, 'Egypt');
      expect(model.latitude, 29.9932);
      expect(model.longitude, 31.1173);
      expect(model.hours, '9:00 AM - 5:00 PM');
      expect(model.ticketRaw, '400 EGP');
      expect(model.ticketPrice, 400.0);
      expect(model.ticketCurrency, 'EGP');
      expect(model.crowds, 'Very High');
      expect(model.description, 'A world-class museum.');
      expect(model.imageUrl, isNull);
    });

    test('fromJson handles numeric ticket and custom currency gracefully', () {
      final json = {
        'id': '10',
        'name': 'Abu Simbel',
        'city': 'Aswan',
        'country': 'Egypt',
        'ticket': 500,
      };

      final model = SiteDetailModel.fromJson(json);
      expect(model.id, '10');
      expect(model.ticketPrice, 500.0);
      expect(model.ticketCurrency, 'EGP');
    });

    test('fromJson handles malformed ticket without throwing', () {
      final json = {
        'id': '10',
        'name': 'Karnak',
        'ticket': 'Free Entry',
      };

      final model = SiteDetailModel.fromJson(json);
      expect(model.ticketPrice, 0.0);
      expect(model.ticketCurrency, 'EGP');
    });

    test('toJson produces expected map', () {
      const model = SiteDetailModel(
        id: '2',
        name: 'GEM',
        city: 'Giza',
        country: 'Egypt',
        latitude: 29.99,
        longitude: 31.11,
        hours: '9-5',
        ticketRaw: '400 EGP',
        ticketPrice: 400.0,
        ticketCurrency: 'EGP',
        crowds: 'High',
        description: 'Desc',
      );

      final json = model.toJson();
      expect(json['id'], '2');
      expect(json['ticket'], '400 EGP');
    });
  });
}
