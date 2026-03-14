import 'package:flutter/material.dart';
import 'package:skkumap/core/utils/color_utils.dart';
import 'package:skkumap/features/transit/model/realtime_station.dart';

class BusGroup {
  final String id;
  final String screenType; // "realtime" | "schedule"
  final String label;
  final BusGroupVisibility visibility;
  final BusGroupCard card;
  final Map<String, dynamic> screen;

  const BusGroup({
    required this.id,
    required this.screenType,
    required this.label,
    required this.visibility,
    required this.card,
    required this.screen,
  });

  factory BusGroup.fromJson(Map<String, dynamic> json) {
    return BusGroup(
      id: json['id'] as String,
      screenType: json['screenType'] as String,
      label: json['label'] as String,
      visibility: BusGroupVisibility.fromJson(
          json['visibility'] as Map<String, dynamic>),
      card: BusGroupCard.fromJson(json['card'] as Map<String, dynamic>),
      screen: json['screen'] as Map<String, dynamic>,
    );
  }

  bool get isRealtime => screenType == 'realtime';
  bool get isSchedule => screenType == 'schedule';

  bool isVisible(DateTime now) => visibility.isVisible(now);

  // --- schedule accessors ---
  String? get defaultServiceId => screen['defaultServiceId'] as String?;

  List<BusService> get services => (screen['services'] as List? ?? [])
      .map((e) => BusService.fromJson(e as Map<String, dynamic>))
      .toList();

  HeroCard? get heroCard {
    final hc = screen['heroCard'];
    if (hc == null) return null;
    return HeroCard.fromJson(hc as Map<String, dynamic>);
  }

  List<RouteBadge> get routeBadges => (screen['routeBadges'] as List? ?? [])
      .map((e) => RouteBadge.fromJson(e as Map<String, dynamic>))
      .toList();

  List<Map<String, dynamic>> get features =>
      (screen['features'] as List? ?? []).cast<Map<String, dynamic>>();

  // --- realtime accessors ---
  String? get dataEndpoint => screen['dataEndpoint'] as String?;
  int get refreshInterval =>
      (screen['refreshInterval'] as num?)?.toInt() ?? 15;
  int get lastStationIndex =>
      (screen['lastStationIndex'] as num?)?.toInt() ?? 10;
  List<RealtimeStation> get realtimeStations =>
      (screen['stations'] as List? ?? [])
          .map((e) => RealtimeStation.fromJson(e as Map<String, dynamic>))
          .toList();
}

class BusGroupVisibility {
  final String type; // "always" | "dateRange"
  final String? from;
  final String? until;

  const BusGroupVisibility({required this.type, this.from, this.until});

  factory BusGroupVisibility.fromJson(Map<String, dynamic> json) {
    return BusGroupVisibility(
      type: json['type'] as String,
      from: json['from'] as String?,
      until: json['until'] as String?,
    );
  }

  bool isVisible(DateTime now) {
    if (type == 'always') return true;
    if (type == 'dateRange' && from != null && until != null) {
      final start = DateTime.parse(from!);
      final end = DateTime.parse('${until!}T23:59:59.999');
      return !now.isBefore(start) && !now.isAfter(end);
    }
    return true;
  }
}

class BusGroupCard {
  final Color themeColor;
  final String iconType;
  final String busTypeText;

  const BusGroupCard({
    required this.themeColor,
    required this.iconType,
    required this.busTypeText,
  });

  factory BusGroupCard.fromJson(Map<String, dynamic> json) {
    return BusGroupCard(
      themeColor: parseHexColor(json['themeColor'] as String?),
      iconType: json['iconType'] as String,
      busTypeText: json['busTypeText'] as String,
    );
  }
}

class BusService {
  final String serviceId;
  final String label;
  final String weekEndpoint;

  const BusService({
    required this.serviceId,
    required this.label,
    required this.weekEndpoint,
  });

  factory BusService.fromJson(Map<String, dynamic> json) {
    return BusService(
      serviceId: json['serviceId'] as String,
      label: json['label'] as String,
      weekEndpoint: json['weekEndpoint'] as String,
    );
  }
}

class RouteBadge {
  final String id;
  final String label;
  final String color; // hex "003626"

  const RouteBadge({
    required this.id,
    required this.label,
    required this.color,
  });

  factory RouteBadge.fromJson(Map<String, dynamic> json) {
    return RouteBadge(
      id: json['id'] as String,
      label: json['label'] as String,
      color: json['color'] as String,
    );
  }
}

class HeroCard {
  final String etaEndpoint;
  final int showUntilMinutesBefore;

  const HeroCard({
    required this.etaEndpoint,
    required this.showUntilMinutesBefore,
  });

  factory HeroCard.fromJson(Map<String, dynamic> json) {
    return HeroCard(
      etaEndpoint: json['etaEndpoint'] as String,
      showUntilMinutesBefore: (json['showUntilMinutesBefore'] as num).toInt(),
    );
  }
}
