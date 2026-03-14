import 'package:skkumap/core/model/sdui_section.dart';

class CampusSectionsResponse {
  final List<SduiSection> sections;
  final String? minAppVersion;

  const CampusSectionsResponse({
    required this.sections,
    this.minAppVersion,
  });

  factory CampusSectionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final list = data['sections'] as List;
    return CampusSectionsResponse(
      sections: list
          .map((e) => SduiSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      minAppVersion: data['minAppVersion'] as String?,
    );
  }
}
