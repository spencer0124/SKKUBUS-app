import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/core/admob/ad_helper.dart';
import 'package:skkumap/core/utils/app_logger.dart';

/// App-wide ad preload & lifecycle manager.
///
/// Slot-based: each placement key owns an independent ad instance with
/// reactive load state. Supports both [BannerAd] and [NativeAd].
class AdService extends GetxService {
  // ── Banner state ──────────────────────────────────────
  final _banners = <String, BannerAd>{};
  final _loaded = <String, RxBool>{};
  final _expectedHeights = <String, RxnInt>{};

  // ── Native state ──────────────────────────────────────
  final _nativeAds = <String, NativeAd>{};
  final _nativeLoaded = <String, RxBool>{};
  final _nativeConfigs =
      <String, ({String factoryId, String adUnitId})>{};

  late final int _screenWidth;

  @override
  void onInit() {
    super.onInit();
    _screenWidth = _logicalScreenWidth();

    preloadBanner('bus_realtime');
    preloadNative('native_building',
        factoryId: 'smallNativeAd',
        adUnitId: AdHelper.nativeBusAdUnitId);
    preloadNative('native_campus',
        factoryId: 'smallNativeAd',
        adUnitId: AdHelper.nativeCampusAdUnitId);
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

  // ── Native Ad API ──────────────────────────────────

  /// Start loading a native ad for [placement]. Fire-and-forget.
  ///
  /// Config is stored in [_nativeConfigs] so [recycleNative] can
  /// re-preload without the caller re-supplying the config.
  Future<void> preloadNative(
    String placement, {
    required String factoryId,
    required String adUnitId,
  }) async {
    _nativeLoaded.putIfAbsent(placement, () => false.obs);
    _nativeConfigs[placement] = (factoryId: factoryId, adUnitId: adUnitId);

    final nativeAd = NativeAd(
      adUnitId: adUnitId,
      factoryId: factoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _nativeAds[placement] = ad as NativeAd;
          _nativeLoaded[placement]!.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          logger.e('Native ad preload failed [$placement]: ${err.message}');
          ad.dispose();
          _nativeLoaded[placement]!.value = false;
        },
      ),
    )..load();

    _nativeAds[placement] = nativeAd;
  }

  /// Returns the loaded [NativeAd] for [placement], or `null`.
  NativeAd? getNativeAd(String placement) => _nativeAds[placement];

  /// Reactive loaded flag for native [placement].
  RxBool isNativeLoaded(String placement) {
    return _nativeLoaded.putIfAbsent(placement, () => false.obs);
  }

  /// Dispose current native ad for [placement] and preload a fresh one.
  void recycleNative(String placement) {
    final existing = _nativeAds.remove(placement);
    existing?.dispose();
    _nativeLoaded[placement]?.value = false;

    final config = _nativeConfigs[placement];
    if (config != null) {
      preloadNative(placement,
          factoryId: config.factoryId, adUnitId: config.adUnitId);
    }
  }

  /// Dispose a native ad without re-preloading.
  ///
  /// Use for one-shot placements like splash that are never revisited.
  void disposeNative(String placement) {
    final existing = _nativeAds.remove(placement);
    existing?.dispose();
    _nativeLoaded[placement]?.value = false;
    _nativeConfigs.remove(placement);
  }

  // ── Lifecycle ───────────────────────────────────────

  @override
  void onClose() {
    for (final banner in _banners.values) {
      banner.dispose();
    }
    _banners.clear();
    for (final nativeAd in _nativeAds.values) {
      nativeAd.dispose();
    }
    _nativeAds.clear();
    super.onClose();
  }

  // ── Helpers ─────────────────────────────────────────

  /// Logical screen width in dp — no [BuildContext] needed.
  int _logicalScreenWidth() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return (view.physicalSize.width / view.devicePixelRatio).truncate();
  }

}
