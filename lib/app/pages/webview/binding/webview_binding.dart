import 'package:get/get.dart';
import 'package:skkumap/app/pages/webview/controller/webview_controller.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomWebViewController>(() => CustomWebViewController());
  }
}
