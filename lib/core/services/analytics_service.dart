import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized analytics service. Thin wrapper around [FirebaseAnalytics]
/// that standardizes event names and parameters.
///
/// All methods are fire-and-forget — analytics must never crash the app.
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  // ── User ID ──────────────────────────────────────────────────────

  void setUserId(String? uid) {
    _log(() => _analytics.setUserId(id: uid));
  }

  // ── User Properties ──────────────────────────────────────────────

  void setPreferredCampus(String campus) {
    _log(() => _analytics.setUserProperty(
          name: 'preferred_campus',
          value: campus,
        ));
  }

  void setAppLanguage(String lang) {
    _log(() => _analytics.setUserProperty(
          name: 'app_language',
          value: lang,
        ));
  }

  // ── Tab Navigation ───────────────────────────────────────────────

  void logTabSwitch({required String tabName}) {
    _logEvent('tab_switch', {'tab_name': tabName});
  }

  // ── Campus Map ───────────────────────────────────────────────────

  void logCampusSwitch({required String campus}) {
    _logEvent('campus_switch', {'campus': campus});
  }

  void logLayerToggle({required String layerId, required bool visible}) {
    _logEvent('layer_toggle', {
      'layer_id': layerId,
      'visible': visible ? 'true' : 'false',
    });
  }

  void logMarkerTap({required int skkuId}) {
    _logEvent('marker_tap', {'skku_id': skkuId});
  }

  // ── Building Detail ──────────────────────────────────────────────

  void logBuildingView({
    required int skkuId,
    required String buildingName,
    required String campus,
    required String source,
  }) {
    _logEvent('building_view', {
      'skku_id': skkuId,
      'building_name': _truncate(buildingName, 100),
      'campus': campus,
      'source': source,
    });
  }

  void logFloorExpand({required int skkuId, required String floorName}) {
    _logEvent('floor_expand', {
      'skku_id': skkuId,
      'floor_name': floorName,
    });
  }

  void logSpaceShowAll({required int skkuId, required String floorName}) {
    _logEvent('space_show_all', {
      'skku_id': skkuId,
      'floor_name': floorName,
    });
  }

  void logConnectionTap({
    required int fromSkkuId,
    required int targetSkkuId,
  }) {
    _logEvent('connection_tap', {
      'from_skku_id': fromSkkuId,
      'target_skku_id': targetSkkuId,
    });
  }

  void logConnectionMapOpen({required String campus}) {
    _logEvent('connection_map_open', {'campus': campus});
  }

  // ── Search ───────────────────────────────────────────────────────

  void logSearchPerform({
    required String query,
    required int buildingResults,
    required int spaceResults,
    String? campusFilter,
  }) {
    _logEvent('search_perform', {
      'query': _truncate(query, 100),
      'building_results': buildingResults,
      'space_results': spaceResults,
      'campus_filter': campusFilter ?? 'all',
    });
  }

  void logSearchResultTap({
    required String resultType,
    required String resultName,
    required String campus,
    int? skkuId,
  }) {
    _logEvent('search_result_tap', {
      'result_type': resultType,
      'result_name': _truncate(resultName, 100),
      'campus': campus,
      if (skkuId != null) 'skku_id': skkuId,
    });
  }

  void logSearchFilterChange({required String filter}) {
    _logEvent('search_filter_change', {'filter': filter});
  }

  // ── Transit / Bus ────────────────────────────────────────────────

  void logBusRouteOpen({
    required String routeId,
    required String routeLabel,
    required String screenType,
  }) {
    _logEvent('bus_route_open', {
      'route_id': routeId,
      'route_label': _truncate(routeLabel, 100),
      'screen_type': screenType,
    });
  }

  void logBusServiceSwitch({
    required String routeId,
    required String serviceId,
  }) {
    _logEvent('bus_service_switch', {
      'route_id': routeId,
      'service_id': serviceId,
    });
  }

  // ── Alert (existing event — name preserved) ──────────────────────

  void logAlertNextClicked() {
    _logEvent('newalert_nextclicked', {});
  }

  // ── Internal helpers ─────────────────────────────────────────────

  void _logEvent(String name, Map<String, Object> params) {
    _log(() => _analytics.logEvent(name: name, parameters: params));
  }

  void _log(Future<void> Function() action) {
    if (kDebugMode) return;
    action().catchError((_) {});
  }

  String _truncate(String s, int maxLen) =>
      s.length > maxLen ? s.substring(0, maxLen) : s;
}
