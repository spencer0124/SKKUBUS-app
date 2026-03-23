import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_typo.dart';

/// 검색 필드
///
/// ```dart
/// SdsSearchField(
///   placeholder: '성균관대 건물/공간 검색',
///   onChanged: (v) {},
/// )
/// ```
class SdsSearchField extends StatefulWidget {
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? count;
  final bool autofocus;
  final FocusNode? focusNode;

  const SdsSearchField({
    super.key,
    this.placeholder = '',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.count,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<SdsSearchField> createState() => _SdsSearchFieldState();
}

class _SdsSearchFieldState extends State<SdsSearchField> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(SdsSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      if (_ownsController) _controller.dispose();
      if (widget.controller != null) {
        _controller = widget.controller!;
      } else {
        _controller = TextEditingController();
      }
      _hasText = _controller.text.isNotEmpty;
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Container(
        decoration: BoxDecoration(
          color: SdsColors.grey100,
          borderRadius: BorderRadius.circular(SdsRadius.md),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: SdsColors.grey400),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: SdsTypo.sub10().copyWith(color: SdsColors.grey900),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: SdsTypo.sub10().copyWith(color: SdsColors.grey500),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_hasText) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _clearText,
                child: const Icon(
                  Icons.cancel,
                  size: 18,
                  color: SdsColors.grey400,
                ),
              ),
            ],
            if (widget.count != null) ...[
              const SizedBox(width: 8),
              widget.count!,
            ],
          ],
        ),
      ),
    );
  }
}
