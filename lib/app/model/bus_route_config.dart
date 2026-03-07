import 'package:flutter/material.dart';
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

class ScheduleConfig {
  final List<BusDirection> directions;
  final ServiceCalendar serviceCalendar;
  final Map<String, String> routeTypes;

  const ScheduleConfig({
    required this.directions,
    required this.serviceCalendar,
    required this.routeTypes,
  });

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) {
    return ScheduleConfig(
      directions: (json['directions'] as List)
          .map((e) => BusDirection.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceCalendar: ServiceCalendar.fromJson(
          json['serviceCalendar'] as Map<String, dynamic>),
      routeTypes: (json['routeTypes'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as String)),
    );
  }
}

class BusDirection {
  final String id;
  final String label;
  final String endpoint;

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

class ServiceCalendar {
  final Set<int> defaultServiceDays;
  final List<ServiceException> exceptions;

  const ServiceCalendar({
    required this.defaultServiceDays,
    required this.exceptions,
  });

  factory ServiceCalendar.fromJson(Map<String, dynamic> json) {
    return ServiceCalendar(
      defaultServiceDays:
          (json['defaultServiceDays'] as List).map((e) => e as int).toSet(),
      exceptions: (json['exceptions'] as List? ?? [])
          .map((e) => ServiceException.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool isServiceDay(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final exception =
        exceptions.where((e) => e.dateStr == dateStr).firstOrNull;
    if (exception != null) return exception.service;
    return defaultServiceDays.contains(date.weekday - 1); // DateTime: 1=Mon
  }
}

class ServiceException {
  final String dateStr;
  final String reason;
  final bool service;

  const ServiceException({
    required this.dateStr,
    required this.reason,
    required this.service,
  });

  factory ServiceException.fromJson(Map<String, dynamic> json) {
    return ServiceException(
      dateStr: json['date'] as String,
      reason: json['reason'] as String,
      service: json['service'] as bool,
    );
  }
}

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
