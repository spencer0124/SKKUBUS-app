import 'package:flutter/material.dart';
import 'package:skkumap/app/utils/constants.dart';
import 'package:skkumap/app/types/bus_type.dart';

class BusListComponent extends StatelessWidget {
  final String stationName;
  final String? stationNumber;
  final String eta;
  final bool isFirstStation;
  final bool isLastStation;
  final bool isRotationStation;
  final BusType busType;

  const BusListComponent({
    Key? key,
    required this.stationName,
    this.stationNumber,
    required this.eta,
    required this.isFirstStation,
    required this.isLastStation,
    required this.isRotationStation,
    required this.busType,
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
                    color: isFirstStation ? Colors.white : busType.color,
                  ),
                  if (isRotationStation)
                    Container(
                      width: 34,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: busType.color),
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
                                    color: busType.color,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.u_turn_right_rounded,
                                size: 12,
                                color: busType.color,
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
                        border: Border.all(color: busType.color),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 12,
                        color: busType.color,
                      ),
                    ),
                  Container(
                    width: 3,
                    height: 26,
                    color: isLastStation ? Colors.white : busType.color,
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
                            fontFamily: 'WantedSansBold',
                          ),
                        ),
                      if (!(stationName.contains('미정차') ||
                          stationName.contains('하차전용')))
                        Text(
                          stationName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'WantedSansBold',
                          ),
                        ),
                      if (stationName == "낙원상가" || stationName == "종각.공평유적전시관")
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                          margin: const EdgeInsets.only(left: 2),
                          alignment: Alignment.center,
                          width: 13,
                          height: 13,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF0052A4)),
                          child: const Text(
                            "1",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (stationName == "헌법재판소.안국역" ||
                          stationName == "수운회관" ||
                          stationName == "낙원상가" ||
                          stationName == "안국역.인사동" ||
                          stationName == "안국역2번출구앞")
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                          margin: const EdgeInsets.only(left: 2),
                          alignment: Alignment.center,
                          width: 13,
                          height: 13,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFEF7C1C)),
                          child: const Text(
                            "3",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (stationName == "혜화역4번출구" ||
                          stationName == "혜화역1번출구" ||
                          stationName == "혜화역.마로니에공원" ||
                          stationName == "혜화역 1번출구")
                        Container(
                          //
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                          margin: const EdgeInsets.only(left: 2),
                          alignment: Alignment.center,
                          width: 13,
                          height: 13,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF00A5DE)),
                          child: const Text(
                            "4",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (stationName == "낙원상가")
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                          margin: const EdgeInsets.only(left: 2),
                          alignment: Alignment.center,
                          width: 13,
                          height: 13,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF996CAC)),
                          child: const Text(
                            "5",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (stationNumber != null)
                        Text(
                          stationNumber!,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'WantedSansRegular',
                            color: Colors.grey[500],
                          ),
                        ),
                      if (stationNumber != null)
                        Text(
                          " | ",
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'WantedSansRegular',
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      Text(
                        eta,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'WantedSansMedium',
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
              // color: Colors.grey.withOpacity(0.5),
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
              color: Colors.grey.withOpacity(0.4),
              height: 0,
            ),
          ),
      ],
    );
  }
}
