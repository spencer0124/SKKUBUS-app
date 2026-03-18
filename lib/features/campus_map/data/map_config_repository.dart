import 'dart:async';

import 'package:get/get.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/features/campus_map/data/mock/map_config_mock.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/campus_map/model/map_config.dart';
import 'package:skkumap/core/utils/app_logger.dart';

class MapConfigRepository {
  final ApiClient _client;
  MapConfig? _cache;
  String? _cachedETag;
  String? _cachedLang;

  /// In-flight initialization future to prevent duplicate fetches.
  Future<void>? _initFuture;

  bool get isLoaded => _cache != null;
  MapConfig? get config => _cache;
  List<MapLayerDef> get layers => _cache?.layers ?? [];
  List<CampusDef> get campuses => _cache?.campuses ?? [];

  MapConfigRepository(this._client);

  String get _currentLang {
    final locale = Get.locale;
    if (locale == null) return 'ko';
    final lang = locale.languageCode;
    if (['ko', 'en', 'zh'].contains(lang)) return lang;
    return 'ko';
  }

  /// Fetch full config from server. Falls back to mock on failure.
  Future<void> initialize() async {
    final result = await _client.safeGet(
      '/map/config',
      (json) => MapConfig.fromJson(json as Map<String, dynamic>),
    );
    switch (result) {
      case Ok(:final data):
        _cache = data;
        _cachedLang = _currentLang;
        logger.d(
            'MapConfig loaded: ${_cache!.layers.length} layers, ${_cache!.campuses.length} campuses');
      case Err(:final failure):
        logger.e('MapConfig init failed ($failure), using mock');
        _cache = getMockMapConfig();
        _cachedLang = _currentLang;
    }
  }

  /// Wait for config to be ready. If already cached, returns immediately.
  /// If an initialization is in-flight, awaits it. Otherwise starts one.
  Future<void> ensureLoaded() async {
    if (_cache != null) return;
    _initFuture ??= initialize();
    await _initFuture;
    _initFuture = null;
  }

  /// ETag-based update check (RFC 7232).
  ///
  /// On language change: full re-fetch (different ETag per locale via Vary).
  /// Otherwise: sends If-None-Match → 304 means cache is fresh, 200 means
  /// new data available.
  Future<void> checkForUpdates() async {
    if (_cachedLang != _currentLang) {
      _cachedETag = null;
      await initialize();
      return;
    }

    final result = await _client.safeGetConditional(
      '/map/config',
      (json) => MapConfig.fromJson(json as Map<String, dynamic>),
      ifNoneMatch: _cachedETag,
    );

    switch (result) {
      case Ok(:final data):
        if (data.notModified) {
          logger.d('MapConfig: 304 Not Modified');
        } else {
          _cache = data.data;
          _cachedETag = data.etag;
          _cachedLang = _currentLang;
          logger.d('MapConfig updated (new ETag: ${data.etag})');
        }
      case Err(:final failure):
        logger.d('MapConfig update check failed: $failure');
    }
  }
}
