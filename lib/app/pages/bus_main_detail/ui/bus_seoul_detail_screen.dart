import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';

final double dheight =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
final double dwidth =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

class BusDataScreenDetail extends StatelessWidget {
  const BusDataScreenDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: AppColors.green_main,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            CustomNavigationBar(
              title: '인사캠 셔틀버스'.tr,
              backgroundColor: AppColors.green_main,
              isDisplayLeftBtn: true,
              isDisplayRightBtn: false,
              leftBtnAction: () {
                Get.back();
              },
              rightBtnAction: () {},
              rightBtnType: CustomNavigationBtnType.info,
            ),
            Flexible(
              child: Scrollbar(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 0),
                      // color: Colors.green,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Divider(color: Colors.grey[300]),
                          ),
                          Row(
                            children: [
                              Container(width: 5),
                              const Text(
                                '[인사캠 → 혜화역]',
                                style: TextStyle(
                                  color: AppColors.green_main,
                                  fontFamily: 'WantedSansBold',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 16),
                            child: Text(
                              '농구장 → 학생회관 → 정문 → 올림픽기념국민생활관 → 혜화동우체국 → 혜화동로터리 → 혜화역 1번출구',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'WantedSansRegular',
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Divider(color: Colors.grey[300]),
                          ),
                          const Row(
                            children: [
                              // Icon(
                              //   Icons.location_on,
                              //   color: AppColors.green_main,
                              // ),
                              SizedBox(width: 5),
                              Text(
                                '[혜화역 → 인사캠]',
                                style: TextStyle(
                                  color: AppColors.green_main,
                                  fontFamily: 'WantedSansBold',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              '혜화역 1번출구 → 혜화동로터리 → 성균관대입구사거리 → 정문 → 600주년기념관',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'WantedSansRegular',
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Divider(color: Colors.grey[300]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Icon(
                              //   Icons.credit_card,
                              //   color: AppColors.green_main,
                              // ),
                              const SizedBox(width: 5),
                              Text(
                                '요금 및 결제수단'.tr,
                                style: const TextStyle(
                                  color: AppColors.green_main,
                                  fontFamily: 'WantedSansBold',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              '요금 400원\n후불교통결제 기능 일반카드, T머니/캐시비카드 사용 가능\n현금 및 회수권 사용 불가'
                                  .tr,
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'WantedSansRegular',
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Divider(color: Colors.grey[300]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                '운행시간'.tr,
                                style: const TextStyle(
                                  color: AppColors.green_main,
                                  fontFamily: 'WantedSansBold',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              '월~금 운행, 공휴일 운행 안함\n\n[학기중] 07:00 ~ 23:00\n[방학중] 07:00 ~ 19:00'
                                  .tr,
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'WantedSansRegular',
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Divider(color: Colors.grey[300]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                '연락처 (클릭 시 전화연결)'.tr,
                                style: const TextStyle(
                                  color: AppColors.green_main,
                                  fontFamily: 'WantedSansBold',
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '학생지원팀  '.tr,
                                      style: TextStyle(
                                        color: Colors.grey[900],
                                        fontFamily: 'WantedSansRegular',
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          await FlutterPhoneDirectCaller.callNumber(
                                            '027601073',
                                          );
                                        } catch (e) {
                                          print(
                                            "Failed to make a call due to ${e.toString()}",
                                          );
                                        }
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            '02-760-1073',
                                            style: TextStyle(
                                              color: AppColors.green_main,
                                              fontFamily: 'WantedSansBold',
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '인사캠 관리팀  '.tr,
                                      style: TextStyle(
                                        color: Colors.grey[900],
                                        fontFamily: 'WantedSansRegular',
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          await FlutterPhoneDirectCaller.callNumber(
                                            '027600110',
                                          );
                                        } catch (e) {
                                          print(
                                            "Failed to make a call due to ${e.toString()}",
                                          );
                                        }
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            '02-760-0110',
                                            style: TextStyle(
                                              color: AppColors.green_main,
                                              fontFamily: 'WantedSansBold',
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Divider(color: Colors.grey[300]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
