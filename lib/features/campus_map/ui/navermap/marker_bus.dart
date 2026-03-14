import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter/material.dart";

const icon = NOverlayImage.fromAssetImage('assets/images/jonrobus.png');

const List<NLatLng> jongroBusPositions = [
  NLatLng(37.583427, 127.001850),
  NLatLng(37.584000, 127.002000),
];

List<NMarker> buildJongroBusMarkers(List<NLatLng> positions) {
  return List<NMarker>.generate(positions.length, (index) {
    return NMarker(
      size: const Size(20, 20),
      id: 'jongrobusMarker${index + 1}',
      position: positions[index],
      icon: icon,
    );
  });
}
