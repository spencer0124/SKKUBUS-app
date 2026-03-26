import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:skkumap/core/utils/app_logger.dart';

class LocationController extends GetxController {
  var latitude = ''.obs;
  var longitude = ''.obs;

  Future<void> showPermissionAlert() async {
    var result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: '위치 권한이 필요해요'.tr,
      text: '위치 정보를 사용하려면\n권한을 허용해 주세요'.tr,
      positiveButtonTitle: '닫기'.tr,
      negativeButtonTitle: '설정으로 이동'.tr,
    );
    if (result == CustomButton.negativeButton) {
      logger.d("사용자가 확인 버튼을 클릭했습니다.");
      Geolocator.openLocationSettings();
    } else {
      logger.d("사용자가 취소 버튼을 클릭했습니다.");
    }
  }

  // GPS 권한 요청 비활성화
  Future<void> getCurrentPosition() async {
    // // 위치 서비스 활성화 여부 확인
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   logger.d("위치 서비스가 활성화되어 있지 않습니다.");
    //
    //   await showPermissionAlert();
    //   return;
    // }
    //
    // // 위치 권한 확인 및 요청
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     await showPermissionAlert();
    //     return;
    //   }
    // }
    //
    // if (permission == LocationPermission.deniedForever) {
    //   await showPermissionAlert();
    //   return;
    // }
    //
    // // 위치 정보 가져오기
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );
    //
    // // 위도, 경도 업데이트
    // latitude.value = position.latitude.toString();
    // longitude.value = position.longitude.toString();
  }
}
