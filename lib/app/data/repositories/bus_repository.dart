import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/main_bus_location.dart';
import 'package:skkumap/app/model/bus_schedule.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';
import 'package:skkumap/app/types/bus_type.dart';

class BusRepository {
  final ApiClient _client;
  const BusRepository(this._client);

  Future<Result<List<MainBusLocation>>> getLocations(
    BusType type, {
    CancelToken? cancelToken,
  }) {
    final path = switch (type) {
      BusType.jongro07Bus => ApiEndpoints.busJongroLocation('07'),
      BusType.jongro02Bus => ApiEndpoints.busJongroLocation('02'),
      _ => ApiEndpoints.busHsscLocation(),
    };
    return _client.safeGet(
      path,
      (json) => ((json as Map<String, dynamic>)['data'] as List)
          .map((e) => MainBusLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      cancelToken: cancelToken,
    );
  }

  Future<Result<MainBusStationList>> getStations(
    BusType type, {
    CancelToken? cancelToken,
  }) {
    final path = switch (type) {
      BusType.jongro07Bus => ApiEndpoints.busJongroStations('07'),
      BusType.jongro02Bus => ApiEndpoints.busJongroStations('02'),
      _ => ApiEndpoints.busHsscStations(),
    };
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
}
