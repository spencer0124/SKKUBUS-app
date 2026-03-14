import 'package:skkumap/features/campus_map/model/map_config.dart';
import 'package:skkumap/features/campus_map/model/map_marker.dart';

const _mockMapConfigJson = {
  'meta': {},
  'data': {
    'campuses': [
      {
        'id': 'hssc',
        'label': '인사캠',
        'centerLat': 37.587241,
        'centerLng': 126.992858,
        'defaultZoom': 15.8,
      },
      {
        'id': 'nsc',
        'label': '자과캠',
        'centerLat': 37.293580,
        'centerLng': 126.974942,
        'defaultZoom': 15.8,
      },
    ],
    'layers': [
      {
        'id': 'campus_buildings',
        'type': 'marker',
        'label': '건물번호',
        'defaultVisible': true,
        'endpoint': '/map/overlays?category=hssc',
      },
      {
        'id': 'bus_route_jongro07',
        'type': 'polyline',
        'label': '종로07 노선',
        'defaultVisible': true,
        'endpoint': '/map/overlays/jongro07',
        'style': {'color': '4CAF50'},
      },
      {
        'id': 'bus_route_jongro02',
        'type': 'polyline',
        'label': '종로02 노선',
        'defaultVisible': true,
        'endpoint': '/map/overlays/jongro02',
        'style': {'color': '4CAF50'},
      },
    ],
  },
};

MapConfig getMockMapConfig() => MapConfig.fromJson(
    Map<String, dynamic>.from(_mockMapConfigJson).map((k, v) =>
        MapEntry(k, v is Map ? Map<String, dynamic>.from(v) : v)));

/// Campus markers converted from the former hardcoded hsscMarkers / nscMarkers.
List<ServerMapMarker> getMockCampusMarkers() => const [
      // ── HSSC (인사캠) ──
      ServerMapMarker(
          id: 'hssc_1',
          code: '1',
          name: '수선관',
          campus: 'hssc',
          lat: 37.587361,
          lng: 126.994479),
      ServerMapMarker(
          id: 'hssc_2',
          code: '2',
          name: '양현재',
          campus: 'hssc',
          lat: 37.587441,
          lng: 126.990506),
      ServerMapMarker(
          id: 'hssc_4',
          code: '4',
          name: '법학관',
          campus: 'hssc',
          lat: 37.588636,
          lng: 126.993209),
      ServerMapMarker(
          id: 'hssc_7',
          code: '7',
          name: '호암관',
          campus: 'hssc',
          lat: 37.588353,
          lng: 126.994262),
      ServerMapMarker(
          id: 'hssc_8',
          code: '8',
          name: '수선관별관',
          campus: 'hssc',
          lat: 37.58752,
          lng: 126.99322),
      ServerMapMarker(
          id: 'hssc_9',
          code: '9',
          name: '경영대학별관',
          campus: 'hssc',
          lat: 37.586819,
          lng: 126.995246),
      ServerMapMarker(
          id: 'hssc_31',
          code: '31',
          name: '퇴계인문관',
          campus: 'hssc',
          lat: 37.589184,
          lng: 126.991539),
      ServerMapMarker(
          id: 'hssc_32',
          code: '32',
          name: '다산경제관',
          campus: 'hssc',
          lat: 37.589053,
          lng: 126.992435),
      ServerMapMarker(
          id: 'hssc_33',
          code: '33',
          name: '경영대학',
          campus: 'hssc',
          lat: 37.588572,
          lng: 126.992666),
      ServerMapMarker(
          id: 'hssc_61',
          code: '61',
          name: '국제관',
          campus: 'hssc',
          lat: 37.587882,
          lng: 126.991079),
      ServerMapMarker(
          id: 'hssc_62',
          code: '62',
          name: '경영대학신관',
          campus: 'hssc',
          lat: 37.58816,
          lng: 126.990868),
      // ── NSC (자과캠) ──
      ServerMapMarker(
          id: 'nsc_1',
          code: '1',
          name: '자연과학캠퍼스',
          campus: 'nsc',
          lat: 37.293580,
          lng: 126.974942),
    ];
