import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 텍스트 입력 필드 — focused: blue500, error: red500
///
/// ```dart
/// SdsTextField(
///   controller: controller,
///   placeholder: '이름을 입력해 주세요',
///   errorText: '이름을 입력해 주세요',
/// )
/// ```
class SdsTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;
  final FocusNode? focusNode;

  const SdsTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.maxLength,
    this.obscureText = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          style: SdsTypo.t5().copyWith(color: SdsColors.grey900),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: SdsTypo.t5().copyWith(color: SdsColors.grey400),
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(vertical: SdsSpacing.md),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? SdsColors.red500 : SdsColors.grey300,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? SdsColors.red500 : SdsColors.blue500,
                width: 2,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: SdsTypo.t7().copyWith(color: SdsColors.red500),
          ),
        ],
      ],
    );
  }
}
