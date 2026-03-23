import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 접기/펼치기 가능한 텍스트 단락
///
/// ```dart
/// SdsParagraph(text: '2009년에 신축된 삼성학술정보관은...', maxLines: 2)
/// SdsParagraph(text: '...', maxLines: 3, showCard: true)  // grey50 card
/// ```
class SdsParagraph extends StatefulWidget {
  final String text;
  final int maxLines;

  /// true이면 grey50 배경 카드로 감싸기 (목업 info-block 스타일)
  final bool showCard;

  const SdsParagraph({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.showCard = false,
  });

  @override
  State<SdsParagraph> createState() => _SdsParagraphState();
}

class _SdsParagraphState extends State<SdsParagraph> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = SdsTypo.t6().copyWith(color: SdsColors.grey600);
    final actionStyle = SdsTypo.t7(weight: FontWeight.w600)
        .copyWith(color: SdsColors.grey500);

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = textPainter.didExceedMaxLines;

        if (!isOverflow) {
          return Text(widget.text, style: style);
        }

        if (_expanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text, style: style),
              const SizedBox(height: SdsSpacing.sm),
              GestureDetector(
                onTap: () => setState(() => _expanded = false),
                child: Text('접기 ‹', style: actionStyle),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: widget.maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: SdsSpacing.sm),
            GestureDetector(
              onTap: () => setState(() => _expanded = true),
              child: Text('더보기 ›', style: actionStyle),
            ),
          ],
        );
      },
    );

    if (widget.showCard) {
      content = Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: SdsSpacing.base,
        ),
        decoration: BoxDecoration(
          color: SdsColors.grey50,
          borderRadius: BorderRadius.circular(SdsRadius.xl),
        ),
        child: content,
      );
    }

    return content;
  }
}
