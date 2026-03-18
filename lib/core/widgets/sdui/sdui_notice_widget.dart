import 'package:flutter/material.dart';

import 'package:skkumap/app_theme.dart';
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
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          borderRadius: BorderRadius.circular(AppRadius.sm),
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
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 16, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}
