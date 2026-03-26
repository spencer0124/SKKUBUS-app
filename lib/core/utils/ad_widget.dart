import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Wraps a [BannerAd] with fade-in animation to prevent the "flash"
/// caused by platform view surface initialisation.
class AdWidgetContainer extends StatefulWidget {
  final BannerAd? bannerAd;

  const AdWidgetContainer({
    super.key,
    required this.bannerAd,
  });

  @override
  State<AdWidgetContainer> createState() => _AdWidgetContainerState();
}

class _AdWidgetContainerState extends State<AdWidgetContainer> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.bannerAd != null) _scheduleReveal();
  }

  @override
  void didUpdateWidget(AdWidgetContainer old) {
    super.didUpdateWidget(old);
    if (old.bannerAd == null && widget.bannerAd != null) {
      _scheduleReveal();
    }
  }

  void _scheduleReveal() {
    // First frame renders at opacity 0 so the native surface can initialise,
    // then we animate to fully visible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bannerAd == null) return const SizedBox.shrink();
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
      child: SizedBox(
        width: widget.bannerAd!.size.width.toDouble(),
        height: widget.bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: widget.bannerAd!),
      ),
    );
  }
}
