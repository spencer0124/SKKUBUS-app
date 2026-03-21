import 'package:flutter/material.dart';
import 'package:skkumap/core/utils/constants.dart';
import 'package:skkumap/features/transit/model/main_bus_stationlist.dart';

class BusListComponent extends StatelessWidget {
  final String stationName;
  final String? subtitle;
  final String eta;
  final bool isFirstStation;
  final bool isLastStation;
  final bool isRotationStation;
  final Color themeColor;
  final List<TransferLine> transferLines;

  const BusListComponent({
    Key? key,
    required this.stationName,
    this.subtitle,
    required this.eta,
    required this.isFirstStation,
    required this.isLastStation,
    required this.isRotationStation,
    required this.themeColor,
    this.transferLines = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: BusConstants.busComponentLeftpadding),
            // Left side shape UI
            SizedBox(
              height: 66,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 3,
                    height: 26,
                    color: isFirstStation ? Colors.white : themeColor,
                  ),
                  if (isRotationStation)
                    Container(
                      width: 34,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: themeColor),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "회차",
                                style: TextStyle(
                                    color: themeColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.u_turn_right_rounded,
                                size: 12,
                                color: themeColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      alignment: Alignment.center,
                      width: 34,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 12,
                        color: themeColor,
                      ),
                    ),
                  Container(
                    width: 3,
                    height: 26,
                    color: isLastStation ? Colors.white : themeColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            // Right side text UI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (stationName.contains('미정차') ||
                          stationName.contains('하차전용'))
                        Text(
                          stationName,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (!(stationName.contains('미정차') ||
                          stationName.contains('하차전용')))
                        Text(
                          stationName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      // Data-driven transfer line badges
                      ...transferLines.map((tl) => Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                            margin: const EdgeInsets.only(left: 2),
                            alignment: Alignment.center,
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: tl.color),
                            child: Text(
                              tl.line,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      if (subtitle != null && eta.isNotEmpty)
                        Text(
                          " | ",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      Text(
                        eta,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            const SizedBox(
              width: 3,
            ),
          ],
        ),
        if (!isLastStation)
          Padding(
            padding: const EdgeInsets.only(
                left: BusConstants.busComponentLeftpadding + 15),
            child: Divider(
              color: Colors.grey.withValues(alpha: 0.4),
              height: 0,
            ),
          ),
      ],
    );
  }
}
