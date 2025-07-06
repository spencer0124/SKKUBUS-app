import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/grabbing_box.dart';
import 'package:skkumap/app/pages/mainpage/ui/filter/filter_campus_component.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app/pages/mainpage/ui/filter/filter_sheet.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/pages/mainpage/ui/filter/filter_info_component.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenwidth = ScreenSize.width(context);

    var controller = Get.find<MainpageController>();
    List<Widget> buildInfoComponentsRow(List<Map<String, dynamic>> items) {
      return items.expand((item) {
        return [
          FilterInfoComponent(
            text: item["text"],
            index: item["index"],
            selected: controller.selectedCampusInfo.contains(item["index"]),
            onInfoItemTapped: (index) {
              if (controller.selectedCampusInfo.contains(index)) {
                controller.selectedCampusInfo.remove(index);
              } else {
                controller.selectedCampusInfo.add(index);
              }
            },
          ),
          const SizedBox(width: 5),
        ];
      }).toList();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const GrabbingBox(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Row(
              children: [
                const Text(
                  "필터",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WantedSansMedium',
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 0.7,
            endIndent: 0,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                const Text(
                  "캠퍼스",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WantedSansMedium',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Get.toNamed(routeName);
                  },
                  child: const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "지도에 표시할 캠퍼스를 선택하세요",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'WantedSansMedium',
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Obx(
                () {
                  return Row(
                    children: [
                      FilterCampusComponent(
                        selected:
                            controller.selectedCampus.value == 0 ? true : false,
                        index: 0,
                        text: "인사캠",
                        onCampusItemTapped: (int index) {
                          controller.selectedCampus.value = index;
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FilterCampusComponent(
                        selected:
                            controller.selectedCampus.value == 1 ? true : false,
                        index: 1,
                        text: "자과캠",
                        onCampusItemTapped: (int index) {
                          controller.selectedCampus.value = index;
                        },
                      ),
                    ],
                  );
                },
              )),

          // 두번재
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                const Text(
                  "캠퍼스 정보",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WantedSansMedium',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Get.toNamed(routeName);
                  },
                  child: const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "지도에 표시할 캠퍼스 정보를 선택하세요",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'WantedSansMedium',
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Obx(
              () {
                return Column(
                  children: [
                    Row(
                      children: buildInfoComponentsRow(
                          controller.campusInfo.sublist(0, 4)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: buildInfoComponentsRow(
                          controller.campusInfo.sublist(4, 9)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: buildInfoComponentsRow(
                          controller.campusInfo.sublist(9)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
