import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';

class LiveActivityBusETA extends StatelessWidget {
  final double screenWidth;
  final String title; // 예: '인사캠 → 자과캠 셔틀'
  final String duration; // 예: '1시간 30분'
  final String distance; // 예: '131.1km'
  final String timeRange; // 예: '17:00 ~ 18:30'
  final bool isAvailable; // 현재 안내 가능한 버스가 남아있는지 여부

  const LiveActivityBusETA({
    Key? key,
    required this.screenWidth,
    required this.title,
    required this.duration,
    required this.distance,
    required this.timeRange,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      width: screenWidth / 2 - 20 - 6,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'WantedSansRegular',
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              isAvailable == true
                  ? Text(
                      duration,
                      style: const TextStyle(
                        color: AppColors.green_main,
                        fontFamily: 'WantedSansBold',
                        fontSize: 18,
                      ),
                    )
                  : const Text(
                      "운행종료",
                      style: TextStyle(
                        color: AppColors.green_main,
                        fontFamily: 'WantedSansBold',
                        fontSize: 18,
                      ),
                    ),
              const SizedBox(width: 5),
              isAvailable == true
                  ? Text(
                      distance,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontFamily: 'WantedSansRegular',
                        fontSize: 13,
                      ),
                    )
                  : const SizedBox(width: 1, height: 1),
            ],
          ),
          isAvailable == true
              ? Text(
                  timeRange,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'WantedSansRegular',
                  ),
                )
              : Text(
                  "버스 정보 없음",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'WantedSansRegular',
                  ),
                )
        ],
      ),
    );
  }
}
