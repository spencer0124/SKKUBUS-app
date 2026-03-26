import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:skkumap/features/campus_map/data/map_config_repository.dart';
import 'package:skkumap/features/campus_map/data/map_layer_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/campus_map/model/map_config.dart';
import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';
import 'package:skkumap/features/building/ui/building_detail_sheet.dart';
import 'package:skkumap/core/services/analytics_service.dart';
import 'package:skkumap/core/utils/app_logger.dart';

enum LayerLoadStatus { idle, loading, loaded, error }

class LayerState {
  bool visible;
  LayerLoadStatus status;
  List<NMarker>? markers;
  NMultipartPathOverlay? overlay;

  /// Raw marker JSON — kept so we can re-filter by campus without re-fetch.
  List<Map<String, dynamic>>? rawMarkers;

  LayerState({
    required this.visible,
    this.status = LayerLoadStatus.idle,
    this.markers,
    this.overlay,
    this.rawMarkers,
  });
}

const _markerIcon =
    NOverlayImage.fromAssetImage('assets/images/line_blank.png');

class MapLayerController extends GetxController {
  final _configRepo = Get.find<MapConfigRepository>();
  final _layerRepo = Get.find<MapLayerRepository>();

  final layerStates = <String, LayerState>{}.obs;

  /// Initialize layer states from config. Awaits ensureLoaded() internally
  /// so it is safe to call even if main.dart's fire-and-forget hasn't finished.
  ///
  /// Designed to be called with [unawaited] — errors are caught internally
  /// and reflected in [LayerState.status].
  Future<void> initFromConfig() async {
    try {
      await _configRepo.ensureLoaded();
      final layers = _configRepo.layers;

      for (final layer in layers) {
        layerStates[layer.id] = LayerState(visible: layer.defaultVisible);
      }
      layerStates.refresh();

      // Eagerly load defaultVisible layers in parallel.
      await Future.wait([
        for (final layer in layers)
          if (layer.defaultVisible) _loadLayerData(layer),
      ]);

      // Move camera to default campus
      _moveCameraToSelectedCampus();
    } catch (e) {
      logger.e('MapLayerController.initFromConfig error: $e');
    }
  }

  Future<void> toggleLayer(String layerId) async {
    final state = layerStates[layerId];
    if (state == null) return;

    state.visible = !state.visible;
    Get.find<AnalyticsService>().logLayerToggle(
      layerId: layerId,
      visible: state.visible,
    );

    if (state.visible && state.status == LayerLoadStatus.idle) {
      final def = _configRepo.layers.firstWhereOrNull((l) => l.id == layerId);
      if (def != null) {
        layerStates.refresh();
        await _loadLayerData(def);
        return;
      }
    }
    layerStates.refresh();
  }

  /// Re-filter/re-fetch layers and move camera after campus switch.
  /// When [skipCamera] is true, only re-filter markers without moving the
  /// camera (used when the caller already sets its own camera position,
  /// e.g. cross-campus search navigation).
  ///
  /// Returns a [Future] that completes after markers have been re-filtered
  /// and the overlay reconciliation frame has been scheduled.
  Future<void> onCampusChanged({bool skipCamera = false}) {
    // 카메라 먼저 이동 — 사용자에게 즉각적인 피드백
    if (!skipCamera) _moveCameraToSelectedCampus();

    // 마커 재필터링은 다음 프레임 이후 실행 (카메라 이동 렌더링 완료 후)
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final entry in layerStates.entries) {
        final state = entry.value;
        final def =
            _configRepo.layers.firstWhereOrNull((l) => l.id == entry.key);
        if (def == null) continue;

        if (state.rawMarkers != null) {
          state.markers = _buildMarkersFromJson(state.rawMarkers!, def);
        }
      }
      layerStates.refresh();
      completer.complete();
    });
    return completer.future;
  }

  // ── Computed getters for the map ──────────────────

  List<NMarker> get activeMarkers {
    final result = <NMarker>[];
    for (final state in layerStates.values) {
      if (state.visible && state.markers != null) {
        result.addAll(state.markers!);
      }
    }
    return result;
  }

  List<NMultipartPathOverlay> get activeOverlays {
    final result = <NMultipartPathOverlay>[];
    for (final state in layerStates.values) {
      if (state.visible && state.overlay != null) {
        result.add(state.overlay!);
      }
    }
    return result;
  }

  // ── Private ───────────────────────────────────────

  Future<void> _loadLayerData(MapLayerDef def) async {
    final state = layerStates[def.id];
    if (state == null) return;

    state.status = LayerLoadStatus.loading;
    layerStates.refresh();

    try {
      switch (def.type) {
        case 'marker':
          await _loadMarkerLayer(def, state);
        case 'polyline':
          await _loadPolylineLayer(def, state);
        default:
          logger.d('Unknown layer type: ${def.type}');
          state.status = LayerLoadStatus.error;
      }
    } catch (e) {
      logger.e('Layer load error (${def.id}): $e');
      state.status = LayerLoadStatus.error;
    }
    layerStates.refresh();
  }

  /// Load marker data from /map/markers/* endpoints.
  Future<void> _loadMarkerLayer(MapLayerDef def, LayerState state) async {
    final result = await _layerRepo.getMarkers(def.endpoint);
    switch (result) {
      case Ok(:final data):
        state.rawMarkers = data;
        state.markers = _buildMarkersFromJson(data, def);
        state.status = LayerLoadStatus.loaded;
      case Err(:final failure):
        logger.e('Marker fetch failed (${def.id}): $failure');
        state.status = LayerLoadStatus.error;
    }
  }

  /// Build NMarker list from raw JSON, filtered by selected campus.
  /// Rendering depends on [MapLayerDef.markerStyle].
  List<NMarker> _buildMarkersFromJson(
      List<Map<String, dynamic>> markers, MapLayerDef def) {
    final selectedCampus = _selectedCampusKey;
    final markerSize = def.style?.size ?? 25;
    final captionSize = def.style?.captionTextSize ?? 7;

    return markers
        .where((m) => m['campus'] == selectedCampus)
        .map((m) {
      final skkuId = m['skkuId'] as int;
      final lat = (m['lat'] as num).toDouble();
      final lng = (m['lng'] as num).toDouble();

      final NMarker marker;
      switch (def.markerStyle) {
        case 'numberCircle':
          final displayNo = m['displayNo'] as String;
          marker = NMarker(
            id: 'num_$skkuId',
            position: NLatLng(lat, lng),
            size: Size(markerSize, markerSize),
            icon: _markerIcon,
            captionOffset: -22,
            caption: NOverlayCaption(
              textSize: captionSize,
              text: displayNo,
              color: Colors.black,
            ),
          );
        case 'textLabel':
          final text = m['text'] as Map<String, dynamic>;
          final lang = Get.locale?.languageCode;
          final label = lang == 'en'
              ? (text['en'] as String? ?? '')
              : (text['ko'] as String? ?? '');
          marker = NMarker(
            id: 'lbl_$skkuId',
            position: NLatLng(lat, lng),
            size: const Size(1, 1),
            icon: _markerIcon,
            isHideCollidedCaptions: true,
            caption: NOverlayCaption(
              textSize: captionSize,
              text: label,
              color: Colors.black,
            ),
          );
          marker.setGlobalZIndex(100000);
        default:
          marker = NMarker(
            id: 'mkr_$skkuId',
            position: NLatLng(lat, lng),
            size: Size(markerSize, markerSize),
            icon: _markerIcon,
          );
      }
      marker.setOnTapListener((_) {
        Get.find<AnalyticsService>().logMarkerTap(skkuId: skkuId);
        BuildingDetailSheet.show(skkuId, source: 'marker_tap');
      });
      return marker;
    }).toList();
  }

  Future<void> _loadPolylineLayer(MapLayerDef def, LayerState state) async {
    final result = await _layerRepo.getPolyline(def.endpoint);
    switch (result) {
      case Ok(:final data):
        final coords = data.map((c) => NLatLng(c[0], c[1])).toList();
        if (coords.length >= 2) {
          state.overlay = NMultipartPathOverlay(
            id: '${def.id}Route',
            width: def.style?.width ?? 4,
            paths: [
              NMultipartPath(
                color: def.style?.color ?? const Color(0xFF003626),
                outlineColor:
                    def.style?.outlineColor ?? Colors.white,
                coords: coords,
              ),
            ],
          );
        }
        state.status = LayerLoadStatus.loaded;
      case Err(:final failure):
        logger.e('Polyline fetch failed (${def.id}): $failure');
        state.status = LayerLoadStatus.error;
    }
  }

  void _moveCameraToSelectedCampus() {
    try {
      final campusDef = _configRepo.config?.campus(_selectedCampusKey);
      if (campusDef != null) {
        final nmapCtrl = Get.find<UltimateNMapController>();
        nmapCtrl.cameraPosition.value = NCameraPosition(
          target: NLatLng(campusDef.centerLat, campusDef.centerLng),
          zoom: campusDef.defaultZoom,
          tilt: campusDef.defaultTilt,
          bearing: campusDef.defaultBearing,
        );
      }
    } catch (_) {}
  }

  String get _selectedCampusKey {
    try {
      final mainCtrl = Get.find<CampusMapController>();
      return mainCtrl.selectedCampus.value == 0 ? 'hssc' : 'nsc';
    } catch (_) {
      return 'hssc';
    }
  }
}
