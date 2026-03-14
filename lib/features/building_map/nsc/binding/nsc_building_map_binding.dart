import 'package:get/get.dart';
import 'package:skkumap/features/building_map/nsc/controller/nsc_building_map_controller.dart';

class NSCBuildingMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NSCBuildingMapController>(() => NSCBuildingMapController());
  }
}
