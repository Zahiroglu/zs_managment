import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as intl;
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
//import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../giris_cixis/models/model_request_inout.dart';
import '../giris_cixis/sceens/reklam_girisCixis/controller_giriscixis_reklam.dart';
import '../rut_gostericileri/mercendaizer/data_models/model_mercbaza.dart';
import 'model_main_inout.dart';

class ControllerRoutDetailUser extends GetxController {
  LocalUserServices userService = LocalUserServices();
  LocalAppSetting appSetting = LocalAppSetting();
  LocalBaseDownloads localBaseDownloads=LocalBaseDownloads();
  late Rx<AvailableMap> availableMap = AvailableMap(
      mapName: CustomMapType.google.name,
      mapType: MapType.google,
      icon:
      'packages/map_launcher/assets/icons/${CustomMapType.google}.svg').obs;
  late Rx<UserModel> selectedUser = UserModel().obs;
  RxList<UserModel> listUsers = List<UserModel>.empty(growable: true).obs;
  RxList<UserModel> filteredListUsers = List<UserModel>.empty(growable: true).obs;
  RxList<ModelCariler> listSelectedCustomers = List<ModelCariler>.empty(growable: true).obs;
  RxList<MercCustomersDatail> listSelectedMercBaza = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<ModelCariler> listFilteredCustomers = List<ModelCariler>.empty(growable: true).obs;
  RxList<ModelMercBaza> listFilteredMercBaza = List<ModelMercBaza>.empty(growable: true).obs;
  RxList<ModelMainInOut> listGirisCixis = List<ModelMainInOut>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  TextEditingController ctTemsilciKodu = TextEditingController();
  String soapadress = "http://193.105.123.215:9689/WebService1.asmx";
  String soaphost = "193.105.123.215";
  RxList<ModelSifarislerTablesi> listTabSifarisler = List<ModelSifarislerTablesi>.empty(growable: true).obs;
  late Rx<ModelSifarislerTablesi> selectedTab = ModelSifarislerTablesi().obs;
  RxBool routDataLoading = true.obs;
  RxString fistTabSelected = "Exp".obs;
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler=ExeptionHandler();

  @override
  void onInit() {
    getAllUsers();
    super.onInit();
  }


  @override
  void dispose() {
    Get.delete<ControllerRoutDetailUser>;
    super.dispose();
  }

  Future<void> getAllUsers() async {
    await localBaseDownloads.init();
    dataLoading.value = true;
    listUsers.value=localBaseDownloads.getAllConnectedUserFromLocal();
    listUsers.add(UserModel(
      code: "174",
      name: "Test MERC",
      roleId: 23,
      gender: 0,
      roleName: "Mercendaizer"
    ));
    if(listUsers.isEmpty){
      listUsers.value = [
        UserModel(
            roleName: "Expeditor",
            roleId: 17,
            username: "Asif Memmedov",
            code: "112",
            gender: 0),
        UserModel(
            roleName: "Expeditor",
            roleId: 17,
            username: "Zaur Eliyev",
            code: "132",
            gender: 0),
        UserModel(
            roleName: "Expeditor-Mercendaizer",
            roleId: 17,
            username: "Arzu Haciyeva",
            code: "142",
            gender: 1),
        UserModel(
            roleName: "Expeditor",
            roleId: 17,
            username: "Eli Qasimov",
            code: "31",
            gender: 0),
        UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            username: "Zuleyxa Kerimova",
            code: "A1",
            gender: 1),
        UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            username: "Nazile Qasimli",
            code: "A2",
            gender: 1),
        UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            username: "Aysu Qemberova",
            code: "B2",
            gender: 1),
        UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            username: "Qaragoz Afdandilova",
            code: "B2",
            gender: 1),
        UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            username: "Qafuq Memmedob",
            code: "MIN01",
            gender: 0),
      ];}
    filteredListUsers.value = listUsers.where((p0) => p0.roleId == 17).toList();
    dataLoading.value = false;
    update();
  }


  void createDialogTogetExpCode(BuildContext context) {
    Get.dialog(_widgetDialogExpCode(context), barrierDismissible: false);
  }

  Widget _widgetDialogExpCode(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery
                  .of(context)
                  .size
                  .height * 0.34,
              horizontal: MediaQuery
                  .of(context)
                  .size
                  .width * 0.1),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            labeltext: "Temsilci secimi",
                            fontsize: 18,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.all(8.0).copyWith(left: 20, right: 20),
                      child: CustomTextField(
                          obscureText: false,
                          updizayn: true,
                          align: TextAlign.center,
                          controller: ctTemsilciKodu,
                          inputType: TextInputType.text,
                          hindtext: "temsilciSec".tr,
                          fontsize: 14),
                    ),
                    CustomElevetedButton(
                      cllback: () {
                        Get.back();
                        temsilciMelumatlariniGetirElevetedButton(ctTemsilciKodu.text);
                        ctTemsilciKodu.clear();
                      },
                      label: "tesdiqle".tr,
                      fontWeight: FontWeight.w700,
                      borderColor: Colors.grey,
                      elevation: 5,
                      height: 30,
                      width: 200,
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                      ctTemsilciKodu.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> temsilciMelumatlariniGetirElevetedButton(String model) async {
    listSelectedCustomers.clear();
    listFilteredCustomers.clear();
    if (fistTabSelected.value == "Exp") {
      DialogHelper.showLoading("cmendirilir".tr);
      UserModel userModel=UserModel(roleId: 17,code: model,name: "tapilmadi".tr);
      listSelectedCustomers.value = await getAllCustomers(model);
      DialogHelper.hideLoading();
      if (listSelectedCustomers.isNotEmpty) {
        DialogHelper.showLoading("gcendirilir".tr);
        listGirisCixis.value=await getAllGirisCixis(model,"17");
        DialogHelper.hideLoading();
        tabMelumatlariYukle();
         changeSelectedTabItems(listTabSifarisler.first);
        print("Evvel listFilteredCustomers : "+listFilteredCustomers.length.toString());
        Get.toNamed(RouteHelper.screenExpRoutDetail, arguments: [this,userModel,listUsers]);
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "mtapilmadi".tr,
            icon: Icons.error,
            callback: () {
              Get.back();
            }));
      }
    //  tabMelumatlariYukle();
    } else {
      DialogHelper.showLoading("cmendirilir".tr);
      MercDataModel modela = await getAllCustomersMerc(model);
      DialogHelper.hideLoading();
      if (modela.user!=null) {
        DialogHelper.showLoading("gcendirilir".tr);
        listGirisCixis.value=await getAllGirisCixis(model,"23");
        DialogHelper.hideLoading();
        Get.toNamed(RouteHelper.screenMercRoutDatail, arguments: [listSelectedMercBaza,listGirisCixis,listUsers.where((p0) => p0.roleId==23).toList()]);
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "mtapilmadi".tr,
            icon: Icons.error,
            callback: () {
              Get.back();
            }));
      }
    }
  }

  Future<void> temsilciMelumatlariniGetir(UserModel model) async {
    selectedUser.value=model;
    listSelectedCustomers.clear();
    listFilteredCustomers.clear();
    if (fistTabSelected.value == "Exp") {
      DialogHelper.showLoading("cmendirilir".tr);
      listSelectedCustomers.value = await getAllCustomers(model.code!);
      DialogHelper.hideLoading();
      if (listSelectedCustomers.isNotEmpty) {
        DialogHelper.showLoading("gcendirilir".tr);
        await getAllGirisCixis(model.code!,model.roleId!.toString());
        DialogHelper.hideLoading();
        tabMelumatlariYukle();
        changeSelectedTabItems(listTabSifarisler.first);
        Get.toNamed(RouteHelper.screenExpRoutDetail, arguments: [this,model,listUsers.where((p0) => p0.roleId==23).toList()]);
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "mtapilmadi".tr,
            icon: Icons.error,
            callback: () {
              Get.back();
            }));
      }
      tabMelumatlariYukle();
    } else {
      DialogHelper.showLoading("cmendirilir".tr);
      MercDataModel modela = await getAllCustomersMerc(model.code!);
      DialogHelper.hideLoading();
      if (modela.user!=null) {
        DialogHelper.showLoading("gcendirilir".tr);
        List<ModelMainInOut> listGirisCixisa  = await getAllGirisCixis(model.code!,model.roleId!.toString());
        DialogHelper.hideLoading();
        Get.toNamed(RouteHelper.screenMercRoutDatail, arguments: [modela,listGirisCixisa,listUsers.where((p0) => p0.roleId==23).toList()]);
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "mtapilmadi".tr,
            icon: Icons.error,
            callback: () {
              Get.back();
              Get.back();
            }));
      }
    }
  }

  List<ModelCariler> createRandomOrdenNumber(List<ModelCariler> list) {
    List<ModelCariler> yeniList = [];
    List<ModelCariler> listBir = list.where((p) => p.days!=null?p.days!.any((element) => element.day==1):false).toList();
    List<ModelCariler> listIki =  list.where((p) => p.days!=null?p.days!.any((element) => element.day==2):false).toList();
    List<ModelCariler> listUc =  list.where((p) => p.days!=null?p.days!.any((element) => element.day==3):false).toList();
    List<ModelCariler> listDort =  list.where((p) => p.days!=null?p.days!.any((element) => element.day==4):false).toList();
    List<ModelCariler> listBes =  list.where((p) => p.days!=null?p.days!.any((element) => element.day==5):false).toList();
    List<ModelCariler> listAlti =  list.where((p) => p.days!=null?p.days!.any((element) => element.day==6):false).toList();
    yeniList.addAll(listBir);
    yeniList.addAll(listIki);
    yeniList.addAll(listUc);
    yeniList.addAll(listDort);
    yeniList.addAll(listBes);
    yeniList.addAll(listAlti);
    return yeniList;
  }

  void tabMelumatlariYukle() {
    listTabSifarisler.clear();
    listTabSifarisler.value = [
      ModelSifarislerTablesi(
          label: "Umumi cariler",
          summa: double.tryParse(listSelectedCustomers.length.toString()),
          type: "uc",
          color: Colors.blue),
      ModelSifarislerTablesi(
          label: "Passiv cariler",
          summa: double.tryParse(listSelectedCustomers
              .where((p) => p.action == false)
              .length
              .toString()),
          type: "pc",
          color: Colors.orange),
      ModelSifarislerTablesi(
          label: "Bagli cariler",
          summa: 0,
          // summa: double.tryParse(listSelectedCustomers
          //     .where((p) => p.days!.any((element) => element.day==7))
          //     .length
          //     .toString()),
          type: "bc",
          color: Colors.red),
      ModelSifarislerTablesi(
          label: "Rutsuz cariler",
          summa: listSelectedCustomers.any((element) => element.days!=null)?double.tryParse(listSelectedCustomers
              .where((p) =>
          !p.days!.any((element) => element.day==1)&&
              !p.days!.any((element) => element.day==2)&&
              !p.days!.any((element) => element.day==3)&&
              !p.days!.any((element) => element.day==4)&&
              !p.days!.any((element) => element.day==5)&&
              !p.days!.any((element) => element.day==6) &&
              !p.days!.any((element) => element.day==7))
              .length
              .toString()):0,
          type: "rc",
          color: Colors.deepPurple),
    ];
    update();
  }

  void changeSelectedTabItems(ModelSifarislerTablesi element) {
    routDataLoading.value = true;
    selectedTab.value = element;
    listFilteredCustomers.clear();
    switch (element.type) {
      case "uc":
        listSelectedCustomers.toList().forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
      case "pc":
        listSelectedCustomers
            .where((p) => p.action == false)
            .toList()
            .forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
      case "bc":
        listSelectedCustomers
            .where((p) => !p.days!.any((element) => element.day==7))
            .toList()
            .forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
      case "rc":
        listSelectedCustomers
            .where((p) =>
        !p.days!.any((element) => element.day==1)&&
            !p.days!.any((element) => element.day==2)&&
            !p.days!.any((element) => element.day==3)&&
            !p.days!.any((element) => element.day==4)&&
            !p.days!.any((element) => element.day==5)&&
            !p.days!.any((element) => element.day==6) &&
            !p.days!.any((element) => element.day==7))
            .toList()
            .forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
    }
    routDataLoading.value = false;
    update();
  }

  void changeUsers(String s) {
    if (s == "Exp") {
      filteredListUsers.value =
          listUsers.where((p0) => p0.roleId == 17).toList();
    } else {
      filteredListUsers.value =
          listUsers.where((p0) => p0.roleId ==23).toList();
    }
    update();
  }

  ///Cari Baza endirme/////////
  Future<List<ModelCariler>> getAllCustomers(String temKod) async {
    List<ModelCariler> listUsers=[];
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler=[];
    secilmisTemsilciler.add(temKod);
    print("temsilci Kodu :"+secilmisTemsilciler.toString());
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel=userService.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio().post("${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-forwarders",
          data:jsonEncode(secilmisTemsilciler),
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
          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for(var i in listuser){
              var dataCus = json.encode(i['customers']);
              var temsilciKodu=i['user']['code'];
              print("temsilciKodu :"+temsilciKodu.toString());

              List listDataCustomers = jsonDecode(dataCus);
              for(var a in listDataCustomers){
                ModelCariler model=ModelCariler.fromJson(a);
                model.forwarderCode=temsilciKodu;
                listUsers.add(model);

              }
            }

          } else {
            exeptionHandler.handleExeption(response);
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
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }

    return listUsers;
  }
  ///Get MercBaza
  Future<MercDataModel> getAllCustomersMerc(String temKod) async {
    MercDataModel listUsers=MercDataModel();
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler=[];
    secilmisTemsilciler.add(temKod);
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel=userService.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio().post("${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-merch",
          data:jsonEncode(secilmisTemsilciler),
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
        print("responce kode :"+response.data.toString());

          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for(var i in listuser){
              listUsers=MercDataModel.fromJson(i);
            }


          } else {
            exeptionHandler.handleExeption(response);
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
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }
    return listUsers;
  }

  String rutDuzgunluyuYoxla(ModelCariler selectedModel) {
    String rutgun = "Sef";
    int hefteningunu = DateTime
        .now()
        .weekday;
    switch (hefteningunu) {
      case 1:
        if (selectedModel.days!.any((element) => element.day==1)) {
          rutgun = "Duz";
        }
        break;
      case 2:
        if (selectedModel.days!.any((element) => element.day==2)) {
          rutgun = "Duz";
        }
        break;
      case 3:
        if (selectedModel.days!.any((element) => element.day==3)) {
          rutgun = "Duz";
        }
        break;
      case 4:
        if (selectedModel.days!.any((element) => element.day==4)) {
          rutgun = "Duz";
        }
        break;
      case 5:
        if (selectedModel.days!.any((element) => element.day==5)) {
          rutgun = "Duz";
        }
        break;
      case 6:
        if (selectedModel.days!.any((element) => element.day==6)) {
          rutgun = "Duz";
        }
        break;
      default:
        rutgun = "Sef";
    }
    return rutgun;
  }

////giris cixis
  Future<List<ModelMainInOut>> getAllGirisCixis(String temsilcikodu,String roleId) async {
    List<ModelMainInOut> listUsers = [];
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    DateTime dateParse = DateTime.parse(date);
    String ilkGun = intl.DateFormat('yyyy/MM/dd').format(dateParse);
    String songun = intl.DateFormat('yyyy/MM/dd').format(now);
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestInOut model=ModelRequestInOut(
      userRole: [UserRole(code: temsilcikodu, role: roleId)],
      endDate: songun,
      startDate: ilkGun
    );
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio().post(
          "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-customers-by-user",
          data: model.toJson(),
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
        print("selected Object :"+response.toString());

          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for (var i in listuser) {
              ModelMainInOut model=ModelMainInOut.fromJson(i);
              print("model :"+model.toString());
              listUsers.add(model);
            }
          } else {
            exeptionHandler.handleExeption(response);

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
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }
    return listUsers;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
