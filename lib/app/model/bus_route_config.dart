import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skkumap/app/utils/color_utils.dart';

class BusRouteConfig {
  final String id;
  final String screenType; // "realtime" | "schedule" | "webview"
  final String? fallbackUrl;
  final BusDisplay display;
  final RealtimeConfig? realtime;
  final ScheduleConfig? schedule;
  final BusFeatures features;

  const BusRouteConfig({
    required this.id,
    required this.screenType,
    this.fallbackUrl,
    required this.display,
    this.realtime,
    this.schedule,
    required this.features,
  });

  factory BusRouteConfig.fromJson(Map<String, dynamic> json) {
    return BusRouteConfig(
      id: json['id'] as String,
      screenType: json['screenType'] as String,
      fallbackUrl: json['fallbackUrl'] as String?,
      display: BusDisplay.fromJson(json['display'] as Map<String, dynamic>),
      realtime: json['realtime'] != null
          ? RealtimeConfig.fromJson(json['realtime'] as Map<String, dynamic>)
          : null,
      schedule: json['schedule'] != null
          ? ScheduleConfig.fromJson(json['schedule'] as Map<String, dynamic>)
          : null,
      features: BusFeatures.fromJson(
          json['features'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class BusDisplay {
  final String name;
  final Color themeColor;
  final String iconType; // "shuttle" | "village" | URL

  const BusDisplay({
    required this.name,
    required this.themeColor,
    required this.iconType,
  });

  factory BusDisplay.fromJson(Map<String, dynamic> json) {
    return BusDisplay(
      name: json['name'] as String,
      themeColor: parseHexColor(json['themeColor'] as String?),
      iconType: json['iconType'] as String,
    );
  }
}

class RealtimeConfig {
  final String stationsEndpoint;
  final String locationsEndpoint;
  final int refreshInterval;

  const RealtimeConfig({
    required this.stationsEndpoint,
    required this.locationsEndpoint,
    required this.refreshInterval,
  });

  factory RealtimeConfig.fromJson(Map<String, dynamic> json) {
    return RealtimeConfig(
      stationsEndpoint: json['stationsEndpoint'] as String,
      locationsEndpoint: json['locationsEndpoint'] as String,
      refreshInterval: (json['refreshInterval'] as num).toInt(),
    );
  }
}

// ── Schedule config (selector-based) ──

class SelectorItem {
  final String? key; // fixed date (festival) — null if dayOfWeek is set
  final int? dayOfWeek; // 1=Mon...7=Sun (regular) — null if key is set
  final String label;
  final String? sublabel;
  final bool noService;

  const SelectorItem({
    this.key,
    this.dayOfWeek,
    required this.label,
    this.sublabel,
    this.noService = false,
  });

  factory SelectorItem.fromJson(Map<String, dynamic> json) {
    return SelectorItem(
      key: json['key'] as String?,
      dayOfWeek: json['dayOfWeek'] as int?,
      label: json['label'] as String,
      sublabel: json['sublabel'] as String?,
      noService: json['noService'] as bool? ?? false,
    );
  }

  /// Resolve to a YYYY-MM-DD date string.
  /// - Fixed key items: return the key as-is.
  /// - DayOfWeek items: compute this week's date for that weekday.
  String resolveDate() {
    if (key != null) return key!;
    final now = DateTime.now();
    final diff = dayOfWeek! - now.weekday;
    final date = DateTime(now.year, now.month, now.day + diff);
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

class BusDirection {
  final String id;
  final String label;
  final String endpoint; // "/bus/schedule/{routeId}/{direction}/{date}"

  const BusDirection({
    required this.id,
    required this.label,
    required this.endpoint,
  });

  factory BusDirection.fromJson(Map<String, dynamic> json) {
    return BusDirection(
      id: json['id'] as String,
      label: json['label'] as String,
      endpoint: json['endpoint'] as String,
    );
  }
}

class ScheduleConfig {
  final List<SelectorItem> selector;
  final List<BusDirection> directions;

  const ScheduleConfig({
    required this.selector,
    required this.directions,
  });

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) {
    return ScheduleConfig(
      selector: (json['selector'] as List)
          .map((e) => SelectorItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      directions: (json['directions'] as List)
          .map((e) => BusDirection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── Features ──

class BusFeatures {
  final InfoFeature? info;
  final RouteOverlayFeature? routeOverlay;
  final EtaFeature? eta;

  const BusFeatures({this.info, this.routeOverlay, this.eta});

  factory BusFeatures.fromJson(Map<String, dynamic> json) {
    return BusFeatures(
      info: json['info'] != null
          ? InfoFeature.fromJson(json['info'] as Map<String, dynamic>)
          : null,
      routeOverlay: json['routeOverlay'] != null
          ? RouteOverlayFeature.fromJson(
              json['routeOverlay'] as Map<String, dynamic>)
          : null,
      eta: json['eta'] != null
          ? EtaFeature.fromJson(json['eta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class InfoFeature {
  final String url;
  const InfoFeature({required this.url});

  factory InfoFeature.fromJson(Map<String, dynamic> json) {
    return InfoFeature(url: json['url'] as String);
  }
}

class RouteOverlayFeature {
  final String coordsEndpoint;
  final Color color;

  const RouteOverlayFeature({
    required this.coordsEndpoint,
    required this.color,
  });

  factory RouteOverlayFeature.fromJson(Map<String, dynamic> json) {
    return RouteOverlayFeature(
      coordsEndpoint: json['coordsEndpoint'] as String,
      color: parseHexColor(json['color'] as String?),
    );
  }
}

class EtaFeature {
  final String endpoint;
  const EtaFeature({required this.endpoint});

  factory EtaFeature.fromJson(Map<String, dynamic> json) {
    return EtaFeature(endpoint: json['endpoint'] as String);
  }
}
