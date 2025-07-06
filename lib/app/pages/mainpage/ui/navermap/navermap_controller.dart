import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/marker_campus.dart';
import "package:skkumap/app/model/campusmarker_model.dart";
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:skkumap/app/utils/geolocator.dart';
import 'package:geolocator/geolocator.dart';

class UltimateNMapController extends GetxController {
  // ensure marker asset is precached once
  bool _markerIconPrecached = false;
  // store the native map controller for bounds queries
  final mapController = Rx<NaverMapController?>(null);
  final markers = <NMarker>[].obs;
  final overlays = <NOverlay>[].obs;
  final cameraPosition = const NCameraPosition(
    target: NLatLng(37.587241, 126.992858),
    zoom: 15.8,
    // bearing: 330,
    // tilt: 50,
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
                        fontFamily: 'WantedSansBold',
                      ),
                    ),
                  ),
                ),
              if (!m.hasrank)
                // todo: asset logo 넣기 & preload
                if (m.hasStaticLogo == true)
                  const Positioned(
                    top: 3,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "static logo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 7,
                          fontFamily: 'WantedSansBold',
                        ),
                      ),
                    ),
                  )
                // todo: networkimage & preload
                else if (m.hasDynamicLogo == true)
                  const Positioned(
                    top: 3,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "dynamic logo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 7,
                          fontFamily: 'WantedSansBold',
                        ),
                      ),
                    ),
                  )
                // rank, staticLogo, dynamicLogo 모두 없는 경우
                else
                  const Positioned(
                    top: 3,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "else1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 7,
                          fontFamily: 'WantedSansBold',
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

// 예시구현
  Future<void> fetchMarkersFromServer() async {
    // TODO: 서버에서 CampusMarker 데이터 가져오기
    // 예시
    final fetchedMarkers = <CampusMarker>[
      CampusMarker(
        idNumber: "1",
        position: const NLatLng(37.587361, 126.994479),
        hasrank: false,
      ),
      CampusMarker(
        idNumber: "10",
        position: const NLatLng(37.59, 126.99),
        hasrank: false,
      ),
    ];
    updateMarkers(fetchedMarkers);
  }

// 예시구현
  Future<void> fetchCameraPositionFromServer() async {
    // 예시 위치: 중앙도서관 근처
    const newPosition = NCameraPosition(
      target: NLatLng(37.5885, 126.9935),
      zoom: 17.5,
      bearing: 0,
      tilt: 0,
    );
    cameraPosition.value = newPosition;
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
        desiredAccuracy: LocationAccuracy.high,
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

  /// Create markers with custom widget icon (image + text)
  // Future<void> updateMarkersWithWidgetIcon(
  //     BuildContext context, List<CampusMarker> campusMarkers,
  //     {bool clearBefore = true}) async {
  //   const size = Size(25, 25);
  //   final iconImage = await NOverlayImage.fromWidget(
  //     size: size,
  //     context: context,
  //     widget: SizedBox(
  //       width: size.width,
  //       height: size.height,
  //       child: Stack(
  //         children: [
  //           Image.asset('assets/images/line_blank.png',
  //               width: size.width, height: size.height),
  //           // replace with m.idNumber inside loop if needed
  //         ],
  //       ),
  //     ),
  //   );
  //   final newMarkers = campusMarkers.map((m) {
  //     return NMarker(
  //       id: 'line${m.idNumber}',
  //       position: m.position,
  //       size: size,
  //       icon: iconImage,
  //       captionOffset: 0,
  //       caption:
  //           NOverlayCaption(textSize: 7, text: m.idNumber, color: Colors.black),
  //     );
  //   }).toList();
  //   if (clearBefore) {
  //     markers.value = newMarkers;
  //   } else {
  //     markers.addAll(newMarkers);
  //   }
  // }

  // void updateOverlay(List<NLatLng> coords, String id) {
  //   overlays.value = [
  //     NMultipartPathOverlay(
  //       id: id,
  //       paths: [
  //         NMultipartPath(
  //           coords: coords,
  //           color: Colors.green,
  //           outlineColor: Colors.white,
  //         )
  //       ],
  //     ),
  //   ];
  // }
}
