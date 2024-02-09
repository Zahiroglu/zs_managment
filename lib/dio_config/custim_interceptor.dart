import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';

import '../companents/login/models/logged_usermodel.dart';

// import '../companents/login/services/api_services/users_controller_mobile.dart';
import '../companents/local_bazalar/local_users_services.dart';
import '../constands/app_constands.dart';
import '../widgets/simple_info_dialog.dart';
import 'package:get/get.dart' as getxt;

class CustomInterceptor extends Interceptor {
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  Dio dio;

  CustomInterceptor(this.dio);

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('Request[=> PATH:${options.path}] data :${options.data}');
    localUserServices.init();
    String token = localUserServices.getLoggedUser().tokenModel!.accessToken!;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    print('Responce[${response.statusCode}] => PATH: ${response.requestOptions.path.toString()}' + "" + " result :" + response.data.toString());
      if (response.statusCode == 401) {
        int statusrefresh = await refreshAccessToken();
        if (statusrefresh == 200) {
          return handler.resolve(await _retry(response.requestOptions));
        }else{
          Get.dialog(ShowInfoDialog(
            color:Colors.red,
            icon: Icons.error_outline,
            messaje:"Istifadeci tapilmadi.Yeniden giris edin!",
            callback: () {
              localUserServices.init();
              localUserServices.clearALLdata();
              getxt.Get.offNamed(RouteHelper.wellcome);
            },
          ));
        }
      }
      else if(response.statusCode==404){
        Get.toNamed(RouteHelper.mobileLisanceScreen);
      }
      else if(response.statusCode != 200){
        exeptionHandler(response);
      }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    Get.dialog(ShowInfoDialog(
      color:Colors.red,
      icon: Icons.error_outline,
      messaje:err.error.toString(),
      callback: () {
          Get.back();
      },
    ));
   // exeptionHandler(err.response);
    // if (err.response != null) {
    //   if (err.response!.statusCode == 401) {
    //     int statusrefresh = await refreshAccessToken();
    //     if (statusrefresh == 200) {
    //       return handler.resolve(await _retry(err.requestOptions));
    //     }else{
    //       localUserServices.init();
    //       localUserServices.clearALLdata();
    //       getxt.Get.offNamed(RouteHelper.wellcome);
    //     }
    //   } else {
    //     Get.dialog(ShowInfoDialog(
    //       color: Colors.red,
    //       icon: Icons.error,
    //       messaje: "Xeta bas verdi.tekrar yoxla",
    //       callback: () {
    //         Get.back();
    //       },
    //     ));
    //   }
    // } else {
    //   DialogHelper.hideLoading();
    // }
    super.onError(err, handler);
  }

  void exeptionHandler(dataResponce) {
    print("data resp :"+dataResponce.toString());
    ModelExceptions model=ModelExceptions.fromJson(dataResponce.data['exception']);
      Get.dialog(ShowInfoDialog(
        color: model.level == "Error" ? Colors.red : Colors.yellow,
        icon: model.level == "Error" ? Icons.error : Icons.info_outlined,
        messaje: "${model.message!}",
        callback: () {
          Get.back();
        },
      ));

  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<int> refreshAccessToken() async {
    print("refresh token cagrildi");
    int succes = 0;
    localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String refreshToken = loggedUserModel.tokenModel!.refreshToken!;
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    var data = {"refreshtoken": refreshToken};
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      getxt.Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          getxt.Get.back();
        },
      ));
    } else {
      try {
        final response = await dio.post(
          "${loggedUserModel.baseUrl}/api/v1/User/refresh-token",
          data: data,
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        print("responce refresh token :"+response.data.toString());
        if (response.statusCode == 200) {
          TokenModel model = TokenModel.fromJson(response.data['result']);
          loggedUserModel.tokenModel = model;
          localUserServices.addUserToLocalDB(loggedUserModel);
          succes = 200;
        } else {
          localUserServices.init();
          localUserServices.clearALLdata();
          getxt.Get.offNamed(RouteHelper.wellcome);
        }
      } on DioException catch (e) {
        localUserServices.clearALLdata();
        getxt.Get.offNamed(RouteHelper.wellcome);
      }
    }
    return succes;
  }



}
class ModelExceptions {
  String? code;
  String? message;
  String? level;
  String? validationMessage;

  ModelExceptions({
    this.code,
    this.message,
    this.level,
    this.validationMessage,
  });

  ModelExceptions copyWith({
    String? code,
    String? message,
    String? level,
    String? validationMessage,
  }) =>
      ModelExceptions(
        code: code ?? this.code,
        message: message ?? this.message,
        level: level ?? this.level,
        validationMessage: validationMessage ?? this.validationMessage,
      );

  factory ModelExceptions.fromRawJson(String str) => ModelExceptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelExceptions.fromJson(Map<String, dynamic> json) => ModelExceptions(
    code: json["code"],
    message: json["message"],
    level: json["level"],
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "level": level,
    "validationMessage": validationMessage,
  };
}
