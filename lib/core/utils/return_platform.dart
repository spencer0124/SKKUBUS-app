import 'dart:io';

enum PlatformType {
  android,
  ios,
  unknown,
}

PlatformType getCurrentPlatform() {
  if (Platform.isAndroid) {
    return PlatformType.android;
  } else if (Platform.isIOS) {
    return PlatformType.ios;
  } else {
    return PlatformType.unknown;
  }
}
