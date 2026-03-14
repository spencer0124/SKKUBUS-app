import 'package:dio/dio.dart';
import 'package:skkumap/core/utils/app_logger.dart';

/// Logs server-generated observability headers for debugging.
///
/// The Express server attaches:
/// - `X-Request-Id` — UUID per request (from pino-http)
/// - `X-Response-Time` — server-side processing time in ms
///
/// These are logged at debug level — visible in dev console but silent in prod.
class ObservabilityInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.headers.value('x-request-id');
    final responseTime = response.headers.value('x-response-time');
    final path = response.requestOptions.path;

    if (requestId != null || responseTime != null) {
      logger.d('[api] $requestId $path ${responseTime ?? ''}');
    }

    handler.next(response);
  }
}
