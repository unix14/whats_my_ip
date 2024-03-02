import 'dart:io';

import 'package:flutter/foundation.dart';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7481638286003806/1452263955";
    // } else if (Platform.isIOS) {
    //   return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if(kReleaseMode) {
      return "3940256099942544/6300978111";
    }
    if (Platform.isAndroid) {
      return "ca-app-pub-7481638286003806/2806449945";
    // } else if (Platform.isIOS) {
    //   return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}