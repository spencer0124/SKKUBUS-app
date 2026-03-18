import 'package:dio/dio.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/transit/model/station_model.dart';

class StationRepository {
  final ApiClient _client;
  const StationRepository(this._client);

  Future<Result<StationResponse>> getStationData(
    String stationId, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.station(stationId),
      (json) => StationResponse.fromJson(json as Map<String, dynamic>),
      cancelToken: cancelToken,
    );
  }
}
