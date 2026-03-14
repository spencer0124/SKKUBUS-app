import 'package:get/get.dart';
import 'package:skkumap/features/app_shell/controller/app_shell_controller.dart';
import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/features/campus_map/controller/map_layer_controller.dart';
import 'package:skkumap/features/transit/controller/transit_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppShellController>(() => AppShellController());
    Get.lazyPut<AppShellLifeCycle>(() => AppShellLifeCycle());
    Get.lazyPut<CampusMapController>(() => CampusMapController());
    Get.lazyPut<TransitController>(() => TransitController());
    Get.lazyPut<MapLayerController>(() => MapLayerController());
  }
}
