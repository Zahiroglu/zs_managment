import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as intl;
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
//import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import '../../../connected_users/model_main_inout.dart';
import '../../../giris_cixis/models/model_request_inout.dart';

class ControllerUserZiyaret extends GetxController {
  LocalUserServices userService = LocalUserServices();
  RxList<ModelMainInOut> listGirisCixis = List<ModelMainInOut>.empty(growable: true).obs;
  RxList<ModelInOutDay> listGunlukGirisCixislar = List<ModelInOutDay>.empty(growable: true).obs;
  RxList<ModelMainInOut> modelInOut = List<ModelMainInOut>.empty(growable: true).obs;
  String totalIsSaati="0";
  RxBool dataLoading = true.obs;
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler=ExeptionHandler();

  @override
  Future<void> onInit() async {
    await userService.init();
    super.onInit();
  }


  @override
  void dispose() {
    Get.delete<ControllerUserZiyaret>;
    super.dispose();
  }

  Future<void> getAllUsers( List<ModelMainInOut> listGirisCixislar) async {
    dataLoading.value = true;
    if(listGirisCixislar.isNotEmpty) {
      print("ModelInOutDay leng"+ listGirisCixislar.first.modelInOutDays.length.toString());
      for (ModelInOutDay element in listGirisCixislar.first.modelInOutDays) {
        listGunlukGirisCixislar.add(element);
      }
    }
    listGirisCixis.value=listGirisCixislar;
    dataLoading.value = false;
    update();
  }


}
