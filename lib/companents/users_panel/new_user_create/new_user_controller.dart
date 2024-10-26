import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_regions.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/models/model_connections.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/models/model_roles.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

import '../../login/models/base_responce.dart';
import '../mobile/dialog_select_user_connections_mobile.dart';
import '../models_user/model_requet_allusers.dart';
import 'package:intl/intl.dart';

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
  TextEditingController cttextDogumTarix = TextEditingController();
  TextEditingController cttextAd = TextEditingController();
  RxBool cttextAdError = false.obs;
  TextEditingController cttextSoyad = TextEditingController();
  RxBool cttextSoyadError = false.obs;
  TextEditingController cttextCode = TextEditingController();
  RxBool cttextCodeError = false.obs;
  TextEditingController cttextTelefon = TextEditingController();
  RxBool cttextTelefonError = false.obs;
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
  ExeptionHandler exeptionHandler=ExeptionHandler();

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
    cttextDogumTarix.text=selectedDate.value;
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
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient().dio(false).post(
        AppConstands.baseUrlsMain+"/Admin/getCompanyRegions",
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        DialogHelper.hideLoading();
        var regionlist = json.encode(response.data['Result']);
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
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient().dio(false).post(
        AppConstands.baseUrlsMain+"/Admin/getCompanyAktivRoles",
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        var userresult = json.encode(response.data['Result']);
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
      }else{
        DialogHelper.hideLoading();
        exeptionHandler.handleExeption(response);
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
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient().dio(false).get(
        AppConstands.baseUrlsMain+"/UserControl/getUserInfoByCodeAndRoleId?userCode="+cttextCode.text.toString()+"&roleId="+selectedVezife.value!.id.toString(),
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        var connections = json.encode(response.data['Result']['Connections']);
        List list = jsonDecode(connections);
        for (int i = 0; i < list.length; i++) {
          var s = jsonEncode(list.elementAt(i));
          User model = User.fromJson(jsonDecode(s));
          model.isSelected=true;
          selectedListUserConnections.add(model);
          print("selectedListUserConnections :"+selectedListUserConnections.toString());
        }
        var permitions = json.encode(response.data['Result']['Permissions']);
        List listpermissions = jsonDecode(permitions);
        for (int i = 0; i < listpermissions.length; i++) {
          ModelSelectUserPermitions model = ModelSelectUserPermitions.fromJson(listpermissions.elementAt(i));
          listModelSelectUserPermitions.add(model);
        }
        DialogHelper.hideLoading();
        getConnectionsFromApiService(controller);
      }
      else{
        DialogHelper.hideLoading();
        Get.back();
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
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient().dio(false).post(
        AppConstands.baseUrlsMain+"/Admin/getCompanyDefautRoleConnectionByRoleId?selectedRole="+selectedVezife.value!.id.toString(),
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        DialogHelper.hideLoading();
        var userresult = json.encode(response.data['Result']);
        print("Connections :" + userresult.toString());
        List list = jsonDecode(userresult);
        for (int i = 0; i < list.length; i++) {
          var s = jsonEncode(list.elementAt(i));
          ModelConnectionsTest model = ModelConnectionsTest.fromJson(jsonDecode(s));
          listGroupNameConnection.add(model);
          listGroupNameConnection.value = checkListGroupNameConnection(listGroupNameConnection);
          print("MODEL :" + model.toString());

        }
        if (listGroupNameConnection.isNotEmpty) {
          selectedGroupName.value = listGroupNameConnection.elementAt(0);
          if (selectedGroupName.value.connections!.isNotEmpty) {
            listUserConnections.value = selectedGroupName.value.connections!;
          }
        }
        getUsersPermitionsFromApi(controller);
      }else{
        DialogHelper.hideLoading();
        exeptionHandler.handleExeption(response);
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
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient().dio(false).post(
        AppConstands.baseUrlsMain+"/Admin/GetRoleDefaultPermitionsByRoleId?selectedRole="+selectedVezife.value!.id.toString(),
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
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
        var permitions = json.encode(response.data['Result']);
        print("Gelen permitionslar :"+permitions);
        List list = jsonDecode(permitions);
        for (int i = 0; i < list.length; i++) {
          //var s = jsonEncode(list.elementAt(i));
          ModelUserPermissions model = ModelUserPermissions.fromJson(list.elementAt(i));
          listPermisions.add(model);
        }
        var sehfeler=listPermisions.where((e)=>e.category==1).toList();
        var donwloadBases=listPermisions.where((e)=>e.category==2).toList();
        var hesabatlar=listPermisions.where((e)=>e.category==3).toList();
        var digetIcazeler=listPermisions.where((e)=>e.category==0).toList();
        if(sehfeler.isNotEmpty){
          listModelSelectUserPermitions.add(ModelSelectUserPermitions(
              name: "sehfeler".tr,
              id: 1,
              permissions: sehfeler
          ));

        }
        if(donwloadBases.isNotEmpty){
          listModelSelectUserPermitions.add(ModelSelectUserPermitions(
              name: "endirmeler".tr,
              id: 2,
              permissions: donwloadBases
          ));

        }
        if(hesabatlar.isNotEmpty){
          listModelSelectUserPermitions.add(ModelSelectUserPermitions(
              name: "hesabatlar".tr,
              id: 3,
              permissions: hesabatlar
          ));

        }
        if(digetIcazeler.isNotEmpty){
          listModelSelectUserPermitions.add(ModelSelectUserPermitions(
              name: "digericazeler".tr,
              id: 0,
              permissions: digetIcazeler
          ));

        }
        if (listModelSelectUserPermitions.isNotEmpty) {
          changeSelectedModelSelectUserPermitions(listModelSelectUserPermitions.first);
        }
      }
    }
    canUseNextButton.value = true;

  }

  void changeSelectedSobe(ModelUserRolesTest val) {
    selectedSobe.value = val;
    selectedVezife.value = null;
    print("selected Sobe id :"+val.id.toString());
    listVezifeler.value = val.roles ?? [];
    sobeSecildi.value = true;
    update();
  }

  void changeSelectedVezife(Role val) {
    selectedVezife.value = val;
    print("selected vezife id :"+val.id.toString());
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
        .where((elementa) => elementa.connectionRoleId == selectedVezife.value!.id)
        .toList();
    update();
  }

  List<ModelConnectionsTest> checkListGroupNameConnection( List<ModelConnectionsTest> groupList) {
    List<ModelConnectionsTest> list = [];
    for (ModelConnectionsTest element in groupList) {
      for (ModelMustConnect model in element.connections!) {
        print("ModelMustConnect connection :"+model.toString());
        print("selected group connection :"+groupList.toString());
        print("selectedVezife.value!.id :"+selectedVezife.value!.id.toString());
        if (!list.contains(element)) {
          list.add(element);

        }
      }
    }
    return list;
  }

  Future<void> getConnectionMustSelect(ModelMustConnect element) async {
    await getUserListApiService(element,true);
  }

  Future<List<User>> getUserListApiService(ModelMustConnect element,bool isWindows) async {
    List<User> listUsers = [];
    ModelRequestUsersFilter modelFilter=ModelRequestUsersFilter(
        roleId: element.connectionRoleId,
        moduleId: null,
    );
    DialogHelper.showLoading("yoxlanir".tr);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient()
          .dio(false)
          .post(AppConstands.baseUrlsMain+"/Admin/getAllUserMyModuleIdMyltyProcedure",
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
          data: modelFilter.toJson());
      if (response.statusCode == 200) {
        var userresult = json.encode(response.data['Result']);
        List list = jsonDecode(userresult);
        for (int i = 0; i < list.length; i++) {
          var s = jsonEncode(list.elementAt(i));
          int userId = jsonDecode(s)['Id'];
          int roleId = jsonDecode(s)['RoleId'];
          String roleName = jsonDecode(s)['RoleName'];
          String code = jsonDecode(s)['Code'];
          String fullName = jsonDecode(s)['Name']+" "+jsonDecode(s)['Surname'] ?? "Melumat Tapilmadi";
          User user = User(
              id: userId,
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

          Get.dialog(DialogSelectedUserConnectinsMobile(
            isWindows: isWindows,
            selectedListUsers: selectedListUserConnections,
            addConnectin: (listSelected, listDeselected) {
              addSelectedUserToList(
                  listSelected, listDeselected, selectedGroupName.value.id);
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
    DialogHelper.showLoading("yoxlanir".tr,false);
    List<ConnectionRegister> listcon = [];
    List<PermitionRegister> listper = [];
    for(var e in listPermisions){
      print("permition id :"+e.id.toString());
      listper.add(PermitionRegister(e.id!));
    }
    for (var element in selectedListUserConnections) {
      ConnectionRegister cn = ConnectionRegister(
          myAssociatedUserCode: element.code,
          myAssociatedUsersRoleId: element.roleId);
      listcon.add(cn);
    }
    registerData.value = RegisterUserModel(
        id: 0,
        name: cttextAd.text,
        permissions: listper,
        code: cttextCode.text.toString(),
        companyId: loggedUserModel.userModel!.companyId!,
        moduleId: selectedSobe.value!.id,
        roleId: selectedVezife.value!.id,
        usernameLogin: canUseWindows.value,
        surname: cttextSoyad.text,
        phone: cttextTelefon.text.toString().removeAllWhitespace,
        gender: genderSelect.value ? 0 : 1,
        fatherName: "",
        regionId: selectedRegion.value!.id,
        email: cttextEmail.text,
        deviceLogin: canUseMobile.value,
        deviceId: cttextDviceId.text,
        connections: listcon,
        birthdate: selectedDate.value,
        createrUser: loggedUserModel.userModel!.id,
        macAddress: "00wdew555151",
        username: cttextUsername.text,
        password: cttextPassword.text,
        folloginService: "true"
    );
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      final response = await ApiClient().dio(false).post(
        AppConstands.baseUrlsMain+"/Admin/RegisterByAdmin",
        data: registerData.toJson(),
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        if(response.statusCode!=null&&response.statusCode==200){
          succes=true;

        }
      }
    }

    return succes;
  }

  void callDatePickerFirst() async {
    String day = "01";
    String ay = "01";
    var order = DateTime.now();
    // if (order.day.toInt() < 10) {
    //   day = "0${order.day}";
    // } else {
    //   day = order.day.toString();
    // }
    // if (order.month.toInt() < 10) {
    //   ay = "0${order.month}";
    // } else {
    //   ay = order.month.toString();
    // }

    // selectedDate.value = "$day.$ay.${order.year}";
    selectedDate.value =  DateFormat('yyyy-MM-dd').format(order);
    cttextDogumTarix.text =  DateFormat('yyyy-MM-dd').format(order);
  }

  void callDatePicker() async {
    DateTime? order = await getDate();
    // if (order!.day.toInt() < 10) {
    //   day = "0${order.day}";
    // } else {
    //   day = order.day.toString();
    // }
    // if (order.month.toInt() < 10) {
    //   ay = "0${order.month}";
    // } else {
    //   ay = order.month.toString();
    // }
    selectedDate.value =  DateFormat('yyyy-MM-dd').format(order!);
    cttextDogumTarix.text =  DateFormat('yyyy-MM-dd').format(order);
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
        id: json["Id"],
        name: json["Name"],
        roles: json["Roles"] == null
            ? []
            : List<Role>.from(json["Roles"]!.map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "Roles": roles == null
        ? []
        : List<dynamic>.from(roles!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelUserRolesTest{id: $id, name: $name, roles: $roles}';
  }
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
    id: json["Id"],
    name: json["Name"],
    usernameLogin: json["UsernameLogin"],
    deviceLogin: json["DeviceLogin"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "UsernameLogin": usernameLogin,
    "DeviceLogin": deviceLogin,
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
        connections: json["Connections"] == null
            ? []
            : List<ModelMustConnect>.from(
            json["Connections"]!.map((x) => ModelMustConnect.fromJson(x))),
        id: json["Id"],
        name: json["Name"],
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
  int? connectionRoleId;
  String? connectionRoleName;

  ModelMustConnect({
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
        connectionRoleId: connectionRoleId ?? this.connectionRoleId,
        connectionRoleName: connectionRoleName ?? this.connectionRoleName,
      );

  factory ModelMustConnect.fromRawJson(String str) =>
      ModelMustConnect.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMustConnect.fromJson(Map<String, dynamic> json) =>
      ModelMustConnect(
        connectionRoleId: json["ConnectionRoleId"],
        connectionRoleName: json["ConnectionRoleName"],
      );

  Map<String, dynamic> toJson() => {
    "ConnectionRoleId": connectionRoleId,
    "ConnectionRoleName": connectionRoleName,
  };

  @override
  String toString() {
    return 'ModelMustConnect{ connectionRoleId: $connectionRoleId, connectionRoleName: $connectionRoleName}';
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
        permissions: json["Permitions"] == null
            ? []
            : List<ModelUserPermissions>.from(json["Permitions"]!
            .map((x) => ModelUserPermissions.fromJson(x))),
        id: json["Id"],
        name: json["Name"],
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
  int? moduleId;
  int? companyId;
  String? regionCode;
  int? regionId;
  String? deviceId;
  int? createrUser;
  String? macAddress;
  bool? deviceLogin;
  bool? usernameLogin;
  String? username;
  String? password;
  List<ConnectionRegister>? connections;
  List<PermitionRegister>? permissions;
  String? folloginService;

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
    this.moduleId,
    this.companyId,
    this.regionId,
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
    this.folloginService,
  });

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Code": code,
    "Name": name,
    "Surname": surname,
    "FatherName": fatherName,
    "Birthdate": birthdate,
    "Gender": gender,
    "Phone": phone,
    "Email": email,
    "CompanyId": companyId,
    "ModuleId": moduleId,
    "RoleId": roleId,
    "RegionId": regionId,
    "DeviceId": deviceId,
    "CreaterUser": createrUser,
    "MacAddress": macAddress,
    "DeviceLogin": deviceLogin,
    "UsernameLogin": usernameLogin,
    "Username": username,
    "Password": password,
    "FolloginService": folloginService,
    "Connections": connections?.map((e) => e.toJson()).toList(),
    "Permissions": permissions?.map((e) => e.toJson()).toList(),
  };
}

class ConnectionRegister {
  String? myAssociatedUserCode;
  int? myAssociatedUsersRoleId;


  ConnectionRegister({
    this.myAssociatedUserCode,
    this.myAssociatedUsersRoleId,

  });


  String toRawJson() => json.encode(toJson());


  Map<String, dynamic> toJson() => {
    "MyAssociatedUsersCode": myAssociatedUserCode,
    "myAssociatedUsersRoleId": myAssociatedUsersRoleId,

  };

}

class PermitionRegister {
  int? perId;

  PermitionRegister(this.perId);




  String toRawJson() => json.encode(toJson());


  Map<String, dynamic> toJson() => {
    "perId": perId,
  };

}
