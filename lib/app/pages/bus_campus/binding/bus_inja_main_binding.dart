import 'package:get/get.dart';

import 'package:skkumap/app/pages/bus_campus/controller/bus_inja_main_controller.dart';

class ESKARABinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InjaMainController>(() => InjaMainController());
    Get.lazyPut<InjaMainLifeCycle>(() => InjaMainLifeCycle());
  }
}
