import 'package:get/get.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/utils/app_logger.dart';
import 'package:skkumap/features/building/data/building_repository.dart';
import 'package:skkumap/features/building/model/building_detail.dart';

/// Singleton controller for the building detail bottom sheet.
/// State is reset on each [loadDetail] call.
class BuildingDetailController extends GetxController {
  final _buildingRepo = Get.find<BuildingRepository>();

  final detail = Rx<BuildingDetail?>(null);
  final isLoading = true.obs;
  final hasError = false.obs;

  Future<void> loadDetail(int skkuId) async {
    detail.value = null;
    isLoading.value = true;
    hasError.value = false;

    final result = await _buildingRepo.getDetail(skkuId);
    switch (result) {
      case Ok(:final data):
        detail.value = data;
      case Err(:final failure):
        logger.e('BuildingDetail error: $failure');
        hasError.value = true;
    }
    isLoading.value = false;
  }
}
