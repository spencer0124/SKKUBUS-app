import 'package:flutter/material.dart';

class ResponseMetadata {
  final String currentTime;
  final int totalBuses;
  final int lastStationIndex;

  ResponseMetadata({
    required this.currentTime,
    required this.totalBuses,
    required this.lastStationIndex,
  });

  factory ResponseMetadata.fromJson(Map<String, dynamic> json) {
    return ResponseMetadata(
      currentTime: json['currentTime'],
      totalBuses: json['totalBuses'],
      lastStationIndex: json['lastStationIndex'],
    );
  }
}

class TransferLine {
  final String line;
  final Color color;

  const TransferLine({required this.line, required this.color});

  factory TransferLine.fromJson(Map<String, dynamic> json) {
    return TransferLine(
      line: json['line'] as String,
      color: Color(int.parse('0xFF${json['color']}')),
    );
  }
}

class BusStation {
  final String stationName;
  final String? stationNumber;
  final String eta;
  final bool isFirstStation;
  final bool isLastStation;
  final bool isRotationStation;
  final String busType;
  final List<TransferLine> transferLines;

  BusStation({
    required this.stationName,
    this.stationNumber,
    required this.eta,
    required this.isFirstStation,
    required this.isLastStation,
    required this.isRotationStation,
    required this.busType,
    this.transferLines = const [],
  });

  factory BusStation.fromJson(Map<String, dynamic> json) {
    return BusStation(
      stationName: json['stationName'],
      stationNumber: json['stationNumber'],
      eta: json['eta'],
      isFirstStation: json['isFirstStation'],
      isLastStation: json['isLastStation'],
      isRotationStation: json['isRotationStation'],
      busType: json['busType'],
      transferLines: (json['transferLines'] as List?)
              ?.map((e) => TransferLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class MainBusStationList {
  final ResponseMetadata metadata;
  final List<BusStation> stations;

  MainBusStationList({
    required this.metadata,
    required this.stations,
  });

  factory MainBusStationList.fromJson(Map<String, dynamic> json) {
    var stationsList = (json['data'] as List)
        .map((i) => BusStation.fromJson(i))
        .toList();

    return MainBusStationList(
      metadata: ResponseMetadata.fromJson(json['meta']),
      stations: stationsList,
    );
  }
}
