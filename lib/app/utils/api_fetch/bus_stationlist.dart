import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';
import 'package:skkumap/app/types/bus_type.dart';

/// Backward-compat wrapper — delegates to [BusRepository].
Future<MainBusStationList> fetchMainBusStations(
    {required BusType busType}) async {
  final result = await Get.find<BusRepository>().getStations(busType);
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw Exception(failure.message),
  };
}
