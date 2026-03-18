import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LicensePlate extends StatelessWidget {
  final String plateNumber;
  final Color textColor;
  final Color borderColor;

  const LicensePlate({
    Key? key,
    required this.plateNumber,
    this.textColor = Colors.grey,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Assuming you have an image named 'license_plate.png' in your assets
        SvgPicture.asset(
          'assets/images/LicensePlate.svg', // Update with your actual image asset path
          colorFilter: ColorFilter.mode(borderColor, BlendMode.srcIn),
          // color: Colors.red,
          // height: 20,
          width: 40,
          // height: 20,

          fit: BoxFit.fitWidth,
        ),
        if (plateNumber != '0000')
          Positioned(
            left: 6.5,
            child: Text(
              plateNumber,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        if (plateNumber == '0000')
          Positioned(
            left: 2,
            child: Text(
              "번호 미제공",
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
      ],
    );
  }
}
