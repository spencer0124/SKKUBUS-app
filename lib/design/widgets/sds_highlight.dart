import 'package:flutter/material.dart';

import '../sds_colors.dart';

/// 텍스트 일부 강조 (검색 결과 매칭 등)
///
/// ```dart
/// SdsHighlight(
///   text: '삼성학술정보관',
///   highlights: ['학술'],
///   style: SdsTypo.t5(),
/// )
/// ```
class SdsHighlight extends StatelessWidget {
  final String text;
  final List<String> highlights;
  final TextStyle? style;
  final Color highlightColor;
  final int? maxLines;

  const SdsHighlight({
    super.key,
    required this.text,
    required this.highlights,
    this.style,
    this.highlightColor = SdsColors.highlight,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return Text(text, style: style, maxLines: maxLines);
    }

    final spans = _buildSpans();
    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }

  List<TextSpan> _buildSpans() {
    final pattern = highlights
        .where((h) => h.isNotEmpty)
        .map(RegExp.escape)
        .join('|');
    if (pattern.isEmpty) {
      return [TextSpan(text: text)];
    }

    final regex = RegExp(pattern, caseSensitive: false);
    final spans = <TextSpan>[];
    var lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(backgroundColor: highlightColor),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return spans;
  }
}
