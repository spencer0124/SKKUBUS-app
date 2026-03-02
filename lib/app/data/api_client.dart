import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/utils/app_logger.dart';

/// Dio-based API client with typed error handling.
///
/// All network calls go through [safeGet] / [safePost] which return
/// `Result<T>` — callers never deal with raw exceptions.
///
/// Envelope unwrapping is automatic: v2 responses `{ meta, data }` are
/// unwrapped before the parser runs, so parsers always receive the inner
/// payload regardless of API version.
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
  /// [parser] receives the unwrapped payload — either the raw v1 response
  /// or the `data` field from a v2 `{ meta, data }` envelope.
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
      final data = _unwrapIfEnvelope(response.data);
      return Result.ok(parser(data));
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
      final body = _unwrapIfEnvelope(response.data);
      return Result.ok(parser(body));
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

  /// Unwrap v2 response envelope `{ meta, data }` if present.
  ///
  /// Detection heuristic: v2 responses always have `meta.lang` (injected by
  /// the server's `res.success()` in responseHelper.js). v1 responses use
  /// `"metaData"` (not `"meta"`) or are bare arrays — no false positives.
  static dynamic _unwrapIfEnvelope(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData['meta'] is Map<String, dynamic> &&
        (responseData['meta'] as Map).containsKey('lang') &&
        responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

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
