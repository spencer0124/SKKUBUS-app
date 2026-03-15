import 'package:skkumap/features/building/model/building_models.dart';

/// Unified building model used across /building/list, /building/search,
/// and /building/{skkuId} responses.
///
/// Fields that may be absent in search results are nullable.
class Building {
  final int skkuId;
  final String? buildNo;
  final String? displayNo;
  final String type; // "building" | "facility"
  final String campus; // "hssc" | "nsc"
  final LocalizedText name;
  final LocalizedText? description;
  final double lat;
  final double lng;
  final BuildingImage? image;
  final Accessibility? accessibility;
  final List<dynamic> attachments;
  final Map<String, dynamic> extensions;

  const Building({
    required this.skkuId,
    this.buildNo,
    this.displayNo,
    required this.type,
    required this.campus,
    required this.name,
    this.description,
    required this.lat,
    required this.lng,
    this.image,
    this.accessibility,
    this.attachments = const [],
    this.extensions = const {},
  });

  bool get isBuilding => type == 'building';
  bool get isFacility => type == 'facility';

  factory Building.fromJson(Map<String, dynamic> json) {
    // GeoJSON: location.coordinates = [lng, lat]
    final location = json['location'] as Map<String, dynamic>?;
    final coords = location?['coordinates'] as List?;
    final lng = coords != null ? (coords[0] as num).toDouble() : 0.0;
    final lat = coords != null ? (coords[1] as num).toDouble() : 0.0;

    return Building(
      skkuId: json['_id'] as int,
      buildNo: json['buildNo'] as String?,
      displayNo: json['displayNo'] as String?,
      type: json['type'] as String? ?? 'building',
      campus: json['campus'] as String? ?? 'hssc',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      description: json['description'] != null
          ? LocalizedText.fromJson(json['description'] as Map<String, dynamic>)
          : null,
      lat: lat,
      lng: lng,
      image: json['image'] != null &&
              (json['image'] as Map<String, dynamic>)['url'] != null
          ? BuildingImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      accessibility: json['accessibility'] != null
          ? Accessibility.fromJson(
              json['accessibility'] as Map<String, dynamic>)
          : null,
      attachments: json['attachments'] as List? ?? [],
      extensions: json['extensions'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  String toString() => 'Building(skkuId: $skkuId, name: ${name.ko})';
}
