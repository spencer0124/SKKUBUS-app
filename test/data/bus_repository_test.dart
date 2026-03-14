import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/features/transit/data/bus_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/transit/model/realtime_data.dart';
import 'package:skkumap/features/transit/model/smart_schedule.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late BusRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dioAdapter = DioAdapter(dio: dio);
    repository = BusRepository(ApiClient(dio));
  });

  group('getRealtimeData', () {
    test('parses empty buses and stationEtas', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/hssc',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko', 'currentTime': '02:30 PM', 'totalBuses': 0},
          'data': {
            'groupId': 'hssc',
            'buses': [],
            'stationEtas': [],
          },
        }),
      );

      final result =
          await repository.getRealtimeData('/bus/realtime/data/hssc');
      expect(result, isA<Ok<RealtimeData>>());
      final data = (result as Ok<RealtimeData>).data;
      expect(data.groupId, 'hssc');
      expect(data.buses, isEmpty);
      expect(data.stationEtas, isEmpty);
      expect(data.meta.currentTime, '02:30 PM');
      expect(data.meta.totalBuses, 0);
    });

    test('parses buses with stationIndex (0-based)', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/hssc',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko', 'currentTime': '10:00 AM', 'totalBuses': 2},
          'data': {
            'groupId': 'hssc',
            'buses': [
              {
                'stationIndex': 0,
                'carNumber': '0000',
                'estimatedTime': 30,
              },
              {
                'stationIndex': 5,
                'carNumber': '1234',
                'estimatedTime': 100,
              },
            ],
            'stationEtas': [],
          },
        }),
      );

      final result =
          await repository.getRealtimeData('/bus/realtime/data/hssc');
      expect(result, isA<Ok<RealtimeData>>());
      final data = (result as Ok<RealtimeData>).data;
      expect(data.meta.totalBuses, 2);
      expect(data.buses, hasLength(2));
      expect(data.buses[0].stationIndex, 0);
      expect(data.buses[0].carNumber, '0000');
      expect(data.buses[0].estimatedTime, 30);
      expect(data.buses[1].stationIndex, 5);
    });

    test('parses stationEtas for jongro-type buses', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/jongro07',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko', 'currentTime': '03:00 PM', 'totalBuses': 1},
          'data': {
            'groupId': 'jongro07',
            'buses': [
              {
                'stationIndex': 5,
                'carNumber': '5537',
                'estimatedTime': 100,
              },
            ],
            'stationEtas': [
              {'stationIndex': 0, 'eta': '3분후[1번째 전]'},
              {'stationIndex': 3, 'eta': '1분후[도착 예정]'},
            ],
          },
        }),
      );

      final result =
          await repository.getRealtimeData('/bus/realtime/data/jongro07');
      expect(result, isA<Ok<RealtimeData>>());
      final data = (result as Ok<RealtimeData>).data;
      expect(data.stationEtas, hasLength(2));
      expect(data.stationEtas[0].stationIndex, 0);
      expect(data.stationEtas[0].eta, '3분후[1번째 전]');
      expect(data.stationEtas[1].stationIndex, 3);
    });
  });

  group('getSmartSchedule', () {
    test('parses active smart schedule correctly', () async {
      dioAdapter.onGet(
        '/bus/schedule/data/campus-inja/smart',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': {
            'serviceId': 'campus-inja',
            'status': 'active',
            'from': '2026-03-16',
            'selectedDate': '2026-03-18',
            'days': [
              {
                'date': '2026-03-16',
                'dayOfWeek': 1,
                'display': 'schedule',
                'label': null,
                'notices': [],
                'schedule': [
                  {
                    'index': 1,
                    'time': '07:00',
                    'routeType': 'regular',
                    'busCount': 1,
                    'notes': null,
                  },
                ],
              },
              {
                'date': '2026-03-17',
                'dayOfWeek': 2,
                'display': 'schedule',
                'label': null,
                'notices': [],
                'schedule': [],
              },
              {
                'date': '2026-03-18',
                'dayOfWeek': 3,
                'display': 'schedule',
                'label': null,
                'notices': [],
                'schedule': [],
              },
            ],
          },
        }),
      );

      final result = await repository
          .getSmartSchedule('/bus/schedule/data/campus-inja/smart');
      expect(result, isA<Ok<ConditionalResult<SmartSchedule>>>());
      final cond = (result as Ok<ConditionalResult<SmartSchedule>>).data;
      expect(cond.notModified, isFalse);
      final data = cond.data!;
      expect(data.serviceId, 'campus-inja');
      expect(data.status, 'active');
      expect(data.isActive, isTrue);
      expect(data.from, '2026-03-16');
      expect(data.selectedDate, '2026-03-18');
      expect(data.days, hasLength(3));
      expect(data.selectedDayIndex, 2);
    });

    test('parses suspended schedule', () async {
      dioAdapter.onGet(
        '/bus/schedule/data/campus-inja/smart',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': {
            'serviceId': 'campus-inja',
            'status': 'suspended',
            'from': null,
            'selectedDate': null,
            'days': [],
            'resumeDate': '2026-09-01',
            'message': '방학 기간 운행 중단',
          },
        }),
      );

      final result = await repository
          .getSmartSchedule('/bus/schedule/data/campus-inja/smart');
      expect(result, isA<Ok<ConditionalResult<SmartSchedule>>>());
      final data =
          (result as Ok<ConditionalResult<SmartSchedule>>).data.data!;
      expect(data.isSuspended, isTrue);
      expect(data.resumeDate, '2026-09-01');
      expect(data.message, '방학 기간 운행 중단');
      expect(data.days, isEmpty);
    });

    test('handles 304 Not Modified', () async {
      dioAdapter.onGet(
        '/bus/schedule/data/campus-inja/smart',
        (server) => server.reply(304, null),
        headers: {'If-None-Match': 'etag-123'},
      );

      final result = await repository.getSmartSchedule(
        '/bus/schedule/data/campus-inja/smart',
        ifNoneMatch: 'etag-123',
      );
      expect(result, isA<Ok<ConditionalResult<SmartSchedule>>>());
      final cond = (result as Ok<ConditionalResult<SmartSchedule>>).data;
      expect(cond.notModified, isTrue);
      expect(cond.data, isNull);
    });

    test('returns ServerFailure on 500', () async {
      dioAdapter.onGet(
        '/bus/schedule/data/campus-inja/smart',
        (server) => server.reply(500, 'Server Error'),
      );

      final result = await repository
          .getSmartSchedule('/bus/schedule/data/campus-inja/smart');
      expect(result, isA<Err>());
      final failure = (result as Err).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });
  });

  group('error handling', () {
    test('returns ServerFailure on 500', () async {
      dioAdapter.onGet(
        '/bus/realtime/data/hssc',
        (server) => server.reply(500, 'Server Error'),
      );

      final result =
          await repository.getRealtimeData('/bus/realtime/data/hssc');
      expect(result, isA<Err>());
      final failure = (result as Err).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });
  });
}
