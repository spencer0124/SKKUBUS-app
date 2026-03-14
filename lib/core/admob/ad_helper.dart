import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kReleaseMode) {
        return 'ca-app-pub-5619947536545679/9080383017';
      } else {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
    } else if (Platform.isIOS) {
      if (kReleaseMode) {
        return 'ca-app-pub-5619947536545679/2519510376';
      } else {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
