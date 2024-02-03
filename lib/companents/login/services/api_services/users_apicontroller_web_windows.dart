import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class UsersApiController extends GetxController {
  TextEditingController ctUsername = TextEditingController();
  TextEditingController ctPassword = TextEditingController();
  Dio dio = Dio();
  RxBool isLoading = false.obs;
  int dviceType = 0;
  CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();

  String languageIndex = "az";

  @override
  void onClose() {
    ctPassword.dispose();
    ctUsername.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() async {
    dviceType = checkDviceType.getDviceType();
    localUserServices.init();
    super.onInit();
  }


  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void changeLoading() {
    isLoading.toggle();
    update();
  }


  Future<void> getCompanyUrlByDivaceId() async {
    changeLoading();
    int compId=1;
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
      changeLoading();
    }
    else {
      try {
        final response = await dio.post(
          "${AppConstands.baseUrlsMain}v1/User/serviceurl-by-username/$compId",
          data: {'username':ctUsername.text, 'password': ctPassword.text},
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
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
        print("Request :"+response.requestOptions.path);
        print("request data :"+response.requestOptions.data.toString());
        print("responce data :"+response.data.toString());
        if (response.statusCode == 404) {
          changeLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {
          if (response.statusCode == 200) {
            String baseUrl=response.data['result'];
            loginWithUsername(baseUrl);


          } else {
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: response.data!.toString(),
              callback: () {},
            ));
            changeLoading();
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
        print(e.message);
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message??"Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
        changeLoading();
      }
    }
  }

  Future<void> loginWithUsername(String baseUrl) async {
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
      changeLoading();
    }
    else {
      try {
        final response = await dio.post(
          "$baseUrl/api/v1/User/login-with-username",
          data: {'username': ctUsername.text, 'password': ctPassword.text},
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
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
        print("login-with-username :"+response.requestOptions.path.toString());
        print("login-with-username :"+response.data.toString());

        if (response.statusCode == 404) {
          changeLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {
          if (response.statusCode == 200) {
           TokenModel modelToken = TokenModel.fromJson(response.data['result']);
           getLoggedUserInfo(modelToken,baseUrl);

          } else {
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: response.data!.toString(),
              callback: () {},
            ));
            changeLoading();
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
        print(e.message);
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message??"Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
        changeLoading();
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
    }
    else {
      try {
        final response = await dio.get(
          "$baseUrl/api/v1/User/myinfo",
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
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
        print('REQUEST[${response.requestOptions.method}] => PATH: ${response.requestOptions.path}'+" req header :"+response.requestOptions.headers.toString()+" data :"+response.requestOptions.data.toString());
        print("responce :"+response.data.toString());
        if (response.statusCode == 404) {
          changeLoading();
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
                isLogged: true,
                baseUrl: baseUrl,
                companyModel: modelCompany,
                tokenModel: modelToken,
                userModel: modelUser);
            print("Login Screen header:"+response.requestOptions.headers.toString());
            print("Login screen modelLogged:"+modelLogged.userModel!.permissions.toString());
            localUserServices.addUserToLocalDB(modelLogged);
            Future.delayed(const Duration(seconds: 1), () {
              Get.offNamed(RouteHelper.windosMainScreen,arguments: modelLogged);
              changeLoading();
            });
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje:baseResponce.exception!.message.toString(),
              callback: () {},
            ));
            changeLoading();
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
          messaje: e.message??"Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
        changeLoading();
      }
    }
  }

  Future<bool> getLoggedUserInfoForDrowers(TokenModel modelToken,String selectedLanguage) async {
    DialogHelper.showLoading("Dil deyisdirilir...");
    bool isSucces=false;
   // languageIndex = await getLanguageIndex();
    dviceType = checkDviceType.getDviceType();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
      DialogHelper.hideLoading();
    }
    else {
      try {

        final response = await ApiClient().dio().get(
          "${loggedUserModel.baseUrl}/api/v1/User/myinfo",
          options: Options(
            headers: {
              'Lang': selectedLanguage,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer ${modelToken.accessToken}"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        if (response.statusCode == 404) {
          DialogHelper.hideLoading();
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
            LoggedUserModel modelLogged = LoggedUserModel(isLogged: true, companyModel: modelCompany, tokenModel: modelToken, userModel: modelUser);
            localUserServices.addUserToLocalDB(modelLogged);
            DrawerMenuController drawerMenuController=Get.put(DrawerMenuController());
            drawerMenuController.addPermisionsInDrawerMenu(modelLogged);
            isSucces=true;
            DialogHelper.hideLoading();
          } else {
            DialogHelper.hideLoading();
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje:baseResponce.exception!.message.toString(),
              callback: () {},
            ));
          }
        }
      } on DioException catch (e) {
        if (e.response != null) {
          DialogHelper.hideLoading();
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
          messaje: e.message??"Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
        DialogHelper.hideLoading();
      }
    }
    return isSucces;
  }

  Future<bool> loginWithUsernameForCheck() async {
    changeLoading();
    bool isSucces = false;
    languageIndex = await getLanguageIndex();
    dviceType = checkDviceType.getDviceType();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          isSucces = false;
        },
      ));
      changeLoading();
    } else {
      try {
        showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          barrierColor: Colors.white.withOpacity(0.5),
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color:Colors.green,
                ),
              ),
            ),
          ),
        );
        final response = await dio.post(
          "${loggedUserModel.baseUrl}/api/v1/User/login-with-username",
          data: {'username': "abas_jafar", 'password': "abas123"},
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
        if (response.statusCode == 404) {
          changeLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {
              isSucces = false;

            },
          ));
        } else {
          if (response.statusCode == 200) {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            TokenModel modelToken = TokenModel.fromJson(baseResponce.result['token']);
            UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
            CompanyModel modelCompany = CompanyModel.fromJson(baseResponce.result['company']);
            LoggedUserModel modelLogged = LoggedUserModel(
                isLogged: true,
                companyModel: modelCompany,
                tokenModel: modelToken,
                userModel: modelUser);
            localUserServices.addUserToLocalDB(modelLogged);


            print("Gelen User Model :"+modelLogged.userModel.toString());
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: "Dil ugula deyisdirildi",
              callback: () {
              },
            ));
            isSucces = true;
            Get.offNamed(RouteHelper.getWellComeScreen());
            Get.forceAppUpdate();
            //Get.appUpdate();
            changeLoading();
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {
                isSucces = false;
              },
            ));
            changeLoading();
          }
        }
      } on DioError catch (e) {
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message!,
          callback: () {
            isSucces = false;
          },
        ));
      }
    }
   print("IsSucees :"+isSucces.toString());
    return isSucces;
  }

}
