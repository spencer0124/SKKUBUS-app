import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/model/building_models.dart';

/// Full building detail from GET /building/{skkuId}.
class BuildingDetail {
  final Building building;
  final List<FloorInfo> floors;
  final List<BuildingConnection> connections;

  const BuildingDetail({
    required this.building,
    required this.floors,
    required this.connections,
  });

  bool get hasFloors => floors.isNotEmpty;
  bool get hasConnections => connections.isNotEmpty;

  factory BuildingDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return BuildingDetail(
      building:
          Building.fromJson(data['building'] as Map<String, dynamic>),
      floors: (data['floors'] as List? ?? [])
          .map((e) => FloorInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      connections: (data['connections'] as List? ?? [])
          .map((e) =>
              BuildingConnection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A connection passage to another building.
class BuildingConnection {
  final int targetSkkuId;
  final String? targetBuildNo;
  final String? targetDisplayNo;
  final LocalizedText targetName;
  final LocalizedText fromFloor;
  final LocalizedText toFloor;

  const BuildingConnection({
    required this.targetSkkuId,
    this.targetBuildNo,
    this.targetDisplayNo,
    required this.targetName,
    required this.fromFloor,
    required this.toFloor,
  });

  factory BuildingConnection.fromJson(Map<String, dynamic> json) {
    return BuildingConnection(
      targetSkkuId: json['targetSkkuId'] as int,
      targetBuildNo: json['targetBuildNo'] as String?,
      targetDisplayNo: json['targetDisplayNo'] as String?,
      targetName:
          LocalizedText.fromJson(json['targetName'] as Map<String, dynamic>),
      fromFloor:
          LocalizedText.fromJson(json['fromFloor'] as Map<String, dynamic>),
      toFloor:
          LocalizedText.fromJson(json['toFloor'] as Map<String, dynamic>),
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
