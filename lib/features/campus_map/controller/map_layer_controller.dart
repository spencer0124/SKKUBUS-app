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
import 'package:skkumap/features/building/data/building_repository.dart';
import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/ui/building_detail_sheet.dart';
import 'package:skkumap/core/utils/app_logger.dart';

enum LayerLoadStatus { idle, loading, loaded, error }

class LayerState {
  bool visible;
  LayerLoadStatus status;
  List<NMarker>? markers;
  NMultipartPathOverlay? overlay;

  /// Raw building data — kept so we can re-filter by campus without re-fetch.
  List<Building>? rawBuildings;

  LayerState({
    required this.visible,
    this.status = LayerLoadStatus.idle,
    this.markers,
    this.overlay,
    this.rawBuildings,
  });
}

const _markerIcon =
    NOverlayImage.fromAssetImage('assets/images/line_blank.png');

class MapLayerController extends GetxController {
  final _configRepo = Get.find<MapConfigRepository>();
  final _layerRepo = Get.find<MapLayerRepository>();
  final _buildingRepo = Get.find<BuildingRepository>();

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

      if (state.rawBuildings != null) {
        // Building marker layer — client-side re-filter
        state.markers = _buildBuildingNMarkers(state.rawBuildings!, def);
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
      if (_isBuildingEndpoint(def.endpoint)) {
        // Building layer — use BuildingRepository (unified /building/list)
        await _loadBuildingLayer(def, state);
      } else {
        switch (def.type) {
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

  bool _isBuildingEndpoint(String endpoint) {
    return endpoint.contains('/building/list') ||
        endpoint.contains('/map/markers/campus');
  }

  /// Load building data from BuildingRepository (unified /building/list).
  Future<void> _loadBuildingLayer(MapLayerDef def, LayerState state) async {
    final result = await _buildingRepo.getBuildings();
    switch (result) {
      case Ok(:final data):
        state.rawBuildings = data;
        state.markers = _buildBuildingNMarkers(data, def);
        state.status = LayerLoadStatus.loaded;
      case Err(:final failure):
        logger.e('Building fetch failed (${def.id}): $failure');
        state.status = LayerLoadStatus.error;
    }
  }

  /// Build NMarker list from Building data, filtered by selected campus.
  List<NMarker> _buildBuildingNMarkers(
      List<Building> buildings, MapLayerDef def) {
    final selectedCampus = _selectedCampusKey;
    final markerSize = def.style?.size ?? 25;
    final captionSize = def.style?.captionTextSize ?? 7;
    return buildings
        .where((b) => b.campus == selectedCampus)
        .map((b) {
      final hasNumber = b.displayNo != null;
      final marker = NMarker(
        id: 'bldg_${b.skkuId}',
        position: NLatLng(b.lat, b.lng),
        size: Size(markerSize, markerSize),
        icon: _markerIcon,
        captionOffset: hasNumber ? -22 : 0,
        caption: hasNumber
            ? NOverlayCaption(
                textSize: captionSize,
                text: b.displayNo!,
                color: Colors.black,
              )
            : NOverlayCaption(
                textSize: captionSize,
                text: b.name.localized,
                color: Colors.black,
              ),
        subCaption: hasNumber
            ? NOverlayCaption(
                textSize: captionSize,
                text: b.name.localized,
                color: Colors.black,
              )
            : null,
      );
      marker.setOnTapListener((_) {
        BuildingDetailSheet.show(b.skkuId);
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
