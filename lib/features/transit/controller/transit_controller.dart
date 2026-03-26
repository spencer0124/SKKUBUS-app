import 'package:get/get.dart';

import 'package:skkumap/features/transit/model/mainpage_buslist_model.dart' show BusListItem;
import 'package:skkumap/core/repositories/ui_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/utils/app_logger.dart';

class TransitController extends GetxController {
  final _uiRepo = Get.find<UiRepository>();

  var mainpageBusList = Rx<List<BusListItem>?>(null);

  Future<void> mainPageBusListFetch() async {
    final result = await _uiRepo.getMainpageBusList();
    switch (result) {
      case Ok(:final data):
        mainpageBusList.value = data;
      case Err(:final failure):
        logger.e('Error fetching bus list: $failure');
    }
  }

  @override
  void onInit() {
    super.onInit();
    mainPageBusListFetch();
  }
}
