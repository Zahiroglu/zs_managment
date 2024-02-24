import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_regions.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/models/model_connections.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_dialog/dialog_select_user_connections.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/models/model_roles.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

import '../../login/models/base_responce.dart';

class NewUserController extends GetxController {
  LocalUserServices localUserServices = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();
  List<String> listStepper = [
    'genelinfo'.tr,
    'ilkinsecim'.tr,
    "Baglantilar".tr,
    "Icazeler".tr,
  ];
  TextEditingController cttextDviceId = TextEditingController();
  RxBool cttextDviceIdError = false.obs;
  TextEditingController cttextUsername = TextEditingController();
  RxBool cttextUsernameError = false.obs;
  TextEditingController cttextPassword = TextEditingController();
  RxBool cttextPasswordError = false.obs;
  TextEditingController cttextEmail = TextEditingController();
  TextEditingController cttextAd = TextEditingController();
  RxBool cttextAdError = false.obs;
  TextEditingController cttextSoyad = TextEditingController();
  RxBool cttextSoyadError = false.obs;
  TextEditingController cttextCode = TextEditingController();
  RxBool cttextCodeError = false.obs;
  TextEditingController cttextTelefon = TextEditingController();
  RxBool cttextTelefonError = false.obs;
  TextEditingController cttextDogumTarix = TextEditingController();
  RxBool regionSecilmelidir = false.obs;
  RxBool ilkinMelumatlarSecildi = false.obs;
  RxBool regionSecildi = false.obs;
  RxBool sobeSecildi = false.obs;
  RxBool vezifeSecildi = false.obs;
  RxBool canUseMobile = false.obs;
  RxBool canUseWindows = false.obs;
  RxBool istifadeIcazesiItenildi = false.obs;
  RxBool canUseNextButton = true.obs;
  LoggedUserModel loggedUserModel = LoggedUserModel();
  RxList<ModelRegions> listRegionlar =List<ModelRegions>.empty(growable: true).obs;
  RxList<ModelUserRolesTest> listSobeler = List<ModelUserRolesTest>.empty(growable: true).obs;
  RxList<Role> listVezifeler = List<Role>.empty(growable: true).obs;
  RxList<ModelUserPermissions> listPermisions = List<ModelUserPermissions>.empty(growable: true).obs;
  RxList<ModelUserPermissions> listChangedPermisions = List<ModelUserPermissions>.empty(growable: true).obs;
  RxList<ModelConnectionsTest> listGroupNameConnection = List<ModelConnectionsTest>.empty(growable: true).obs;
  RxList<int> listSelectedGroupId = List<int>.empty(growable: true).obs;
  RxList<ModelMustConnect> listUserConnections = List<ModelMustConnect>.empty(growable: true).obs;
  RxList<User> selectedListUserConnections = List<User>.empty(growable: true).obs;
  Rx<ModelConnectionsTest> selectedGroupName = ModelConnectionsTest().obs;
  RxList<ModelSelectUserPermitions> listModelSelectUserPermitions = List<ModelSelectUserPermitions>.empty(growable: true).obs;
  Rx<ModelSelectUserPermitions> selectedModulPermitions = ModelSelectUserPermitions().obs;
  RxList<ModelUserPermissions> selectedPermitions = List<ModelUserPermissions>.empty(growable: true).obs;
  Rx<RegisterUserModel> registerData=RegisterUserModel().obs;
  final selectedRegion = Rxn<ModelRegions>();
  final selectedSobe = Rxn<ModelUserRolesTest>();
  final selectedVezife = Rxn<Role>();

  //final selectedRole = Rxn<Model>();
  RxString selectedDate = DateTime.now().toString().substring(0, 10).obs;
  RxBool genderSelect = true.obs;
  RxInt selectedIndex = 0.obs;

  ModelRegions? get getselectedRegion => selectedRegion.value;

  ModelUserRolesTest? get getselectedSobe => selectedSobe.value;

  Role? get getselectedVezife => selectedVezife.value;
  RxBool canRegisterNewUser = false.obs;
  RxBool canUserWindowsPermitions = false.obs;
  RxBool canUserMobilePermitions = false.obs;

  @override
  void onInit() {
    super.onInit();
    localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    // TODO: implement onInit
  }

  @override
  void onReady() {
    // TODO: implement onReady
    callDatePickerFirst();
    super.onReady();
  }

  void changeSelectedRegion(ModelRegions val) {
    selectedRegion.value = val;
    regionSecildi.value = true;
    update();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }


  getRegionsFromApiService(PageController controller) async {
    DialogHelper.showLoading("Regional melumatlar axtarilir...");
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().get(
              "${loggedUserModel.baseUrl}/api/v1/Dictionary/regions",
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
          DialogHelper.hideLoading();
          var regionlist = json.encode(response.data['result']);
          List list = jsonDecode(regionlist);
          for (int i = 0; i < list.length; i++) {
            var s = jsonEncode(list.elementAt(i));
            ModelRegions model = ModelRegions.fromJson(jsonDecode(s));
            listRegionlar.add(model);
          }
          getRolesFromApiService(controller);
        }

    }
  }

  getRolesFromApiService(PageController controller) async {
    //dataLoading.value = true;
    DialogHelper.showLoading("Sobe ve vezifeler axtarilir...");
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().get(
              "${loggedUserModel.baseUrl}/api/v1/Dictionary/roles",
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
          var userresult = json.encode(response.data['result']);
          List list = jsonDecode(userresult);
          for (int i = 0; i < list.length; i++) {
            var s = jsonEncode(list.elementAt(i));
            ModelUserRolesTest model = ModelUserRolesTest.fromJson(jsonDecode(s));
            listSobeler.add(model);
          }
            regionSecilmelidir.value = true;
            incrementCustomStepper(controller);
            canUseNextButton.value = false;
          DialogHelper.hideLoading();
        }
    }
  }

  void incrementCustomStepper(PageController controller) {
    if(!canUseMobile.value && !canUseWindows.value){
      canUseNextButton.value=false;
    }
    if (selectedIndex.value != listStepper.length) {
      selectedIndex.value++;
      controller.jumpToPage(selectedIndex.value);
    }
    print("incrementCustomStepper :" + selectedIndex.toString());
    update();
  }

  void useNextButton(PageController controller) {
    if (selectedIndex.value == 0) {
      checkUserInfo(controller);
    } else if (selectedIndex.value == 1) {
      checkIlkinScreenMelumatlar(controller);
    } else if (selectedIndex.value == 2) {
      canRegisterNewUser.value = true;
      incrementCustomStepper(controller);
    }
    update();
  }

  void checkUserInfo(PageController controller) {
    canRegisterNewUser.value = false;
    if (cttextAd.text.isNotEmpty) {
      cttextAdError.value = false;
    } else {
      cttextAdError.value = true;
    }
    if (cttextSoyad.text.isNotEmpty) {
      cttextSoyadError.value = false;
    } else {
      cttextSoyadError.value = true;
    }
    if (cttextTelefon.text.isNotEmpty) {
      cttextTelefonError.value = false;
    } else {
      cttextTelefonError.value = true;
    }
    if (cttextCode.text.isNotEmpty) {
      cttextCodeError.value = false;
    } else {
      cttextCodeError.value = true;
    }
    if (cttextAd.text.isNotEmpty &&
        cttextSoyad.text.isNotEmpty &&
        cttextTelefon.text.isNotEmpty &&
        cttextCode.text.isNotEmpty) {
      if (!canUseMobile.value || !canUseMobile.value) {
        canUseNextButton.value = false;
      } else {
        canUseNextButton.value = true;
      }
      if (listSobeler.isNotEmpty) {
        regionSecilmelidir.value = true;
        canUseNextButton.value = true;
        incrementCustomStepper(controller);
      } else {
        getRegionsFromApiService(controller);
      }
    }
  }

  void checkIlkinScreenMelumatlar(PageController controller) {
    if (canUseWindows.value) {
      if (cttextPassword.text.isEmpty) {
        cttextPasswordError.value = true;
      } else {
        cttextPasswordError.value = false;
      }
      if (cttextUsername.text.isEmpty) {
        cttextUsernameError.value = true;
      } else {
        cttextUsernameError.value = false;
      }
      if (cttextUsername.text.isNotEmpty && cttextPassword.text.isNotEmpty) {
        if (!canUseMobile.value) {
          getCurrentUsersByParams(controller);
        }
      }
    }
    if (canUseMobile.value) {
      if (cttextDviceId.text.isNotEmpty) {
        cttextDviceIdError.value = false;
        if (!canUseWindows.value) {
          getCurrentUsersByParams(controller);
        }
      } else {
        cttextDviceIdError.value = true;
      }
    }
    if (canUseMobile.value && canUseWindows.value) {
      if (cttextPassword.text.isEmpty) {
        cttextPasswordError.value = true;
      } else {
        cttextPasswordError.value = false;
      }
      if (cttextUsername.text.isEmpty) {
        cttextUsernameError.value = true;
      } else {
        cttextUsernameError.value = false;
      }
      if (cttextDviceId.text.isNotEmpty) {
        cttextDviceIdError.value = false;
        if (!canUseWindows.value) {
          getCurrentUsersByParams(controller);
        }
      } else {
        cttextDviceIdError.value = true;
      }
      if (cttextUsername.text.isNotEmpty &&
          cttextPassword.text.isNotEmpty &&
          cttextDviceId.text.isNotEmpty) {
        getCurrentUsersByParams(controller);
      }
    }
    print("Selected Page :"+selectedIndex.toString()+" canUseNext ="+canUseNextButton.toString());
  }

  void decrementCustomStepper(PageController controlle) {
    if (!canUseMobile.value || !canUseMobile.value) {
      if (selectedIndex.value == 1) {
        canUseNextButton.value = true;
      } else {
        canUseNextButton.value = false;
      }
    } else {
      canUseNextButton.value = true;
    }
    if (selectedIndex.value != 0) {
      canRegisterNewUser.value = false;
      selectedIndex.value--;
      controlle.jumpToPage(selectedIndex.value);
    }
    update();
  }

  getCurrentUsersByParams(PageController controller) async {
    selectedListUserConnections.clear();
    DialogHelper.showLoading("Movcud istifadeci axtarilir".tr);
    canUseNextButton.value = false;
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().get(
              "${loggedUserModel.baseUrl}/api/v1/User/user-by-code-for-register/${cttextCode.text.toString()}/${selectedVezife.value!.id}",
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
          var connections = json.encode(response.data['result']['user']['connections']);
          List list = jsonDecode(connections);
          for (int i = 0; i < list.length; i++) {
            var s = jsonEncode(list.elementAt(i));
            User model = User.fromJson(jsonDecode(s));
            model.isSelected=true;
            selectedListUserConnections.add(model);
            print("selectedListUserConnections :"+selectedListUserConnections.toString());
          }
          var permitions = json.encode(response.data['result']['user']['permissions']);
          List listpermissions = jsonDecode(permitions);
          for (int i = 0; i < listpermissions.length; i++) {
            ModelSelectUserPermitions model = ModelSelectUserPermitions.fromJson(listpermissions.elementAt(i));
            listModelSelectUserPermitions.add(model);
          }
          DialogHelper.hideLoading();
          getConnectionsFromApiService(controller);
        }
    }
  }

  getConnectionsFromApiService(PageController controller) async {
    listGroupNameConnection.clear();
    listUserConnections.clear();
    DialogHelper.showLoading("Baglanti melumatlari axtarilir".tr);
    canUseNextButton.value = false;
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().get(
          "${loggedUserModel.baseUrl}/api/v1/Dictionary/connections",
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
          DialogHelper.hideLoading();
          var userresult = json.encode(response.data['result']);
          print("Connections :" + userresult.toString());
          List list = jsonDecode(userresult);
          for (int i = 0; i < list.length; i++) {
            var s = jsonEncode(list.elementAt(i));
            ModelConnectionsTest model = ModelConnectionsTest.fromJson(jsonDecode(s));
            listGroupNameConnection.add(model);
            listGroupNameConnection.value = checkListGroupNameConnection(listGroupNameConnection);
          }
          if (listGroupNameConnection.isNotEmpty) {
            selectedGroupName.value = listGroupNameConnection.elementAt(0);
            if (selectedGroupName.value.connections!.isNotEmpty) {
              listUserConnections.value = selectedGroupName.value.connections!
                  .where(
                      (elementa) => elementa.roleId == selectedVezife.value!.id)
                  .toList();
            }
          }
          getUsersPermitionsFromApi(controller);
        }
    }
  }

  List<ModelMustConnect> getMovcudKodunBaglantilari(List<User> selectedListUserConnections){
    List<ModelMustConnect> list =[];

    return list;
  }

  Future<void> getUsersPermitionsFromApi(PageController controller) async {
    DialogHelper.showLoading("Icaze melumatlari axtarilir".tr);
    listModelSelectUserPermitions.clear();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().get(
              "${loggedUserModel.baseUrl}/api/v1/Dictionary/permissions-by-role/${selectedVezife.value!.id}",
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
          DialogHelper.hideLoading();
          incrementCustomStepper(controller);
          var permitions = json.encode(response.data['result']);
          print("Gelen permitionslar :"+permitions);

          List list = jsonDecode(permitions);
          for (int i = 0; i < list.length; i++) {
            //var s = jsonEncode(list.elementAt(i));
            ModelSelectUserPermitions model = ModelSelectUserPermitions.fromJson(list.elementAt(i));
            for (var element in model.permissions!) {
              listPermisions.add(element);
            }
            listModelSelectUserPermitions.add(model);
          }
          if (listModelSelectUserPermitions.isNotEmpty) {
            changeSelectedModelSelectUserPermitions(listModelSelectUserPermitions.first);
          }
        }
    }
    canUseNextButton.value = true;

    // ModelSelectUserPermitions modelanbar=ModelSelectUserPermitions(
    //   id: 5,
    //   name: "Anbar",
    //   permissions: [
    //     ModelUserPermissions(
    //       id: 1,
    //       name: "Anbar raporunu gore bilsun",
    //       valName: "Tam Icazeli"
    //     ),
    //     ModelUserPermissions(
    //         id: 2,
    //         name: "Mehsullarin qiymetini gore bilsin",
    //       valName: "Tam Icazeli"
    //     ),
    //     ModelUserPermissions(
    //         id: 3,
    //         name: "Mehsullarin qaliq miqdarini gore bilsin",
    //       valName: "Tam Icazeli"
    //     ),
    //   ]
    // );
    // ModelSelectUserPermitions modelSatis=ModelSelectUserPermitions(
    //   id: 7,
    //   name: "Satis Modulu",
    //   permissions: [
    //     ModelUserPermissions(
    //         id: 4,
    //         name: "Butun Expeditorlari gore bilsin?",
    //       valName: "Tam Icazeli",
    //       val: 0
    //     ),
    //     ModelUserPermissions(
    //         id: 5,
    //         name: "Satis ede bilsin?",
    //       valName: "Icazesiz",
    //       val: 1
    //     ),
    //     ModelUserPermissions(
    //       id: 6,
    //       name: "Sifarisde deyisiklik ede bilsin?",
    //       valName: "Icazesiz",
    //       val: 0
    //     ),
    //     ModelUserPermissions(
    //       id: 6,
    //       name: "Sifarisde deyisiklik ede bilsin?",
    //       valName: "Icazesiz",
    //       val: 0
    //     ),
    //   ]
    // );
    // ModelSelectUserPermitions moduleMerc=ModelSelectUserPermitions(
    //   id: 6,
    //   name: "Reklam modulu",
    //   permissions: [
    //     ModelUserPermissions(
    //       id: 7,
    //       name: "Online map sehfesini gore bilsin?",
    //       valName: "Tam Icazeli",
    //       val: 0
    //     ),
    //     ModelUserPermissions(
    //       id: 8,
    //       name: "Mercendaizer motivasiya sehfesini gore bilsin?",
    //       valName: "Tam Icazeli",
    //       val: 0
    //     ),
    //     ModelUserPermissions(
    //       id: 9,
    //       name: "Mercendaizer detayli rutuna baxa bilsin",
    //       valName: "Icazesiz",
    //       val: 1
    //     ),
    //   ]
    // );
    // listModelSelectUserPermitions.add(modelanbar);
    // listModelSelectUserPermitions.add(modelSatis);
    // listModelSelectUserPermitions.add(moduleMerc);
  }

  void changeSelectedSobe(ModelUserRolesTest val) {
    selectedSobe.value = val;
    selectedVezife.value = null;
    print("Roles count :" + val.roles!.length.toString());
    listVezifeler.value = val.roles ?? [];
    sobeSecildi.value = true;
    update();
  }

  void changeSelectedVezife(Role val) {
    selectedVezife.value = val;
    vezifeSecildi.value = true;
    canUserMobilePermitions.value=selectedVezife.value!.deviceLogin!;
    canUserWindowsPermitions.value=selectedVezife.value!.usernameLogin!;
    update();
  }

  void changeCnUseMobile(bool val) {
    canUseMobile.value = val;
    cttextDviceIdError.value = false;
    cttextDviceId.text = "";
    canUseWindows.value
        ? canUseNextButton.value = true
        : canUseNextButton.value = val;
    update();
  }

  void changeCnUseWindows(bool val) {
    canUseWindows.value = val;
    cttextPasswordError.value = false;
    cttextUsernameError.value = false;
    cttextPassword.text = "";
    cttextUsername.text = "";
    canUseNextButton.value = val;
    canUseMobile.value
        ? canUseNextButton.value = true
        : canUseNextButton.value = val;

    update();
  }

  void changeSelectedGender(bool val) {
    genderSelect.value = val;
    update();
  }

  /////users connections part
  void changeSelectedGroupConnected(ModelConnectionsTest element) {
    selectedGroupName.value = element;
    listUserConnections.value = element.connections!
        .where((elementa) => elementa.roleId == selectedVezife.value!.id)
        .toList();
    update();
  }

  List<ModelConnectionsTest> checkListGroupNameConnection( List<ModelConnectionsTest> groupList) {
    List<ModelConnectionsTest> list = [];
    for (ModelConnectionsTest element in groupList) {
      for (ModelMustConnect model in element.connections!) {
        if (model.roleId == selectedVezife.value!.id) {
          if (!list.contains(element)) {
            list.add(element);
          }
        }
      }
    }
    return list;
  }

  Future<void> getConnectionMustSelect(ModelMustConnect element) async {
    await getUserListApiService(element);
  }

  Future<List<User>> getUserListApiService(ModelMustConnect element) async {
    List<User> listUsers = [];
    Map data = {
      "roleId": element.connectionRoleId,
      "connRoleId": 0,
      "connUserCode": "ok"
    };
    DialogHelper.showLoading("Melumatlar axtarilir...");
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient()
            .dio()
            .post("${loggedUserModel.baseUrl}/api/v1/User/user-by-connection",
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
                data: data);
        if (response.statusCode == 200) {
          var userresult = json.encode(response.data['result']);
          List list = jsonDecode(userresult);
          for (int i = 0; i < list.length; i++) {
            var s = jsonEncode(list.elementAt(i));
            int roleId = jsonDecode(s)['roleId'];
            String roleName = jsonDecode(s)['roleName'];
            String code = jsonDecode(s)['code'];
            String fullName = jsonDecode(s)['fullName'] ?? "Melumat Tapilmadi";
            User user = User(
                roleId: roleId,
                roleName: roleName,
                fullName: fullName,
                code: code,
                modulCode: selectedGroupName.value.id.toString(),
                isSelected: selectedListUserConnections
                    .where((p) => p.code.toString() == code&&p.roleId==roleId)
                    .isNotEmpty);
            listUsers.add(user);
          }

          DialogHelper.hideLoading();
          Get.dialog(DialogSelectedUserConnectins(
            isWindows: true,
            selectedListUsers: selectedListUserConnections,
            addConnectin: (listSelected, listDeselected) {
              addSelectedUserToList(listSelected, listDeselected, selectedGroupName.value.id);
            },
            listUsers: listUsers,
            vezifeAdi: selectedGroupName.value.name!,
          ));
        }
    }
    return listUsers;
  }

  void clearDataFromSelectedUsers(User e) {
    selectedListUserConnections.remove(e);
    listSelectedGroupId.remove(selectedGroupName.value.id);
    update();
  }

  void addSelectedUserToList(List<User> value, List<User> listDeselected, int? id) {
    for (var element in value) {
      print("selected Users list:" + element.toString());
      var contain = selectedListUserConnections.where((element2) => element2.code == element.code&&element2.roleId==element.roleId);
      if (contain.isEmpty) {
        selectedListUserConnections.add(element);
        listSelectedGroupId.add(id!);
      } else {
        selectedListUserConnections.remove(element);
        listSelectedGroupId.remove(id!);
      }
    }
    for (var element in listDeselected) {
      var contain = selectedListUserConnections.where((element2) => element2.code == element.code&&element2.roleId==element.roleId);
      if (contain.isNotEmpty) {
        listSelectedGroupId.remove(id);
        selectedListUserConnections.remove(selectedListUserConnections
            .where((element2) => element2.code == element.code||element2.roleId==element.roleId)
            .firstOrNull);
      }
    }
    update();
  }

  /////////users permitions part


  void changeSelectedModelSelectUserPermitions(ModelSelectUserPermitions e) {
    selectedModulPermitions.value = e;
    selectedPermitions.value=e.permissions!;
    update();
  }

  Future<bool> registerUserEndpoint() async {
    bool succes=false;
    DialogHelper.showLoading("Melumatlar yoxlanir...",false);
    List<ConnectionRegister> listcon = [];
    for (var element in selectedListUserConnections) {
      ConnectionRegister cn = ConnectionRegister(
          roleId: element.roleId,
          code: element.code,
          roleName: element.modulCode,
          fullName: element.fullName);
      listcon.add(cn);
    }
    registerData.value = RegisterUserModel(
      id: 0,
        name: cttextAd.text,
        permissions: listPermisions,
        code: cttextCode.text.toString(),
        roleId: selectedVezife.value!.id,
        usernameLogin: canUseWindows.value,
        surname: cttextSoyad.text,
        phone: cttextTelefon.text.toString().removeAllWhitespace,
        gender: genderSelect.value ? 0 : 1,
        fatherName: "",
        email: cttextEmail.text,
        deviceLogin: canUseMobile.value,
        deviceId: cttextDviceId.text,
        connections: listcon,
        birthdate: cttextDogumTarix.text.trim(),
        createrUser: loggedUserModel.userModel!.id,
        macAddress: "00wdew555151",
        username: cttextUsername.text,
        password: cttextPassword.text,
        regionCode:selectedRegion.value!.code!);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {},
      ));
    } else {
        final response = await ApiClient().dio().post(
              "${loggedUserModel.baseUrl}/api/v1/User/register",
              data: registerData.toJson(),
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
          acceptRecistredUser(response.data['result'],registerData.value);
          succes=true;
          Get.back();
        }
    }

    return succes;
  }

  Future<void> acceptRecistredUser(String recNom, RegisterUserModel registerData) async {
    DialogHelper.hideLoading();
    DialogHelper.showLoading("Qeydiyyat tesdiqlenir...",false);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
        final response = await ApiClient().dio().get(
              "${"${loggedUserModel.baseUrl}/api/v1/User/confirm-new-user/${loggedUserModel.userModel!.companyId}"}/$recNom",
              data: registerData.toJson(),
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
          DialogHelper.hideLoading();
          Get.back();
        }
    }
  }

  void callDatePickerFirst() async {
    String day = "01";
    String ay = "01";
    var order = DateTime.now();
    if (order.day.toInt() < 10) {
      day = "0${order.day}";
    } else {
      day = order.day.toString();
    }
    if (order.month.toInt() < 10) {
      ay = "0${order.month}";
    } else {
      ay = order.month.toString();
    }
    selectedDate.value = "$day.$ay.${order.year}";
      cttextDogumTarix.text = "$day.$ay.${order.year}";
  }

  void callDatePicker() async {
    String day = "01";
    String ay = "01";
    var order = await getDate();
    if (order!.day.toInt() < 10) {
      day = "0${order.day}";
    } else {
      day = order.day.toString();
    }
    if (order.month.toInt() < 10) {
      ay = "0${order.month}";
    } else {
      ay = order.month.toString();
    }
    selectedDate.value = "$day.$ay.${order.year}";
      cttextDogumTarix.text = "$day.$ay.${order.year}";
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
  }

  void channgePermitionType(ModelUserPermissions data, bool mustAdd, ModelSelectUserPermitions value,) {
    for (var element in listModelSelectUserPermitions.where((a) => a.id==value.id).first.permissions!) {
      if(element.id==data.id){
        element.val=mustAdd?1:0;
      }
    }
    update();
  }

  void channgePermitionbyModule(bool bool, ModelSelectUserPermitions value) {
    for (var element in listModelSelectUserPermitions.where((a) => a.id==value.id).first.permissions!) {
      element.val=bool?1:0;
    }
    update();
  }

}

class User {
  int? id;
  int? roleId;
  String? roleName;
  String? fullName;
  String? code;
  String? modulCode;
  bool? isSelected;

  User({
    this.id,
    this.roleId,
    this.roleName,
    this.fullName,
    this.code,
    this.modulCode,
    this.isSelected,
  });

  User copyWith({
    int? id,
    int? roleId,
    String? fullName,
    String? code,
  }) =>
      User(
        id: id ?? this.id,
        roleId: roleId ?? this.roleId,
        fullName: fullName ?? this.fullName,
        code: code ?? this.code,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        roleId: json["roleId"],
        fullName: json["fullName"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "roleId": roleId,
        "code": code,
      };

  @override
  String toString() {
    return 'User{id: $id, roleId: $roleId, roleName: $roleName, fullName: $fullName, code: $code, modulCode: $modulCode, isSelected: $isSelected}';
  }
}

class ModelUserRolesTest {
  int? id;
  String? name;
  List<Role>? roles;

  ModelUserRolesTest({
    this.id,
    this.name,
    this.roles,
  });

  ModelUserRolesTest copyWith({
    int? id,
    String? name,
    List<Role>? roles,
  }) =>
      ModelUserRolesTest(
        id: id ?? this.id,
        name: name ?? this.name,
        roles: roles ?? this.roles,
      );

  factory ModelUserRolesTest.fromRawJson(String str) =>
      ModelUserRolesTest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUserRolesTest.fromJson(Map<String, dynamic> json) =>
      ModelUserRolesTest(
        id: json["id"],
        name: json["name"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
      };
}

class Role {
  int? id;
  String? name;
  bool? usernameLogin;
  bool? deviceLogin;

  Role({
    this.id,
    this.name,
    this.usernameLogin,
    this.deviceLogin,
  });

  Role copyWith({
    int? id,
    String? name,
    bool? usernameLogin,
    bool? deviceLogin,
  }) =>
      Role(
        id: id ?? this.id,
        name: name ?? this.name,
        usernameLogin: usernameLogin ?? this.usernameLogin,
        deviceLogin: deviceLogin ?? this.deviceLogin,
      );

  factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        usernameLogin: json["usernameLogin"],
        deviceLogin: json["deviceLogin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "usernameLogin": usernameLogin,
        "deviceLogin": deviceLogin,
      };

  @override
  String toString() {
    return 'Role{id: $id, name: $name, usernameLogin: $usernameLogin, deviceLogin: $deviceLogin}';
  }
}

class ModelConnectionsTest {
  List<ModelMustConnect>? connections;
  int? id;
  String? name;

  ModelConnectionsTest({
    this.connections,
    this.id,
    this.name,
  });

  ModelConnectionsTest copyWith({
    List<ModelMustConnect>? connections,
    int? id,
    String? name,
  }) =>
      ModelConnectionsTest(
        connections: connections ?? this.connections,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ModelConnectionsTest.fromRawJson(String str) =>
      ModelConnectionsTest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelConnectionsTest.fromJson(Map<String, dynamic> json) =>
      ModelConnectionsTest(
        connections: json["connections"] == null
            ? []
            : List<ModelMustConnect>.from(
                json["connections"]!.map((x) => ModelMustConnect.fromJson(x))),
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "connections": connections == null
            ? []
            : List<dynamic>.from(connections!.map((x) => x.toJson())),
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return 'ModelConnectionsTest{connections: $connections, id: $id, name: $name}';
  }
}

class ModelMustConnect {
  int? roleId;
  String? roleName;
  int? connectionRoleId;
  String? connectionRoleName;

  ModelMustConnect({
    this.roleId,
    this.roleName,
    this.connectionRoleId,
    this.connectionRoleName,
  });

  ModelMustConnect copyWith({
    int? roleId,
    String? roleName,
    int? connectionRoleId,
    String? connectionRoleName,
  }) =>
      ModelMustConnect(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        connectionRoleId: connectionRoleId ?? this.connectionRoleId,
        connectionRoleName: connectionRoleName ?? this.connectionRoleName,
      );

  factory ModelMustConnect.fromRawJson(String str) =>
      ModelMustConnect.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMustConnect.fromJson(Map<String, dynamic> json) =>
      ModelMustConnect(
        roleId: json["roleId"],
        roleName: json["roleName"],
        connectionRoleId: json["connectionRoleId"],
        connectionRoleName: json["connectionRoleName"],
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
        "connectionRoleId": connectionRoleId,
        "connectionRoleName": connectionRoleName,
      };

  @override
  String toString() {
    return 'ModelMustConnect{roleId: $roleId, roleName: $roleName, connectionRoleId: $connectionRoleId, connectionRoleName: $connectionRoleName}';
  }
}

class ModelSelectUserPermitions {
  List<ModelUserPermissions>? permissions;
  int? id;
  String? name;

  ModelSelectUserPermitions({
    this.permissions,
    this.id,
    this.name,
  });

  ModelSelectUserPermitions copyWith({
    List<ModelUserPermissions>? permissions,
    int? id,
    String? name,
  }) =>
      ModelSelectUserPermitions(
        permissions: permissions ?? this.permissions,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ModelSelectUserPermitions.fromRawJson(String str) =>
      ModelSelectUserPermitions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelSelectUserPermitions.fromJson(Map<String, dynamic> json) =>
      ModelSelectUserPermitions(
        permissions: json["permissions"] == null
            ? []
            : List<ModelUserPermissions>.from(json["permissions"]!
                .map((x) => ModelUserPermissions.fromJson(x))),
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return 'ModelSelectUserPermitions{permissions: $permissions, id: $id, name: $name}';
  }
}

class RegisterUserModel {
  int? id;
  String? code;
  String? name;
  String? surname;
  String? fatherName;
  String? birthdate;
  int? gender;
  String? phone;
  String? email;
  int? roleId;
  String? regionCode;
  String? deviceId;
  int? createrUser;
  String? macAddress;
  bool? deviceLogin;
  bool? usernameLogin;
  String? username;
  String? password;
  List<ConnectionRegister>? connections;
  List<ModelUserPermissions>? permissions;

  RegisterUserModel({
    this.id,
    this.code,
    this.name,
    this.surname,
    this.fatherName,
    this.birthdate,
    this.gender,
    this.phone,
    this.email,
    this.roleId,
    this.regionCode,
    this.deviceId,
    this.createrUser,
    this.macAddress,
    this.deviceLogin,
    this.usernameLogin,
    this.username,
    this.password,
    this.connections,
    this.permissions,
  });

  RegisterUserModel copyWith({
    int? id,
    String? code,
    String? name,
    String? surname,
    String? fatherName,
    String? birthdate,
    int? gender,
    String? phone,
    String? email,
    int? roleId,
    String? regionCode,
    String? deviceId,
    int? createrUser,
    String? macAddress,
    bool? deviceLogin,
    bool? usernameLogin,
    String? username,
    String? password,
    List<ConnectionRegister>? connections,
    List<ModelUserPermissions>? permissions,
  }) =>
      RegisterUserModel(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        fatherName: fatherName ?? this.fatherName,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        roleId: roleId ?? this.roleId,
        regionCode: regionCode ?? this.regionCode,
        deviceId: deviceId ?? this.deviceId,
        createrUser: createrUser ?? this.createrUser,
        macAddress: macAddress ?? this.macAddress,
        deviceLogin: deviceLogin ?? this.deviceLogin,
        usernameLogin: usernameLogin ?? this.usernameLogin,
        username: username ?? this.username,
        password: password ?? this.password,
        connections: connections ?? this.connections,
        permissions: permissions ?? this.permissions,
      );

  factory RegisterUserModel.fromRawJson(String str) =>
      RegisterUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) =>
      RegisterUserModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        surname: json["surname"],
        fatherName: json["fatherName"],
        birthdate: json["birthdate"],
        gender: json["gender"],
        phone: json["phone"],
        email: json["email"],
        roleId: json["roleId"],
        regionCode: json["regionCode"],
        deviceId: json["deviceId"],
        createrUser: json["createrUser"],
        macAddress: json["macAddress"],
        deviceLogin: json["deviceLogin"],
        usernameLogin: json["usernameLogin"],
        username: json["username"],
        password: json["password"],
        connections: json["connections"] == null
            ? []
            : List<ConnectionRegister>.from(json["connections"]!
                .map((x) => ConnectionRegister.fromJson(x))),
        permissions: json["permissions"] == null
            ? []
            : List<ModelUserPermissions>.from(json["permissions"]!
                .map((x) => ModelUserPermissions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "surname": surname,
        "fatherName": fatherName,
        "birthdate": birthdate,
        "gender": gender,
        "phone": phone,
        "email": email,
        "roleId": roleId,
        "regionCode": regionCode,
        "deviceId": deviceId,
        "createrUser": createrUser,
        "macAddress": macAddress,
        "deviceLogin": deviceLogin,
        "usernameLogin": usernameLogin,
        "username": username,
        "password": password,
        "connections": connections == null
            ? []
            : List<dynamic>.from(connections!.map((x) => x.toJson())),
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'RegisterUserModel{id: $id, code: $code, name: $name, surname: $surname, fatherName: $fatherName, birthdate: $birthdate, gender: $gender, phone: $phone, email: $email, roleId: $roleId, regionCode: $regionCode, deviceId: $deviceId, createrUser: $createrUser, macAddress: $macAddress, deviceLogin: $deviceLogin, usernameLogin: $usernameLogin, username: $username, password: $password, connections: $connections, permissions: $permissions}';
  }
}

class ConnectionRegister {
  int? roleId;
  String? roleName;
  String? code;
  String? fullName;

  ConnectionRegister({
    this.roleId,
    this.roleName,
    this.code,
    this.fullName,
  });

  ConnectionRegister copyWith({
    int? roleId,
    String? roleName,
    String? code,
    String? fullName,
  }) =>
      ConnectionRegister(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        code: code ?? this.code,
        fullName: fullName ?? this.fullName,
      );

  factory ConnectionRegister.fromRawJson(String str) =>
      ConnectionRegister.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConnectionRegister.fromJson(Map<String, dynamic> json) =>
      ConnectionRegister(
        roleId: json["roleId"],
        roleName: json["roleName"],
        code: json["code"],
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
        "code": code,
        "fullName": fullName,
      };

  @override
  String toString() {
    return 'ConnectionRegister{roleId: $roleId, roleName: $roleName, code: $code, fullName: $fullName}';
  }
}
