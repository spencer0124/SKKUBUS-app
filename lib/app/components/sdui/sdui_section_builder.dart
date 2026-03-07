import 'package:flutter/material.dart';

import 'package:skkumap/app/model/sdui_section.dart';
import 'package:skkumap/app/components/sdui/sdui_button_grid_widget.dart';
import 'package:skkumap/app/components/sdui/sdui_section_title_widget.dart';
import 'package:skkumap/app/components/sdui/sdui_notice_widget.dart';
import 'package:skkumap/app/components/sdui/sdui_banner_widget.dart';

/// Maps an [SduiSection] to its corresponding Flutter widget.
///
/// Because [SduiSection] is sealed, the Dart compiler enforces that
/// every subtype is handled. Adding a new section type will produce
/// a compiler warning here until a case is added.
Widget buildSection(SduiSection section) {
  return switch (section) {
    SduiButtonGrid s => SduiButtonGridWidget(section: s),
    SduiSectionTitle s => SduiSectionTitleWidget(section: s),
    SduiNotice s => SduiNoticeWidget(section: s),
    SduiBanner s => SduiBannerWidget(section: s),
    SduiSpacer s => SizedBox(height: s.height),
    SduiUnknown _ => const SizedBox.shrink(),
  };
}
