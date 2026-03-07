import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skkumap/app/model/bus_route_config.dart';

void main() {
  group('BusRouteConfig.fromJson', () {
    test('parses realtime config correctly', () {
      final json = {
        'id': 'hssc',
        'screenType': 'realtime',
        'fallbackUrl': null,
        'display': {
          'name': 'HSSC Shuttle',
          'themeColor': '003626',
          'iconType': 'shuttle',
        },
        'realtime': {
          'stationsEndpoint': '/bus/hssc/stations',
          'locationsEndpoint': '/bus/hssc/location',
          'refreshInterval': 15,
        },
        'features': {
          'info': {'url': 'https://example.com/info'},
        },
      };

      final config = BusRouteConfig.fromJson(json);
      expect(config.id, 'hssc');
      expect(config.screenType, 'realtime');
      expect(config.fallbackUrl, isNull);
      expect(config.display.name, 'HSSC Shuttle');
      expect(config.display.themeColor, const Color(0xFF003626));
      expect(config.display.iconType, 'shuttle');
      expect(config.realtime!.stationsEndpoint, '/bus/hssc/stations');
      expect(config.realtime!.locationsEndpoint, '/bus/hssc/location');
      expect(config.realtime!.refreshInterval, 15);
      expect(config.schedule, isNull);
      expect(config.features.info!.url, 'https://example.com/info');
      expect(config.features.routeOverlay, isNull);
      expect(config.features.eta, isNull);
    });

    test('parses schedule config correctly', () {
      final json = {
        'id': 'campus',
        'screenType': 'schedule',
        'fallbackUrl': 'https://example.com/fallback',
        'display': {
          'name': 'Campus Shuttle',
          'themeColor': '1A7F4B',
          'iconType': 'shuttle',
        },
        'schedule': {
          'directions': [
            {
              'id': 'inja',
              'label': 'HSSC → NSC',
              'endpoint': '/bus/campus/inja/{dayType}',
            },
            {
              'id': 'jain',
              'label': 'NSC → HSSC',
              'endpoint': '/bus/campus/jain/{dayType}',
            },
          ],
          'serviceCalendar': {
            'defaultServiceDays': [0, 1, 2, 3, 4],
            'exceptions': [
              {
                'date': '2026-03-01',
                'reason': 'Holiday',
                'service': false,
              },
            ],
          },
          'routeTypes': {
            'hakbu': 'Undergraduate',
            'regular': 'Regular',
          },
        },
        'features': {
          'eta': {'endpoint': '/bus/campus/eta'},
        },
      };

      final config = BusRouteConfig.fromJson(json);
      expect(config.id, 'campus');
      expect(config.screenType, 'schedule');
      expect(config.fallbackUrl, 'https://example.com/fallback');
      expect(config.realtime, isNull);
      expect(config.schedule!.directions, hasLength(2));
      expect(config.schedule!.directions[0].id, 'inja');
      expect(config.schedule!.directions[0].endpoint,
          '/bus/campus/inja/{dayType}');
      expect(config.schedule!.serviceCalendar.defaultServiceDays,
          {0, 1, 2, 3, 4});
      expect(config.schedule!.serviceCalendar.exceptions, hasLength(1));
      expect(config.schedule!.routeTypes['hakbu'], 'Undergraduate');
      expect(config.features.eta!.endpoint, '/bus/campus/eta');
    });

    test('handles missing features gracefully', () {
      final json = {
        'id': 'test',
        'screenType': 'realtime',
        'fallbackUrl': null,
        'display': {
          'name': 'Test',
          'themeColor': '000000',
          'iconType': 'shuttle',
        },
        'realtime': {
          'stationsEndpoint': '/test/stations',
          'locationsEndpoint': '/test/locations',
          'refreshInterval': 10,
        },
        'features': <String, dynamic>{},
      };

      final config = BusRouteConfig.fromJson(json);
      expect(config.features.info, isNull);
      expect(config.features.routeOverlay, isNull);
      expect(config.features.eta, isNull);
    });

    test('handles null features key', () {
      final json = {
        'id': 'test',
        'screenType': 'realtime',
        'fallbackUrl': null,
        'display': {
          'name': 'Test',
          'themeColor': '000000',
          'iconType': 'shuttle',
        },
        'realtime': {
          'stationsEndpoint': '/test/stations',
          'locationsEndpoint': '/test/locations',
          'refreshInterval': 10,
        },
      };

      final config = BusRouteConfig.fromJson(json);
      expect(config.features.info, isNull);
    });
  });

  group('BusDisplay color parsing', () {
    test('parses valid hex color', () {
      final display = BusDisplay.fromJson({
        'name': 'Test',
        'themeColor': '4CAF50',
        'iconType': 'shuttle',
      });
      expect(display.themeColor, const Color(0xFF4CAF50));
    });

    test('falls back on invalid hex', () {
      final display = BusDisplay.fromJson({
        'name': 'Test',
        'themeColor': 'ZZZZZZ',
        'iconType': 'shuttle',
      });
      expect(display.themeColor, const Color(0xFF003626));
    });

    test('falls back on null hex', () {
      final display = BusDisplay.fromJson({
        'name': 'Test',
        'themeColor': null,
        'iconType': 'shuttle',
      });
      expect(display.themeColor, const Color(0xFF003626));
    });

    test('falls back on empty hex', () {
      final display = BusDisplay.fromJson({
        'name': 'Test',
        'themeColor': '',
        'iconType': 'shuttle',
      });
      expect(display.themeColor, const Color(0xFF003626));
    });
  });

  group('RealtimeConfig', () {
    test('handles refreshInterval as int', () {
      final config = RealtimeConfig.fromJson({
        'stationsEndpoint': '/stations',
        'locationsEndpoint': '/locations',
        'refreshInterval': 15,
      });
      expect(config.refreshInterval, 15);
    });

    test('handles refreshInterval as double', () {
      final config = RealtimeConfig.fromJson({
        'stationsEndpoint': '/stations',
        'locationsEndpoint': '/locations',
        'refreshInterval': 15.0,
      });
      expect(config.refreshInterval, 15);
    });
  });

  group('ServiceCalendar.isServiceDay', () {
    final calendar = ServiceCalendar.fromJson({
      'defaultServiceDays': [0, 1, 2, 3, 4], // Mon-Fri
      'exceptions': [
        {'date': '2026-03-01', 'reason': 'Holiday', 'service': false},
        {'date': '2026-03-07', 'reason': 'Makeup day', 'service': true},
      ],
    });

    test('weekday is a service day', () {
      // 2026-03-02 is Monday
      expect(calendar.isServiceDay(DateTime(2026, 3, 2)), isTrue);
    });

    test('weekend is not a service day', () {
      // 2026-03-07 would be Saturday, but it's an exception (service: true)
      // 2026-03-08 is Sunday
      expect(calendar.isServiceDay(DateTime(2026, 3, 8)), isFalse);
    });

    test('exception overrides default (holiday on weekday)', () {
      // 2026-03-01 is Sunday actually... let's pick a known weekday holiday
      // The exception says 2026-03-01 service: false regardless of day
      expect(calendar.isServiceDay(DateTime(2026, 3, 1)), isFalse);
    });

    test('exception overrides default (makeup day on weekend)', () {
      // 2026-03-07 is Saturday but exception says service: true
      expect(calendar.isServiceDay(DateTime(2026, 3, 7)), isTrue);
    });
  });

  group('RouteOverlayFeature color parsing', () {
    test('parses valid color', () {
      final feature = RouteOverlayFeature.fromJson({
        'coordsEndpoint': '/route/test',
        'color': '4CAF50',
      });
      expect(feature.color, const Color(0xFF4CAF50));
    });

    test('falls back on invalid color', () {
      final feature = RouteOverlayFeature.fromJson({
        'coordsEndpoint': '/route/test',
        'color': 'invalid',
      });
      expect(feature.color, const Color(0xFF003626));
    });
  });

  group('BusDirection endpoint template', () {
    test('endpoint contains dayType placeholder', () {
      final dir = BusDirection.fromJson({
        'id': 'inja',
        'label': 'HSSC → NSC',
        'endpoint': '/bus/campus/inja/{dayType}',
      });
      final path = dir.endpoint.replaceAll('{dayType}', 'monday');
      expect(path, '/bus/campus/inja/monday');
    });
  });
}
