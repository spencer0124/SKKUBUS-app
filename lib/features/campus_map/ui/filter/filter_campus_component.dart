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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandLight : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? AppColors.brand : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? AppColors.brand : AppColors.textSecondary,
            fontFamily: selected ? 'WantedSansMedium' : 'WantedSansRegular',
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
