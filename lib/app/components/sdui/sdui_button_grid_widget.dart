import 'package:flutter/material.dart';

import 'package:skkumap/app/model/sdui_section.dart';
import 'package:skkumap/app/utils/sdui_action_handler.dart';
import 'package:skkumap/app/pages/mainpage/ui/snappingsheet/option_campus_service_button.dart';

class SduiButtonGridWidget extends StatelessWidget {
  final SduiButtonGrid section;

  const SduiButtonGridWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
      child: GridView.count(
        crossAxisCount: section.columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: section.items.map((item) {
          return CustomServiceBtn(
            title: item.title,
            emoji: item.emoji,
            onTap: () => handleSduiAction(
              actionType: item.actionType,
              actionValue: item.actionValue,
              webviewTitle: item.webviewTitle,
              webviewColor: item.webviewColor,
            ),
          );
        }).toList(),
      ),
    );
  }
}
