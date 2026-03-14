class ServerMapMarker {
  final String id;
  final String? code;
  final String name;
  final String campus; // "hssc" | "nsc"
  final double lat;
  final double lng;

  const ServerMapMarker({
    required this.id,
    this.code,
    required this.name,
    required this.campus,
    required this.lat,
    required this.lng,
  });

  factory ServerMapMarker.fromJson(Map<String, dynamic> json) {
    return ServerMapMarker(
      id: json['id'] as String,
      code: json['code'] as String?,
      name: json['name'] as String,
      campus: json['campus'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
