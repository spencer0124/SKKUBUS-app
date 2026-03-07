import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/pages/mainpage/controller/map_layer_controller.dart';

class MainpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainpageController>(() => MainpageController());
    Get.lazyPut<MainpageLifeCycle>(() => MainpageLifeCycle());
    Get.lazyPut<MapLayerController>(() => MapLayerController());
  }
}
