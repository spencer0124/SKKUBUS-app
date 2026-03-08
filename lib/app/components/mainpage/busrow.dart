import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:skkumap/app/routes/app_routes.dart';
import 'package:skkumap/app/data/repositories/bus_config_repository.dart';
import 'package:skkumap/app/model/bus_group.dart';
import 'dart:io' show Platform; // Platform 클래스를 사용하기 위해 import
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:skkumap/app/utils/app_logger.dart';

final double dwidth =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

class CustomRow1 extends StatelessWidget {
  final String title;
  final String subtitle;
  final String busTypeText;
  final String busTypeBgColor;
  final String pageLink;
  final String? pageWebviewLink;
  final String? altPageLink;

  final String? noticeText;
  final bool useAltPageLink;
  final bool showAnimation;

  final bool showNoticeText;
  final String? busConfigId;

  const CustomRow1({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.busTypeText,
    required this.busTypeBgColor,
    required this.pageLink,
    this.pageWebviewLink,
    this.altPageLink,
    this.noticeText,
    required this.useAltPageLink,
    required this.showAnimation,
    required this.showNoticeText,
    this.busConfigId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (useAltPageLink) {
          if (await canLaunchUrl(Uri.parse(altPageLink!))) {
            await launchUrl(Uri.parse(altPageLink!));
          } else {
            Get.snackbar('오류', '해당 링크를 열 수 없습니다.');
          }
        } else if (busConfigId != null) {
          final configRepo = Get.find<BusConfigRepository>();
          final busConfig = await configRepo.ensureAndGet(busConfigId!);
          if (busConfig != null) {
            switch (busConfig.screenType) {
              case 'realtime':
                Get.toNamed(Routes.busRealtime,
                    arguments: {'busConfig': busConfig});
              case 'schedule':
                Get.toNamed(Routes.busCampus,
                    arguments: {'busConfig': busConfig});
              default:
                break;
            }
          }
        } else {
          // Fallback for items without busConfigId
          if (pageLink == Routes.webview) {
            final parameters = <String, Object>{
              'platform': Platform.operatingSystem,
              'os_version_string': Platform.operatingSystemVersion,
              'locale': Platform.localeName,
            };

            FirebaseAnalytics.instance.logEvent(
              name:
                  'webview_$title'
                  ' click',
              parameters: parameters,
            );

            logger.d(
              'Analytics Event Logged (No Packages): $parameters',
            );
            Get.toNamed(
              pageLink,
              arguments: {
                'title': title,
                'color': busTypeBgColor,
                'webviewLink': pageWebviewLink,
              },
            );
          } else {
            Get.toNamed(pageLink);
          }
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: dwidth,
                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 10, 7),
                          child: _buildIcon(),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'WantedSansMedium',
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const Text(
                                  '  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'WantedSansBold',
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                if (busConfigId != null)
                                  Container(
                                    height: 18,
                                    padding: const EdgeInsets.fromLTRB(
                                      7,
                                      2,
                                      7,
                                      2,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse("0xFF$busTypeBgColor"),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      busTypeText,
                                      style: TextStyle(
                                        height: 1.4.h,
                                        color: Colors.white,
                                        fontFamily: 'WantedSansMedium',
                                        fontSize: 10.sp,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'WantedSansMedium',
                                fontSize: 11.5,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            if (showNoticeText)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        size: 13,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        noticeText!,
                                        style: TextStyle(
                                          color: Colors.red[600],
                                          fontFamily: 'WantedSansMedium',
                                          fontSize: 11.5,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Divider(
                color: Colors.grey[300],
                thickness: 0.7,
                endIndent: 0,
                indent: dwidth * 0.145,
              ),
            ],
          ),
          Positioned(
            right: 10,
            top: 10.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '상세정보'.tr,
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontFamily: 'WantedSansMedium',
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  CupertinoIcons.right_chevron,
                  size: 12,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          if (showAnimation)
            Positioned(
              top: -10,
              left: 13,
              child:
              Lottie.asset(
                'assets/lottie/shine2.json',
                reverse: false,
                repeat: true,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (busConfigId == null) {
      return SizedBox(
        width: 23,
        child: Image.network(
          "https://i.imgur.com/IRnCU4R.jpeg",
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Failed to load image');
          },
        ),
      );
    }

    // Use busConfigId to determine icon synchronously
    final configRepo = Get.find<BusConfigRepository>();
    final config = configRepo.getById(busConfigId!);
    final iconType = config?.card.iconType;

    return switch (iconType) {
      'shuttle' => SvgPicture.asset(
          'assets/tossface/toss_bus_skkubus.svg',
          width: 23,
        ),
      'village' => SvgPicture.asset(
          'assets/tossface/toss_bus_citybus.svg',
          width: 23,
        ),
      _ => SizedBox(
          width: 23,
          child: iconType != null
              ? Image.network(
                  iconType,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Failed to load image');
                  },
                )
              : SvgPicture.asset(
                  'assets/tossface/toss_bus_skkubus.svg',
                  width: 23,
                ),
        ),
    };
  }
}
