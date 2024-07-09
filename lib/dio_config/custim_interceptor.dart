import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';

import '../companents/anbar/controller_anbar.dart';
import '../companents/local_bazalar/local_bazalar.dart';
import '../companents/login/models/logged_usermodel.dart';

// import '../companents/login/services/api_services/users_controller_mobile.dart';
import '../companents/local_bazalar/local_users_services.dart';
import '../companents/login/services/api_services/users_apicontroller_web_windows.dart';
import '../companents/main_screen/controller/drawer_menu_controller.dart';
import '../widgets/simple_info_dialog.dart';
import 'package:get/get.dart' as getxt;

class CustomInterceptor extends Interceptor {
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  Dio dio;
  LocalBazalar localBazalar = LocalBazalar();
  bool mustShowResult;


  CustomInterceptor({required this.dio,required this.mustShowResult});

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await localUserServices.init();
    String token = await localUserServices.getLoggedToken();
    print('Time :'+DateTime.now().toString()+' Request[=> PATH:${options.path}] data :${options.data} ');
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
    print('Time :'+DateTime.now().toString()+'Responce[${response.statusCode}] => PATH: ${response.requestOptions.path.toString()}' + " " + " result :" + response.data.toString());
    if(response.statusCode==404){
      Get.offAllNamed(RouteHelper.getWindosLoginScreen());
    }
    else
      if(response.data['exception']!=null){
        ModelExceptions model = ModelExceptions.fromJson(response.data['exception']);
        if(model.code=="006"){
          int statusrefresh = await refreshAccessToken();
          if (statusrefresh == 200) {
            return handler.resolve(await _retry(response.requestOptions));
          }
        }else if(model.code=="005"){
          Get.dialog(ShowInfoDialog(
            color: Colors.red,
            icon: Icons.perm_identity,
            messaje: model.message!,
            callback: () {
              Get.back();
              Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
            },
          ));
        }else{
          Get.dialog(ShowInfoDialog(
            color: Colors.red,
            icon: Icons.perm_identity,
            messaje: model.message!,
            callback: () {
              Get.back();
            },
          ));

        }

      }else{
        if(mustShowResult){
          Get.dialog(ShowInfoDialog(
            color: Colors.blue,
            icon: Icons.verified,
            messaje: response.data['result'],
            callback: () {
              Get.back();
            },
          ));

        }else {
         if(Get.isDialogOpen!){
           Get.back();
         }
        }

    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if(Get.isDialogOpen!){
      Get.back();
    }
    print("error : "+err.toString() );
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
        Get.dialog(ShowInfoDialog(
          color: Colors.red,
          icon: Icons.error,
          messaje: "serverTimeOutXetasi".tr,
          callback: () {
            Get.back();
          },
        ));
          break;
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        print("error badResponse:"+err.response.toString());
        if(err.response!=null){
        ModelExceptions model = ModelExceptions.fromJson(err.response!.data['exception']);
        Get.dialog(ShowInfoDialog(
          color: Colors.red,
          icon: Icons.error,
          messaje: model.message!,
          callback: () {
            Get.back();
          },
        ));}else{
          Get.dialog(ShowInfoDialog(
            color: Colors.red,
            icon: Icons.error,
            messaje: "serverBaglantiXetasi".tr,
            callback: () {
              Get.back();
            },
          ));
        }
        break;
        case DioExceptionType.cancel:
          Get.dialog(ShowInfoDialog(
            color: Colors.blue,
            icon: Icons.verified,
            messaje: "serverConnectionCanceled".tr,
            callback: () {
              Get.back();
            },
          ));
          break;
        case DioExceptionType.connectionError:
          Get.dialog(ShowInfoDialog(
            color: Colors.blue,
            icon: Icons.verified,
            messaje: "serverConnectionError".tr,
            callback: () {
              Get.back();
            },
          ));
          break;
        case DioExceptionType.unknown:
          print("error unnown:"+err.response.toString());
          if(err.response!=null){
          ModelExceptions model = ModelExceptions.fromJson(err.response!.data['exception']);
          Get.dialog(ShowInfoDialog(
            color: Colors.red,
            icon: Icons.error,
            messaje: model.message!,
            callback: () {
              Get.back();
            },
          ));
          }else{
            Get.dialog(ShowInfoDialog(
              color: Colors.blue,
              icon: Icons.verified,
              messaje: "serverunnownError".tr,
              callback: () {
                Get.back();
              },
            ));
          }

          break;

      // TODO: Handle this case.
      }
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
