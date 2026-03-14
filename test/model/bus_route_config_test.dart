import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skkumap/features/transit/model/bus_group.dart';
import 'package:skkumap/features/transit/model/week_schedule.dart';

void main() {
  group('BusGroup.fromJson', () {
    test('parses realtime group correctly', () {
      final json = {
        'id': 'hssc',
        'screenType': 'realtime',
        'label': 'HSSC Shuttle',
        'visibility': {'type': 'always'},
        'card': {
          'themeColor': '003626',
          'iconType': 'shuttle',
          'busTypeText': 'SKKU',
        },
        'screen': {
          'stationsEndpoint': '/bus/hssc/stations',
          'locationsEndpoint': '/bus/hssc/location',
          'refreshInterval': 15,
          'features': [
            {'type': 'info', 'url': 'https://example.com/info'},
          ],
        },
      };

      final group = BusGroup.fromJson(json);
      expect(group.id, 'hssc');
      expect(group.screenType, 'realtime');
      expect(group.isRealtime, isTrue);
      expect(group.isSchedule, isFalse);
      expect(group.label, 'HSSC Shuttle');
      expect(group.card.themeColor, const Color(0xFF003626));
      expect(group.card.iconType, 'shuttle');
      expect(group.card.busTypeText, 'SKKU');
      expect(group.screen['stationsEndpoint'], '/bus/hssc/stations');
      expect(group.screen['locationsEndpoint'], '/bus/hssc/location');
      expect(group.features, hasLength(1));
      expect(group.features[0]['type'], 'info');
    });

    test('parses schedule group correctly', () {
      final json = {
        'id': 'campus',
        'screenType': 'schedule',
        'label': 'Campus Shuttle',
        'visibility': {'type': 'always'},
        'card': {
          'themeColor': '1A7F4B',
          'iconType': 'shuttle',
          'busTypeText': 'SKKU',
        },
        'screen': {
          'defaultServiceId': 'campus-inja',
          'services': [
            {
              'serviceId': 'campus-inja',
              'label': 'HSSC → NSC',
              'weekEndpoint': '/bus/schedule/data/campus-inja/week',
            },
          ],
          'heroCard': {
            'etaEndpoint': '/bus/campus/eta',
            'showUntilMinutesBefore': 0,
          },
          'routeBadges': [
            {'id': 'regular', 'label': 'Regular', 'color': '003626'},
            {'id': 'hakbu', 'label': 'Undergraduate', 'color': '1565C0'},
          ],
          'features': [],
        },
      };

      final group = BusGroup.fromJson(json);
      expect(group.isSchedule, isTrue);
      expect(group.defaultServiceId, 'campus-inja');
      expect(group.services, hasLength(1));
      expect(group.services[0].serviceId, 'campus-inja');
      expect(group.heroCard!.etaEndpoint, '/bus/campus/eta');
      expect(group.heroCard!.showUntilMinutesBefore, 0);
      expect(group.routeBadges, hasLength(2));
      expect(group.routeBadges[0].label, 'Regular');
    });

    test('handles null heroCard', () {
      final json = {
        'id': 'test',
        'screenType': 'schedule',
        'label': 'Test',
        'visibility': {'type': 'always'},
        'card': {
          'themeColor': '000000',
          'iconType': 'shuttle',
          'busTypeText': 'Test',
        },
        'screen': {
          'defaultServiceId': 'test',
          'services': [
            {
              'serviceId': 'test',
              'label': 'Test',
              'weekEndpoint': '/test/week',
            },
          ],
          'heroCard': null,
          'routeBadges': [],
          'features': [],
        },
      };

      final group = BusGroup.fromJson(json);
      expect(group.heroCard, isNull);
    });
  });

  group('BusGroupVisibility', () {
    test('always visible', () {
      final v = BusGroupVisibility.fromJson({'type': 'always'});
      expect(v.isVisible(DateTime(2026, 3, 8)), isTrue);
    });

    test('dateRange visible within range', () {
      final v = BusGroupVisibility.fromJson({
        'type': 'dateRange',
        'from': '2026-03-09',
        'until': '2026-03-10',
      });
      expect(v.isVisible(DateTime(2026, 3, 9, 12)), isTrue);
      expect(v.isVisible(DateTime(2026, 3, 10, 23, 59)), isTrue);
    });

    test('dateRange not visible outside range', () {
      final v = BusGroupVisibility.fromJson({
        'type': 'dateRange',
        'from': '2026-03-09',
        'until': '2026-03-10',
      });
      expect(v.isVisible(DateTime(2026, 3, 8, 23, 59)), isFalse);
      expect(v.isVisible(DateTime(2026, 3, 11, 0, 0)), isFalse);
    });
  });

  group('BusGroupCard color parsing', () {
    test('parses valid hex color', () {
      final card = BusGroupCard.fromJson({
        'themeColor': '4CAF50',
        'iconType': 'shuttle',
        'busTypeText': 'Test',
      });
      expect(card.themeColor, const Color(0xFF4CAF50));
    });

    test('falls back on null hex', () {
      final card = BusGroupCard.fromJson({
        'themeColor': null,
        'iconType': 'shuttle',
        'busTypeText': 'Test',
      });
      expect(card.themeColor, const Color(0xFF003626));
    });
  });

  group('WeekSchedule.fromJson', () {
    test('parses week schedule correctly', () {
      final json = {
        'meta': {'lang': 'ko'},
        'data': {
          'serviceId': 'campus-inja',
          'requestedFrom': '2026-03-09',
          'from': '2026-03-09',
          'days': [
            {
              'date': '2026-03-09',
              'dayOfWeek': 1,
              'display': 'schedule',
              'label': null,
              'notices': [
                {
                  'style': 'info',
                  'text': 'Updated schedule',
                  'source': 'service',
                },
              ],
              'schedule': [
                {
                  'index': 1,
                  'time': '07:00',
                  'routeType': 'regular',
                  'busCount': 1,
                  'notes': null,
                },
                {
                  'index': 2,
                  'time': '10:00',
                  'routeType': 'hakbu',
                  'busCount': 2,
                  'notes': 'Special',
                },
              ],
            },
            {
              'date': '2026-03-14',
              'dayOfWeek': 6,
              'display': 'noService',
              'label': null,
              'notices': <Map<String, dynamic>>[],
              'schedule': <Map<String, dynamic>>[],
            },
          ],
        },
      };

      final ws = WeekSchedule.fromJson(json);
      expect(ws.serviceId, 'campus-inja');
      expect(ws.requestedFrom, '2026-03-09');
      expect(ws.from, '2026-03-09');
      expect(ws.days, hasLength(2));

      final day1 = ws.days[0];
      expect(day1.hasSchedule, isTrue);
      expect(day1.isNoService, isFalse);
      expect(day1.notices, hasLength(1));
      expect(day1.schedule, hasLength(2));
      expect(day1.schedule[0].time, '07:00');
      expect(day1.schedule[1].notes, 'Special');

      final day2 = ws.days[1];
      expect(day2.isNoService, isTrue);
      expect(day2.schedule, isEmpty);
    });

    test('today() finds matching day', () {
      final ws = WeekSchedule(
        serviceId: 'test',
        from: '2026-03-09',
        days: [
          DaySchedule(
            date: '2026-03-09',
            dayOfWeek: 1,
            display: 'schedule',
            notices: [],
            schedule: [],
          ),
        ],
      );
      expect(ws.today(DateTime(2026, 3, 9)), isNotNull);
      expect(ws.today(DateTime(2026, 3, 10)), isNull);
    });
  });

  group('DaySchedule display getters', () {
    test('hasSchedule', () {
      final day = DaySchedule(
        date: '2026-03-09',
        dayOfWeek: 1,
        display: 'schedule',
        notices: [],
        schedule: [],
      );
      expect(day.hasSchedule, isTrue);
      expect(day.isNoService, isFalse);
      expect(day.isHidden, isFalse);
    });

    test('isNoService', () {
      final day = DaySchedule(
        date: '2026-03-09',
        dayOfWeek: 1,
        display: 'noService',
        notices: [],
        schedule: [],
      );
      expect(day.isNoService, isTrue);
    });

    test('isHidden', () {
      final day = DaySchedule(
        date: '2026-03-09',
        dayOfWeek: 1,
        display: 'hidden',
        notices: [],
        schedule: [],
      );
      expect(day.isHidden, isTrue);
    });
  });
}
