import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mobile/screens/screen_dashbourdmobile.dart';
import 'mobile/screens/users_screen.dart';

class DrawerScreenController extends GetxController{
  dynamic pageView;
  RxInt drawerIndex= 0.obs;

   Widget getCurrentPage()=>pageView=const ScreenDashBourdMobile();

  void changeIndex(int drawerIndexdata) {
    drawerIndex=RxInt(drawerIndexdata);
    if (drawerIndexdata == 0) {
        pageView=const ScreenDashBourdMobile();
        update();
    } else if (drawerIndexdata ==1) {
        pageView=const UsersScreenMobile();
        update();

    }else if(drawerIndexdata==2){
      update();

    }
  }


}