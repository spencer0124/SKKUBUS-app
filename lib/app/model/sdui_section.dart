import 'package:skkumap/app/model/campus_service_model.dart';

/// Base sealed class for all SDUI section types.
///
/// Each subtype corresponds to a section `type` from the server API.
/// Unknown types are captured as [SduiUnknown] and render as empty space.
sealed class SduiSection {
  final String id;
  const SduiSection({required this.id});

  factory SduiSection.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'button_grid' => SduiButtonGrid.fromJson(json),
      'section_title' => SduiSectionTitle.fromJson(json),
      'notice' => SduiNotice.fromJson(json),
      'banner' => SduiBanner.fromJson(json),
      'spacer' => SduiSpacer.fromJson(json),
      _ => SduiUnknown(id: json['id'] as String? ?? '', type: type),
    };
  }
}

/// Emoji+text button grid with configurable column count.
final class SduiButtonGrid extends SduiSection {
  final int columns;
  final List<SduiButtonItem> items;

  const SduiButtonGrid({
    required super.id,
    required this.columns,
    required this.items,
  });

  factory SduiButtonGrid.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List;
    return SduiButtonGrid(
      id: json['id'] as String,
      columns: json['columns'] as int? ?? 4,
      items: rawItems
          .map((e) => SduiButtonItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Individual button item inside a [SduiButtonGrid].
class SduiButtonItem {
  final String id;
  final String title;
  final String emoji;
  final ActionType actionType;
  final String actionValue;
  final String? webviewTitle;
  final String? webviewColor;

  const SduiButtonItem({
    required this.id,
    required this.title,
    required this.emoji,
    required this.actionType,
    required this.actionValue,
    this.webviewTitle,
    this.webviewColor,
  });

  factory SduiButtonItem.fromJson(Map<String, dynamic> json) {
    return SduiButtonItem(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String,
      actionType: ActionType.fromString(json['actionType'] as String),
      actionValue: json['actionValue'] as String,
      webviewTitle: json['webviewTitle'] as String?,
      webviewColor: json['webviewColor'] as String?,
    );
  }
}

/// Section header text.
final class SduiSectionTitle extends SduiSection {
  final String title;

  const SduiSectionTitle({required super.id, required this.title});

  factory SduiSectionTitle.fromJson(Map<String, dynamic> json) {
    return SduiSectionTitle(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }
}

/// Top notice bar with action.
final class SduiNotice extends SduiSection {
  final String title;
  final ActionType actionType;
  final String actionValue;

  const SduiNotice({
    required super.id,
    required this.title,
    required this.actionType,
    required this.actionValue,
  });

  factory SduiNotice.fromJson(Map<String, dynamic> json) {
    return SduiNotice(
      id: json['id'] as String,
      title: json['title'] as String,
      actionType: ActionType.fromString(json['actionType'] as String),
      actionValue: json['actionValue'] as String,
    );
  }
}

/// Image banner with action.
final class SduiBanner extends SduiSection {
  final String imageUrl;
  final ActionType actionType;
  final String actionValue;

  const SduiBanner({
    required super.id,
    required this.imageUrl,
    required this.actionType,
    required this.actionValue,
  });

  factory SduiBanner.fromJson(Map<String, dynamic> json) {
    return SduiBanner(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      actionType: ActionType.fromString(json['actionType'] as String),
      actionValue: json['actionValue'] as String,
    );
  }
}

/// Vertical spacing between sections.
final class SduiSpacer extends SduiSection {
  final double height;

  const SduiSpacer({required super.id, this.height = 16});

  factory SduiSpacer.fromJson(Map<String, dynamic> json) {
    return SduiSpacer(
      id: json['id'] as String? ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 16,
    );
  }
}

/// Catch-all for unknown section types. Renders as empty space.
final class SduiUnknown extends SduiSection {
  final String type;
  const SduiUnknown({required super.id, required this.type});
}
