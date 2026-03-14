import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:skkumap/features/app_shell/controller/app_shell_controller.dart';
import 'package:skkumap/features/transit/controller/transit_controller.dart';
import 'package:skkumap/features/transit/widgets/busrow.dart';
import 'package:skkumap/core/utils/screensize.dart';

class TransitTab extends StatelessWidget {
  const TransitTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transitCtrl = Get.find<TransitController>();
    final adCtrl = Get.find<AppShellController>();
    final double screenWidth = ScreenSize.width(context);
    final double statusBarHeight = ScreenSize.statusBarHeight(context);

    return Container(
      color: Colors.white,
      child: Obx(() {
        if (transitCtrl.mainpageBusList.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final busList = transitCtrl.mainpageBusList.value!;

        final busWidgets = busList.map((item) {
          return CustomRow1(
            label: item.card.label,
            themeColor: item.card.themeColor,
            iconType: item.card.iconType,
            busTypeText: item.card.busTypeText,
            actionRoute: item.action.route,
            groupId: item.action.groupId,
          );
        }).toList();

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: statusBarHeight + 10),
              // Notice banner
              Obx(() {
                if (adCtrl.showmainpageNoticeText.value != true) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey[300],
                      height: 0,
                      thickness: 0.7,
                      endIndent: 0,
                      indent: screenWidth * 0.145,
                    ),
                    const SizedBox(height: 7),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        if (adCtrl.mainpageNoticeLink.value != '') {
                          if (await canLaunchUrl(
                              Uri.parse(adCtrl.mainpageNoticeLink.value))) {
                            await launchUrl(
                                Uri.parse(adCtrl.mainpageNoticeLink.value));
                          } else {
                            Get.snackbar('오류', '해당 링크를 열 수 없습니다.');
                          }
                        } else {
                          Get.snackbar('오류2', '해당 링크를 열 수 없습니다.');
                        }
                      },
                      child: Container(
                        width: screenWidth * 0.95,
                        height: 33,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 14),
                            Image.asset(
                              'assets/images/flaticon_megaphone.png',
                              width: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 19),
                            Obx(() =>
                                adCtrl.mainpageNoticeText.value == ''
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[100]!,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          width: screenWidth * 0.75,
                                          height: 20,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Text(
                                        adCtrl.mainpageNoticeText.value,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'WantedSansMedium',
                                          fontSize: 12.5,
                                        ),
                                      )),
                            const Spacer(),
                            Obx(() => adCtrl.mainpageAdText.value == ''
                                ? const SizedBox(width: 1, height: 1)
                                : const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 2),
                                      Icon(
                                        CupertinoIcons.right_chevron,
                                        size: 12,
                                        color: Colors.black,
                                      ),
                                    ],
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Container(color: Colors.white, height: 10),
              ...busWidgets,
              const SizedBox(height: 5),
              // Bottom padding for nav bar clearance
              const SizedBox(height: 92),
            ],
          ),
        );
      }),
    );
  }
}
