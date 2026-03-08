import 'package:get/get.dart';

import 'package:skkumap/app/pages/bus_campus/controller/bus_campus_controller.dart';

class BusCampusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusScheduleController>(() => BusScheduleController());
    Get.lazyPut<BusScheduleLifeCycle>(() => BusScheduleLifeCycle());
  }
}
