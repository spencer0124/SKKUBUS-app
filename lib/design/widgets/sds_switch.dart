import 'package:flutter/cupertino.dart';

import '../sds_colors.dart';

/// 토글 스위치 — on: blue500, off: grey300
///
/// ```dart
/// SdsSwitch(value: true, onChanged: (v) {})
/// ```
class SdsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SdsSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 51,
      height: 31,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: SdsColors.blue500,
        inactiveTrackColor: SdsColors.grey300,
      ),
    );
  }
}
