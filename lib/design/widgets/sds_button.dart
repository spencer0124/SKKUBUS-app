import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_typo.dart';
import 'sds_loader.dart';

/// 버튼 — fill/weak × primary/dark/danger/light × 4 sizes
///
/// ```dart
/// SdsButton(text: '확인하기', onPressed: () {})
/// SdsButton(text: '삭제하기', variant: SdsButtonVariant.fill, color: SdsButtonColor.danger)
/// SdsButton(text: '닫기', variant: SdsButtonVariant.weak, color: SdsButtonColor.dark)
/// ```
class SdsButton extends StatefulWidget {
  final String text;
  final SdsButtonVariant variant;
  final SdsButtonColor color;
  final SdsButtonSize size;
  final bool isLoading;
  final bool disabled;
  final bool fullWidth;
  final VoidCallback? onPressed;

  const SdsButton({
    super.key,
    required this.text,
    this.variant = SdsButtonVariant.fill,
    this.color = SdsButtonColor.primary,
    this.size = SdsButtonSize.medium,
    this.isLoading = false,
    this.disabled = false,
    this.fullWidth = false,
    this.onPressed,
  });

  @override
  State<SdsButton> createState() => _SdsButtonState();

  ({Color bg, Color fg}) get _colorScheme {
    final isFill = variant == SdsButtonVariant.fill;
    return switch (color) {
      SdsButtonColor.primary => (
        bg: isFill ? SdsColors.blue500 : SdsColors.blue50,
        fg: isFill ? Colors.white : SdsColors.blue500,
      ),
      SdsButtonColor.dark => (
        bg: isFill ? SdsColors.grey900 : SdsColors.grey100,
        fg: isFill ? Colors.white : SdsColors.grey800,
      ),
      SdsButtonColor.danger => (
        bg: isFill ? SdsColors.red500 : SdsColors.red50,
        fg: isFill ? Colors.white : SdsColors.red500,
      ),
      SdsButtonColor.light => (
        bg: SdsColors.grey100,
        fg: SdsColors.grey800,
      ),
    };
  }

  ({double height, double hPad, double fontSize, double radius}) get _metrics =>
      switch (size) {
        SdsButtonSize.small => (
          height: 32.0,
          hPad: 12.0,
          fontSize: 13.0,
          radius: 8.0,
        ),
        SdsButtonSize.medium => (
          height: 40.0,
          hPad: 16.0,
          fontSize: 15.0,
          radius: 10.0,
        ),
        SdsButtonSize.large => (
          height: 48.0,
          hPad: 20.0,
          fontSize: 16.0,
          radius: 12.0,
        ),
        SdsButtonSize.xlarge => (
          height: 56.0,
          hPad: 24.0,
          fontSize: 17.0,
          radius: 14.0,
        ),
      };
}

class _SdsButtonState extends State<SdsButton> {
  bool _pressed = false;

  bool get _enabled => !widget.disabled && !widget.isLoading;

  void _handleTapDown(TapDownDetails _) {
    if (_enabled) setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_pressed) {
      setState(() => _pressed = false);
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (_pressed) setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = widget._colorScheme;
    final ms = widget._metrics;
    final isFullWidth = widget.fullWidth || widget.size == SdsButtonSize.xlarge;

    Widget child;
    if (widget.isLoading) {
      child = SdsLoader(size: 16, color: cs.fg, strokeWidth: 2);
    } else {
      child = Text(
        widget.text,
        style: SdsTypo.sub10(weight: FontWeight.w600).copyWith(
          fontSize: ms.fontSize,
          color: cs.fg,
        ),
      );
    }

    // Darken bg on press by blending 5% black
    final bgColor =
        _pressed ? Color.alphaBlend(const Color(0x0D000000), cs.bg) : cs.bg;

    final button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        height: ms.height,
        padding: EdgeInsets.symmetric(horizontal: ms.hPad),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(ms.radius),
        ),
        child: Opacity(
          opacity: widget.disabled ? 0.4 : 1.0,
          child: child,
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

enum SdsButtonVariant { fill, weak }

enum SdsButtonColor { primary, dark, danger, light }

enum SdsButtonSize { small, medium, large, xlarge }
