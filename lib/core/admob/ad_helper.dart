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

  static String get nativeSplashAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? 'ca-app-pub-5619947536545679/7570128823'
          : 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return kReleaseMode
          ? 'ca-app-pub-5619947536545679/8020987716'
          : 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeBusAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? 'ca-app-pub-5619947536545679/2996458991'
          : 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return kReleaseMode
          ? 'ca-app-pub-5619947536545679/2511708413'
          : 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeCampusAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? 'ca-app-pub-5619947536545679/9370295650'
          : 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return kReleaseMode
          ? 'ca-app-pub-5619947536545679/2915733791'
          : 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
