import 'package:dio/dio.dart';
import 'package:skkumap/core/data/api_config.dart';
import 'package:skkumap/core/data/interceptors/auth_interceptor.dart';
import 'package:skkumap/core/data/interceptors/observability_interceptor.dart';
import 'package:skkumap/core/data/interceptors/platform_interceptor.dart';
import 'package:skkumap/core/data/interceptors/retry_interceptor.dart';

/// Creates a fully-configured [Dio] instance with the interceptor chain.
///
/// **Interceptor execution order matters:**
/// - `onRequest` runs top → bottom: Auth → Platform → Retry → Observability
/// - `onError`  runs bottom → top: Observability → Retry → Platform → Auth
///
/// This means RetryInterceptor handles 408/429/503 *before* AuthInterceptor
/// sees them, while 401s pass through Retry (not in retryableStatuses) up to
/// AuthInterceptor for token refresh.
Dio createDioClient() {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 5),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(),
    PlatformInterceptor(),
    createRetryInterceptor(dio),
    ObservabilityInterceptor(),
  ]);

  return dio;
}
