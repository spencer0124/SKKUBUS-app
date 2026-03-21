import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:skkumap/app_theme.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/features/transit/data/bus_config_repository.dart';

class CustomRow1 extends StatelessWidget {
  final String label;
  final String themeColor;
  final String iconType;
  final String busTypeText;
  final String? subtitle;
  final String actionRoute;
  final String groupId;

  const CustomRow1({
    Key? key,
    required this.label,
    required this.themeColor,
    required this.iconType,
    required this.busTypeText,
    this.subtitle,
    required this.actionRoute,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(int.parse("0xFF$themeColor"));

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
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: badgeColor.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                busTypeText,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.textDisabled,
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.divider,
              thickness: 0.5,
              height: 0.5,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return switch (iconType) {
      'shuttle' => SvgPicture.asset(
          'assets/tossface/toss_bus_skkubus.svg',
          width: 28,
        ),
      'village' => SvgPicture.asset(
          'assets/tossface/toss_bus_citybus.svg',
          width: 28,
        ),
      _ => SizedBox(
          width: 28,
          child: Image.network(
            iconType,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) {
              return SvgPicture.asset(
                'assets/tossface/toss_bus_skkubus.svg',
                width: 28,
              );
            },
          ),
        ),
    };
  }
}
