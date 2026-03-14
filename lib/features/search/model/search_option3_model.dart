class SearchOption3Model {
  @override
  String toString() {
    return 'SearchOption3Model{metaData: $metaData, option3Items: $option3Items}';
  }

  MetaData metaData;
  Option3Items option3Items;

  SearchOption3Model({required this.metaData, required this.option3Items});

  factory SearchOption3Model.fromJson(Map<String, dynamic> json) {
    return SearchOption3Model(
      metaData: MetaData.fromJson(json['meta']),
      option3Items: Option3Items.fromJson(json['data'] ??
          {'hssc': [], 'nsc': []}), // Provide a default empty structure
    );
  }
}

class MetaData {
  @override
  String toString() {
    return 'MetaData{keyword: $keyword, option3TotalCount: $option3TotalCount, option3HsscCount: $option3HsscCount, option3NscCount: $option3NscCount}';
  }

  String keyword;
  int option3TotalCount;
  int option3HsscCount;
  int option3NscCount;

  MetaData({
    required this.keyword,
    required this.option3TotalCount,
    required this.option3HsscCount,
    required this.option3NscCount,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      keyword: json['keyword'],
      option3TotalCount: json['facilitiesTotalCount'],
      option3HsscCount: json['facilitiesHsscCount'],
      option3NscCount: json['facilitiesNscCount'],
    );
  }
}

class Option3Items {
  @override
  String toString() {
    return 'Option3Items{hssc: $hssc, nsc: $nsc}';
  }

  List<SpaceItem>? hssc;
  List<SpaceItem>? nsc;

  Option3Items({this.hssc, this.nsc});

  factory Option3Items.fromJson(Map<String, dynamic> json) {
    return Option3Items(
      hssc: (json['hssc'] as List<dynamic>?)
          ?.map((x) => SpaceItem.fromJson(x))
          .toList(),
      nsc: (json['nsc'] as List<dynamic>?)
          ?.map((x) => SpaceItem.fromJson(x))
          .toList(),
    );
  }
}

class BuildingInfo {
  @override
  String toString() {
    return 'BuildingInfo{buildNmKr: $buildNmKr, buildNmEn: $buildNmEn, buildNo: $buildNo, latitude: $latitude, longtitude: $longtitude}';
  }

  String? buildNmKr;
  String? buildNmEn;
  String? buildNo;
  double? latitude;
  double? longtitude;

  BuildingInfo(
      {this.buildNmKr,
      this.buildNmEn,
      this.buildNo,
      this.latitude,
      this.longtitude});

  factory BuildingInfo.fromJson(Map<String, dynamic> json) {
    return BuildingInfo(
      buildNmKr: json['buildNm_kr'] as String?,
      buildNmEn: json['buildNm_en'] as String?,
      buildNo: json['buildNo'] as String?,
      latitude: json['latitude'] as double?,
      longtitude: json['longtitude'] as double?,
    );
  }
}

class SpaceInfo {
  @override
  String toString() {
    return 'SpaceInfo{floorNmKr: $floorNmKr, floorNmEn: $floorNmEn, spaceNmKr: $spaceNmKr, spaceNmEn: $spaceNmEn, spaceCd: $spaceCd}';
  }

  String? floorNmKr;
  String? floorNmEn;
  String? spaceNmKr;
  String? spaceNmEn;
  String? spaceCd;

  SpaceInfo(
      {this.floorNmKr,
      this.floorNmEn,
      this.spaceNmKr,
      this.spaceNmEn,
      this.spaceCd});

  factory SpaceInfo.fromJson(Map<String, dynamic> json) {
    return SpaceInfo(
      floorNmKr: json['floorNm_kr'] as String?,
      floorNmEn: json['floorNm_en'] as String?,
      spaceNmKr: json['spaceNm_kr'] as String?,
      spaceNmEn: json['spaceNm_en'] as String?,
      spaceCd: json['spaceCd'] as String?,
    );
  }
}

class SpaceItem {
  @override
  String toString() {
    return 'SpaceItem{buildingInfo: $buildingInfo, spaceInfo: $spaceInfo}';
  }

  BuildingInfo? buildingInfo;
  SpaceInfo? spaceInfo;
  String? category;

  SpaceItem({this.buildingInfo, this.spaceInfo, this.category});

  factory SpaceItem.fromJson(Map<String, dynamic> json) {
    return SpaceItem(
      buildingInfo: json['buildingInfo'] != null
          ? BuildingInfo.fromJson(json['buildingInfo'])
          : null,
      spaceInfo: json['spaceInfo'] != null
          ? SpaceInfo.fromJson(json['spaceInfo'])
          : null,
    );
  }
}
