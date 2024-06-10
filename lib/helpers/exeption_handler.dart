import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/routs/rout_controller.dart';

import '../dio_config/custim_interceptor.dart';
import '../widgets/simple_info_dialog.dart';

class ExeptionHandler{

  void handleExeption(dataResponce) {
    if(dataResponce.toString()=="") {
      Get.dialog(ShowInfoDialog(
        color: Colors.red,
        icon: Icons.error,
        messaje: "Xeta bas verdi",
        callback: () {
          Get.back();
        },
      ));
    }else {
      try {
        print("exeption sr=tatus code : text:" + dataResponce.toString());
        if (dataResponce.statusCode != 404) {
          ModelExceptions model = ModelExceptions.fromJson(dataResponce.data['exception']);
          Get.dialog(ShowInfoDialog(
            color: model.level == "Error" ? Colors.red : Colors.yellow,
            icon: model.level == "Error" ? Icons.error : Icons.info_outlined,
            messaje: model.message!,
            callback: () {
              Get.back();
            },
          ));
        } else {
          Get.dialog(ShowInfoDialog(
            color: true ? Colors.red : Colors.yellow,
            icon: true ? Icons.error : Icons.info_outlined,
            messaje: "baglantierror".tr,
            callback: () {
              Get.offAllNamed(RouteHelper.wellcome);
            },
          ));
        }
      } on DioException catch (e) {
        Get.back();
        Get.back();
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e.response != null) {
          print(e.response!.data.toString());
          print(e.response!.headers.toString());
          print(e.response!.requestOptions.toString());
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
        }
      }
    }
  }

}