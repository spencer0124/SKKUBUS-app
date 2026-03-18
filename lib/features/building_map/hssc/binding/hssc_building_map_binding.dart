import 'package:get/get.dart';
import 'package:skkumap/features/building_map/hssc/controller/hssc_building_map_controller.dart';

class HSSCBuildingMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HSSCBuildingMapController>(() => HSSCBuildingMapController());
  }
}
