import 'package:flutter/material.dart';

import '../sds_colors.dart';

/// 별점 — 5개 별, 반별 지원
///
/// ```dart
/// SdsRating(rating: 3.5)
/// SdsRating(rating: 0, onChanged: (v) {})  // 인터랙티브
/// ```
class SdsRating extends StatelessWidget {
  final double rating;
  final ValueChanged<double>? onChanged;
  final double size;

  const SdsRating({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1.0;
        final fill = (rating >= starValue)
            ? 1.0
            : (rating >= starValue - 0.5)
                ? 0.5
                : 0.0;

        Widget star;
        if (fill == 1.0) {
          star = Icon(Icons.star_rounded, size: size, color: SdsColors.yellow400);
        } else if (fill == 0.5) {
          star = _HalfStar(size: size);
        } else {
          star = Icon(Icons.star_rounded, size: size, color: SdsColors.grey300);
        }

        if (onChanged != null) {
          return GestureDetector(
            onTap: () => onChanged!(starValue),
            child: star,
          );
        }
        return star;
      }),
    );
  }
}

class _HalfStar extends StatelessWidget {
  final double size;

  const _HalfStar({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Icon(Icons.star_rounded, size: size, color: SdsColors.grey300),
          ClipRect(
            clipper: _HalfClipper(),
            child: Icon(Icons.star_rounded, size: size, color: SdsColors.yellow400),
          ),
        ],
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width / 2, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
