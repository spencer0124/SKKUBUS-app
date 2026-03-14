import 'package:flutter/material.dart';

class StationRowComponent extends StatelessWidget {
  const StationRowComponent({
    Key? key,
    required this.containerColor,
    required this.containerText,
  }) : super(key: key);

  final Color containerColor;
  final String containerText;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(5, 3, 1, 3),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[500]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              containerText,
              style: TextStyle(
                color: Colors.grey[800],
                // fontFamily: 'WantedSansMedium',
                fontSize: 10,
              ),
              textAlign: TextAlign.start,
            ),
            Icon(
              Icons.keyboard_arrow_right_outlined,
              size: 10,
              color: Colors.grey[400],
            )
          ],
        ),
      ),
    );
  }
}
