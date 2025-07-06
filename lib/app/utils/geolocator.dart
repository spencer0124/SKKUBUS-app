import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

class LocationController extends GetxController {
  var latitude = ''.obs;
  var longitude = ''.obs;

  Future<void> showPermissionAlert() async {
    var result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: "위치 권한 오류",
      text: "정상적인 서비스 이용을 위해\n위치 권한을 허용해주세요",
      positiveButtonTitle: "취소",
      negativeButtonTitle: "설정 이동",
    );
    if (result == CustomButton.negativeButton) {
      print("사용자가 확인 버튼을 클릭했습니다.");
      Geolocator.openLocationSettings();
    } else {
      print("사용자가 취소 버튼을 클릭했습니다.");
    }
  }

  Future<void> getCurrentPosition() async {
    // 위치 서비스 활성화 여부 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 서비스가 활성화되어 있지 않습니다.");

      await showPermissionAlert();
      return;
    }

    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await showPermissionAlert();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await showPermissionAlert();
      return;
    }

    // 위치 정보 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 위도, 경도 업데이트
    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
  }
}
