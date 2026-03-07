import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/utils/app_logger.dart';

/// Result of a conditional GET (ETag-based). Kept in api_client.dart
/// because it's tightly coupled to [ApiClient.safeGetConditional].
class ConditionalResult<T> {
  /// Parsed data, or `null` if the server returned 304 Not Modified.
  final T? data;

  /// ETag value from the response `etag` header. Store this and pass it
  /// back as `ifNoneMatch` on subsequent calls.
  final String? etag;

  const ConditionalResult({this.data, this.etag});

  /// `true` when the server returned 304 — cached data is still fresh.
  bool get notModified => data == null;
}

/// Dio-based API client with typed error handling.
///
/// All network calls go through [safeGet] / [safePost] which return
/// `Result<T>` — callers never deal with raw exceptions.
///
/// v2 responses must be `{ meta, data }` envelopes. The full envelope is
/// passed to parsers so models can access both `meta` and `data`.
class ApiClient {
  final Dio _dio;
  const ApiClient(this._dio);

  /// Ensure anonymous Firebase sign-in. Call once on app startup.
  Future<void> ensureAuth() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
      logger.i('[auth] Anonymous sign-in complete: ${auth.currentUser?.uid}');
    }
  }

  /// GET request with typed result.
  ///
  /// [parser] receives the full v2 envelope `{ meta, data }`.
  Future<Result<T>> safeGet<T>(
    String path,
    T Function(dynamic json) parser, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      final raw = response.data;
      if (raw is Map<String, dynamic> &&
          raw.containsKey('meta') &&
          raw.containsKey('data')) {
        return Result.ok(parser(raw));
      } else {
        return Result.error(const ParseFailure('Invalid v2 envelope'));
      }
    } on DioException catch (e) {
      return Result.error(_mapDioError(e));
    } catch (e) {
      return Result.error(ParseFailure('Parse error: $e'));
    }
  }

  /// Conditional GET with ETag support (RFC 7232).
  ///
  /// Pass the previously received [ifNoneMatch] value. If the server
  /// responds with 304, [ConditionalResult.notModified] is `true` and
  /// the caller should keep its cached copy.
  Future<Result<ConditionalResult<T>>> safeGetConditional<T>(
    String path,
    T Function(dynamic json) parser, {
    String? ifNoneMatch,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (ifNoneMatch != null) 'If-None-Match': ifNoneMatch,
          },
          validateStatus: (s) => s != null && (s == 200 || s == 304),
        ),
      );

      if (response.statusCode == 304) {
        return Result.ok(ConditionalResult<T>(etag: ifNoneMatch));
      }

      final raw = response.data;
      if (raw is Map<String, dynamic> &&
          raw.containsKey('meta') &&
          raw.containsKey('data')) {
        final etag = response.headers.value('etag');
        return Result.ok(ConditionalResult(data: parser(raw), etag: etag));
      } else {
        return Result.error(const ParseFailure('Invalid v2 envelope'));
      }
    } on DioException catch (e) {
      return Result.error(_mapDioError(e));
    } catch (e) {
      return Result.error(ParseFailure('Parse error: $e'));
    }
  }

  /// POST request with typed result.
  Future<Result<T>> safePost<T>(
    String path,
    T Function(dynamic json) parser, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      final raw = response.data;
      if (raw is Map<String, dynamic> &&
          raw.containsKey('meta') &&
          raw.containsKey('data')) {
        return Result.ok(parser(raw));
      } else {
        return Result.error(const ParseFailure('Invalid v2 envelope'));
      }
    } on DioException catch (e) {
      return Result.error(_mapDioError(e));
    } catch (e) {
      return Result.error(ParseFailure('Parse error: $e'));
    }
  }

  /// Fire-and-forget POST for analytics/tracking.
  ///
  /// Failures are logged at debug level — silent to users but visible in
  /// dev console. Used by ad event tracking where delivery is best-effort.
  Future<void> firePost(String path, {dynamic data}) async {
    try {
      await _dio.post(path, data: data);
    } catch (e) {
      logger.d('[api] firePost $path failed: $e');
    }
  }

  // ── Private helpers ────────────────────────────────

  /// Map [DioException] to a typed [AppFailure].
  static AppFailure _mapDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        NetworkFailure('Network error: ${e.message}'),
      DioExceptionType.cancel => const CancelledFailure(),
      DioExceptionType.badResponse => _parseServerError(e),
      _ => NetworkFailure('Unknown error: ${e.message}'),
    };
  }

  /// Extract structured error from v2 error envelope `{ error: { code, message } }`.
  /// Falls back to generic status message if envelope is absent.
  static ServerFailure _parseServerError(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final body = e.response?.data;
    if (body is Map<String, dynamic> &&
        body['error'] is Map<String, dynamic>) {
      final err = body['error'] as Map<String, dynamic>;
      return ServerFailure(
        status,
        err['message'] as String? ?? 'Server error',
        errorCode: err['code'] as String?,
      );
    }
    return ServerFailure(status, 'Server error $status');
  }
}
