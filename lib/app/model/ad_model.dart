/// Ad placement model — extracted from fetch_ad.dart to prevent
/// circular imports between backward-compat wrappers and AdRepository.

class AdPlacement {
  final String type;
  final String? imageUrl;
  final String? text;
  final String linkUrl;
  final bool enabled;
  final String? adId;

  AdPlacement({
    required this.type,
    this.imageUrl,
    this.text,
    required this.linkUrl,
    required this.enabled,
    this.adId,
  });

  factory AdPlacement.fromJson(Map<String, dynamic> json) {
    return AdPlacement(
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
      text: json['text'] as String?,
      linkUrl: json['linkUrl'] as String,
      enabled: json['enabled'] as bool,
      adId: json['adId'] as String?,
    );
  }
}

class AdPlacementsResponse {
  final Map<String, AdPlacement> placements;

  AdPlacementsResponse({required this.placements});

  factory AdPlacementsResponse.fromJson(Map<String, dynamic> json) {
    final placementsJson = json['data'] as Map<String, dynamic>;
    final placements = placementsJson.map(
      (key, value) =>
          MapEntry(key, AdPlacement.fromJson(value as Map<String, dynamic>)),
    );
    return AdPlacementsResponse(placements: placements);
  }

  AdPlacement? operator [](String key) => placements[key];
}
