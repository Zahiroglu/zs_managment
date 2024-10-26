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
import 'package:zs_managment/companents/users_panel/mobile/dialog_select_user_connections_mobile.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:intl/intl.dart';
import '../../login/models/model_userconnnection.dart';
import '../models_user/model_requet_allusers.dart';

class UpdateUserController extends GetxController {
  Rx<UserModel> selectedUserModel = UserModel().obs;
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
  RxList<PermitionRegister> listPermisionsForSend = List<PermitionRegister>.empty(growable: true).obs;
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
  ExeptionHandler exeptionHandler=ExeptionHandler();

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
        selectedRegion.value=listRegionlar.firstWhere((e)=>e.code==selectedUserModel.value.regionCode!);
        if(selectedRegion.value!=null){
          regionSecildi.value=true;
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
          ModelUserRolesTest model =
          ModelUserRolesTest.fromJson(jsonDecode(s));
          if (selectedUserModel.value.moduleId == model.id) {
            sobeSecildi.value = true;
            selectedSobe.value = model;
          }
          listSobeler.add(model);
        }
        if( listSobeler.where((element) => element.id == selectedUserModel.value.moduleId).isNotEmpty){
          ModelUserRolesTest modela = listSobeler.where((element) => element.id == selectedUserModel.value.moduleId).first;
          listVezifeler.value = modela.roles!;}
        if (listVezifeler.where((x) => x.id == selectedUserModel.value.roleId).isNotEmpty) {
          selectedVezife.value = listVezifeler
              .where((x) => x.id == selectedUserModel.value.roleId)
              .first;
          vezifeSecildi.value = true;
          canUserMobilePermitions.value = selectedVezife.value!.deviceLogin!;
          canUserWindowsPermitions.value = selectedVezife.value!.usernameLogin!;
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
        // var userresult = json.encode(response.data['Result']);
        // List list = jsonDecode(userresult);
        // for (int i = 0; i < list.length; i++) {
        //   var s = jsonEncode(list.elementAt(i));
        //   ModelUserRolesTest model = ModelUserRolesTest.fromJson(jsonDecode(s));
        //   listSobeler.add(model);
        // }
        // selectedSobe.value=listSobeler.firstWhere((e)=>e.id==selectedUserModel.value.moduleId!);
        // if(selectedSobe.value!=null){
        //   sobeSecildi.value=true;
        //   listVezifeler.value=selectedSobe.value!.roles!;
        //   selectedVezife.value=selectedSobe.value!.roles!.firstWhere((w)=>w.id==selectedUserModel.value.roleId!);
        //   if(selectedVezife.value!=null){
        //     vezifeSecildi.value=true;
        //     canUserMobilePermitions.value = selectedVezife.value!.deviceLogin!;
        //     canUserWindowsPermitions.value = selectedVezife.value!.usernameLogin!;
        //     canUseNextButton.value = true;
        //   }
        //  }
        // //regionSecilmelidir.value = true;
        // incrementCustomStepper(controller);
        // canUseNextButton.value = false;
        // DialogHelper.hideLoading();
      }else{
        DialogHelper.hideLoading();
        exeptionHandler.handleExeption(response);
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
      }
      else {
        getRegionsFromApiService(controller);
      }
    }
    update();
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
          if(model.code!=null){

          }

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
        List list = jsonDecode(userresult);
        for (int i = 0; i < list.length; i++) {
          var s = jsonEncode(list.elementAt(i));
          ModelConnectionsTest model = ModelConnectionsTest.fromJson(jsonDecode(s));
          listGroupNameConnection.add(model);
          //checkListGroupNameConnection(listGroupNameConnection);
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

  Future<void> getUsersPermitionsFromApi(PageController controller) async {
    listPermisions.value=[];
    listModelSelectUserPermitions.value=[];
    selectedModulPermitions.value=ModelSelectUserPermitions();
    DialogHelper.showLoading("Icaze melumatlari axtarilir".tr);
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
          var elemntVal=selectedUserModel.value.permissions!.any((el)=>el.id==model.id);
          var elementVal2=selectedUserModel.value.draweItems!.any((el)=>el.id==model.id);
          print("selected user: "+selectedUserModel.toString());
          print("selected userin permitionlari : "+selectedUserModel.value.permissions.toString());
          print("axtarilan element id : "+model.id.toString());
          print("axtarilan element userde var? : "+elemntVal.toString());
          model.val=elemntVal||elementVal2?1:0;
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

        if(selectedUserModel.value.roleId==selectedVezife.value!.id) {
          for (var element in selectedUserModel.value.permissions!) {
            listPermisions.where((p) => p.id == element.id).first.val = element.val;
          }
        }
        else{
          if(listModelSelectUserPermitions.isNotEmpty) {
            listPermisions.value =
            listModelSelectUserPermitions.first.permissions!;
            selectedPermitions.value =
            listModelSelectUserPermitions.first.permissions!;
            selectedModulPermitions.value = listModelSelectUserPermitions.first;
          }}


        // DialogHelper.hideLoading();
        // incrementCustomStepper(controller);
        // var permitions = json.encode(response.data['Result']);
        // print("Gelen permitionslar :"+permitions);
        //
        // List list = jsonDecode(permitions);
        // for (int i = 0; i < list.length; i++) {
        //   //var s = jsonEncode(list.elementAt(i));
        //   ModelSelectUserPermitions model = ModelSelectUserPermitions.fromJson(list.elementAt(i));
        //   for (var element in model.permissions!) {
        //     listPermisions.add(element);
        //   }
        //   listModelSelectUserPermitions.add(model);
        // }
        // if (listModelSelectUserPermitions.isNotEmpty) {
        //   changeSelectedModelSelectUserPermitions(listModelSelectUserPermitions.first);
        // }
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
    listUserConnections.value = element.connections!;
    update();
  }

  void checkListGroupNameConnection(List<ModelConnectionsTest> groupList) {
    for (ModelConnectionsTest element in groupList) {
      for(ModelMustConnect model in element.connections!){
        List<ModelUserConnection> listConnected=selectedUserModel.value.connections!.where((el)=>el.roleId==model.connectionRoleId).toList();
        for (var e in listConnected) {
          if(!selectedListUserConnections.contains(User(
              id:  e.userId,
              roleId:  e.roleId,
              roleName:  e.roleName,
              code: e.code,
              fullName: e.fullName,
              isSelected: true,
              modulCode: element.name

          ))) {
            selectedListUserConnections.add(User(
                id: e.userId,
                roleId: e.roleId,
                roleName: e.roleName,
                code: e.code,
                fullName: e.fullName,
                isSelected: true,
                modulCode: element.name

            ));
          }
        }

      }
      print("selected Model: "+element.toString());
    }

    update();
  }

  Future<void> getConnectionMustSelect(ModelMustConnect element, bool isWindows) async {
    await getUserListApiService(element,isWindows);
  }

  Future<List<User>> getUserListApiService(ModelMustConnect element, bool isWindows) async {
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
        if(isWindows) {
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
        }else{
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

        }}
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
      var contain = selectedListUserConnections.where((element2) => element2.id == element.id);
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
    print("Model per :"+e.toString());
    update();
  }


  Future<bool> updateUserEndpoint() async {
    bool succes=false;
    DialogHelper.showLoading("yoxlanir".tr,false);
    List<ConnectionRegister> listcon = [];
    List<PermitionRegister> listper = [];
    for(var e in listPermisions){
      if(e.val==1) {
        listper.add(PermitionRegister(e.id!));
      }}
    for (var element in selectedListUserConnections) {
      ConnectionRegister cn = ConnectionRegister(
          myAssociatedUserCode: element.code,
          myAssociatedUsersRoleId: element.roleId);
      listcon.add(cn);
    }
    RegisterUserModel registerData = RegisterUserModel(
        id: selectedUserModel.value.id,
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
        birthdate: cttextDogumTarix.text.trim(),
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
        AppConstands.baseUrlsMain+"/Admin/UpdateByAdminMain",
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
          Get.dialog(ShowInfoDialog(
            color: Colors.blue,
            icon: Icons.verified,
            messaje: response.data['Result'],
            callback: () {
              Get.back();
              succes=true;
              Get.back();
            },
          ));
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

  void addSelecTedUser(UserModel model) {
    selectedUserModel.value = model;
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
    print("Selected users connectoons :"+model.connections.toString());
    for (var element in model.connections!) {
      User userS = User(
          id: element.userId,
          fullName: element.fullName,
          code: element.code,
          isSelected: true,
          modulCode: "",
          roleName: element.roleName,
          roleId: element.roleId);
      selectedListUserConnections.add(userS);
    }
    print("ufter add selected : "+selectedListUserConnections.toString());
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
