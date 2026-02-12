import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/stationrow.dart';
import 'package:skkumap/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:skkumap/app/pages/search_list/controller/search_list_controller.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app/model/search_option3_model.dart';
import 'package:skkumap/app/pages/search_list/controller/search_list_controller.dart';

class SearchList extends StatefulWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // Dismiss keyboard when this page is popped
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);

    final controller = Get.find<SearchListController>();

    searchController.addListener(() {
      controller.onSearchChanged(searchController.text);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: Alignment.centerLeft,
            height: 49,
            width: screenWidth * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              // only bottom border! bottom border

              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 1,
              //     blurRadius: 5,
              //     offset: const Offset(0, 3), // changes position of shadow
              //   ),
              // ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 23,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(
                  width: dwidth * 0.85,
                  height: 70,
                  child: TextField(
                    autofocus: true,

                    controller: searchController,
                    autocorrect: false,
                    enableSuggestions: false,
                    enableIMEPersonalizedLearning: false,
                    // keyboardType: TextInputType.,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'WantedSansMedium',
                    ),
                    cursorHeight: 19,
                    cursorColor: AppColors.green_main,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "성균관대 공간명/코드 검색".tr,
                      isDense: true,
                      // contentPadding: EdgeInsets.all(20),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                // Text(
                //   '성균관대 공간명/코드 검색',
                //   style: TextStyle(
                //     color: Colors.grey[400],
                //     fontFamily: 'WantedSansMedium',
                //     fontSize: 15,
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: screenWidth,
            height: 25,
            color: Colors.grey[200],
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '총 ${controller.searchResult.value?.metaData.option3TotalCount ?? 0}건의 검색결과 (인사캠 ${controller.searchResult.value?.metaData.option3HsscCount ?? 0}건, 자과캠 ${controller.searchResult.value?.metaData.option3NscCount ?? 0}건)',
                    style: const TextStyle(
                      fontFamily: 'WantedSansMedium',
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            return Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.updateFilter(SearchTab.all);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                    decoration: BoxDecoration(
                      color: controller.currentTab.value == SearchTab.all
                          ? AppColors.green_main
                          : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: controller.currentTab.value == SearchTab.all
                            ? AppColors.green_main
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '전체'.tr,
                      style: TextStyle(
                        color: controller.currentTab.value == SearchTab.all
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'WantedSansMedium',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.updateFilter(SearchTab.hssc);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                    decoration: BoxDecoration(
                      color: controller.currentTab.value == SearchTab.hssc
                          ? AppColors.green_main
                          : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: controller.currentTab.value == SearchTab.hssc
                            ? AppColors.green_main
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '인사캠'.tr,
                      style: TextStyle(
                        color: controller.currentTab.value == SearchTab.hssc
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'WantedSansMedium',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.updateFilter(SearchTab.nsc);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                    decoration: BoxDecoration(
                      color: controller.currentTab.value == SearchTab.nsc
                          ? AppColors.green_main
                          : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: controller.currentTab.value == SearchTab.nsc
                            ? AppColors.green_main
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '자과캠'.tr,
                      style: TextStyle(
                        color: controller.currentTab.value == SearchTab.nsc
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'WantedSansMedium',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            // Filtered list based on the current tab
            List<SpaceItem> items = controller.filteredItems;
            if (items.isEmpty) {
              return Center(
                child: Text('검색 결과가 없습니다'.tr),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    SpaceItem item = items[index];

                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                      height: 65,
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      item.spaceInfo!.spaceNmKr!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'WantedSansMedium',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        item.category!,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(item.buildingInfo!.buildNmKr!),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(item.spaceInfo!.floorNmKr!),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                item.spaceInfo!.spaceCd!,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: 'WantedSansMedium',
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                    );

                    // ListTile(
                    //   title: Column(
                    //     children: [
                    //       Divider(
                    //         color: Colors.grey.withOpacity(0.4),
                    //         height: 0,
                    //       ),
                    //       const SizedBox(
                    //         height: 12.5,
                    //       ),
                    //       Row(
                    //         children: [
                    //           Text(
                    //             item.spaceInfo!.spaceNmKr!,
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //           const Spacer(),
                    //           Text(item.spaceInfo!.spaceCd!,
                    //               style: TextStyle(
                    //                 color: Colors.grey[500],
                    //                 fontFamily: 'WantedSansMedium',
                    //                 fontSize: 15,
                    //               )),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    //   subtitle: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Text(item.category!),
                    //           const SizedBox(
                    //             width: 3,
                    //           ),
                    //           Text(item.buildingInfo!.buildNmKr!),
                    //           const SizedBox(
                    //             width: 3,
                    //           ),
                    //           Text(item.spaceInfo!.floorNmKr!),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
