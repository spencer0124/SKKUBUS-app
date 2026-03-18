import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skkumap/core/utils/app_logger.dart';

/// Attaches Firebase ID token to every request and retries on 401.
///
/// Uses [QueuedInterceptor] (not plain Interceptor) so that when a 401
/// triggers a token refresh, concurrent in-flight requests are queued
/// instead of each independently refreshing — preventing a thundering herd.
class AuthInterceptor extends QueuedInterceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final idToken = await user.getIdToken();
        if (idToken != null) {
          options.headers['Authorization'] = 'Bearer $idToken';
        }
      } catch (e) {
        logger.w('[auth] Failed to get idToken: $e');
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Force-refresh the token and retry the original request once.
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final freshToken = await user.getIdToken(true);
          if (freshToken != null) {
            err.requestOptions.headers['Authorization'] =
                'Bearer $freshToken';
            // Retry with the fresh token
            final dio = Dio();
            final response = await dio.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } catch (e) {
          logger.w('[auth] Token refresh failed: $e');
        }
      }
    }
    handler.next(err);
  }
}
