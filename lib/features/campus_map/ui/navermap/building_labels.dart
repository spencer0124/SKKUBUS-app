import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

const _icon = NOverlayImage.fromAssetImage('assets/images/line_blank.png');

class _Building {
  final String name;
  final String number;
  final double lat;
  final double lng;
  const _Building(this.name, this.number, this.lat, this.lng);
}

const _buildings = [
  _Building('법학관', '2', 37.58748501659492, 126.99053101116544),
  _Building('수선관', '61', 37.58788072085495, 126.99092247338302),
  _Building('수선관 별관', '62', 37.588139811212706, 126.99106740087694),
  _Building('퇴계인문관', '31', 37.589220754319406, 126.99147717805783),
  _Building('호암관', '50', 37.58848847613726, 126.99199321977022),
  _Building('다산경제관', '32', 37.58911270777998, 126.99232478242072),
  _Building('경영관', '33', 37.58879804609599, 126.99259012301832),
  _Building('교수회관', '4', 37.58867986636413, 126.99318393697439),
  _Building('중앙학술정보관', '7', 37.58844500320003, 126.99415885814051),
  _Building('600주년 기념관', '1', 37.58741293295885, 126.99456883922579),
  _Building('국제관', '9', 37.58679514260422, 126.99524802288272),
  _Building('학생회관', '8', 37.58751562962703, 126.99328505952604),
];

Set<NMarker> buildBuildingLabels() {
  final markers = <NMarker>{};
  for (final b in _buildings) {
    // 건물 이름 라벨
    markers.add(NMarker(
      id: '_bldg_name_${b.number}',
      position: NLatLng(b.lat, b.lng),
      size: const Size(1, 1),
      caption: NOverlayCaption(
        text: b.name,
        textSize: 10,
        color: Colors.black,
        haloColor: Colors.white,
      ),
    ));
    // 번호 마커
    markers.add(NMarker(
      id: '_bldg_num_${b.number}',
      position: NLatLng(b.lat, b.lng),
      size: const Size(25, 25),
      icon: _icon,
      captionOffset: -22,
      caption: NOverlayCaption(
        textSize: 7,
        text: b.number,
        color: Colors.black,
      ),
    ));
  }
  return markers;
}
