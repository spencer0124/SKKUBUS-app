class MarkerPayload {
  final String? icon;
  final String label;
  final String? subLabel;

  const MarkerPayload({this.icon, required this.label, this.subLabel});

  factory MarkerPayload.fromJson(Map<String, dynamic> json) {
    return MarkerPayload(
      icon: json['icon'] as String?,
      label: json['label'] as String,
      subLabel: json['subLabel'] as String?,
    );
  }
}

class MapOverlay {
  final String type; // "marker" | "path" | "polygon" | ...
  final String id;
  final double lat;
  final double lng;
  final MarkerPayload? marker; // only when type == "marker"

  const MapOverlay({
    required this.type,
    required this.id,
    required this.lat,
    required this.lng,
    this.marker,
  });

  factory MapOverlay.fromJson(Map<String, dynamic> json) {
    final position = json['position'] as Map<String, dynamic>;
    MarkerPayload? marker;
    if (json['type'] == 'marker' && json['marker'] != null) {
      marker =
          MarkerPayload.fromJson(json['marker'] as Map<String, dynamic>);
    }
    return MapOverlay(
      type: json['type'] as String,
      id: json['id'] as String,
      lat: (position['lat'] as num).toDouble(),
      lng: (position['lng'] as num).toDouble(),
      marker: marker,
    );
  }
}

class OverlayResponse {
  final String category;
  final List<MapOverlay> overlays;

  const OverlayResponse({required this.category, required this.overlays});

  factory OverlayResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return OverlayResponse(
      category: data['category'] as String? ?? '',
      overlays: (data['overlays'] as List)
          .map((e) => MapOverlay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
