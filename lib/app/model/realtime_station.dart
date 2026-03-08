import 'package:skkumap/app/model/main_bus_stationlist.dart';

/// Static station from realtime bus config `screen.stations[]`.
class RealtimeStation {
  final int index;
  final String name;
  final String? stationNumber;
  final bool isFirstStation;
  final bool isLastStation;
  final bool isRotationStation;
  final List<TransferLine> transferLines;

  const RealtimeStation({
    required this.index,
    required this.name,
    this.stationNumber,
    required this.isFirstStation,
    required this.isLastStation,
    required this.isRotationStation,
    this.transferLines = const [],
  });

  factory RealtimeStation.fromJson(Map<String, dynamic> json) {
    return RealtimeStation(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      stationNumber: json['stationNumber'] as String?,
      isFirstStation: json['isFirstStation'] as bool,
      isLastStation: json['isLastStation'] as bool,
      isRotationStation: json['isRotationStation'] as bool,
      transferLines: (json['transferLines'] as List?)
              ?.map((e) => TransferLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
