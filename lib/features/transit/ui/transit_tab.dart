import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/app_shell/controller/app_shell_controller.dart';
import 'package:skkumap/features/transit/controller/transit_controller.dart';
import 'package:skkumap/features/transit/widgets/busrow.dart';
import 'package:skkumap/core/utils/screensize.dart' show ScreenSize;

class TransitTab extends StatelessWidget {
  const TransitTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transitCtrl = Get.find<TransitController>();
    final adCtrl = Get.find<AppShellController>();
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
            subtitle: item.card.subtitle,
            actionRoute: item.action.route,
            groupId: item.action.groupId,
          );
        }).toList();

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: statusBarHeight + 16),
              // Notice banner
              Obx(() {
                if (adCtrl.showmainpageNoticeText.value != true) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: GestureDetector(
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
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.bgGrey,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/flaticon_megaphone.png',
                            width: 16,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() =>
                                adCtrl.mainpageNoticeText.value == ''
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        adCtrl.mainpageNoticeText.value,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                          ),
                          Obx(() => adCtrl.mainpageNoticeLink.value != ''
                              ? const Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: AppColors.textDisabled,
                                )
                              : const SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              ...busWidgets,
              // Bottom padding for nav bar clearance
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}
