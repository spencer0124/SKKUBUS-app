import 'package:get/get.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/services/analytics_service.dart';
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

  /// Floor/space to highlight (set from search navigation).
  String? highlightFloor;
  String? highlightSpaceCd;

  /// Which floor index is currently expanded (null = all collapsed).
  final expandedFloorIndex = RxnInt(null);

  /// Per-floor "show all spaces" toggle (floor index → bool).
  final showAllSpaces = <int, bool>{}.obs;

  void toggleFloor(int index) {
    if (expandedFloorIndex.value == index) {
      expandedFloorIndex.value = null;
    } else {
      expandedFloorIndex.value = index;
      final floor = detail.value?.floors[index];
      if (floor != null && detail.value != null) {
        Get.find<AnalyticsService>().logFloorExpand(
          skkuId: detail.value!.building.skkuId,
          floorName: floor.floor.ko,
        );
      }
    }
  }

  void showAllSpacesFor(int floorIndex) {
    showAllSpaces[floorIndex] = true;
    final floor = detail.value?.floors[floorIndex];
    if (floor != null && detail.value != null) {
      Get.find<AnalyticsService>().logSpaceShowAll(
        skkuId: detail.value!.building.skkuId,
        floorName: floor.floor.ko,
      );
    }
  }

  String? _currentSource;

  Future<void> loadDetail(
    int skkuId, {
    String? highlightFloor,
    String? highlightSpaceCd,
    String? source,
  }) async {
    _currentSource = source;
    this.highlightFloor = highlightFloor;
    this.highlightSpaceCd = highlightSpaceCd;
    detail.value = null;
    isLoading.value = true;
    hasError.value = false;
    expandedFloorIndex.value = null;
    showAllSpaces.clear();

    final result = await _buildingRepo.getDetail(skkuId);
    switch (result) {
      case Ok(:final data):
        detail.value = data;
        Get.find<AnalyticsService>().logBuildingView(
          skkuId: data.building.skkuId,
          buildingName: data.building.name.ko,
          campus: data.building.campus,
          source: _currentSource ?? 'direct',
        );
        // Auto-expand highlighted floor
        if (highlightFloor != null) {
          for (var i = 0; i < data.floors.length; i++) {
            if (data.floors[i].floor.ko == highlightFloor) {
              expandedFloorIndex.value = i;
              showAllSpaces[i] = true; // show all when navigated from search
              break;
            }
          }
        }
      case Err(:final failure):
        logger.e('BuildingDetail error: $failure');
        hasError.value = true;
    }
    isLoading.value = false;
  }
}
