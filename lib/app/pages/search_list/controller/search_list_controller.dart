import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:skkumap/app/model/search_option3_model.dart';
import 'package:skkumap/app/utils/api_fetch/search_option3.dart';
import 'package:skkumap/app/utils/app_logger.dart';

import 'dart:async';

enum SearchTab { all, hssc, nsc }

class SearchListController extends GetxController {
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
    try {
      // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // print("queryString: $queryString");
      SearchOption3Model result = await searchOption3(queryString);
      result.option3Items.hssc?.forEach((item) {
        item.category = '인사캠'; // Mark HSSC items
      });
      result.option3Items.nsc?.forEach((item) {
        item.category = '자과캠'; // Mark NSC items
      });
      searchResult.value = result;
    } catch (e) {
      logger.e("Error performing search: $e");
    }
  }

  @override
  void onClose() {
    debounceTimer?.cancel(); // Always dispose of timers to avoid memory leaks
    super.onClose();
  }
}
