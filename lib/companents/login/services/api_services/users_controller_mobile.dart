import 'dart:convert';

import 'package:android_id/android_id.dart';
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

class UserApiControllerMobile extends GetxController {
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
  FirebaseNotyficationController fireTokenServiz=FirebaseNotyficationController();
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
      String val=await localUserServices.getCanGetBaseUrl();
      if(val=="Bos"){
        getCompanyUrlByDivaceId();
      }else{
        changeLoading();
        loginWithMobileDviceId(val);

      }

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

  Future<void> getCompanyUrlByDivaceId() async {
    changeLoading();
    languageIndex = await getLanguageIndex();
    dviceType = checkDviceType.getDviceType();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
      changeLoading();
    } else {
      try {
        final response = await dio.post(
          "${AppConstands.baseUrlsMain}v1/User/serviceurl-by-device",
          data: {"deviceId": dviceId.value, "macAddress": "123-123-123-123"},
          options: Options(
            // receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '1234589'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        print("Request url:"+response.requestOptions.headers.toString());
        print("Request:"+response.data.toString());
        if (response.statusCode == 404) {
          changeLoading();
          basVerenXeta = "baglantierror".tr;
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {
              changeLoading();
            },
          ));
        }
        else {
          if (response.statusCode == 200) {
            String baseUrl=response.data['result'];
            await localUserServices.addCanGetBaseUrl(baseUrl);
            loginWithMobileDviceId(baseUrl);
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            basVerenXeta = baseResponce.exception!.message!;
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {
                changeLoading();
              },
            ));
            if (baseResponce.code == 400) {
              deviceIdMustvisible.value = true;

            }
          }
        }
      } on DioException catch (e) {
        changeLoading();
        if (e.response != null) {
        } else {}
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "baglantierror".tr,
          callback: () {
            changeLoading();
          },
        ));
      }
    }
  }


  Future<void> loginWithMobileDviceId(String baseUrl) async {
    print("baseUrl :"+baseUrl.toString());
    languageIndex = await getLanguageIndex();
    dviceType = checkDviceType.getDviceType();
    var data={
    "deviceId": dviceId.value,
    "firebaseId": await fireTokenServiz.getFireToken(),
    "macAddress": "123-123-123-123"
    };
    print("Data :"+data.toString());
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          changeLoading();
        },
      ));
    } else {
      try {
        final response = await dio.post(
          "$baseUrl/api/v1/User/login-with-deviceid", data:data,
          options: Options(
            // receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        print("request:"+response.requestOptions.headers.toString());
        print("responce:"+response.data.toString());
        if (response.statusCode == 404) {
          basVerenXeta = "baglantierror".tr;
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {
              changeLoading();
            },
          ));
        } else {
          if (response.statusCode == 200) {
            TokenModel modelToken = TokenModel.fromJson(response.data['result']);
            getLoggedUserInfo(modelToken,baseUrl);
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            basVerenXeta = baseResponce.exception!.message!;
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {
                changeLoading();
              },
            ));
            if (baseResponce.code == 400) {
              deviceIdMustvisible.value = true;

            }
          }
        }
      } on DioException catch (e) {
        if (e.response != null) {
          changeLoading();
        } else {
          changeLoading();
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {
            changeLoading();
          },
        ));
      }
    }
  }

  Future<void> getLoggedUserInfo(TokenModel modelToken, String baseUrl) async {
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
      changeLoading();
    } else {
      try {
        final response = await dio.get(
          "$baseUrl/api/v1/User/myinfo",
          options: Options(
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer ${modelToken.accessToken}"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        print("Request responce My USER INFO:" + response.data.toString());
        if (response.statusCode == 404) {
          changeLoading();
          basVerenXeta = "baglantierror".tr;
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {

          if (response.statusCode == 200) {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
            CompanyModel modelCompany = CompanyModel.fromJson(baseResponce.result['company']);
            LoggedUserModel modelLogged = LoggedUserModel(
              baseUrl: baseUrl,
                isLogged: true,
                companyModel: modelCompany,
                tokenModel: modelToken,
                userModel: modelUser);
            await getCompanyConfig(modelLogged);
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            basVerenXeta = baseResponce.exception!.message!;
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {
                changeLoading();
              },
            ));
          }
        }
      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "baglantierror".tr,
          callback: () {
            changeLoading();
          },
        ));
      }
    }
  }

  Future<void> getCompanyConfig(LoggedUserModel modelLogged) async {
    List<ModelConfigrations> listConfig=[];
    languageIndex = await getLanguageIndex();
    var data={
      "dictionaryTypes": [
        "Configurations"
      ]
    };
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
      changeLoading();
    } else {
      try {
        final response = await dio.post(
          "${modelLogged.baseUrl!}/api/v1/Dictionary",
          data: data,
          options: Options(
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer ${modelLogged.tokenModel!.accessToken}"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 404) {
          changeLoading();
          basVerenXeta = "baglantierror".tr;
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {

          if (response.statusCode == 200) {
            var listConfigs = json.encode(response.data['result']['Configurations']);
            print("listConfigs :"+listConfigs.toString());
            List list = jsonDecode(listConfigs);
            for(var i in list){
              ModelConfigrations model=ModelConfigrations.fromJson(i);
              listConfig.add(model);
            }
            modelLogged.companyConfigModel=listConfig;
            localUserServices.init();
            localUserServices.addUserToLocalDB(modelLogged);
            if (await checkUsersDownloads(modelLogged.userModel!.roleId)) {
              Future.delayed(const Duration(milliseconds: 20), () {Get.offNamed(RouteHelper.bazaDownloadMobile, arguments: [true,true]);
              });
            } else {
              Future.delayed(const Duration(milliseconds: 20), () {Get.offNamed(RouteHelper.mobileMainScreen, arguments: modelLogged);
              });
            }
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            basVerenXeta = baseResponce.exception!.message!;
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {
                changeLoading();
              },
            ));
          }
        }
      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "baglantierror".tr,
          callback: () {
            changeLoading();
          },
        ));
      }
    }
  }

  Future<bool> loginWithMobileDviceIdForDrawerItems(String languageCode) async {
    DialogHelper.showLoading("Dil deyisdirilir...");
    bool isSucces = false;
    await localUserServices.init();
    LoggedUserModel loggedUserModel=await localUserServices.getLoggedUser();
    dviceType = checkDviceType.getDviceType();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          DialogHelper.hideLoading();
          isSucces = false;
        },
      ));
      basVerenXeta = "internetError".tr;
      return false;
    } else {
      try {
        final response = await ApiClient().dio(false).get(
              "${loggedUserModel.baseUrl}/api/v1/User/myinfo",
              data: {
                "deviceId": dviceId.value,
                "macAddress": "123-123-123-123"
              },
              options: Options(
                headers: {
                  'Lang': languageCode,
                  'Device': dviceType,
                  'abs': '123456',
                  "Authorization": "Bearer ${loggedUserModel.tokenModel!.accessToken}"
                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );
        if (response.statusCode == 200) {
          BaseResponce baseResponce = BaseResponce.fromJson(response.data);
          UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
          CompanyModel modelCompany = CompanyModel.fromJson(baseResponce.result['company']);
          LoggedUserModel modelLogged = LoggedUserModel(
              isLogged: true,
              companyModel: modelCompany,
              tokenModel:  loggedUserModel.tokenModel,
              baseUrl: loggedUserModel.baseUrl,
              userModel: modelUser);
          await localUserServices.addUserToLocalDB(modelLogged);
          //await Get.delete<DrawerMenuController>();
          //await Get.delete<SettingPanelController>();
          DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
          SettingPanelController settingcontroller = Get.put(SettingPanelController());
          await settingcontroller.getCurrentLoggedUserFromLocale(modelUser);
          await drawerMenuController.addPermisionsInDrawerMenu(modelLogged);
          isSucces = true;
          DialogHelper.hideLoading();
        }
      } on DioException catch (e) {
      }
    }
    return isSucces;
  }

  Future<bool> checkUsersDownloads(int? roleId) async{
    await localBaseDownloads.init();
    return  localBaseDownloads.checkIfUserMustDonwloadsBaseFirstTime(roleId);
  }



}
