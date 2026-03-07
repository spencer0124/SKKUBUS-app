import 'package:flutter/material.dart';
import 'package:skkumap/app/utils/color_utils.dart';

class RouteTypeDisplay {
  final String label;
  final Color color;

  const RouteTypeDisplay({required this.label, required this.color});

  factory RouteTypeDisplay.fromJson(Map<String, dynamic> json) {
    return RouteTypeDisplay(
      label: json['label'] as String,
      color: parseHexColor(json['color'] as String?),
    );
  }
}

class ScheduleSlot {
  final String time;
  final RouteTypeDisplay routeType;
  final int busCount;
  final String? boardingLocation;
  final bool isFastest;
  final String? note;

  const ScheduleSlot({
    required this.time,
    required this.routeType,
    required this.busCount,
    this.boardingLocation,
    required this.isFastest,
    this.note,
  });

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ScheduleSlot(
      time: json['time'] as String,
      routeType:
          RouteTypeDisplay.fromJson(json['routeType'] as Map<String, dynamic>),
      busCount: (json['busCount'] as num?)?.toInt() ?? 1,
      boardingLocation: json['boardingLocation'] as String?,
      isFastest: json['isFastest'] as bool? ?? false,
      note: json['note'] as String?,
    );
  }
}

class ScheduleResponse {
  final String? boardingLocation;
  final bool noService;
  final String? noServiceReason;
  final List<ScheduleSlot> slots;

  const ScheduleResponse({
    this.boardingLocation,
    required this.noService,
    this.noServiceReason,
    required this.slots,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final data = json['data'] as List? ?? [];
    return ScheduleResponse(
      boardingLocation: meta['boardingLocation'] as String?,
      noService: meta['noService'] as bool? ?? false,
      noServiceReason: meta['noServiceReason'] as String?,
      slots: data
          .map((e) => ScheduleSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
