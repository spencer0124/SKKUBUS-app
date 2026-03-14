import 'package:flutter/material.dart';

import 'package:skkumap/core/model/sdui_section.dart';
import 'package:skkumap/core/utils/sdui_action_handler.dart';

class SduiBannerWidget extends StatelessWidget {
  final SduiBanner section;

  const SduiBannerWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleSduiAction(
        actionType: section.actionType,
        actionValue: section.actionValue,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            section.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
