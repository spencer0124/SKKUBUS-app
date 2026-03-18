import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/data/result.dart';

/// Placeholder repository for the v2 /app/config endpoint.
///
/// Currently unused — will be wired when the Flutter app migrates to
/// the v2 force-update flow (server's `features/app/app.routes.js`).
class AppRepository {
  final ApiClient _client;
  const AppRepository(this._client);

  Future<Result<Map<String, dynamic>>> getConfig() {
    return _client.safeGet(
      ApiEndpoints.appConfig(),
      (json) => json as Map<String, dynamic>,
    );
  }
}
