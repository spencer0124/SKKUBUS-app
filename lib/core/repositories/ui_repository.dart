import 'package:dio/dio.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/transit/model/mainpage_buslist_model.dart';
import 'package:skkumap/core/model/campus_sections_response.dart';

class UiRepository {
  final ApiClient _client;
  const UiRepository(this._client);

  Future<Result<List<BusListItem>>> getMainpageBusList({
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.homeTransitList(),
      (json) {
        final envelope = json as Map<String, dynamic>;
        final data = envelope['data'] as List;
        return data
            .map((item) => BusListItem.fromJson(item as Map<String, dynamic>))
            .toList();
      },
      cancelToken: cancelToken,
    );
  }

  Future<Result<CampusSectionsResponse>> getCampusSections({
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.homeCampus(),
      (json) =>
          CampusSectionsResponse.fromJson(json as Map<String, dynamic>),
      cancelToken: cancelToken,
    );
  }
}
