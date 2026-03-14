import 'package:dio/dio.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/transit/model/realtime_data.dart';
import 'package:skkumap/features/transit/model/week_schedule.dart';

class BusRepository {
  final ApiClient _client;
  const BusRepository(this._client);

  /// Fetch realtime bus data (buses + stationEtas) from the unified data endpoint.
  Future<Result<RealtimeData>> getRealtimeData(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      path,
      (json) => RealtimeData.fromJson(json as Map<String, dynamic>),
      cancelToken: cancelToken,
    );
  }

  /// Fetch weekly schedule with ETag caching.
  Future<Result<ConditionalResult<WeekSchedule>>> getWeekSchedule(
    String weekEndpoint, {
    String? from,
    String? ifNoneMatch,
  }) {
    return _client.safeGetConditional<WeekSchedule>(
      weekEndpoint,
      (json) => WeekSchedule.fromJson(json as Map<String, dynamic>),
      queryParameters: from != null ? {'from': from} : null,
      ifNoneMatch: ifNoneMatch,
    );
  }

  /// Returns { 'inja': durationMs, 'jain': durationMs }
  Future<Result<Map<String, int>>> getCampusEta({
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.campusEta(),
      (json) {
        final data = (json as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
        final result = <String, int>{};
        if (data['inja'] != null) {
          result['inja'] = data['inja']['duration'] as int;
        }
        if (data['jain'] != null) {
          result['jain'] = data['jain']['duration'] as int;
        }
        return result;
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetch route overlay coordinates.
  Future<Result<List<List<double>>>> getRouteOverlay(
    String endpoint, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      endpoint,
      (json) {
        final data = (json as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
        return (data['coords'] as List)
            .map((e) => (e as List).map((c) => (c as num).toDouble()).toList())
            .toList();
      },
      cancelToken: cancelToken,
    );
  }
}
