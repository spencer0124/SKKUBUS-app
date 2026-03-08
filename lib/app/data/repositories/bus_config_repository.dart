import 'package:get/get.dart';
import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/bus_group.dart';
import 'package:skkumap/app/utils/app_logger.dart';

class BusConfigRepository {
  final ApiClient _client;
  List<BusGroup>? _groups;
  String? _etag;
  String? _cachedLang;

  bool get isLoaded => _groups != null;
  List<BusGroup> get groups => _groups ?? [];

  /// Returns only groups visible at [now] (KST).
  List<BusGroup> visibleGroups(DateTime now) =>
      groups.where((g) => g.isVisible(now)).toList();

  BusConfigRepository(this._client);

  String get _currentLang {
    final locale = Get.locale;
    if (locale == null) return 'ko';
    final lang = locale.languageCode;
    if (['ko', 'en', 'zh'].contains(lang)) return lang;
    return 'ko';
  }

  /// ETag-based fetch. 304 keeps cached data.
  Future<void> initialize() async {
    // Language changed → invalidate cache
    if (_cachedLang != _currentLang) {
      _etag = null;
    }

    final result = await _client.safeGetConditional<List<BusGroup>>(
      '/bus/config',
      (json) {
        final envelope = json as Map<String, dynamic>;
        final data = envelope['data'] as Map<String, dynamic>;
        final groupsList = data['groups'] as List;
        return groupsList
            .map((g) => BusGroup.fromJson(g as Map<String, dynamic>))
            .toList();
      },
      ifNoneMatch: _etag,
    );

    switch (result) {
      case Ok(:final data):
        if (!data.notModified) {
          _groups = data.data;
          _etag = data.etag;
          _cachedLang = _currentLang;
          logger.d('BusConfig loaded: ${_groups!.length} groups');
        } else {
          logger.d('BusConfig not modified (304)');
        }
      case Err(:final failure):
        logger.e('BusConfig init failed: $failure');
    }
  }

  /// Re-fetch with ETag (304 if unchanged).
  Future<void> checkForUpdates() => initialize();

  /// Get config by id, initializing if needed.
  Future<BusGroup?> ensureAndGet(String id) async {
    if (_groups == null) await initialize();
    return getById(id);
  }

  BusGroup? getById(String id) =>
      _groups?.where((g) => g.id == id).firstOrNull;
}
