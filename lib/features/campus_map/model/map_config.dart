import 'package:flutter/material.dart';
import 'package:skkumap/core/utils/color_utils.dart';

class NaverConfig {
  final String? styleId;

  const NaverConfig({this.styleId});

  factory NaverConfig.fromJson(Map<String, dynamic> json) {
    return NaverConfig(styleId: json['styleId'] as String?);
  }
}

class MapConfig {
  final NaverConfig naver;
  final List<CampusDef> campuses;
  final List<MapLayerDef> layers;

  const MapConfig(
      {required this.naver, required this.campuses, required this.layers});

  factory MapConfig.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MapConfig(
      naver: NaverConfig.fromJson(
          data['naver'] as Map<String, dynamic>? ?? const {}),
      campuses: (data['campuses'] as List? ?? [])
          .map((e) => CampusDef.fromJson(e as Map<String, dynamic>))
          .toList(),
      layers: (data['layers'] as List)
          .map((e) => MapLayerDef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Lookup a campus by id. Returns null if not found.
  CampusDef? campus(String id) {
    for (final c in campuses) {
      if (c.id == id) return c;
    }
    return null;
  }
}

class CampusDef {
  final String id; // "hssc" | "nsc"
  final String label; // "인사캠" | "자과캠"
  final double centerLat;
  final double centerLng;
  final double defaultZoom;
  final double defaultTilt;
  final double defaultBearing;

  const CampusDef({
    required this.id,
    required this.label,
    required this.centerLat,
    required this.centerLng,
    required this.defaultZoom,
    this.defaultTilt = 0,
    this.defaultBearing = 0,
  });

  factory CampusDef.fromJson(Map<String, dynamic> json) {
    return CampusDef(
      id: json['id'] as String,
      label: json['label'] as String,
      centerLat: (json['centerLat'] as num).toDouble(),
      centerLng: (json['centerLng'] as num).toDouble(),
      defaultZoom: (json['defaultZoom'] as num?)?.toDouble() ?? 15.8,
      defaultTilt: (json['defaultTilt'] as num?)?.toDouble() ?? 0,
      defaultBearing: (json['defaultBearing'] as num?)?.toDouble() ?? 0,
    );
  }
}

class MapLayerDef {
  final String id;
  final String type; // "marker" | "polyline"
  final String label;
  final bool defaultVisible;
  final String endpoint;
  final String? markerStyle; // "numberCircle" | "textLabel"
  final MapLayerStyle? style;

  const MapLayerDef({
    required this.id,
    required this.type,
    required this.label,
    required this.defaultVisible,
    required this.endpoint,
    this.markerStyle,
    this.style,
  });

  factory MapLayerDef.fromJson(Map<String, dynamic> json) {
    return MapLayerDef(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      defaultVisible: json['defaultVisible'] as bool? ?? false,
      endpoint: json['endpoint'] as String,
      markerStyle: json['markerStyle'] as String?,
      style: json['style'] != null
          ? MapLayerStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MapLayerStyle {
  final Color? color;
  // Polyline
  final Color? outlineColor;
  final double? width;
  // Marker
  final double? size;
  final double? captionTextSize;

  const MapLayerStyle({
    this.color,
    this.outlineColor,
    this.width,
    this.size,
    this.captionTextSize,
  });

  factory MapLayerStyle.fromJson(Map<String, dynamic> json) {
    return MapLayerStyle(
      color: json['color'] != null
          ? parseHexColor(json['color'] as String)
          : null,
      outlineColor: json['outlineColor'] != null
          ? parseHexColor(json['outlineColor'] as String)
          : null,
      width: (json['width'] as num?)?.toDouble(),
      size: (json['size'] as num?)?.toDouble(),
      captionTextSize: (json['captionTextSize'] as num?)?.toDouble(),
    );
  }
}
