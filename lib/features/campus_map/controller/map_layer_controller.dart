import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:skkumap/features/campus_map/data/map_config_repository.dart';
import 'package:skkumap/features/campus_map/data/map_layer_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/features/campus_map/model/map_config.dart';
import 'package:skkumap/features/campus_map/model/map_marker.dart';
import 'package:skkumap/features/campus_map/model/map_overlay.dart';
import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';
import 'package:skkumap/core/utils/app_logger.dart';

enum LayerLoadStatus { idle, loading, loaded, error }

class LayerState {
  bool visible;
  LayerLoadStatus status;
  List<NMarker>? markers;
  NMultipartPathOverlay? overlay;

  /// Raw server markers — kept so we can re-filter by campus without re-fetch.
  List<ServerMapMarker>? rawMarkers;

  /// Raw overlay data — kept so we can detect overlay layers on campus switch.
  List<MapOverlay>? rawOverlays;

  LayerState({
    required this.visible,
    this.status = LayerLoadStatus.idle,
    this.markers,
    this.overlay,
    this.rawMarkers,
    this.rawOverlays,
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
  void onCampusChanged() {
    for (final entry in layerStates.entries) {
      final state = entry.value;
      final def =
          _configRepo.layers.firstWhereOrNull((l) => l.id == entry.key);
      if (def == null) continue;

      if (state.rawOverlays != null) {
        // Overlay layer — clear cache & re-fetch for new campus.
        // Keep old markers until fetch succeeds (rollback on failure).
        final previousMarkers = state.markers;
        state.status = LayerLoadStatus.loading;
        final endpoint = _resolveOverlayEndpoint(def.endpoint);
        _loadOverlayLayer(def, state, endpoint,
            fallbackMarkers: previousMarkers);
      } else if (state.rawMarkers != null) {
        // Standard marker layer — client-side re-filter
        state.markers = _buildNMarkers(state.rawMarkers!, def);
      }
    }
    layerStates.refresh();

    _moveCameraToSelectedCampus();
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
      if (_isOverlayEndpoint(def.endpoint)) {
        final endpoint = _resolveOverlayEndpoint(def.endpoint);
        await _loadOverlayLayer(def, state, endpoint);
      } else {
        switch (def.type) {
          case 'marker':
            await _loadMarkerLayer(def, state);
          case 'polyline':
            await _loadPolylineLayer(def, state);
          default:
            logger.d('Unknown layer type: ${def.type}');
            state.status = LayerLoadStatus.error;
        }
      }
    } catch (e) {
      logger.e('Layer load error (${def.id}): $e');
      state.status = LayerLoadStatus.error;
    }
    layerStates.refresh();
  }

  bool _isOverlayEndpoint(String endpoint) {
    return endpoint.contains('/map/overlays') &&
        Uri.parse(endpoint).queryParameters.containsKey('category');
  }

  /// Replace the category query parameter with the currently selected campus.
  String _resolveOverlayEndpoint(String baseEndpoint) {
    final uri = Uri.parse(baseEndpoint);
    final params = Map<String, String>.from(uri.queryParameters);
    params['category'] = _selectedCampusKey;
    return uri.replace(queryParameters: params).toString();
  }

  Future<void> _loadOverlayLayer(
    MapLayerDef def,
    LayerState state,
    String endpoint, {
    List<NMarker>? fallbackMarkers,
  }) async {
    // Invalidate cache for this endpoint pattern so we get fresh data.
    final result = await _layerRepo.getOverlays(endpoint);
    switch (result) {
      case Ok(:final data):
        state.rawOverlays = data.overlays;
        state.markers = _buildOverlayNMarkers(data.overlays, def);
        state.status = LayerLoadStatus.loaded;
      case Err(:final failure):
        logger.e('Overlay fetch failed (${def.id}): $failure');
        state.status = LayerLoadStatus.error;
        // Rollback: keep previous markers if available
        if (fallbackMarkers != null) {
          state.markers = fallbackMarkers;
        }
    }
    layerStates.refresh();
  }

  /// Build NMarker list from overlay data.
  List<NMarker> _buildOverlayNMarkers(
      List<MapOverlay> overlays, MapLayerDef def) {
    final markers = <NMarker>[];
    for (final o in overlays) {
      if (o.type != 'marker') {
        logger.d('Skipping non-marker overlay type: ${o.type}');
        continue;
      }
      if (o.marker == null) continue;

      final m = o.marker!;

      // Name label marker (invisible 1x1 with caption)
      markers.add(NMarker(
        id: '_overlay_name_${o.id}',
        position: NLatLng(o.lat, o.lng),
        size: const Size(1, 1),
        caption: NOverlayCaption(
          text: m.label,
          textSize: 10,
          color: Colors.black,
          haloColor: Colors.white,
        ),
      ));

      // Number marker — only when subLabel is present
      if (m.subLabel != null) {
        markers.add(NMarker(
          id: '_overlay_num_${o.id}',
          position: NLatLng(o.lat, o.lng),
          size: const Size(25, 25),
          icon: _markerIcon,
          captionOffset: -22,
          caption: NOverlayCaption(
            textSize: 7,
            text: m.subLabel!,
            color: Colors.black,
          ),
        ));
      }
    }
    return markers;
  }

  Future<void> _loadMarkerLayer(MapLayerDef def, LayerState state) async {
    final result = await _layerRepo.getMarkers(def.endpoint);
    switch (result) {
      case Ok(:final data):
        state.rawMarkers = data;
        state.markers = _buildNMarkers(data, def);
        state.status = LayerLoadStatus.loaded;
      case Err(:final failure):
        logger.e('Marker fetch failed (${def.id}): $failure');
        state.status = LayerLoadStatus.error;
    }
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

  /// Build NMarker list from server markers, filtered by selected campus.
  List<NMarker> _buildNMarkers(
      List<ServerMapMarker> serverMarkers, MapLayerDef def) {
    final selectedCampus = _selectedCampusKey;
    final markerSize = def.style?.size ?? 25;
    final captionSize = def.style?.captionTextSize ?? 7;
    return serverMarkers
        .where((m) => m.campus == selectedCampus)
        .map((m) => NMarker(
              id: m.id,
              position: NLatLng(m.lat, m.lng),
              size: Size(markerSize, markerSize),
              icon: _markerIcon,
              captionOffset: -22,
              caption: NOverlayCaption(
                textSize: captionSize,
                text: m.code ?? m.name,
                color: Colors.black,
              ),
            ))
        .toList();
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
