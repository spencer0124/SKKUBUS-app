import 'package:flutter/material.dart';

import 'package:skkumap/app_theme.dart';
import 'package:skkumap/core/model/sdui_section.dart';

class SduiSectionTitleWidget extends StatelessWidget {
  final SduiSectionTitle section;

  const SduiSectionTitleWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        section.title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
