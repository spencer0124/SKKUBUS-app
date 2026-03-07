import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/mainpage_buslist_model.dart';
import 'package:skkumap/app/model/campus_sections_response.dart';

class UiRepository {
  final ApiClient _client;
  const UiRepository(this._client);

  Future<Result<MainPageBusListResponse>> getMainpageBusList({
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.homeBusList(),
      (json) =>
          MainPageBusListResponse.fromJson(json as Map<String, dynamic>),
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
