import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

/// Configures automatic retry for transient failures.
///
/// Retries on:
/// - Connection errors, timeouts (default by dio_smart_retry)
/// - 408 Request Timeout
/// - 429 Too Many Requests (server rate-limit)
/// - 503 Service Unavailable (maintenance/deploy)
///
/// Does NOT retry 401 — that's handled by [AuthInterceptor]'s token refresh.
RetryInterceptor createRetryInterceptor(Dio dio) {
  return RetryInterceptor(
    dio: dio,
    retries: 2,
    retryDelays: const [
      Duration(seconds: 1),
      Duration(seconds: 3),
    ],
    retryableExtraStatuses: {408, 429, 503},
  );
}
