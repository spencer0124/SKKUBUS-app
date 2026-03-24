import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_typo.dart';

/// 접기/펼치기 가능한 텍스트 단락
///
/// "더보기" / "접기"가 텍스트 끝에 인라인으로 붙는 토스 패턴.
///
/// ```dart
/// SdsParagraph(text: '2009년에 신축된 삼성학술정보관은...', maxLines: 3)
/// ```
class SdsParagraph extends StatefulWidget {
  final String text;
  final int maxLines;

  const SdsParagraph({
    super.key,
    required this.text,
    this.maxLines = 2,
  });

  @override
  State<SdsParagraph> createState() => _SdsParagraphState();
}

class _SdsParagraphState extends State<SdsParagraph> {
  bool _expanded = false;
  late final TapGestureRecognizer _moreRecognizer;
  late final TapGestureRecognizer _lessRecognizer;

  @override
  void initState() {
    super.initState();
    _moreRecognizer = TapGestureRecognizer()
      ..onTap = () => setState(() => _expanded = true);
    _lessRecognizer = TapGestureRecognizer()
      ..onTap = () => setState(() => _expanded = false);
  }

  @override
  void dispose() {
    _moreRecognizer.dispose();
    _lessRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = SdsTypo.t7().copyWith(color: SdsColors.grey600);
    final actionStyle = SdsTypo.t7(weight: FontWeight.w600)
        .copyWith(color: SdsColors.grey500);

    return LayoutBuilder(
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
          return Text.rich(
            TextSpan(children: [
              TextSpan(text: widget.text, style: style),
              TextSpan(
                text: ' 접기',
                style: actionStyle,
                recognizer: _lessRecognizer,
              ),
            ]),
          );
        }

        // 인라인 "더보기": 마지막 줄 끝에 "… 더보기"가 들어갈 자리를 계산해
        // 텍스트를 잘라낸 뒤 TextSpan으로 이어 붙인다.
        // suffix를 실제 렌더와 동일한 mixed-style로 측정.
        final suffixPainter = TextPainter(
          text: TextSpan(children: [
            TextSpan(text: '… ', style: style),
            TextSpan(text: '더보기', style: actionStyle),
          ]),
          textDirection: TextDirection.ltr,
        )..layout();

        final lastLineY =
            textPainter.preferredLineHeight * (widget.maxLines - 0.5);
        final cutX = (constraints.maxWidth - suffixPainter.width - 4)
            .clamp(0.0, constraints.maxWidth);
        final cutPos =
            textPainter.getPositionForOffset(Offset(cutX, lastLineY));
        final truncated = widget.text.substring(0, cutPos.offset).trimRight();

        return Text.rich(
          TextSpan(children: [
            TextSpan(text: '$truncated… ', style: style),
            TextSpan(
              text: '더보기',
              style: actionStyle,
              recognizer: _moreRecognizer,
            ),
          ]),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        );
      },
    );
  }
}
