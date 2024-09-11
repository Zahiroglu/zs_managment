import 'dart:convert';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_configrations.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/setting_panel/setting_panel_controller.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
export 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../local_bazalar/local_db_downloads.dart';
import '../../../notifications/firebase_notificatins.dart';

class FirebaseUserApiControllerMobile extends GetxController {
  Dio dio = Dio();
  RxBool isLoading = false.obs;
  int dviceType = 0;
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  late final RxString dviceId = ''.obs;
  RxBool deviceIdMustvisible = false.obs;
  RxInt countClick = 0.obs;
  final _androidIdPlugin = const AndroidId();
  String basVerenXeta = "";
  String languageIndex = "az";
  DrawerMenuController controller = Get.put(DrawerMenuController());
  //FirebaseNotyficationController fireTokenServiz=FirebaseNotyficationController();
  @override
  void onInit() {
    localUserServices.init();
    localBaseDownloads.init();

    initPlatformState();
    // TODO: implement onInit
    super.onInit();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Future<void> initPlatformState() async {
    deviceIdMustvisible.value = false;
    changeLoading();
    try {
      // deviceId = await PlatformDeviceId.getDeviceId;
      dviceId.value = (await _androidIdPlugin.getId())!;
    } on PlatformException {
      dviceId.value = 'Failed to get deviceId.';
    }
    if (dviceId.value.isNotEmpty) {
     checkIfUserHaveLisance();

    } else {
      Get.dialog(ShowInfoDialog(
        messaje: "Xeta bas verdi",
        icon: Icons.error_outline,
        callback: () {
          initPlatformState();
        },
      ));
    }
    changeLoading();
  }

  void changeLoading() {
    isLoading.toggle();
    print("Isloading :" + isLoading.toString());
    update();
  }

  void clouseApp() {
    Get.delete<DrawerMenuController>();
    Get.reset(clearRouteBindings: true); SystemNavigator.pop();
  }



  Future<bool> checkUsersDownloads(int? roleId) async{
    await localBaseDownloads.init();
    return  localBaseDownloads.checkIfUserMustDonwloadsBaseFirstTime(roleId);
  }

  void checkIfUserHaveLisance() {
    FirebaseFirestore.instance
        .collection('db_lisances')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc);
      });
    });
  }



}
