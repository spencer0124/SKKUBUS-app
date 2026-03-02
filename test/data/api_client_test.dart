import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/result.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dioAdapter = DioAdapter(dio: dio);
    client = ApiClient(dio);
  });

  group('safeGet', () {
    test('returns Ok on 200 with parsed data', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, [
          {'id': 1, 'name': 'Alice'},
          {'id': 2, 'name': 'Bob'},
        ]),
      );

      final result = await client.safeGet<List<String>>(
        '/test',
        (json) => (json as List).map((e) => e['name'] as String).toList(),
      );

      expect(result, isA<Ok<List<String>>>());
      final data = (result as Ok<List<String>>).data;
      expect(data, ['Alice', 'Bob']);
    });

    test('returns Err(ServerFailure) on 4xx/5xx', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(500, 'Internal Server Error'),
      );

      final result = await client.safeGet<String>(
        '/test',
        (json) => json as String,
      );

      expect(result, isA<Err<String>>());
      final failure = (result as Err<String>).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });

    test('returns Err(ServerFailure) with errorCode from v2 error envelope',
        () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(429, {
          'error': {
            'code': 'RATE_LIMIT',
            'message': 'Too many requests',
          }
        }),
      );

      final result = await client.safeGet<String>(
        '/test',
        (json) => json as String,
      );

      expect(result, isA<Err<String>>());
      final failure = (result as Err<String>).failure;
      expect(failure, isA<ServerFailure>());
      final sf = failure as ServerFailure;
      expect(sf.statusCode, 429);
      expect(sf.errorCode, 'RATE_LIMIT');
      expect(sf.message, 'Too many requests');
    });

    test('returns Err(CancelledFailure) on cancelled request', () async {
      final cancelToken = CancelToken();

      dioAdapter.onGet(
        '/test',
        (server) {
          cancelToken.cancel();
          server.reply(200, 'ok');
        },
      );

      final result = await client.safeGet<String>(
        '/test',
        (json) => json as String,
        cancelToken: cancelToken,
      );

      expect(result, isA<Err<String>>());
      final failure = (result as Err<String>).failure;
      expect(failure, isA<CancelledFailure>());
    });

    test('returns Err(ParseFailure) on fromJson crash', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {'unexpected': 'shape'}),
      );

      final result = await client.safeGet<String>(
        '/test',
        (json) {
          // Simulate a fromJson that throws
          throw FormatException('Expected a List but got Map');
        },
      );

      expect(result, isA<Err<String>>());
      final failure = (result as Err<String>).failure;
      expect(failure, isA<ParseFailure>());
      expect(failure.message, contains('FormatException'));
    });
  });

  group('envelope unwrapping', () {
    test('passes through v1 bare array unchanged', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, [
          {'stationName': 'A'},
          {'stationName': 'B'},
        ]),
      );

      final result = await client.safeGet<int>(
        '/test',
        (json) => (json as List).length,
      );

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).data, 2);
    });

    test('passes through v1 object with metaData unchanged', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {
          'metaData': {'count': 3},
          'stations': [1, 2, 3],
        }),
      );

      final result = await client.safeGet<int>(
        '/test',
        (json) => (json as Map<String, dynamic>)['stations'].length,
      );

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).data, 3);
    });

    test('unwraps v2 envelope { meta: { lang }, data: [...] }', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko', 'requestId': 'abc-123'},
          'data': [
            {'id': 1},
            {'id': 2},
          ],
        }),
      );

      final result = await client.safeGet<int>(
        '/test',
        (json) => (json as List).length,
      );

      // Parser receives the unwrapped `data` array, not the full envelope
      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).data, 2);
    });

    test('does not unwrap map with meta but without lang', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {
          'meta': {'version': '1.0'},
          'data': [1, 2, 3],
        }),
      );

      final result = await client.safeGet<bool>(
        '/test',
        (json) => json is Map<String, dynamic>,
      );

      // Should receive the full map (not unwrapped) because meta has no lang
      expect(result, isA<Ok<bool>>());
      expect((result as Ok<bool>).data, true);
    });
  });

  group('firePost', () {
    test('does not throw on failure', () async {
      dioAdapter.onPost(
        '/events',
        (server) => server.reply(500, 'Server Error'),
        data: Matchers.any,
      );

      // Should complete without throwing
      await client.firePost('/events', data: {'event': 'click'});
    });
  });
}
