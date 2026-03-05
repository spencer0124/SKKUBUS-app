import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:skkumap/app/model/search_option3_model.dart';
import 'package:skkumap/app/data/repositories/search_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/utils/app_logger.dart';

import 'dart:async';

enum SearchTab { all, hssc, nsc }

class PlaceSearchController extends GetxController {
  final _searchRepo = Get.find<SearchRepository>();

  var searchResult = Rx<SearchOption3Model?>(null);
  Timer? debounceTimer;

  var currentTab = Rx<SearchTab>(SearchTab.all);

  List<SpaceItem> get filteredItems {
    switch (currentTab.value) {
      case SearchTab.hssc:
        return searchResult.value?.option3Items.hssc ?? [];
      case SearchTab.nsc:
        return searchResult.value?.option3Items.nsc ?? [];
      case SearchTab.all:
      default:
        return [
          ...searchResult.value?.option3Items.hssc ?? [],
          ...searchResult.value?.option3Items.nsc ?? [],
        ];
    }
  }

  void updateFilter(SearchTab tab) {
    currentTab.value = tab;
  }

  void onSearchChanged(String queryString) {
    if (debounceTimer?.isActive ?? false) debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 500), () {
      performSearch(queryString);
    });
  }

  Future<void> performSearch(String queryString) async {
    final result = await _searchRepo.searchBuildings(queryString);
    switch (result) {
      case Ok(:final data):
        data.option3Items.hssc?.forEach((item) {
          item.category = '인사캠';
        });
        data.option3Items.nsc?.forEach((item) {
          item.category = '자과캠';
        });
        searchResult.value = data;
      case Err(:final failure):
        logger.e("Error performing search: $failure");
    }
  }

  @override
  void onClose() {
    debounceTimer?.cancel(); // Always dispose of timers to avoid memory leaks
    super.onClose();
  }
}
