import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../enums/proje_enums.dart';

class CheckDviceType {

  int getDviceType() {
    int dviceType = 0;
    if (kIsWeb) {
      dviceType = 2;
      print("Dvice is Web");
    } else {
      if (Platform.isAndroid) {
        dviceType = getAndroidDeviceType();
        print("Dvice is android");

      } else if (Platform.isIOS) {
        dviceType = getIosDeviceType();
        print("Dvice is ios");

      } else if (Platform.isWindows) {
        dviceType = 3;
        print("Dvice is windows");

      }
    }

    return dviceType;
  }

  int getAndroidDeviceType() {
    //0= android phone and 1= android tablet
    final data = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    return data.shortestSide < 600 ? 0 : 1;
  }

  int getIosDeviceType() {
    final data = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    //4= ios phone and 5= ios tablet
    return data.shortestSide < 600 ? 4 : 5;
  }

  bool isDeviceSmoll(){
    return getDviceType()==0||getDviceType()==4;
  }
}
