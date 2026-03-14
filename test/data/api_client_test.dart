import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/result.dart';

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
    test('returns Ok on 200 with valid v2 envelope', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': [
            {'id': 1, 'name': 'Alice'},
            {'id': 2, 'name': 'Bob'},
          ],
        }),
      );

      final result = await client.safeGet<List<String>>(
        '/test',
        (json) => ((json as Map<String, dynamic>)['data'] as List)
            .map((e) => e['name'] as String)
            .toList(),
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
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
          'data': {'unexpected': 'shape'},
        }),
      );

      final result = await client.safeGet<String>(
        '/test',
        (json) {
          // Simulate a fromJson that throws
          throw const FormatException('Expected a List but got Map');
        },
      );

      expect(result, isA<Err<String>>());
      final failure = (result as Err<String>).failure;
      expect(failure, isA<ParseFailure>());
      expect(failure.message, contains('FormatException'));
    });
  });

  group('envelope validation', () {
    test('v2 envelope with meta + data passes full map to parser', () async {
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
        (json) {
          final map = json as Map<String, dynamic>;
          // Parser receives the full envelope
          expect(map.containsKey('meta'), true);
          expect(map.containsKey('data'), true);
          return (map['data'] as List).length;
        },
      );

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).data, 2);
    });

    test('response missing meta returns ParseFailure', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {
          'data': [1, 2, 3],
        }),
      );

      final result = await client.safeGet<int>(
        '/test',
        (json) => 0,
      );

      expect(result, isA<Err<int>>());
      final failure = (result as Err<int>).failure;
      expect(failure, isA<ParseFailure>());
      expect(failure.message, 'Invalid v2 envelope');
    });

    test('response missing data returns ParseFailure', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, {
          'meta': {'lang': 'ko'},
        }),
      );

      final result = await client.safeGet<int>(
        '/test',
        (json) => 0,
      );

      expect(result, isA<Err<int>>());
      final failure = (result as Err<int>).failure;
      expect(failure, isA<ParseFailure>());
      expect(failure.message, 'Invalid v2 envelope');
    });

    test('bare array response returns ParseFailure', () async {
      dioAdapter.onGet(
        '/test',
        (server) => server.reply(200, [1, 2, 3]),
      );

      final result = await client.safeGet<int>(
        '/test',
        (json) => 0,
      );

      expect(result, isA<Err<int>>());
      final failure = (result as Err<int>).failure;
      expect(failure, isA<ParseFailure>());
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
