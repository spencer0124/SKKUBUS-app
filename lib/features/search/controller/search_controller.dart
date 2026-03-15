import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/utils/app_logger.dart';
import 'package:skkumap/features/building/data/building_repository.dart';
import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/model/building_search_result.dart';

enum SearchTab { all, hssc, nsc }

/// Union type for search result display items.
sealed class SearchDisplayItem {}

class BuildingDisplayItem extends SearchDisplayItem {
  final Building building;
  BuildingDisplayItem(this.building);
}

class SpaceDisplayItem extends SearchDisplayItem {
  final SpaceGroup group;
  final SearchSpaceItem space;
  SpaceDisplayItem({required this.group, required this.space});
}

class PlaceSearchController extends GetxController {
  final _buildingRepo = Get.find<BuildingRepository>();

  final searchResult = Rx<BuildingSearchResult?>(null);
  final isLoading = false.obs;
  final currentTab = Rx<SearchTab>(SearchTab.all);

  Timer? _debounceTimer;
  CancelToken? _cancelToken;
  String _lastQuery = '';

  /// Combined display items for the ListView.
  List<SearchDisplayItem> get filteredItems {
    final result = searchResult.value;
    if (result == null) return [];

    final items = <SearchDisplayItem>[];

    // Buildings section
    for (final b in result.buildings) {
      items.add(BuildingDisplayItem(b));
    }

    // Spaces section (each space as a separate item)
    for (final group in result.spaces) {
      for (final space in group.items) {
        items.add(SpaceDisplayItem(group: group, space: space));
      }
    }

    return items;
  }

  void updateFilter(SearchTab tab) {
    currentTab.value = tab;
    // Re-search with campus filter
    if (_lastQuery.isNotEmpty) {
      performSearch(_lastQuery);
    }
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      searchResult.value = null;
      _lastQuery = '';
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      performSearch(query);
    });
  }

  Future<void> performSearch(String query) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    _lastQuery = query;
    isLoading.value = true;

    final campus = switch (currentTab.value) {
      SearchTab.all => null,
      SearchTab.hssc => 'hssc',
      SearchTab.nsc => 'nsc',
    };

    final result = await _buildingRepo.search(
      query,
      campus: campus,
      cancelToken: _cancelToken,
    );
    switch (result) {
      case Ok(:final data):
        searchResult.value = data;
      case Err(:final failure):
        if (failure is! CancelledFailure) {
          logger.e('Search error: $failure');
        }
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _cancelToken?.cancel();
    super.onClose();
  }
}
