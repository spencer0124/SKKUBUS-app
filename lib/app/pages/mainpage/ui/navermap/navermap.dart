import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/material.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/marker_bus.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/marker_campus.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/route_jongrobus.dart';
import 'package:skkumap/app/types/campus_type.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';
import 'package:skkumap/app/utils/geolocator.dart';

const initCameraPosition = NCameraPosition(
  target: NLatLng(37.587241, 126.992858),
  zoom: 15.8,
  // bearing: 330,
  // tilt: 50,
);

Widget buildMap() {
  final ultimateNampController = Get.put(UltimateNMapController());
  return NaverMap(
    options: const NaverMapViewOptions(
      zoomGesturesEnable: true,
      locationButtonEnable: false,
      mapType: NMapType.basic,
      logoAlign: NLogoAlign.rightBottom,
      logoClickEnable: true,
      logoMargin: EdgeInsets.all(1000),
      activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
      initialCameraPosition: initCameraPosition,
    ),
    onMapReady: (mapcontroller) {
      // save native controller for later bounds queries
      ultimateNampController.mapController.value = mapcontroller;
      mapcontroller.addOverlayAll({
        // 초기 마커 세팅
        ...ultimateNampController.markers,
        ...buildCampusMarkers(CampusType.hssc),
        // 종로07버스 노선 오버레이
        NMultipartPathOverlay(
          id: "jongro07Route",
          paths: [
            const NMultipartPath(
              color: Colors.green,
              outlineColor: Colors.white,
              coords: jongro07Route,
            ),
          ],
        ),

        // 종로02버스 노선 오버레이
        NMultipartPathOverlay(
          id: "jongro02Route",
          paths: [
            const NMultipartPath(
              color: Colors.green,
              outlineColor: Colors.white,
              coords: jongro02Route,
            ),
          ],
        ),
      });

      // 위치 오버레이 추적 모드 설정
      // noFollow: 사용자의 위치가 변경되어도 카메라가 따라가지 않음
      mapcontroller.setLocationTrackingMode(NLocationTrackingMode.noFollow);

      // 위치 오버레이 커스터마이징 > 위치값 얻고 나서로 위치 변경
      // 아이콘 변경, 크기 변경, 원형 반경 설정 등
      // final locationOverlay = mapcontroller.getLocationOverlay();
      // locationOverlay.setIcon(const NOverlayImage.fromAssetImage(
      //     'assets/images/location_marker.png'));
      // locationOverlay.setIconSize(const Size.fromRadius(5));
      // locationOverlay.setCircleRadius(10.0);
      // locationOverlay.setCircleColor(Colors.yellow.withOpacity(0.25));
      // locationOverlay.setIsVisible(true);

      // 사용자 현재 위치 초기화 (앱 시작시 1번만 호출)
      // 추후 업데이트는 위치 버튼 클릭으로 처리
      // ultimateNampController.moveToCurrentLocation().then((_) {
      //   mapcontroller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
      //   final locationOverlay = mapcontroller.getLocationOverlay();
      //   locationOverlay.setCircleRadius(10.0);
      //   locationOverlay.setIsVisible(true);
      // });

      mapcontroller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
      final locationOverlay = mapcontroller.getLocationOverlay();
      locationOverlay.setCircleRadius(10.0);
      locationOverlay.setIsVisible(true);

      // 마커 갱신
      // ever를 이용한 자동 갱
      ever(ultimateNampController.markers, (_) {
        mapcontroller.clearOverlays(); // 필요시 clear
        mapcontroller.addOverlayAll({...ultimateNampController.markers});
      });

      // 카메라 갱신
      // ever를 이용한 자동 갱신
      ever<NCameraPosition>(ultimateNampController.cameraPosition, (pos) {
        mapcontroller.updateCamera(
          NCameraUpdate.withParams(
            target: pos.target,
            zoom: pos.zoom,
            tilt: pos.tilt,
            bearing: pos.bearing,
          ),
        );
      });

      // // 인사캠 건물 번호마커
      // ...buildCampusMarkers(CampusType.hssc),

      // // 종로07버스 노선 오버레이
      // NMultipartPathOverlay(
      //   id: "jongro07Route",
      //   paths: [
      //     const NMultipartPath(
      //       color: Colors.green,
      //       outlineColor: Colors.white,
      //       coords: jongro07Route,
      //     ),
      //   ],
      // ),

      // // 종로02버스 노선 오버레이
      // NMultipartPathOverlay(
      //   id: "jongro02Route",
      //   paths: [
      //     const NMultipartPath(
      //       color: Colors.green,
      //       outlineColor: Colors.white,
      //       coords: jongro02Route,
      //     ),
      //   ],
      // ),
    },
  );
}
