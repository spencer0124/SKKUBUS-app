import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';

const _fallbackColor = AppColors.brand;

/// Parse a 6-digit hex string (without '#') into a [Color].
/// Returns [_fallbackColor] on null, empty, or malformed input.
Color parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return _fallbackColor;
  try {
    return Color(int.parse('0xFF$hex'));
  } catch (_) {
    return _fallbackColor;
  }
}
