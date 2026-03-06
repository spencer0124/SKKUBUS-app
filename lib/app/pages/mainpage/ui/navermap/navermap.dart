import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/material.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/marker_bus.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/marker_campus.dart';
import 'package:skkumap/app/types/campus_type.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';
import 'package:skkumap/app/utils/geolocator.dart';
import 'package:skkumap/app/data/repositories/bus_config_repository.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/utils/app_logger.dart';

const initCameraPosition = NCameraPosition(
  target: NLatLng(37.587241, 126.992858),
  zoom: 15.8,
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
      });

      // 서버에서 경로 오버레이 동적 로드
      _loadRouteOverlays(mapcontroller);

      // 위치 오버레이 추적 모드 설정
      mapcontroller.setLocationTrackingMode(NLocationTrackingMode.noFollow);

      mapcontroller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
      final locationOverlay = mapcontroller.getLocationOverlay();
      locationOverlay.setCircleRadius(10.0);
      locationOverlay.setIsVisible(true);

      // 마커 갱신
      ever(ultimateNampController.markers, (_) {
        mapcontroller.clearOverlays();
        mapcontroller.addOverlayAll({...ultimateNampController.markers});
      });

      // 카메라 갱신
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
    },
  );
}

/// Fetch route overlays from server based on BusConfigRepository configs.
Future<void> _loadRouteOverlays(NaverMapController mapcontroller) async {
  try {
    final configRepo = Get.find<BusConfigRepository>();
    final busRepo = Get.find<BusRepository>();
    final configs = configRepo.all;

    for (final entry in configs.entries) {
      final config = entry.value;
      final overlay = config.features.routeOverlay;
      if (overlay == null) continue;

      final result = await busRepo.getRouteOverlay(overlay.coordsEndpoint);
      switch (result) {
        case Ok(:final data):
          final coords =
              data.map((c) => NLatLng(c[0], c[1])).toList();
          if (coords.length >= 2) {
            mapcontroller.addOverlay(
              NMultipartPathOverlay(
                id: '${config.id}Route',
                paths: [
                  NMultipartPath(
                    color: overlay.color,
                    outlineColor: Colors.white,
                    coords: coords,
                  ),
                ],
              ),
            );
          }
        case Err(:final failure):
          logger.d('Route overlay fetch failed for ${config.id}: $failure');
      }
    }
  } catch (e) {
    logger.d('Route overlay loading error: $e');
  }
}
