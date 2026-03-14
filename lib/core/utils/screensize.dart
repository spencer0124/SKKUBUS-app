import 'package:flutter/widgets.dart';

class ScreenSize {
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;
}
