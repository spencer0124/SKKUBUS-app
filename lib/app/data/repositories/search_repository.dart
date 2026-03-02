import 'package:dio/dio.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/search_option3_model.dart';

class SearchRepository {
  final ApiClient _client;
  const SearchRepository(this._client);

  Future<Result<SearchOption3Model>> searchBuildings(
    String query, {
    CancelToken? cancelToken,
  }) {
    return _client.safeGet(
      ApiEndpoints.searchBuildings(query),
      (json) => SearchOption3Model.fromJson(json as Map<String, dynamic>),
      cancelToken: cancelToken,
    );
  }
}
