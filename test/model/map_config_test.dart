import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skkumap/features/campus_map/model/map_config.dart';
import 'package:skkumap/features/building/model/building.dart';

void main() {
  group('MapConfig.fromJson', () {
    test('parses full config with campuses and layers', () {
      final json = {
        'meta': {},
        'data': {
          'campuses': [
            {
              'id': 'hssc',
              'label': '인사캠',
              'centerLat': 37.587241,
              'centerLng': 126.992858,
              'defaultZoom': 15.8,
            },
            {
              'id': 'nsc',
              'label': '자과캠',
              'centerLat': 37.293580,
              'centerLng': 126.974942,
            },
          ],
          'layers': [
            {
              'id': 'campus_buildings',
              'type': 'marker',
              'label': '건물번호',
              'defaultVisible': true,
              'endpoint': '/map/markers/campus',
            },
            {
              'id': 'bus_route_hssc',
              'type': 'polyline',
              'label': '인사캠 셔틀노선',
              'defaultVisible': true,
              'endpoint': '/bus/hssc/overlay',
              'style': {'color': '2D8C4E'},
            },
          ],
        },
      };

      final config = MapConfig.fromJson(json);
      expect(config.campuses.length, 2);
      expect(config.layers.length, 2);

      final hssc = config.campuses[0];
      expect(hssc.id, 'hssc');
      expect(hssc.label, '인사캠');
      expect(hssc.centerLat, 37.587241);
      expect(hssc.centerLng, 126.992858);
      expect(hssc.defaultZoom, 15.8);

      final nsc = config.campuses[1];
      expect(nsc.id, 'nsc');
      expect(nsc.defaultZoom, 15.8); // default

      final marker = config.layers[0];
      expect(marker.id, 'campus_buildings');
      expect(marker.type, 'marker');
      expect(marker.label, '건물번호');
      expect(marker.defaultVisible, true);
      expect(marker.endpoint, '/map/markers/campus');
      expect(marker.style, isNull);

      final polyline = config.layers[1];
      expect(polyline.id, 'bus_route_hssc');
      expect(polyline.type, 'polyline');
      expect(polyline.style, isNotNull);
      expect(polyline.style!.color, const Color(0xFF2D8C4E));
    });

    test('parses empty campuses and layers', () {
      final json = {
        'meta': {},
        'data': {'layers': []},
      };
      final config = MapConfig.fromJson(json);
      expect(config.layers, isEmpty);
      expect(config.campuses, isEmpty);
    });

    test('campus() lookup returns correct campus or null', () {
      final json = {
        'meta': {},
        'data': {
          'campuses': [
            {
              'id': 'hssc',
              'label': '인사캠',
              'centerLat': 37.587,
              'centerLng': 126.993,
            },
          ],
          'layers': [],
        },
      };
      final config = MapConfig.fromJson(json);
      expect(config.campus('hssc'), isNotNull);
      expect(config.campus('hssc')!.label, '인사캠');
      expect(config.campus('nsc'), isNull);
      expect(config.campus('unknown'), isNull);
    });
  });

  group('CampusDef.fromJson', () {
    test('parses all fields', () {
      final json = {
        'id': 'hssc',
        'label': '인사캠',
        'centerLat': 37.587241,
        'centerLng': 126.992858,
        'defaultZoom': 16.0,
      };
      final campus = CampusDef.fromJson(json);
      expect(campus.id, 'hssc');
      expect(campus.label, '인사캠');
      expect(campus.centerLat, 37.587241);
      expect(campus.centerLng, 126.992858);
      expect(campus.defaultZoom, 16.0);
    });

    test('defaults defaultZoom to 15.8 when missing', () {
      final json = {
        'id': 'nsc',
        'label': '자과캠',
        'centerLat': 37.2936,
        'centerLng': 126.9749,
      };
      final campus = CampusDef.fromJson(json);
      expect(campus.defaultZoom, 15.8);
    });

    test('handles integer coordinates', () {
      final json = {
        'id': 'test',
        'label': 'Test',
        'centerLat': 37,
        'centerLng': 127,
      };
      final campus = CampusDef.fromJson(json);
      expect(campus.centerLat, 37.0);
      expect(campus.centerLng, 127.0);
    });

    test('defaults tilt and bearing to 0 when missing', () {
      final json = {
        'id': 'hssc',
        'label': '인사캠',
        'centerLat': 37.587,
        'centerLng': 126.993,
      };
      final campus = CampusDef.fromJson(json);
      expect(campus.defaultTilt, 0);
      expect(campus.defaultBearing, 0);
    });

    test('parses tilt and bearing when present', () {
      final json = {
        'id': 'hssc',
        'label': '인사캠',
        'centerLat': 37.587,
        'centerLng': 126.993,
        'defaultTilt': 30,
        'defaultBearing': 45.5,
      };
      final campus = CampusDef.fromJson(json);
      expect(campus.defaultTilt, 30.0);
      expect(campus.defaultBearing, 45.5);
    });
  });

  group('MapLayerDef.fromJson', () {
    test('defaults defaultVisible to false when missing', () {
      final json = {
        'id': 'test',
        'type': 'marker',
        'label': 'Test',
        'endpoint': '/test',
      };
      final layer = MapLayerDef.fromJson(json);
      expect(layer.defaultVisible, false);
    });

    test('parses style with color', () {
      final json = {
        'id': 'test',
        'type': 'polyline',
        'label': 'Test',
        'defaultVisible': true,
        'endpoint': '/test',
        'style': {'color': 'FF0000'},
      };
      final layer = MapLayerDef.fromJson(json);
      expect(layer.style, isNotNull);
      expect(layer.style!.color, const Color(0xFFFF0000));
    });

    test('handles null style', () {
      final json = {
        'id': 'test',
        'type': 'marker',
        'label': 'Test',
        'defaultVisible': false,
        'endpoint': '/test',
      };
      final layer = MapLayerDef.fromJson(json);
      expect(layer.style, isNull);
    });
  });

  group('MapLayerStyle.fromJson', () {
    test('parses valid hex color', () {
      final style = MapLayerStyle.fromJson({'color': '1A5FA8'});
      expect(style.color, const Color(0xFF1A5FA8));
    });

    test('handles null color field', () {
      final style = MapLayerStyle.fromJson({});
      expect(style.color, isNull);
    });

    test('all fields null when empty JSON', () {
      final style = MapLayerStyle.fromJson({});
      expect(style.color, isNull);
      expect(style.outlineColor, isNull);
      expect(style.width, isNull);
      expect(style.size, isNull);
      expect(style.captionTextSize, isNull);
    });

    test('parses polyline style fields', () {
      final style = MapLayerStyle.fromJson({
        'color': '4CAF50',
        'outlineColor': 'FFFFFF',
        'width': 6,
      });
      expect(style.color, const Color(0xFF4CAF50));
      expect(style.outlineColor, const Color(0xFFFFFFFF));
      expect(style.width, 6.0);
    });

    test('parses marker style fields', () {
      final style = MapLayerStyle.fromJson({
        'size': 30,
        'captionTextSize': 10,
      });
      expect(style.size, 30.0);
      expect(style.captionTextSize, 10.0);
    });
  });

  group('Building.fromJson', () {
    test('parses full building with GeoJSON coordinate swap', () {
      final json = {
        '_id': 27,
        'buildNo': '248',
        'type': 'building',
        'campus': 'nsc',
        'name': {'ko': '삼성학술정보관', 'en': 'Samsung Library'},
        'location': {
          'type': 'Point',
          'coordinates': [126.974906, 37.293885], // [lng, lat]
        },
      };
      final building = Building.fromJson(json);
      expect(building.skkuId, 27);
      expect(building.buildNo, '248');
      expect(building.type, 'building');
      expect(building.campus, 'nsc');
      expect(building.name.ko, '삼성학술정보관');
      // Verify GeoJSON [lng, lat] → lat, lng swap
      expect(building.lat, 37.293885);
      expect(building.lng, 126.974906);
    });

    test('handles facility with null buildNo', () {
      final json = {
        '_id': 50,
        'type': 'facility',
        'campus': 'hssc',
        'name': {'ko': '정문', 'en': 'Main Gate'},
        'location': {
          'type': 'Point',
          'coordinates': [126.993, 37.587],
        },
      };
      final building = Building.fromJson(json);
      expect(building.buildNo, isNull);
      expect(building.isFacility, true);
      expect(building.isBuilding, false);
    });
  });
}
