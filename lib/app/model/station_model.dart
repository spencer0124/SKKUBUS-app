class StationResponse {
  final MetaData metaData;
  final List<StationData> stationData;

  StationResponse({required this.metaData, required this.stationData});

  factory StationResponse.fromJson(Map<String, dynamic> json) {
    return StationResponse(
      metaData: MetaData.fromJson(json["metaData"]),
      stationData: List<StationData>.from(
          json["stationData"].map((x) => StationData.fromJson(x))),
    );
  }

  @override
  String toString() {
    return 'MetaData: ${metaData.toString()}, StationData: ${stationData.map((e) => e.toString()).join(', ')}';
  }
}

class MetaData {
  final bool success;
  final int totalCount;

  MetaData({required this.success, required this.totalCount});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      success: json["success"],
      totalCount: json["total_count"],
    );
  }

  @override
  String toString() {
    return '{Success: $success, TotalCount: $totalCount}';
  }
}

class StationData {
  final String busNm;
  final bool busSupportTime;
  final bool msg1Showmessage;
  final String msg1Message;
  final int? msg1RemainStation;
  final int? msg1RemainSeconds;
  final bool msg2Showmessage;
  final String? msg2Message;
  final int? msg2RemainStation;
  final int? msg2RemainSeconds;

  StationData({
    required this.busNm,
    required this.busSupportTime,
    required this.msg1Showmessage,
    required this.msg1Message,
    this.msg1RemainStation,
    this.msg1RemainSeconds,
    required this.msg2Showmessage,
    this.msg2Message,
    this.msg2RemainStation,
    this.msg2RemainSeconds,
  });

  factory StationData.fromJson(Map<String, dynamic> json) {
    return StationData(
      busNm: json["busNm"],
      busSupportTime: json["busSupportTime"],
      msg1Showmessage: json["msg1_showmessage"],
      msg1Message: json["msg1_message"],
      msg1RemainStation: json["msg1_remainStation"],
      msg1RemainSeconds: json["msg1_remainSeconds"],
      msg2Showmessage: json["msg2_showmessage"],
      msg2Message: json["msg2_message"],
      msg2RemainStation: json["msg2_remainStation"],
      msg2RemainSeconds: json["msg2_remainSeconds"],
    );
  }

  @override
  String toString() {
    return '{BusNm: $busNm, BusSupportTime: $busSupportTime, ...}';
  }
}
