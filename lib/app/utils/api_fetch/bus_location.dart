import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/main_bus_location.dart';
import 'package:skkumap/app/types/bus_type.dart';

/// Backward-compat wrapper — delegates to [BusRepository].
/// Controllers can migrate to calling the repository directly.
Future<List<MainBusLocation>> fetchMainBusLocation(
    {required BusType busType}) async {
  final result = await Get.find<BusRepository>().getLocations(busType);
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw Exception(failure.message),
  };
}
