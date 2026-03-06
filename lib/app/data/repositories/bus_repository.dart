import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/main_bus_location.dart';
import 'package:skkumap/app/model/bus_schedule.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';

class BusRepository {
  final ApiClient _client;
  const BusRepository(this._client);

  Future<Result<List<MainBusLocation>>> getLocationsByPath(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      path,
      (json) => ((json as Map<String, dynamic>)['data'] as List)
          .map((e) => MainBusLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      cancelToken: cancelToken,
    );
  }

  Future<Result<MainBusStationList>> getStationsByPath(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      path,
      (json) => MainBusStationList.fromJson(json as Map<String, dynamic>),
      cancelToken: cancelToken,
    );
  }

  Future<Result<List<BusSchedule>>> getSchedule(
    String prefix,
    String dayType, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.campusSchedule(prefix, dayType),
      (json) => ((json as Map<String, dynamic>)['data'] as List)
          .map((e) => BusSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      cancelToken: cancelToken,
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
