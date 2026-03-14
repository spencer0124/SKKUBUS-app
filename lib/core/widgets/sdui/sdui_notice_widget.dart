import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:skkumap/core/model/sdui_section.dart';
import 'package:skkumap/core/utils/sdui_action_handler.dart';

class SduiNoticeWidget extends StatelessWidget {
  final SduiNotice section;

  const SduiNoticeWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleSduiAction(
        actionType: section.actionType,
        actionValue: section.actionValue,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Text(
              '\u{1F4E2}',
              style: TextStyle(fontFamily: 'Tossface', fontSize: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                style: const TextStyle(
                  fontFamily: 'WantedSansMedium',
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(CupertinoIcons.right_chevron, size: 12),
          ],
        ),
      ),
    );
  }
}
