import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:skkumap/core/types/bus_status.dart';
import 'package:skkumap/core/types/time_format.dart';

import 'package:get/get.dart';

class TopInfo extends StatelessWidget {
  final TimeFormat timeFormat;
  final String currentTime;
  final int busCount;
  final BusStatus busStatus;
  final bool isLoaded;

  const TopInfo({
    Key? key,
    required this.timeFormat,
    required this.currentTime,
    required this.busCount,
    required this.busStatus,
    required this.isLoaded,
  }) : super(key: key);

  String get busCountString {
    return busStatus == BusStatus.active
        ? "$busCount${"대 운행 중".tr}"
        : "운행중인 버스 없음".tr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 4.0),
            child: isLoaded
                ? Text(
                    "$currentTime ${"기준".tr} · $busCountString",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[100]!,
                    highlightColor: Colors.white,
                    child: Container(
                      width: 200,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
