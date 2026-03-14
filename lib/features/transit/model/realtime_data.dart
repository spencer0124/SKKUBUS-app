/// Parsed response from `GET /bus/realtime/data/:groupId`.
class RealtimeData {
  final RealtimeMeta meta;
  final String groupId;
  final List<RealtimeBus> buses;
  final List<StationEta> stationEtas;

  const RealtimeData({
    required this.meta,
    required this.groupId,
    required this.buses,
    required this.stationEtas,
  });

  factory RealtimeData.fromJson(Map<String, dynamic> json) {
    final meta = RealtimeMeta.fromJson(json['meta'] as Map<String, dynamic>);
    final data = json['data'] as Map<String, dynamic>;
    return RealtimeData(
      meta: meta,
      groupId: data['groupId'] as String,
      buses: (data['buses'] as List)
          .map((e) => RealtimeBus.fromJson(e as Map<String, dynamic>))
          .toList(),
      stationEtas: (data['stationEtas'] as List)
          .map((e) => StationEta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RealtimeMeta {
  final String currentTime;
  final int totalBuses;

  const RealtimeMeta({
    required this.currentTime,
    required this.totalBuses,
  });

  factory RealtimeMeta.fromJson(Map<String, dynamic> json) {
    return RealtimeMeta(
      currentTime: json['currentTime'] as String,
      totalBuses: json['totalBuses'] as int,
    );
  }
}

class RealtimeBus {
  final int stationIndex; // 0-based
  final String carNumber;
  final int estimatedTime; // seconds elapsed since last station crossing

  const RealtimeBus({
    required this.stationIndex,
    required this.carNumber,
    required this.estimatedTime,
  });

  factory RealtimeBus.fromJson(Map<String, dynamic> json) {
    return RealtimeBus(
      stationIndex: (json['stationIndex'] as num).toInt(),
      carNumber: json['carNumber'] as String,
      estimatedTime: (json['estimatedTime'] as num).toInt(),
    );
  }
}

class StationEta {
  final int stationIndex; // 0-based
  final String eta; // e.g. "3분후[1번째 전]"

  const StationEta({
    required this.stationIndex,
    required this.eta,
  });

  factory StationEta.fromJson(Map<String, dynamic> json) {
    return StationEta(
      stationIndex: (json['stationIndex'] as num).toInt(),
      eta: json['eta'] as String,
    );
  }
}
