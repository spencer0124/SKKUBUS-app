import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdWidgetContainer extends StatelessWidget {
  final BannerAd? bannerAd;

  const AdWidgetContainer({
    super.key,
    required this.bannerAd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: AdWidget(ad: bannerAd!),
      ),
    );
  }
}
