import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/thema/theme_constants.dart';

class ThemaController extends GetxController {
  ThemeData themeData = ThemeData.light();
  RxBool isDark = false.obs;

  @override
  void onInit() {
    isDark.value = loadCurrentThema();
  }

  toggleTheme() {
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),);
    saveThema(Get.isDarkMode ? false : true);
    Get.forceAppUpdate();
  }

  void saveThema(bool isdark) async {
    isDark.value = isdark;
    late Box box = Hive.box("theme");
    await box.clear();
    await box.put("isDark", isdark);
    update();
  }

  bool loadCurrentThema() {
    late Box box = Hive.box("theme");
    var value = box.get("isDark");
    return value ?? false;
  }
}
