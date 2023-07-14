import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:zs_managment/app_companents/location_service/location_controller.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/models/model_company.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/login/service/dio_inspector.dart';
import 'package:zs_managment/login/service/models/base_responce.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../customwidgets/simple_dialog.dart';

class UsersApiController extends GetxController {
  TextEditingController ctUsername = TextEditingController();
  TextEditingController ctPassword = TextEditingController();
  SharedManager sharedManager = SharedManager();
  Dio dio = Dio();
  RxBool isLoading = false.obs;
  String baseEndpoint="https://ceea-62-212-234-9.ngrok-free.app/api/";


  @override
  void onClose() {
    ctPassword.dispose();
    ctUsername.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() async {
    await sharedManager.init();
    dio=Dio(BaseOptions(baseUrl:baseEndpoint,followRedirects: false))..interceptors.add(DioInspector());
    super.onInit();
  }

  void chengeLoading() {
    isLoading.toggle();
    print("Isloading :" + isLoading.toString());
    update();
  }

  Future<void> loginWithUsername(int dviceTipe, int languageIndex) async {
    chengeLoading();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {},
      ));
      chengeLoading();
    } else {
      LoggedUserModel modelLogged=LoggedUserModel().getLoggedUserModel();
      sharedManager.saveUser("keyUser", modelLogged);
            Get.offNamed(RouteHelper.mainScreenWidows,arguments: modelLogged);
            chengeLoading();
      // try {
      //   final response = await dio.post(
      //    "${baseEndpoint}v1/User/login-with-username",
      //     data: {'username': 'abas_jafar', 'password': 'abas123'},
      //   //  data: {'username': ctUsername.text, 'password': ctPassword.text},
      //     options: Options(
      //       // receiveTimeout: const Duration(seconds: 60),
      //       headers: {
      //         'Lang': languageIndex,
      //         'Device': dviceTipe,
      //         'abs': '123456'
      //       },
      //       validateStatus: (_) => true,
      //       contentType: Headers.jsonContentType,
      //       responseType: ResponseType.json,
      //     ),
      //   );
      //   if(response.statusCode==404){
      //     chengeLoading();
      //     Get.dialog(ShowInfoDialog(
      //       icon: Icons.error,
      //       messaje: "error:404.Sistem muveqqeti olaraq islemir",
      //       callback: () {},
      //     ));
      //   }else {
      //     BaseResponce baseResponce = BaseResponce.fromJson(response.data);
      //     print("Base responce :"+baseResponce.toString());
      //     if (response.statusCode == 200) {
      //       TokenModel modelToken = TokenModel.fromJson(baseResponce.result['token']);
      //       UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
      //       CompanyModel modelCompany = CompanyModel.fromJson(baseResponce.result['company']);
      //       LoggedUserModel modelLogged = LoggedUserModel(isLogged: true, companyModel: modelCompany, tokenModel: modelToken, userModel: modelUser);
      //       sharedManager.saveUser("keyUser", modelLogged);
      //       Get.offNamed(RouteHelper.mainScreenWidows,arguments: modelLogged);
      //       chengeLoading();
      //     } else {
      //       Get.dialog(ShowInfoDialog(
      //         icon: Icons.error_outline,
      //         messaje: baseResponce.exception!.message.toString(),
      //         callback: () {},
      //       ));
      //       chengeLoading();
      //     }
      //   }} on DioError catch (e) {
      //   Get.dialog(ShowInfoDialog(
      //     icon: Icons.error_outline,
      //     messaje: e.message!,
      //     callback: () {},
      //   ));
      // }
    }
  }

  Future<BaseResponce> LoginWithMobileDviceId(int dviceTipe, int languageIndex, String dviceId) async {
    BaseResponce baseResponce = BaseResponce();
    chengeLoading();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          chengeLoading();
        },
      ));
      baseResponce = BaseResponce(
          exception: Exception(message: "Internet baglanti problemi"));
    } else {
      try {
        // final response = await dio.post(
        //   'https://def4-62-212-234-9.ngrok-free.app/api/v1/User/login-with-deviceid',
        //   data: {'deviceId': 'abas_jafar', 'macAddress': 'abas123'},
        //   //data: {'username': ctUsername.text, 'password': ctPassword.text},
        //   options: Options(
        //     receiveDataWhenStatusError: true,
        //     receiveTimeout: const Duration(seconds: 60), //
        //     headers: {
        //       'Lang': languageIndex,
        //       'Device': dviceTipe,
        //       'abs': '123456'
        //     },
        //     validateStatus: (_) => true,
        //     contentType: Headers.jsonContentType,
        //     responseType: ResponseType.json,
        //
        //   ),
        // );
        final response = await dio.post(
          'https://def4-62-212-234-9.ngrok-free.app/api/v1/User/login-with-username/',
          data: {'username': 'abas_jafar', 'password': 'abas123'},
          // data: {'username': ctUsername.text, 'password': ctPassword.text},
          options: Options(
            // receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceTipe,
              'abs': '123456'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        baseResponce = BaseResponce.fromJson(response.data);
        if (baseResponce.code == 200) {
          TokenModel modelToken =
              TokenModel.fromJson(baseResponce.result['token']);
          UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
          CompanyModel modelCompany =
              CompanyModel.fromJson(baseResponce.result['user']);
          LoggedUserModel modelLogged = LoggedUserModel(
              isLogged: true,
              companyModel: modelCompany,
              tokenModel: modelToken,
              userModel: modelUser);
          sharedManager.saveUser("keyUser", modelLogged);
          Get.offNamed(RouteHelper.mainScreenMobile, arguments: modelLogged);
        } else {
          print("Base respince :" + baseResponce.toString());
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: baseResponce.exception!.message.toString(),
            callback: () {
              chengeLoading();
            },
          ));
        }
        return baseResponce;
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              chengeLoading();
            },
          ));
          baseResponce = BaseResponce(
              exception:
                  Exception(message: "Baglanti xetasi var.Sonra cehd edin"));
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              chengeLoading();
            },
          ));
          baseResponce = BaseResponce(exception: Exception(message: e.message));
          chengeLoading();
        }
      }
    }
    return baseResponce;
  }

  Future<List<UserModel>> getAllUsers(int dviceTipe, int languageIndex, String dviceId) async {
    // TokenModel modelToken=await sharedManager.getTokens();
    // String accesToken=modelToken.accessToken!;
    List<UserModel> listUsers = [];
    chengeLoading();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {},
      ));
      chengeLoading();
    } else {
      for(LoggedUserModel model in LoggedUserModel().getLoggedUsers()){
        listUsers.add(model.userModel!);
      }
      chengeLoading();
      // try {
      //   final response = await dio.get(
      //     "${baseEndpoint}v1/User",
      //     options: Options(headers: {
      //         'Lang': languageIndex,
      //         'Device': dviceTipe,
      //         'abs': '123456',
      //         "Authorization":"Bearer $accesToken"
      //       },
      //       validateStatus: (_) => true,
      //       contentType: Headers.jsonContentType,
      //       responseType: ResponseType.json,
      //     ),
      //   );
      //
      //   if(response.statusCode==404){
      //     chengeLoading();
      //     Get.dialog(ShowInfoDialog(
      //       icon: Icons.error,
      //       messaje: "error:404.Sistem muveqqeti olaraq islemir",
      //       callback: () {},
      //     ));
      //   }else {
      //     BaseResponce baseResponce = BaseResponce.fromJson(response.data);
      //     if (response.statusCode == 200) {
      //       List istifadeciler=baseResponce.result;
      //       listUsers= istifadeciler.map((m) => UserModel.fromJson(m)).toList();
      //     //  List responseJson = json.decode(response.data);
      //
      //       chengeLoading();
      //     } else {
      //       Get.dialog(ShowInfoDialog(
      //         icon: Icons.error_outline,
      //         messaje: baseResponce.exception!.message.toString(),
      //         callback: () {},
      //       ));
      //       chengeLoading();
      //     }
      //   }} on DioError catch (e) {
      //   if (e.type == DioErrorType.connectionTimeout) {
      //     Get.dialog(ShowInfoDialog(
      //       icon: Icons.error_outline,
      //       messaje: e.message!,
      //       callback: () {
      //         chengeLoading();
      //       },
      //     ));
      //   } else {
      //     Get.dialog(ShowInfoDialog(
      //       icon: Icons.error_outline,
      //       messaje: e.toString(),
      //       callback: () {
      //         chengeLoading();
      //       },
      //     ));
      //     chengeLoading();
      //   }
      // }
    }
    return listUsers;
  }

  Future<BaseResponce> sendUserLocationToServer(int dviceTipe, int languageIndex, Position? posinitial) async {
    LoggedUserModel model = await sharedManager.getLoggedUser();
    String datetime=DateTime.now().toIso8601String();
    BaseResponce baseResponce = BaseResponce();
    chengeLoading();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          chengeLoading();
        },
      ));
      baseResponce = BaseResponce(
          exception: Exception(message: "Internet baglanti problemi"));
    } else {
      try {
        final response = await dio.post(
          'https://def4-62-212-234-9.ngrok-free.app/api/v1/User/add-user-location',
          data:{
            "userCode": model.userModel!.code.toString(),
            "roleId": model.userModel!.roleId,
            "latitude": posinitial!.latitude.toString(),
            "longitude": posinitial.longitude.toString(),
            "lastSendTime": datetime
          },
          // data: {'username': ctUsername.text, 'password': ctPassword.text},
          options: Options(
            // receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceTipe,
              'abs': '123456'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        baseResponce = BaseResponce.fromJson(response.data);
        if (baseResponce.code == 200) {
          print("baseResponce:"+baseResponce.result.toString());
        } else {
          print("Base respince :" + baseResponce.toString());
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: baseResponce.exception!.message.toString(),
            callback: () {
              chengeLoading();
            },
          ));
        }
        return baseResponce;
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              chengeLoading();
            },
          ));
          baseResponce = BaseResponce(
              exception:
                  Exception(message: "Baglanti xetasi var.Sonra cehd edin"));
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              chengeLoading();
            },
          ));
          baseResponce = BaseResponce(exception: Exception(message: e.message));
          chengeLoading();
        }
      }
    }
    return baseResponce;
  }

  Future<BaseResponce> getUsersLocationFromBase() async {
    BaseResponce baseResponce = BaseResponce();
    chengeLoading();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          chengeLoading();
        },
      ));
      baseResponce = BaseResponce(
          exception: Exception(message: "Internet baglanti problemi"));
    } else {
      try {
        final response = await dio.get(
          'https://def4-62-212-234-9.ngrok-free.app/api/v1/User/user-locations',
          // data: {'username': ctUsername.text, 'password': ctPassword.text},
          options: Options(
            // receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': 0,
              'Device': 0,
              'abs': '123456'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        baseResponce = BaseResponce.fromJson(response.data);
        print("baseResponce:"+baseResponce.result.toString());
        if (baseResponce.code == 200) {
          chengeLoading();
          print("baseResponce:"+baseResponce.result.toString());
          return baseResponce;
        } else {
          chengeLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: baseResponce.exception!.message.toString(),
            callback: () {
              chengeLoading();
            },
          ));
        }
        return baseResponce;
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              chengeLoading();
            },
          ));
          baseResponce = BaseResponce(
              exception:
                  Exception(message: "Baglanti xetasi var.Sonra cehd edin"));
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              chengeLoading();
            },
          ));
          baseResponce = BaseResponce(exception: Exception(message: e.message));
          chengeLoading();
        }
      }
    }
    return baseResponce;
  }


}
