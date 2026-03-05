import 'package:get/get.dart';

import 'package:skkumap/app/pages/bus_hssc/controller/bus_seoul_main_controller.dart';

class BusDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusDataController>(() => BusDataController());
    Get.lazyPut<SeoulMainLifeCycle>(() => SeoulMainLifeCycle());
  }
}
