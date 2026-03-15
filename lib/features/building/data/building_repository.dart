import 'package:dio/dio.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/model/building_detail.dart';
import 'package:skkumap/features/building/model/building_search_result.dart';

class BuildingRepository {
  final ApiClient _client;

  /// Memory cache for /building/list (loaded once, reused by map + search).
  List<Building>? _listCache;

  BuildingRepository(this._client);

  /// Fetch all buildings. Cached in memory after first successful load.
  Future<Result<List<Building>>> getBuildings({
    bool forceRefresh = false,
  }) async {
    if (_listCache != null && !forceRefresh) {
      return Result.ok(_listCache!);
    }
    final result = await _client.safeGet(
      ApiEndpoints.buildingList(),
      (json) {
        final data =
            (json as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        return (data['buildings'] as List)
            .map((e) => Building.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (result case Ok(:final data)) {
      _listCache = data;
    }
    return result;
  }

  /// Search buildings and spaces.
  Future<Result<BuildingSearchResult>> search(
    String query, {
    String? campus,
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.buildingSearch(),
      (json) =>
          BuildingSearchResult.fromJson(json as Map<String, dynamic>),
      queryParameters: {
        'q': query,
        if (campus != null) 'campus': campus,
      },
      cancelToken: cancelToken,
    );
  }

  /// Fetch full building detail with floors/spaces.
  Future<Result<BuildingDetail>> getDetail(int skkuId) {
    return _client.safeGet(
      ApiEndpoints.buildingDetail(skkuId),
      (json) => BuildingDetail.fromJson(json as Map<String, dynamic>),
    );
  }
}
