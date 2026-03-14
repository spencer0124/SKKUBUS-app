import 'package:get/get.dart';

import 'package:skkumap/core/model/sdui_section.dart';
import 'package:skkumap/features/campus_map/data/campus_service_defaults.dart';
import 'package:skkumap/core/repositories/ui_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/utils/app_logger.dart';

class CampusMapController extends GetxController {
  final _uiRepo = Get.find<UiRepository>();

  var snappingSheetIsExpanded = false.obs;

  // 필터에서 선택된 캠퍼스
  // 0: 인사캠, 1: 자과캠
  var selectedCampus = 0.obs;

  var campusSections = <SduiSection>[].obs;
  var isCampusLoading = true.obs;

  Future<void> campusSectionsFetch() async {
    final result = await _uiRepo.getCampusSections();
    switch (result) {
      case Ok(:final data):
        campusSections.value = data.sections;
      case Err(:final failure):
        logger.e('Error fetching campus sections: $failure');
        if (campusSections.isEmpty) {
          campusSections.value = defaultCampusSections;
        }
    }
    isCampusLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    campusSectionsFetch();
  }
}
