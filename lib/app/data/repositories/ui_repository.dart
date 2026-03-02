import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/mainpage_buslist_model.dart';

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
}
