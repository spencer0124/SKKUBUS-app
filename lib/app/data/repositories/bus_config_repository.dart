import 'package:get/get.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/bus_route_config.dart';
import 'package:skkumap/app/utils/app_logger.dart';

class BusConfigRepository {
  final ApiClient _client;
  Map<String, BusRouteConfig>? _cache;
  int? _cachedVersion;
  String? _cachedLang;

  bool get isLoaded => _cache != null;

  BusConfigRepository(this._client);

  String get _currentLang {
    final locale = Get.locale;
    if (locale == null) return 'ko';
    final lang = locale.languageCode;
    if (['ko', 'en', 'zh'].contains(lang)) return lang;
    return 'ko';
  }

  /// Fetch full config from server. Safe to call multiple times.
  Future<void> initialize() async {
    final result = await _client.safeGet(
      '/bus/config',
      (json) {
        final envelope = json as Map<String, dynamic>;
        final data = envelope['data'] as Map<String, dynamic>;
        final meta = envelope['meta'] as Map<String, dynamic>;
        final configs = data.map(
          (key, value) => MapEntry(
            key,
            BusRouteConfig.fromJson(value as Map<String, dynamic>),
          ),
        );
        return _ConfigResult(configs, meta['configVersion'] as int);
      },
    );
    switch (result) {
      case Ok(:final data):
        _cache = data.configs;
        _cachedVersion = data.version;
        _cachedLang = _currentLang;
        logger.d('BusConfig loaded: ${_cache!.length} routes, v$_cachedVersion');
      case Err(:final failure):
        logger.e('BusConfig init failed: $failure');
    }
  }

  /// Lightweight version check. Re-fetches config only when needed.
  Future<void> checkForUpdates() async {
    // Language changed → must re-fetch
    if (_cachedLang != _currentLang) {
      await initialize();
      return;
    }
    final result = await _client.safeGet(
      '/bus/config/version',
      (json) {
        final envelope = json as Map<String, dynamic>;
        final data = envelope['data'] as Map<String, dynamic>;
        return data['configVersion'] as int;
      },
    );
    switch (result) {
      case Ok(:final data):
        if (data != _cachedVersion) {
          await initialize();
        }
      case Err(:final failure):
        logger.d('BusConfig version check failed: $failure');
    }
  }

  /// Get config by id, initializing if needed.
  Future<BusRouteConfig?> ensureAndGet(String id) async {
    if (_cache == null) await initialize();
    return _cache?[id];
  }

  BusRouteConfig? getById(String id) => _cache?[id];

  Map<String, BusRouteConfig> get all => _cache ?? {};
}

class _ConfigResult {
  final Map<String, BusRouteConfig> configs;
  final int version;
  _ConfigResult(this.configs, this.version);
}
