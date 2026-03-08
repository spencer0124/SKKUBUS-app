import 'package:skkumap/app/data/api_client.dart';
import 'package:skkumap/app/data/api_endpoints.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/bus_group.dart';
import 'package:skkumap/app/utils/app_logger.dart';

class BusConfigRepository {
  final ApiClient _client;

  final Map<String, BusGroup> _cache = {};
  final Map<String, String> _etags = {};

  BusConfigRepository(this._client);

  /// Fetch config for a single group on-demand with ETag caching.
  Future<BusGroup?> getGroupConfig(String groupId) async {
    final result = await _client.safeGetConditional<BusGroup>(
      ApiEndpoints.busConfigGroup(groupId),
      (json) {
        final envelope = json as Map<String, dynamic>;
        final data = envelope['data'] as Map<String, dynamic>;
        return BusGroup.fromJson(data);
      },
      ifNoneMatch: _etags[groupId],
    );

    switch (result) {
      case Ok(:final data):
        if (!data.notModified && data.data != null) {
          _cache[groupId] = data.data!;
          _etags[groupId] = data.etag ?? '';
          logger.d('BusConfig[$groupId] loaded');
        } else {
          logger.d('BusConfig[$groupId] not modified (304)');
        }
        return _cache[groupId];
      case Err(:final failure):
        logger.e('BusConfig[$groupId] fetch failed: $failure');
        return _cache[groupId];
    }
  }

  BusGroup? getById(String id) => _cache[id];
}
