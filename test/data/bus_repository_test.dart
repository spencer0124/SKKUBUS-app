import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/main_bus_location.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late BusRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dioAdapter = DioAdapter(dio: dio);
    repository = BusRepository(ApiClient(dio));
  });

  group('getLocationsByPath', () {
    test('uses correct path for hsscBus', () async {
      dioAdapter.onGet(
        '/bus/hssc/location',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': [],
        }),
      );

      final result = await repository.getLocationsByPath('/bus/hssc/location');
      expect(result, isA<Ok<List<MainBusLocation>>>());
      expect((result as Ok).data, isEmpty);
    });

    test('uses correct path for jongro07Bus', () async {
      dioAdapter.onGet(
        '/bus/jongro/location/07',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': [],
        }),
      );

      final result =
          await repository.getLocationsByPath('/bus/jongro/location/07');
      expect(result, isA<Ok<List<MainBusLocation>>>());
    });

    test('uses correct path for jongro02Bus', () async {
      dioAdapter.onGet(
        '/bus/jongro/location/02',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': [],
        }),
      );

      final result =
          await repository.getLocationsByPath('/bus/jongro/location/02');
      expect(result, isA<Ok<List<MainBusLocation>>>());
    });

    test('parses bus location list from JSON', () async {
      dioAdapter.onGet(
        '/bus/hssc/location',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': [
            {
              'sequence': '1',
              'stationName': '혜화역',
              'carNumber': '서울70사1234',
              'eventDate': '20240301120000',
              'estimatedTime': 5,
              'isLastBus': false,
            },
            {
              'sequence': '2',
              'stationName': '대학로',
              'carNumber': '서울70사5678',
              'eventDate': '20240301120100',
              'estimatedTime': 10,
              'isLastBus': true,
            },
          ],
        }),
      );

      final result = await repository.getLocationsByPath('/bus/hssc/location');
      expect(result, isA<Ok<List<MainBusLocation>>>());
      final locations = (result as Ok<List<MainBusLocation>>).data;
      expect(locations, hasLength(2));
      expect(locations[0].stationName, '혜화역');
      expect(locations[1].isLastBus, true);
    });
  });

  group('getStationsByPath', () {
    test('uses correct path for hsscBus', () async {
      dioAdapter.onGet(
        '/bus/hssc/stations',
        (server) => server.reply(200, {
          'meta': {
            'lang': 'ko',
            'currentTime': '12:00',
            'totalBuses': 0,
            'lastStationIndex': 0,
          },
          'data': [],
        }),
      );

      final result =
          await repository.getStationsByPath('/bus/hssc/stations');
      expect(result, isA<Ok>());
    });

    test('uses correct path for jongro07Bus', () async {
      dioAdapter.onGet(
        '/bus/jongro/stations/07',
        (server) => server.reply(200, {
          'meta': {
            'lang': 'ko',
            'currentTime': '12:00',
            'totalBuses': 0,
            'lastStationIndex': 0,
          },
          'data': [],
        }),
      );

      final result =
          await repository.getStationsByPath('/bus/jongro/stations/07');
      expect(result, isA<Ok>());
    });
  });

  group('error handling', () {
    test('returns ServerFailure on 500', () async {
      dioAdapter.onGet(
        '/bus/hssc/location',
        (server) => server.reply(500, 'Server Error'),
      );

      final result =
          await repository.getLocationsByPath('/bus/hssc/location');
      expect(result, isA<Err>());
      final failure = (result as Err).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });
  });
}
