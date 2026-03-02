import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/search_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/search_option3_model.dart';

/// Backward-compat wrapper — delegates to [SearchRepository].
Future<SearchOption3Model> searchOption3(String queryString) async {
  final result =
      await Get.find<SearchRepository>().searchBuildings(queryString);
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw Exception(failure.message),
  };
}
