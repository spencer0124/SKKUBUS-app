import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/model/building_models.dart';

/// Top-level search result from GET /building/search.
class BuildingSearchResult {
  final String keyword;
  final int buildingCount;
  final int spaceCount;
  final List<Building> buildings;
  final List<SpaceGroup> spaces;

  const BuildingSearchResult({
    required this.keyword,
    required this.buildingCount,
    required this.spaceCount,
    required this.buildings,
    required this.spaces,
  });

  factory BuildingSearchResult.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    return BuildingSearchResult(
      keyword: meta['keyword'] as String? ?? '',
      buildingCount: meta['buildingCount'] as int? ?? 0,
      spaceCount: meta['spaceCount'] as int? ?? 0,
      buildings: (data['buildings'] as List? ?? [])
          .map((e) => Building.fromJson(e as Map<String, dynamic>))
          .toList(),
      spaces: (data['spaces'] as List? ?? [])
          .map((e) => SpaceGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A group of spaces within one building from search results.
class SpaceGroup {
  final int? skkuId;
  final String buildNo;
  final String? displayNo;
  final LocalizedText buildingName;
  final List<SearchSpaceItem> items;

  const SpaceGroup({
    this.skkuId,
    required this.buildNo,
    this.displayNo,
    required this.buildingName,
    required this.items,
  });

  factory SpaceGroup.fromJson(Map<String, dynamic> json) {
    return SpaceGroup(
      skkuId: json['skkuId'] as int?,
      buildNo: json['buildNo'] as String? ?? '',
      displayNo: json['displayNo'] as String?,
      buildingName: LocalizedText.fromJson(
          json['buildingName'] as Map<String, dynamic>),
      items: (json['items'] as List? ?? [])
          .map((e) => SearchSpaceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A single space/room from search results.
class SearchSpaceItem {
  final String spaceCd;
  final LocalizedText name;
  final LocalizedText floor;

  const SearchSpaceItem({
    required this.spaceCd,
    required this.name,
    required this.floor,
  });

  factory SearchSpaceItem.fromJson(Map<String, dynamic> json) {
    return SearchSpaceItem(
      spaceCd: json['spaceCd'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      floor: LocalizedText.fromJson(json['floor'] as Map<String, dynamic>),
    );
  }
}
