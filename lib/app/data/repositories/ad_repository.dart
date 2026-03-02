import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/ad_model.dart';

class AdRepository {
  final ApiClient _client;
  const AdRepository(this._client);

  Future<Result<AdPlacementsResponse>> getPlacements({
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.adPlacements(),
      (json) => AdPlacementsResponse.fromJson(json as Map<String, dynamic>),
      cancelToken: cancelToken,
    );
  }

  /// Fire-and-forget event tracking. Failures are logged, not surfaced.
  Future<void> trackEvent(
    String placement,
    String event, {
    String? adId,
  }) {
    final body = <String, String>{
      'placement': placement,
      'event': event,
    };
    if (adId != null) body['adId'] = adId;
    return _client.firePost(ApiEndpoints.adEvents(), data: body);
  }
}
