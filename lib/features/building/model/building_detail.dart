import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/model/building_models.dart';

/// Full building detail from GET /building/{skkuId}.
class BuildingDetail {
  final Building building;
  final List<FloorInfo> floors;

  const BuildingDetail({required this.building, required this.floors});

  bool get hasFloors => floors.isNotEmpty;

  factory BuildingDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return BuildingDetail(
      building:
          Building.fromJson(data['building'] as Map<String, dynamic>),
      floors: (data['floors'] as List? ?? [])
          .map((e) => FloorInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// One floor in a building, with its spaces.
class FloorInfo {
  final LocalizedText floor;
  final List<FloorSpace> spaces;

  const FloorInfo({required this.floor, required this.spaces});

  factory FloorInfo.fromJson(Map<String, dynamic> json) {
    return FloorInfo(
      floor: LocalizedText.fromJson(json['floor'] as Map<String, dynamic>),
      spaces: (json['spaces'] as List? ?? [])
          .map((e) => FloorSpace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A space within a floor.
class FloorSpace {
  final String spaceCd;
  final LocalizedText name;
  final String? conspaceCd;

  const FloorSpace({
    required this.spaceCd,
    required this.name,
    this.conspaceCd,
  });

  factory FloorSpace.fromJson(Map<String, dynamic> json) {
    return FloorSpace(
      spaceCd: json['spaceCd'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      conspaceCd: json['conspaceCd'] as String?,
    );
  }
}
