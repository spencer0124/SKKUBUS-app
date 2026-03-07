import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/mock/map_config_mock.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/map_marker.dart';

class MapLayerRepository {
  final ApiClient _client;
  final Map<String, List<ServerMapMarker>> _markerCache = {};
  final Map<String, List<List<double>>> _polylineCache = {};

  MapLayerRepository(this._client);

  Future<Result<List<ServerMapMarker>>> getMarkers(
    String endpoint, {
    CancelToken? cancelToken,
  }) async {
    if (_markerCache.containsKey(endpoint)) {
      return Result.ok(_markerCache[endpoint]!);
    }
    final result = await _client.safeGet(
      endpoint,
      (json) {
        final data =
            (json as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        return (data['markers'] as List)
            .map((e) => ServerMapMarker.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      cancelToken: cancelToken,
    );
    switch (result) {
      case Ok(:final data):
        _markerCache[endpoint] = data;
      case Err():
        // Fall back to mock markers for dev
        final mockMarkers = getMockCampusMarkers();
        _markerCache[endpoint] = mockMarkers;
        return Result.ok(mockMarkers);
    }
    return result;
  }

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
    _markerCache.clear();
    _polylineCache.clear();
  }
}
