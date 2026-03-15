import 'package:dio/dio.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/result.dart';

class MapLayerRepository {
  final ApiClient _client;
  final Map<String, List<List<double>>> _polylineCache = {};

  MapLayerRepository(this._client);

  Future<Result<List<List<double>>>> getPolyline(
    String endpoint, {
    CancelToken? cancelToken,
  }) async {
    if (_polylineCache.containsKey(endpoint)) {
      return Result.ok(_polylineCache[endpoint]!);
    }
    final result = await _client.safeGet(
      endpoint,
      (json) {
        final data =
            (json as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        return (data['coords'] as List)
            .map(
                (e) => (e as List).map((c) => (c as num).toDouble()).toList())
            .toList();
      },
      cancelToken: cancelToken,
    );
    switch (result) {
      case Ok(:final data):
        _polylineCache[endpoint] = data;
      case Err():
        break;
    }
    return result;
  }

  void clearCache() {
    _polylineCache.clear();
  }
}
