import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app_theme.dart';

// '주변' 탭 UI
class OptionAround extends StatelessWidget {
  OptionAround({Key? key}) : super(key: key);

  final controller = Get.find<MainpageController>();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);

    return Container(
      color: Colors.white,
      width: double.infinity,
      // Ensure the container has enough height to be scrollable in the sheet
      constraints: BoxConstraints(minHeight: screenHeight * 0.9),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCallToActionButton(),
              const SizedBox(height: 24.0),
              _buildSearchBar(),
              const SizedBox(height: 20.0),
              _buildListHeader(),
              const Divider(height: 1, color: Color(0xFFF2F2F2)),
              // Taxi party list items will be generated here
              _buildPartyListItem(
                "전남대학교",
                "조선대학교",
                "2022. 06. 01",
                "15:30 PM",
                "1명 / 3명",
              ),
              _buildPartyListItem(
                "전남대학교",
                "조선대학교",
                "2022. 06. 01",
                "15:30 PM",
                "2명 / 3명",
              ),
              _buildPartyListItem(
                "전남대학교",
                "조선대학교",
                "2022. 06. 01",
                "15:30 PM",
                "1명 / 3명",
              ),
              _buildPartyListItem(
                "전남대학교",
                "조선대학교",
                "2022. 06. 01",
                "15:30 PM",
                "1명 / 3명",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the top call-to-action button.
  Widget _buildCallToActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        spacing: 5,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/tossface/toss_shield.svg', width: 20),
          const Text(
            '인증된 성대생과 택시 동승하기',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              // Handle "자세히보기" tap
              print("인증하기 클릭됨");
            },
            child: const Row(
              children: [
                Text(
                  '인증하기',
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
                Icon(Icons.arrow_forward_ios, size: 12.0, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the search bar with destination, radius, and search button.
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                hintText: '출발지',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          Container(
            height: 20,
            width: 1,
            color: const Color(0xFFE0E0E0),
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
          ),
          const Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: '도착지 ',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.green_main,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                // Handle search action
              },
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the header for the taxi party list.
  Widget _buildListHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '출발지',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              '도착지',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '출발 일자',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '출발 시각',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '인원 현황',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          SizedBox(width: 24), // For alignment with the arrow icon
        ],
      ),
    );
  }

  /// Builds a single item for the taxi party list.
  Widget _buildPartyListItem(
    String origin,
    String destination,
    String date,
    String time,
    String occupancy,
  ) {
    return InkWell(
      onTap: () {
        // Handle party list item tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                origin,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.arrow_forward, size: 16.0),
            ),
            Expanded(
              flex: 4,
              child: Text(
                destination,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(date, style: const TextStyle(fontSize: 13)),
            ),
            Expanded(
              flex: 3,
              child: Text(time, style: const TextStyle(fontSize: 13)),
            ),
            Expanded(
              flex: 2,
              child: Text(occupancy, style: const TextStyle(fontSize: 13)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
