import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/core/admob/ad_helper.dart';
import 'package:skkumap/core/utils/app_logger.dart';

/// App-wide banner ad preload & lifecycle manager.
///
/// Slot-based: each placement key (e.g. `'bus_realtime'`, `'building_detail'`)
/// owns an independent [BannerAd] instance with reactive load state.
class AdService extends GetxService {
  final _banners = <String, BannerAd>{};
  final _loaded = <String, RxBool>{};
  final _expectedHeights = <String, RxnInt>{};

  late final int _screenWidth;

  @override
  void onInit() {
    super.onInit();
    _screenWidth = _logicalScreenWidth();
    preloadBanner('bus_realtime');
    preloadBanner('building_detail');
  }

  // ── Public API ──────────────────────────────────────

  /// Start loading a banner for [placement]. Fire-and-forget.
  Future<void> preloadBanner(String placement) async {
    _loaded.putIfAbsent(placement, () => false.obs);
    _expectedHeights.putIfAbsent(placement, () => RxnInt());

    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            _screenWidth);
    if (adSize == null) return;

    _expectedHeights[placement]!.value = adSize.height;

    final banner = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _banners[placement] = ad as BannerAd;
          _loaded[placement]!.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          logger.e('Ad preload failed [$placement]: ${err.message}');
          ad.dispose();
          _loaded[placement]!.value = false;
          _expectedHeights[placement]!.value = null;
        },
      ),
    )..load();

    // Store reference so we can dispose later even if load fails mid-flight.
    _banners[placement] = banner;
  }

  /// Returns the loaded [BannerAd] for [placement], or `null`.
  BannerAd? getBanner(String placement) => _banners[placement];

  /// Reactive loaded flag for [placement].
  RxBool isLoaded(String placement) {
    return _loaded.putIfAbsent(placement, () => false.obs);
  }

  /// Reactive expected ad height (set once ad size is resolved).
  RxnInt expectedHeight(String placement) {
    return _expectedHeights.putIfAbsent(placement, () => RxnInt());
  }

  /// Dispose current ad for [placement] and start preloading a fresh one.
  ///
  /// Call this when the screen using the ad is closed so the next visit
  /// gets an instant banner.
  void recycleBanner(String placement) {
    final existing = _banners.remove(placement);
    existing?.dispose();
    _loaded[placement]?.value = false;
    preloadBanner(placement);
  }

  // ── Lifecycle ───────────────────────────────────────

  @override
  void onClose() {
    for (final banner in _banners.values) {
      banner.dispose();
    }
    _banners.clear();
    super.onClose();
  }

  // ── Helpers ─────────────────────────────────────────

  /// Logical screen width in dp — no [BuildContext] needed.
  int _logicalScreenWidth() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return (view.physicalSize.width / view.devicePixelRatio).truncate();
  }
}
