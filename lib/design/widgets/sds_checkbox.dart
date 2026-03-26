import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_duration.dart';

/// 체크박스 — checked: blue500, unchecked: grey300 border
///
/// ```dart
/// SdsCheckbox(value: true, onChanged: (v) {})
/// SdsCheckbox(value: false, onChanged: (v) {}, shape: SdsCheckboxShape.circle)
/// ```
class SdsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final SdsCheckboxShape shape;

  const SdsCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.shape = SdsCheckboxShape.square,
  });

  @override
  Widget build(BuildContext context) {
    final radius = switch (shape) {
      SdsCheckboxShape.square => 6.0,
      SdsCheckboxShape.circle => 12.0,
    };

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: SdsDuration.fast,
        curve: SdsCurves.standard,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? SdsColors.blue500 : Colors.transparent,
          border: value
              ? null
              : Border.all(color: SdsColors.grey300, width: 2),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: value
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}

enum SdsCheckboxShape { square, circle }
