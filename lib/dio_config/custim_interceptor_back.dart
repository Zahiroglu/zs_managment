import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
import '../companents/main_screen/controller/drawer_menu_controller.dart';
import '../constands/app_constands.dart';
import '../widgets/simple_info_dialog.dart';
import 'package:get/get.dart' as getxt;

class CustomInterceptorBack extends Interceptor {
  late CheckDviceType checkDviceType = CheckDviceType();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  Dio dio;
  LocalBazalar localBazalar = LocalBazalar();
  bool mustShowResult;

  CustomInterceptorBack({required this.dio, required this.mustShowResult});

  Future<String> getLanguageIndex() async {
    const boxName = "myLanguage";

    // Hive qutusu açıqdırsa, birbaşa istifadə edin; əks halda açın
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }

    final box = Hive.box(boxName);
    return box.get("langCode") ?? "az"; // Dəyəri götür və ya default olaraq "az" qaytar
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    LocalUserServices localUserServicesa = LocalUserServices();
    await localUserServicesa.init();
    String token = await localUserServicesa.getLoggedToken();
    String refreshToken = await localUserServicesa.getRefreshToken();
    print('Time :' + DateTime.now().toString() + ' Request[=> PATH:${options.path}] data :${options.data}');
  // print('Time :' + DateTime.now().toString() + options.headers.toString());
   print('Time :' + DateTime.now().toString() + "Refresh token : "+refreshToken.toString());
    if (token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    } else {
      await localBazalar.claerBaseUrl();
      Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    print('Time :' + DateTime.now().toString() + ' Responce[${response.statusCode}] => PATH: ${response.requestOptions.path.toString()}' + " result :" + response.data.toString());
    if (response.statusCode == 404) {
      Get.offAllNamed(RouteHelper.getMobileLisanceScreen());
    }
    else if(response.data!=null){
      if (response.data['Exception'] != null) {
      ModelExceptions model = ModelExceptions.fromJson(response.data['Exception']);
      if (model.code == "006") {
        int statusrefresh = await refreshAccessToken();
        if (statusrefresh == 200) {
          return handler.resolve(await _retry(response.requestOptions));
        }
      }
    }
    else {
      if (mustShowResult) {
        Get.back();
        Get.dialog(ShowInfoDialog(
          color: Colors.blue,
          icon: Icons.verified,
          messaje: response.data['Result'].toString()??response.toString(),
          callback: () {
            Get.back();
          },
        ));
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    }}
    super.onResponse(response, handler);
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
    int succes = 0;
    LocalUserServices localUserServices = LocalUserServices();
    await localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    String refreshToken = await localUserServices.getRefreshToken();
    String accesToken = await localUserServices.getLoggedToken();
    String languageIndex = await getLanguageIndex();
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
          "${AppConstands.baseUrlsMain}/v1/LoginController/RefreshToken?oldRefreshToken=$refreshToken",
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': 1,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          TokenModel model = TokenModel.fromJson(response.data['Result']);
          loggedUserModel.tokenModel = model;
          await localUserServices.addUserToLocalDB(loggedUserModel).whenComplete(() => succes = 200);
        } else {
          succes = response.statusCode ?? 0;
        }
      } on DioException {
        // Handle the exception here if needed
      }
    }
    return succes;
  }

  Future<void> _sistemiYenidenBaslat() async {
    Get.delete<DrawerMenuController>();
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
        code: json["Code"],
        message: json["Message"],
        level: json["Level"].toString(),
        validationMessage: json["ValidationMessage"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "level": level,
        "validationMessage": validationMessage,
      };
}
