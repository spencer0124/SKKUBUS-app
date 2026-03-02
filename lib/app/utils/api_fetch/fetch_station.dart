import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/station_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/station_model.dart';

/// Backward-compat wrapper — delegates to [StationRepository].
Future<StationResponse> fetchStationData(String stationId) async {
  final result =
      await Get.find<StationRepository>().getStationData(stationId);
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw Exception(failure.message),
  };
}
