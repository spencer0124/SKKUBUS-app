import 'package:skkumap/features/campus_map/model/map_config.dart';

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
        'endpoint': '/building/list',
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
