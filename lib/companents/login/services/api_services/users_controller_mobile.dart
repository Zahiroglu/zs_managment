
import 'package:android_id/android_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
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
import '../../../../dio_config/custim_interceptor.dart';
import '../../../local_bazalar/local_db_downloads.dart';
import '../../../notifications/firebase_notificatins.dart';
import '../../register/model_lisance.dart';

class UserApiControllerMobile extends GetxController {
  Dio dio = Dio();
  RxBool isLoading = true.obs;
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
    super.onInit();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Future<void> initPlatformState() async {
    deviceIdMustvisible.value = false;
    try {
      dviceId.value = (await _androidIdPlugin.getId())!;
    } on PlatformException {
      dviceId.value = 'Failed to get deviceId.';
    }
    if (dviceId.value.isNotEmpty) {
        isLoading.value=true;
        loginWithMobileDviceId(AppConstands.baseUrlsMain);
    } else {
      Get.dialog(ShowInfoDialog(
        messaje: "Xeta bas verdi",
        icon: Icons.error_outline,
        callback: () {
          initPlatformState();
        },
      ));
    }
  }



  void clouseApp() {
    Get.delete<DrawerMenuController>();
    Get.reset(clearRouteBindings: true); SystemNavigator.pop();
  }


  Future<void> loginWithMobileDviceId(String baseUrl) async {
    final info = await PackageInfo.fromPlatform();
    languageIndex = await getLanguageIndex();
    print("info.buildNumber : "+info.buildNumber.toString());
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          isLoading.value=false;
          update();
        },
      ));
    }
    else {
      try {
        final response = await dio.post(
          "${AppConstands.baseUrlsMain}/v1/LoginController/LoginWithDeviceId",
          data: {
              "mobileAppVersion":"${info.version}+${info.buildNumber}",
              "deviceId":  dviceId.value,
              "firebaseId": await fireTokenServiz.getFireToken(),
              "macAddress": "string"

          },
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': checkDviceType.getDviceType(),
              'smr': '12345'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        if (response.statusCode == 404) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {
              isLoading.value=false;
              update();
            },
          ));
        } else {
          if (response.statusCode == 200) {
            if(response.data['Code']==201){
              LicenseModel lisaceModel = LicenseModel.fromJson(response.data['Result']['Result']);
              Get.offNamed(RouteHelper.registerByUser,arguments: [lisaceModel,dviceId.value]);
            }
            else if(response.data['Code']==202){
              var xeta = response.data['Result'];
              Get.offNamed(RouteHelper.appNewVersion,arguments: [xeta]);
            }
            else {
              LoggedUserModel modelLogged = LoggedUserModel.fromJson(response.data['Result']);
              await localUserServices.init();
              await localUserServices.addUserToLocalDB(modelLogged);
              if (await checkUsersDownloads(modelLogged.userModel!.roleId)) {
                Future.delayed(const Duration(milliseconds: 20), () {Get.offNamed(RouteHelper.bazaDownloadMobile, arguments: [true,true])!.whenComplete((){
                  isLoading.value=false;
                  update();
                });
                });
              } else {
                Future.delayed(const Duration(milliseconds: 20), () {
                  Get.offNamed(RouteHelper.mobileMainScreen, arguments: modelLogged)!.whenComplete((){
                    isLoading.value=false;
                    update();
                  });
                });
              }
            }
          } else {
            if(response.data['Exception']!=null){
              ModelExceptions model = ModelExceptions.fromJson(response.data['Exception']);
              Get.dialog(ShowInfoDialog(
                icon: Icons.error_outline,
                messaje: model.message.toString(),
                callback: () {
                  isLoading.value=false;
                  update();
                },
              ));
              basVerenXeta= model.message.toString();
              deviceIdMustvisible.value=true;
            }else{
              isLoading.value=false;
              update();
            }

          }
        }
      } on DioException catch (e) {
        if (e.response != null) {
        } else {
          // Something happened in setting up or sending the request that triggered an Error
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message??"Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
        isLoading.value=false;
        update();
      }
    }
  }



  Future<bool> loginWithMobileDviceIdForDrawerItems(String languageCode) async {
    DialogHelper.showLoading("Dil deyisdirilir...");
    bool isSucces = false;
    await localUserServices.init();
    LoggedUserModel loggedUserModel=localUserServices.getLoggedUser();
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
        final response = await ApiClient().dio(true).post(
          "${AppConstands.baseUrlsMain}/v1/LoginController/LoginWithDeviceId",
          data: {
            "deviceId":  loggedUserModel.userModel!.deviceId!,
            "firebaseId": "string",
            "macAddress": "string"

          },
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': checkDviceType.getDviceType(),
              'smr': '12345'
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 200) {
          LoggedUserModel modelLogged = LoggedUserModel.fromJson(response.data['Result']);
          await localUserServices.init();
          await localUserServices.addUserToLocalDB(modelLogged);
          DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
          SettingPanelController settingcontroller = Get.put(SettingPanelController());
          await settingcontroller.getCurrentLoggedUserFromLocale(modelLogged.userModel);
          drawerMenuController.addPermisionsInDrawerMenu(modelLogged);
          isSucces = true;
          DialogHelper.hideLoading();
        }else{
          isSucces = false;
          DialogHelper.hideLoading();
        }
      } on DioException {
        DialogHelper.hideLoading();
      }
    }
    return isSucces;
  }

  Future<bool> checkUsersDownloads(int? roleId) async{
    await localBaseDownloads.init();
    return  localBaseDownloads.checkIfUserMustDonwloadsBaseFirstTime(roleId);
  }



}
