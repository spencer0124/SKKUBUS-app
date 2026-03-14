import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/features/transit/data/bus_config_repository.dart';

final double dwidth =
    MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width;

class CustomRow1 extends StatelessWidget {
  final String label;
  final String themeColor;
  final String iconType;
  final String busTypeText;
  final String actionRoute;
  final String groupId;

  const CustomRow1({
    Key? key,
    required this.label,
    required this.themeColor,
    required this.iconType,
    required this.busTypeText,
    required this.actionRoute,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final configRepo = Get.find<BusConfigRepository>();
        final busConfig = await configRepo.getGroupConfig(groupId);
        if (busConfig != null) {
          if (actionRoute == '/bus/realtime') {
            Get.toNamed(Routes.busRealtime,
                arguments: {'busConfig': busConfig});
          } else if (actionRoute == '/bus/schedule') {
            Get.toNamed(Routes.busCampus,
                arguments: {'busConfig': busConfig});
          }
        }
      },
      child: Column(
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
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            label,
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
                          Container(
                            height: 18,
                            padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(int.parse("0xFF$themeColor")),
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
                          const Spacer(),
                          Row(
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
                          const SizedBox(width: 10),
                        ],
                      ),
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
    );
  }

  Widget _buildIcon() {
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
          child: Image.network(
            iconType,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) {
              return SvgPicture.asset(
                'assets/tossface/toss_bus_skkubus.svg',
                width: 23,
              );
            },
          ),
        ),
    };
  }
}
