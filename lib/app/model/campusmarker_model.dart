import 'dart:ffi';

import 'package:flutter_naver_map/flutter_naver_map.dart';

class CampusMarker {
  final String idNumber;
  final NLatLng position;
  final bool hasrank;
  final Int? rank;
  final bool? hasStaticLogo;
  final bool? hasDynamicLogo;
  final String? staticLogoLink;
  final String? dynamicLogoUrl;
  final String? name;

  CampusMarker({
    required this.idNumber,
    required this.position,
    required this.hasrank,
    this.rank,
    this.hasStaticLogo,
    this.hasDynamicLogo,
    this.staticLogoLink,
    this.dynamicLogoUrl,
    this.name,
  });
}
