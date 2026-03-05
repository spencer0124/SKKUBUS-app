import 'package:get/get.dart';
import 'package:skkumap/app/pages/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceSearchController>(() => PlaceSearchController());
  }
}
