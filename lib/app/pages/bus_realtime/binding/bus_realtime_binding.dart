import 'package:get/get.dart';

import 'package:skkumap/app/pages/bus_realtime/controller/bus_realtime_controller.dart';

class BusRealtimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusRealtimeController>(() => BusRealtimeController());
    Get.lazyPut<BusRealtimeLifeCycle>(() => BusRealtimeLifeCycle());
  }
}
