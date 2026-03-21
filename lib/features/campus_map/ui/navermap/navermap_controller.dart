import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import "package:skkumap/features/campus_map/model/campusmarker_model.dart";
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:skkumap/core/utils/geolocator.dart';
import 'package:geolocator/geolocator.dart';

class UltimateNMapController extends GetxController {
  // ensure marker asset is precached once
  bool _markerIconPrecached = false;
  // store the native map controller for bounds queries
  final mapController = Rx<NaverMapController?>(null);

  /// True while [animateCamera] is running — suppresses the reactive
  /// `ever` listener in navermap.dart so it doesn't override the animation
  /// with an instant jump.
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  /// Animate camera to [position] and return when the animation completes.
  /// Uses `NaverMapController.updateCamera` which returns `Future<bool>`
  /// (resolves when the native animation finishes).
  Future<void> animateCamera(
    NCameraPosition position, {
    NCameraAnimation animation = NCameraAnimation.easing,
    Duration duration = const Duration(milliseconds: 400),
  }) async {
    final mc = mapController.value;
    if (mc == null) {
      cameraPosition.value = position;
      return;
    }
    _isAnimating = true;
    cameraPosition.value = position; // sync state (ever listener skips)
    final update = NCameraUpdate.withParams(
      target: position.target,
      zoom: position.zoom,
      tilt: position.tilt,
      bearing: position.bearing,
    );
    update.setAnimation(animation: animation, duration: duration);
    await mc.updateCamera(update);
    _isAnimating = false;
  }
  final markers = <NMarker>[].obs;
  final overlays = <NOverlay>[].obs;
  // Fallback before config loads — HSSC is default campus.
  // Config-driven position is set by MapLayerController.initFromConfig().
  final cameraPosition = const NCameraPosition(
    target: NLatLng(37.587241, 126.992858),
    zoom: 15.8,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    // Precache marker asset once when controller initializes
    final ctx = Get.context;
    if (ctx != null) {
      precacheImage(const AssetImage('assets/images/line_blank.png'), ctx);
      _markerIconPrecached = true;
    }
  }

  Future<void> updateMarkers(List<CampusMarker> campusMarkers,
      {bool clearBefore = true, BuildContext? context}) async {
    // preload marker asset once to avoid missing texture
    if (!_markerIconPrecached) {
      final ctx = Get.context;
      if (ctx != null) {
        precacheImage(const AssetImage('assets/images/line_blank.png'), ctx);
        _markerIconPrecached = true;
      }
    }
    const size = Size(25, 25);
    final newMarkers = <NMarker>[];
    for (var m in campusMarkers) {
      final iconImage = await NOverlayImage.fromWidget(
        size: size,
        context: Get.context!,
        widget: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Image.asset('assets/images/line_blank.png',
                  width: size.width, height: size.height),
              if (m.hasrank)
                Positioned(
                  top: 3,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      m.rank.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

      newMarkers.add(NMarker(
        id: 'line${m.idNumber}',
        position: m.position,
        size: size,
        icon: iconImage,
        captionOffset: 0,
        caption: NOverlayCaption(
          textSize: 10,
          text: m.name ?? '',
          color: Colors.black,
          requestWidth: 40,
        ),
      ));
    }

    if (clearBefore) {
      markers.value = newMarkers;
    } else {
      markers.addAll(newMarkers);
    }
  }

  Future<void> moveToCurrentLocation() async {
    final locCtrl = Get.find<LocationController>();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await locCtrl.showPermissionAlert();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await locCtrl.showPermissionAlert();
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      cameraPosition.value = NCameraPosition(
        target: NLatLng(position.latitude, position.longitude),
        zoom: cameraPosition.value.zoom,
        bearing: cameraPosition.value.bearing,
        tilt: cameraPosition.value.tilt,
      );
    } catch (_) {
      await locCtrl.showPermissionAlert();
    }
  }

  @override
  void onClose() {
    markers.clear();
    overlays.clear();
    super.onClose();
  }
}
