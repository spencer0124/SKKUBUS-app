import 'package:skkumap/features/campus_map/ui/navermap/marker_campus.dart';
import 'package:skkumap/features/campus_map/model/campusmarker_model.dart';

enum CampusType { hssc, nsc }

extension CampusTypeExtension on CampusType {
  List<CampusMarker> get markername {
    switch (this) {
      case CampusType.hssc:
        return hsscMarkers;
      case CampusType.nsc:
        return nscMarkers;
    }
  }
}
