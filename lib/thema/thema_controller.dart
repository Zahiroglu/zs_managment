import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:zs_managment/login/service/shared_manager.dart';

class ThemaController extends GetxController implements GetxService{
  late final SharedManager sharedPreferences;
  RxBool isDark=false.obs;





  @override
  void onInit() async{
    await sharedPreferences.init();
    loadCurrentThema();
    super.onInit();
  }




  toggleTheme(bool isDark) {
    Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());
    saveThema(isDark);
    update();
  }

  void saveThema(bool isDark) async {
    sharedPreferences.saveChangedThema(isDark);
  }

  Future<void> loadCurrentThema() async {
    bool? isdark=await sharedPreferences.getSavedThema();
    Get.changeTheme(isdark! ? ThemeData.dark() : ThemeData.light());
    isDark=isdark as RxBool;
    update();
  }
}
