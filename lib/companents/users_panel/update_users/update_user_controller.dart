import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_regions.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_dialog/dialog_select_user_connections.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/models/model_roles.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class UpdateUserController extends GetxController {
  UserModel selectedUserModel = UserModel();
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
  RxList<ModelRegions> listRegionlar = List<ModelRegions>.empty(growable: true).obs;
  RxList<ModelUserRolesTest> listSobeler = List<ModelUserRolesTest>.empty(growable: true).obs;
  RxList<Role> listVezifeler = List<Role>.empty(growable: true).obs;
  RxList<ModelUserPermissions> listPermisions = List<ModelUserPermissions>.empty(growable: true).obs;
  RxList<ModelConnectionsTest> listGroupNameConnection = List<ModelConnectionsTest>.empty(growable: true).obs;
  RxList<int> listSelectedGroupId = List<int>.empty(growable: true).obs;
  RxList<ModelMustConnect> listUserConnections = List<ModelMustConnect>.empty(growable: true).obs;
  RxList<User> selectedListUserConnections = List<User>.empty(growable: true).obs;
  Rx<ModelConnectionsTest> selectedGroupName = ModelConnectionsTest().obs;
  RxList<ModelSelectUserPermitions> listModelSelectUserPermitions = List<ModelSelectUserPermitions>.empty(growable: true).obs;
  Rx<ModelSelectUserPermitions> selectedModulPermitions = ModelSelectUserPermitions().obs;
  RxList<ModelUserPermissions> selectedPermitions = List<ModelUserPermissions>.empty(growable: true).obs;
  final selectedRegion = Rxn<ModelRegions>();
  final selectedSobe = Rxn<ModelUserRolesTest>();
  final selectedVezife = Rxn<Role>();
  //final selectedRole = Rxn<Model>();
  RxString selectedDate = DateTime.now().toString().substring(0, 10).obs;
  RxBool genderSelect = true.obs;
  RxInt selectedIndex = 0.obs;
  List<ModelUserPermissions> getUsersPermisions() => listPermisions;
  List<ModelConnectionsTest> getConnections() => listGroupNameConnection;
  ModelRegions? get getselectedRegion => selectedRegion.value;
  ModelUserRolesTest? get getselectedSobe => selectedSobe.value;
  Role? get getselectedVezife => selectedVezife.value;
  RxBool canRegisterNewUser = false.obs;
  RxBool canUserWindowsPermitions = false.obs;
  RxBool canUserMobilePermitions = false.obs;

  @override
  void onInit() {
    super.onInit();
    callDatePickerFirst();
    localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    // TODO: implement onInit
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void changeSelectedRegion(ModelRegions val) {
    selectedRegion.value = val;
    sobeSecildi.value = true;
    vezifeSecildi.value = true;
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
            if (selectedUserModel.regionCode == model.code) {
              regionSecildi.value = true;
              selectedRegion.value = model;
            }
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
            ModelUserRolesTest model =
                ModelUserRolesTest.fromJson(jsonDecode(s));
            if (selectedUserModel.moduleId == model.id) {
              sobeSecildi.value = true;
              selectedSobe.value = model;
            }
            listSobeler.add(model);
          }
          if( listSobeler.where((element) => element.id == selectedUserModel.moduleId).isNotEmpty){
          ModelUserRolesTest modela = listSobeler.where((element) => element.id == selectedUserModel.moduleId).first;
          listVezifeler.value = modela.roles!;}
          if (listVezifeler.where((x) => x.id == selectedUserModel.roleId).isNotEmpty) {
            selectedVezife.value = listVezifeler
                .where((x) => x.id == selectedUserModel.roleId)
                .first;
            vezifeSecildi.value = true;
            canUserMobilePermitions.value = selectedVezife.value!.deviceLogin!;
            canUserWindowsPermitions.value =
                selectedVezife.value!.usernameLogin!;
            if (selectedRegion.value == null) {
              regionSecildi.value = false;
              sobeSecildi.value = false;
              vezifeSecildi.value = false;
            } else {
              regionSecildi.value = true;
              canUseNextButton.value = true;
            }
          }
          regionSecilmelidir.value = true;
          incrementCustomStepper(controller);
          DialogHelper.hideLoading();
        }
    }
  }

  void incrementCustomStepper(PageController controller) {
    if (selectedIndex.value != listStepper.length) {
      selectedIndex.value++;
      controller.jumpToPage(selectedIndex.value);
    }
    update();
  }

  void useNextButton(PageController controller) {
    if (selectedIndex.value == 0) {
      checkUserInfo(controller);
    } else if (selectedIndex.value == 1) {
      getConnectionsFromApiService(controller);
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
        Get.dialog(ShowInfoDialog(messaje: response.data.toString(), icon: Icons.error, callback: (){}));
        DialogHelper.hideLoading();
      }else{
        DialogHelper.hideLoading();
      }
    }
    getConnectionsFromApiService(controller);
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
          canUseNextButton.value=true;
          getUsersPermitionsFromApi(controller);
        }
    }
  }

  Future<void> getUsersPermitionsFromApi(PageController controller) async {
    listPermisions.clear();
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
          List list = jsonDecode(permitions);
          for (int i = 0; i < list.length; i++) {
            ModelSelectUserPermitions model = ModelSelectUserPermitions.fromJson(list.elementAt(i));
            for (var element in model.permissions!) {
              element.val=0;
              listPermisions.add(element);
            }
            listModelSelectUserPermitions.add(model);
          }
          if (listModelSelectUserPermitions.isNotEmpty) {
            changeSelectedModelSelectUserPermitions(listModelSelectUserPermitions.first);
          }

          if(selectedUserModel.roleId==selectedVezife.value!.id) {
            for (var element in selectedUserModel.permissions!) {
              listPermisions
                  .where((p) => p.code == element.code)
                  .first
                  .val = element.val;
            }
          }
          else{
            listPermisions.value=listModelSelectUserPermitions.first.permissions!;
            selectedPermitions.value=listModelSelectUserPermitions.first.permissions!;
            selectedModulPermitions.value = listModelSelectUserPermitions.first;
          }
        }
        }
    canUseNextButton.value = true;

  }

  void changeSelectedSobe(ModelUserRolesTest val) {
    selectedSobe.value = val;
    selectedVezife.value = null;
    listVezifeler.value = val.roles ?? [];
    sobeSecildi.value = true;
    update();
  }

  void changeSelectedVezife(Role val) {
    selectedVezife.value = val;
    print("selected vezife :"+selectedVezife.toString());
    canUserMobilePermitions.value = selectedVezife.value!.deviceLogin!;
    canUserWindowsPermitions.value = selectedVezife.value!.usernameLogin!;
    vezifeSecildi.value = true;
    update();
  }

  void changeCnUseMobile(bool val) {
    canUseMobile.value = val;
    canUseWindows.value
        ? canUseNextButton.value = true
        : canUseNextButton.value = val;
    update();
  }

  void changeCnUseWindows(bool val) {
    canUseWindows.value = val;
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

  List<ModelConnectionsTest> checkListGroupNameConnection(List<ModelConnectionsTest> groupList) {
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
    DialogHelper.showLoading("Istifadeciler axtarilir");
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
      var contain = selectedListUserConnections.where((element2) => element2.code == element.code&&element2.roleId==element.roleId);
      if (contain.isEmpty) {
        element.modulCode="";
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
            .where((element2) => element2.code == element.code&&element2.roleId==element.roleId)
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

  Future<RegisterUserModel> updateUserEndpoint() async {
    for (ModelSelectUserPermitions modelP in listModelSelectUserPermitions) {
      print("listModelSelectUserPermitions element :"+modelP.toString());
      for (var e in modelP.permissions!) {
        if(!listPermisions.contains(e)) {
          listPermisions.add(e);
        }}
    }
    DialogHelper.showLoading("Melumatlar deyisdirilir...");
    List<ConnectionRegister> listcon = [];
    if (selectedVezife.value!.usernameLogin!) {
      canUseWindows.value = true;
    } else {
      canUseWindows.value = false;
    }
    if (selectedVezife.value!.deviceLogin!) {
      canUseMobile.value = true;
    } else {
      canUseMobile.value = false;
    }
    for (var element in selectedListUserConnections) {
      ConnectionRegister cn = ConnectionRegister(
          roleId: element.roleId,
          code: element.code,
          roleName: element.roleName,
          fullName: element.fullName);
      listcon.add(cn);
    }
    RegisterUserModel registerData = RegisterUserModel(
        id: selectedUserModel.id,
        name: cttextAd.text.trim(),
        permissions: listPermisions,
        code: cttextCode.text.trim(),
        roleId: selectedVezife.value!.id,
        usernameLogin: canUseWindows.value,
        surname: cttextSoyad.text.trim(),
        phone: cttextTelefon.text.toString().removeAllWhitespace.trim(),
        gender: genderSelect.value ? 0 : 1,
        fatherName: "",
        email: cttextEmail.text.trim(),
        deviceLogin: canUseMobile.value,
        deviceId: cttextDviceId.text.trim(),
        connections: listcon,
        birthdate: cttextDogumTarix.text.trim(),
        createrUser: loggedUserModel.userModel!.id,
        macAddress: "00wdew555151",
        username: cttextUsername.text.trim(),
        password: cttextPassword.text.trim(),
        regionCode: selectedRegion.value!.code!);
    print("registerData :"+registerData.toString());
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
        final response = await ApiClient().dio().put(
              "${loggedUserModel.baseUrl}/api/v1/User/edit-user",
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
          BaseResponce responce=BaseResponce.fromJson(response.data);
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.verified_user_outlined,
            color: Colors.green,
            messaje:responce.result,
            callback: () {
              Get.until((route) => !Get.isDialogOpen!);
              },
          ));

        }
        //dataLoading.value = false;
      }
    return registerData;
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

  void addSelecTedUser(UserModel model) {
    selectedUserModel = model;
    canUseWindows.value = model.usernameLogin!;
    canUseMobile.value = model.deviceLogin!;
    cttextSoyad.text = model.surname ?? "Bosdur";
    cttextEmail.text = model.email ?? "Bosdur";
    cttextAd.text = model.name ?? "Bosdur";
    genderSelect.value = model.gender == 0 ? true : false;
    cttextDogumTarix.text = model.birthdate ?? "Bosdur";
    cttextCode.text = model.code ?? "Bosdur";
    cttextTelefon.text = model.phone ?? "";
    cttextDviceId.text = model.deviceId!;
    for (var element in model.connections!) {
      User userS = User(
          id: 0,
          fullName: element.fullName,
          code: element.code,
          isSelected: true,
          modulCode: "",
          roleName: element.roleName,
          roleId: element.roleId);
      selectedListUserConnections.add(userS);
    }
    update();
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
