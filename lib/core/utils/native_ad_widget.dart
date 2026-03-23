import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Fixed container heights for predictable layout sizing.
const double kNativeSmallHeight = 132.0;
const double kNativeMediumHeight = 350.0;

/// Wraps a [NativeAd] with fade-in animation to prevent the "flash"
/// caused by platform view surface initialisation.
///
/// Accepts an explicit [height] so callers don't need to import
/// [TemplateType] — keeps the google_mobile_ads dependency out of the
/// widget layer.
class NativeAdContainer extends StatefulWidget {
  final NativeAd? nativeAd;
  final double height;

  const NativeAdContainer({
    super.key,
    required this.nativeAd,
    required this.height,
  });

  @override
  State<NativeAdContainer> createState() => _NativeAdContainerState();
}

class _NativeAdContainerState extends State<NativeAdContainer> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.nativeAd != null) _scheduleReveal();
  }

  @override
  void didUpdateWidget(NativeAdContainer old) {
    super.didUpdateWidget(old);
    if (old.nativeAd == null && widget.nativeAd != null) {
      _scheduleReveal();
    }
  }

  void _scheduleReveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nativeAd == null) return const SizedBox.shrink();
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: AdWidget(ad: widget.nativeAd!),
      ),
    );
  }
}
