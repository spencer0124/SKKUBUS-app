class StationResponse {
  final MetaData metaData;
  final List<StationData> stationData;

  StationResponse({required this.metaData, required this.stationData});

  factory StationResponse.fromJson(Map<String, dynamic> json) {
    return StationResponse(
      metaData: MetaData.fromJson(json["meta"]),
      stationData: List<StationData>.from(
          json["data"].map((x) => StationData.fromJson(x))),
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

  MetaData({this.success = true, required this.totalCount});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      success: json["success"] ?? true,
      totalCount: json["totalCount"],
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
      msg1Showmessage: json["msg1ShowMessage"],
      msg1Message: json["msg1Message"],
      msg1RemainStation: json["msg1RemainStation"],
      msg1RemainSeconds: json["msg1RemainSeconds"],
      msg2Showmessage: json["msg2ShowMessage"],
      msg2Message: json["msg2Message"],
      msg2RemainStation: json["msg2RemainStation"],
      msg2RemainSeconds: json["msg2RemainSeconds"],
    );
  }

  @override
  String toString() {
    return '{BusNm: $busNm, BusSupportTime: $busSupportTime, ...}';
  }
}
