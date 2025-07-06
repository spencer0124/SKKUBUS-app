import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';

class FilterCampusComponent extends StatelessWidget {
  const FilterCampusComponent({
    Key? key,
    required this.text,
    required this.index,
    required this.selected,
    required this.onCampusItemTapped,
  }) : super(key: key);
  final String text;
  final int index;
  final bool selected;
  final Function(int) onCampusItemTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onCampusItemTapped(index);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.green_main : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? AppColors.green_main : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontFamily: 'WantedSansMedium',
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
