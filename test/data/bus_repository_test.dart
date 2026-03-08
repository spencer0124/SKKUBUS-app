import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/realtime_data.dart';

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
