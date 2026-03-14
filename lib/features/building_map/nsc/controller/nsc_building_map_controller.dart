import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class NSCBuildingMapController extends GetxController {
  RxBool showInfoTap = false.obs;
  RxString placeName = "".obs;
  RxString buildingName = "".obs;
  RxString previousPlace = "".obs;
  RxString afterPlace = "".obs;
  RxString placeInfo = "".obs;
  RxString time = "".obs;
  RxString leftColor = "000000".obs;
  RxString rightColor = "000000".obs;

  late WebViewController webcontroller;

  @override
  void onInit() {
    super.onInit();
    webcontroller = WebViewController();
    setupWebViewController();
  }

  void setupWebViewController() {
    webcontroller.clearCache();
    webcontroller
        .loadRequest(Uri.parse("https://webview.skkuuniverse.com/#/map/nsc"));
    // Uri.parse("http://192.168.45.226:3001/SKKUBUS_webview/#/map/nsc"));
    webcontroller.enableZoom(true);
    webcontroller.clearCache();
    webcontroller.setJavaScriptMode(JavaScriptMode.unrestricted);
    webcontroller.setBackgroundColor(const Color(0x00000000));
  }
}
