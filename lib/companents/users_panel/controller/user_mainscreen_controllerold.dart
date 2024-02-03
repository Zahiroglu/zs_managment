import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/model_userconnnection.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/users_panel/models_user/model_requet_allusers.dart';
import 'package:zs_managment/companents/users_panel/services/service_excellcreate.dart';
import 'package:zs_managment/companents/users_panel/services/user_datagrid.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class UserMainScreenController extends GetxController {
  late CheckDviceType checkDviceType = CheckDviceType();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalUserServices localUserServices = LocalUserServices();
  Dio dio = Dio();
  RxBool userloadding = false.obs;
  RxBool userLisanceLoading = true.obs;
  TextEditingController ctSearch = TextEditingController();
  RxBool openUserInfoTable = false.obs;
  late RxList<UserModel>? listUsers = RxList<UserModel>();
  Rx<ModelAllUsersLisance> selectedModelAllUsersLisance = ModelAllUsersLisance().obs;
  late RxList<ModelAllUsersLisanceUserCount> listModelAllUsersLisanceUserCount = RxList<ModelAllUsersLisanceUserCount>();
  RxBool infodashbourdVisible = true.obs;
  ServiceExcell serviceExcell = ServiceExcell();
  UserModel selectedUser = UserModel();
  RxInt greateCountInList=4.obs;

  UserModel getSelectedUser() => selectedUser;

  @override
  void onInit() {
    localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    getTotalInfoUsersFromApiService();
    super.onReady();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void getTotalInfoUsersFromApiService()async{
    listModelAllUsersLisanceUserCount.value=[];
    DialogHelper.showLoading("Melumatlar yoxlanir");
    infodashbourdVisible.value=false;
    userLisanceLoading.value=true;
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      userLisanceLoading.value=false;
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
      try {
        final response = await ApiClient().dio().get(
          "${loggedUserModel.baseUrl}/api/v1/User/user-counts",
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
           userLisanceLoading.value=false;
           selectedModelAllUsersLisance.value=ModelAllUsersLisance.fromJson(response.data['result']);
           listModelAllUsersLisanceUserCount.value=  selectedModelAllUsersLisance.value.userCounts!;
        } else if (response.statusCode == 404) {
          userLisanceLoading.value=false;
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: "baglantierror".tr,
            callback: () {
              Get.back();
            },
          ));
        } else {
          if (response.statusCode == 401) {
            userLisanceLoading.value=false;
            DialogHelper.hideLoading();
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: "${response.statusCode}-${response.data.toString()}",
              callback: () {
                Get.back();
              },
            ));
            Get.back();
          }
          userLisanceLoading.value=false;
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: "${response.statusCode}-${response.data.toString()}",
            callback: () {
              Get.back();
            },
          ));
        }
      } on DioException catch (e) {
        userLisanceLoading.value=false;
        DialogHelper.hideLoading();
        if (e.type == DioExceptionType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              Get.back();
            },
          ));
          //dataLoading.value = false;
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.type.toString() ?? "xeta".tr,
            callback: () {},
          ));
        }
      }
    }
    List<ModelAllUsersItemsLisance>list=[];
    if(selectedModelAllUsersLisance.value.userCounts!=null){
    for (var element in selectedModelAllUsersLisance.value.userCounts!) {
      ModelAllUsersItemsLisance count=ModelAllUsersItemsLisance(
        roleName: element.name,
        totalCount: element.userCounts!.fold<int>(0, (sum, element) => sum+element.totalCount!),
        usedCount:  element.userCounts!.fold<int>(0, (sum, element) => sum+element.usedCount!)
      );
      list.add(count);
    }}
    ModelAllUsersLisanceUserCount totalModel=ModelAllUsersLisanceUserCount(
      name: "usercount".tr,
      id: -1,
      userCounts: list
    );
    listModelAllUsersLisanceUserCount.insert(0, totalModel);
    for (var element in listModelAllUsersLisanceUserCount.value) {
      if(element.userCounts!.length>greateCountInList.value){
        greateCountInList.value=element.userCounts!.length;
      }
    }
    userLisanceLoading.value=false;
    infodashbourdVisible.value=true;
    update();
  }


  void exportUsersDataGridToExcel(GlobalKey<SfDataGridState> key) {
    serviceExcell.exportUsersDataGridToExcel(key);
    update();
  }

  changeSelectedUser(UserModel model) {
    selectedUser = model;
    print("Selected User :"+model.toString());
    update();
  }

  Future<void> getAllUsersDataByParams(ModelAllUsersLisanceUserCount element) async {
    listUsers!.clear();
    userloadding.value = true;
    infodashbourdVisible.value = false;
    DialogHelper.showLoading("loading");
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      userLisanceLoading.value=false;
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
      try {
        final response = await ApiClient().dio().get(
          "${loggedUserModel.baseUrl}/api/v1/User/all-users",
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
          var userlist = json.encode(response.data['result']);
          print("userlist :"+userlist.toString());
          List list = jsonDecode(userlist);
          for(var i in list){
            UserModel model=UserModel.fromJson(i);
            listUsers!.add(model);
          }

        }
      } on DioException catch (e) {
        userLisanceLoading.value=false;
        DialogHelper.hideLoading();
        if (e.type == DioExceptionType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              Get.back();
            },
          ));
          //dataLoading.value = false;
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.type.toString() ?? "xeta".tr,
            callback: () {},
          ));
        }
      }
    }

    DialogHelper.hideLoading();
    userloadding.value = false;
    update();
  }

  Future<void> getAllUsersByParams(ModelRequestUsersFilter element) async {
    openUserInfoTable.value=false;
    listUsers!.clear();
    userloadding.value = true;
    infodashbourdVisible.value = false;
    DialogHelper.showLoading("loading");
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      userLisanceLoading.value=false;
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "Internet baglanti problemi",
        callback: () {
          Get.back();
        },
      ));
    } else {
      try {
        final response = await ApiClient().dio().post(
          "${loggedUserModel.baseUrl}/api/v1/User/users-by-filter",
         data: element.toJson(),
          //data: data,
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
          var userlist = json.encode(response.data['result']);
          print("userlist :"+userlist.toString());
          List list = jsonDecode(userlist);
          for(var i in list){
            UserModel model=UserModel.fromJson(i);
            listUsers!.add(model);
          }

        }
      } on DioException catch (e) {
        userLisanceLoading.value=false;
        DialogHelper.hideLoading();
        if (e.type == DioExceptionType.connectionTimeout) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.message!,
            callback: () {
              Get.back();
            },
          ));
          //dataLoading.value = false;
        } else {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error_outline,
            messaje: e.type.toString() ?? "xeta".tr,
            callback: () {},
          ));
        }
      }
    }

    DialogHelper.hideLoading();
    userloadding.value = false;
    update();
  }

  void deleteUser(UserModel selectedUser) {
    listUsers!.remove(selectedUser);
    getTotalInfoUsersFromApiService();
    update();
  }
  void updateAllValues(){
    getTotalInfoUsersFromApiService();
    getAllUsersByParams(ModelRequestUsersFilter());
    update();
  }
}

class ModelAllUsersLisance {
  int? totalCount;
  int? totalRemainder;
  List<ModelAllUsersLisanceUserCount>? userCounts;

  ModelAllUsersLisance({
    this.totalCount,
    this.totalRemainder,
    this.userCounts,
  });

  ModelAllUsersLisance copyWith({
    int? totalCount,
    int? totalRemainder,
    List<ModelAllUsersLisanceUserCount>? userCounts,
  }) =>
      ModelAllUsersLisance(
        totalCount: totalCount ?? this.totalCount,
        totalRemainder: totalRemainder ?? this.totalRemainder,
        userCounts: userCounts ?? this.userCounts,
      );

  factory ModelAllUsersLisance.fromRawJson(String str) => ModelAllUsersLisance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelAllUsersLisance.fromJson(Map<String, dynamic> json) => ModelAllUsersLisance(
    totalCount: json["totalCount"],
    totalRemainder: json["totalRemainder"],
    userCounts: json["userCounts"] == null ? [] : List<ModelAllUsersLisanceUserCount>.from(json["userCounts"]!.map((x) => ModelAllUsersLisanceUserCount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalRemainder": totalRemainder,
    "userCounts": userCounts == null ? [] : List<dynamic>.from(userCounts!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ModelAllUsersLisance{totalCount: $totalCount, totalRemainder: $totalRemainder, userCounts: $userCounts}';
  }
}

class ModelAllUsersLisanceUserCount {
  List<ModelAllUsersItemsLisance>? userCounts;
  int? id;
  String? name;

  ModelAllUsersLisanceUserCount({
    this.userCounts,
    this.id,
    this.name
  });

  ModelAllUsersLisanceUserCount copyWith({
    List<ModelAllUsersItemsLisance>? userCounts,
    int? id,
    String? name,
  }) =>
      ModelAllUsersLisanceUserCount(
        userCounts: userCounts ?? this.userCounts,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ModelAllUsersLisanceUserCount.fromRawJson(String str) => ModelAllUsersLisanceUserCount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelAllUsersLisanceUserCount.fromJson(Map<String, dynamic> json) => ModelAllUsersLisanceUserCount(
    userCounts: json["userCounts"] == null ? [] : List<ModelAllUsersItemsLisance>.from(json["userCounts"]!.map((x) => ModelAllUsersItemsLisance.fromJson(x))),
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "userCounts": userCounts == null ? [] : List<dynamic>.from(userCounts!.map((x) => x.toJson())),
    "id": id,
    "name": name,
  };

  @override
  String toString() {
    return 'ModelAllUsersLisanceUserCount{userCounts: $userCounts, id: $id, name: $name}';
  }
}

class ModelAllUsersItemsLisance {
  int? roleId;
  String? roleName;
  int? usedCount;
  int? remainderCount;
  int? totalCount;
  int? countLimit;
  bool? newUserAccess;

  ModelAllUsersItemsLisance({
    this.roleId,
    this.roleName,
    this.usedCount,
    this.remainderCount,
    this.totalCount,
    this.countLimit,
    this.newUserAccess,
  });

  ModelAllUsersItemsLisance copyWith({
    int? roleId,
    String? roleName,
    int? usedCount,
    int? remainderCount,
    int? totalCount,
    int? countLimit,
    bool? newUserAccess,
  }) =>
      ModelAllUsersItemsLisance(
        roleId: roleId ?? this.roleId,
        roleName: roleName ?? this.roleName,
        usedCount: usedCount ?? this.usedCount,
        remainderCount: remainderCount ?? this.remainderCount,
        totalCount: totalCount ?? this.totalCount,
        countLimit: countLimit ?? this.countLimit,
        newUserAccess: newUserAccess ?? this.newUserAccess,
      );

  factory ModelAllUsersItemsLisance.fromRawJson(String str) => ModelAllUsersItemsLisance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelAllUsersItemsLisance.fromJson(Map<String, dynamic> json) => ModelAllUsersItemsLisance(
    roleId: json["roleId"],
    roleName: json["roleName"],
    usedCount: json["usedCount"],
    remainderCount: json["remainderCount"],
    totalCount: json["totalCount"],
    countLimit: json["countLimit"],
    newUserAccess: json["newUserAccess"],
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "roleName": roleName,
    "usedCount": usedCount,
    "remainderCount": remainderCount,
    "totalCount": totalCount,
    "countLimit": countLimit,
    "newUserAccess": newUserAccess,
  };

  @override
  String toString() {
    return 'ModelAllUsersItemsLisance{roleId: $roleId, roleName: $roleName, usedCount: $usedCount, remainderCount: $remainderCount, totalCount: $totalCount, countLimit: $countLimit, newUserAccess: $newUserAccess}';
  }
}
