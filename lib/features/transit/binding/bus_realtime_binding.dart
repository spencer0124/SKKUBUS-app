import 'package:get/get.dart';

import 'package:skkumap/features/transit/controller/bus_realtime_controller.dart';

class BusRealtimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusRealtimeController>(() => BusRealtimeController());
    Get.lazyPut<BusRealtimeLifeCycle>(() => BusRealtimeLifeCycle());
  }
}
