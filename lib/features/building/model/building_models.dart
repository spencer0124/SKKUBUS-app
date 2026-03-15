import 'package:get/get.dart';

/// Localized text pair from server ({ko, en}).
class LocalizedText {
  final String ko;
  final String en;

  const LocalizedText({required this.ko, required this.en});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      ko: json['ko'] as String? ?? '',
      en: json['en'] as String? ?? '',
    );
  }

  /// Returns the text for the current locale. Falls back to Korean.
  String get localized {
    final lang = Get.locale?.languageCode;
    return lang == 'en' ? en : ko;
  }

  @override
  String toString() => 'LocalizedText(ko: $ko, en: $en)';
}

/// Building image info from server.
class BuildingImage {
  final String url;
  final String filename;

  const BuildingImage({required this.url, required this.filename});

  factory BuildingImage.fromJson(Map<String, dynamic> json) {
    return BuildingImage(
      url: json['url'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
    );
  }
}

/// Accessibility features of a building.
class Accessibility {
  final bool elevator;
  final bool toilet;

  const Accessibility({required this.elevator, required this.toilet});

  factory Accessibility.fromJson(Map<String, dynamic> json) {
    return Accessibility(
      elevator: json['elevator'] as bool? ?? false,
      toilet: json['toilet'] as bool? ?? false,
    );
  }

  bool get hasAny => elevator || toilet;
}
