import 'dart:async';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';
import 'package:skkumap/features/campus_map/controller/map_layer_controller.dart';
import 'package:skkumap/features/campus_map/ui/navermap/coord_picker.dart';
import 'package:skkumap/features/campus_map/ui/navermap/building_labels.dart';
import 'package:skkumap/core/utils/app_logger.dart';

// Fallback before config loads — HSSC is default campus.
// Config-driven camera position is applied in MapLayerController.initFromConfig().
const _fallbackCameraPosition = NCameraPosition(
  target: NLatLng(37.587241, 126.992858),
  zoom: 15.8,
);

Widget buildMap() {
  final ultimateNampController = Get.put(UltimateNMapController());
  final pickerCtrl = Get.put(CoordPickerController());
  return NaverMap(
    options: const NaverMapViewOptions(
      zoomGesturesEnable: true,
      mapType: NMapType.basic,
      logoAlign: NLogoAlign.rightBottom,
      logoClickEnable: true,
      logoMargin: EdgeInsets.all(1000),
      activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
      initialCameraPosition: _fallbackCameraPosition,
      customStyleId: '91a6fcf5-9d03-4762-99a5-7e58a5674628',
    ),
    onMapTapped: (point, latLng) => pickerCtrl.addPoint(latLng),
    onMapReady: (mapcontroller) {
      // Save native controller for later bounds queries
      ultimateNampController.mapController.value = mapcontroller;

      // Location overlay 비활성화
      // mapcontroller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
      // final locationOverlay = mapcontroller.getLocationOverlay();
      // locationOverlay.setCircleRadius(10.0);
      // locationOverlay.setIsVisible(true);

      // Initialize map layers from server config.
      // unawaited — errors are caught internally in MapLayerController.
      final layerCtrl = Get.find<MapLayerController>();
      unawaited(layerCtrl.initFromConfig());

      // Unified overlay reconciliation: re-render all active layers + bus markers
      ever(layerCtrl.layerStates,
          (_) => _reconcileOverlays(mapcontroller, layerCtrl, ultimateNampController, pickerCtrl));
      ever(ultimateNampController.markers,
          (_) => _reconcileOverlays(mapcontroller, layerCtrl, ultimateNampController, pickerCtrl));
      ever(pickerCtrl.points,
          (_) => _reconcileOverlays(mapcontroller, layerCtrl, ultimateNampController, pickerCtrl));

      // Camera updates
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

/// Rebuild all map overlays from all sources.
///
/// Clears and re-adds everything to avoid the previous bug where
/// clearOverlays() wiped bus route polylines on marker updates.
void _reconcileOverlays(
  NaverMapController mc,
  MapLayerController layerCtrl,
  UltimateNMapController nmapCtrl,
  CoordPickerController pickerCtrl,
) {
  try {
    mc.clearOverlays();
    mc.addOverlayAll({
      ...layerCtrl.activeMarkers,
      ...layerCtrl.activeOverlays,
      ...nmapCtrl.markers,
      ...pickerCtrl.markers,
      ...buildBuildingLabels(),
    });
  } catch (e) {
    logger.d('Overlay reconciliation error: $e');
  }
}
