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

import '../companents/anbar/controller_anbar.dart';
import '../companents/local_bazalar/local_bazalar.dart';
import '../companents/login/models/logged_usermodel.dart';

// import '../companents/login/services/api_services/users_controller_mobile.dart';
import '../companents/local_bazalar/local_users_services.dart';
import '../companents/login/services/api_services/users_apicontroller_web_windows.dart';
import '../companents/main_screen/controller/drawer_menu_controller.dart';
import '../companents/setting_panel/setting_panel_controller.dart';
import '../constands/app_constands.dart';
import '../helpers/exeption_handler.dart';
import '../widgets/simple_info_dialog.dart';
import 'package:get/get.dart' as getxt;

class CustomInterceptor extends Interceptor {
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  bool isLiveTrackRequest = false;
  Dio dio;
  LocalBazalar localBazalar = LocalBazalar();

  CustomInterceptor(this.dio, this.isLiveTrackRequest);

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await localUserServices.init();
    String token = await localUserServices.getLoggedToken();
    print('Request[=> PATH:${options.path}] data :${options.data} ');
    if (token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }else{
      await localBazalar.claerBaseUrl();
      Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    print('Responce[${response.statusCode}] => PATH: ${response.requestOptions.path.toString()}' + " " + " result :" + response.data.toString());
    if(response.data['exception']!=null){
     ModelExceptions model = ModelExceptions.fromJson(response.data['exception']);
    if (response.statusCode == 401) {
     if(model.code=="007"){
       if(isLiveTrackRequest){
       Get.dialog(ShowInfoDialog(
         color: Colors.red,
         icon: Icons.error_outline,
         messaje: model.message!,
         callback: () {
           Get.back();
         },
       ));}
     }else if(model.code=="006"){
       int statusrefresh = await refreshAccessToken();
       if (statusrefresh == 200) {
         return handler.resolve(await _retry(response.requestOptions));
       }
     }
   }}
    else{
    if (response.statusCode != 200) {
       if(response.statusCode == 404){
         await localBazalar.claerBaseUrl();
         Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
       }
       else if(response.statusCode == 401) {
          int statusrefresh = await refreshAccessToken();
          if (statusrefresh == 200) {
            return handler.resolve(await _retry(response.requestOptions));
          }
        }}
      else{
        Get.back();
      }
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if(!isLiveTrackRequest) {
      Get.dialog(ShowInfoDialog(
        color: Colors.red,
        icon: Icons.error_outline,
        messaje: err.toString(),
        callback: () {
          Get.back();
        },
      ));
    }
    // if(err.type == DioExceptionType.receiveTimeout){
    //   await localBazalar.claerBaseUrl();
    //   Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
    // }else {
    //   Get.dialog(ShowInfoDialog(
    //     color: Colors.red,
    //     icon: Icons.error_outline,
    //     messaje: err.toString(),
    //     callback: () {
    //       Get.back();
    //     },
    //   ));
    // }
    super.onError(err, handler);
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
    await localUserServices.init();
    loggedUserModel= localUserServices.getLoggedUser();
    String refreshToken =await localUserServices.getRefreshToken();
    String accesToken = await localUserServices.getLoggedToken();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    var data = {"refreshtoken": refreshToken};
    print("old refresh token : " + refreshToken);
    print("old  token : " + accesToken);
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      getxt.Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
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
        print("responce refresh token :" + response.data.toString());
        if (response.statusCode == 200) {
          TokenModel model = TokenModel.fromJson(response.data['result']);
          loggedUserModel.tokenModel = model;
          await localUserServices.addUserToLocalDB(loggedUserModel).whenComplete(() => succes = 200);
        } else {
            succes == response.statusCode;
        }
      } on DioException catch (e) {
       print(e.error);
      }
    }
    return succes;
  }

  Future<void> _sistemiYenidenBaslat() async {
    Get.delete<DrawerMenuController>();
    Get.delete<UsersApiController>();
    //Get.delete<SettingPanelController>();
    Get.delete<ControllerAnbar>();
    await localBazalar.clearLoggedUserInfo();
    await localBazalar.clearAllBaseDownloads();
    Get.offAllNamed(RouteHelper.getMobileLisanceScreen());

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

  factory ModelExceptions.fromRawJson(String str) =>
      ModelExceptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelExceptions.fromJson(Map<String, dynamic> json) =>
      ModelExceptions(
        code: json["code"],
        message: json["message"],
        level: json["level"],
        validationMessage: json["validationMessage"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "level": level,
        "validationMessage": validationMessage,
      };
}
