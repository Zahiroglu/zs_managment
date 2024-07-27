import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_inout.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/model_merc_customers_edit.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import '../../../dio_config/api_client.dart';
import '../../../helpers/dialog_helper.dart';
import '../../../helpers/exeption_handler.dart';
import '../../../helpers/user_permitions_helper.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../base_downloads/models/model_downloads.dart';
import '../../giris_cixis/sceens/reklam_girisCixis/controller_giriscixis_reklam.dart';
import '../../local_bazalar/local_db_downloads.dart';
import 'connected_users/model_main_inout.dart';
import 'package:intl/intl.dart' as intl;

class ControllerMercPref extends GetxController {
  RxList<MercCustomersDatail> listMercBaza = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<MercCustomersDatail> listRutGunleri = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<MercCustomersDatail> listZiyeretEdilmeyenler = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<ModelMainInOut> modelInOut = List<ModelMainInOut>.empty(growable: true).obs;
  RxList<ModelInOut> listGirisCixislar = List<ModelInOut>.empty(growable: true).obs;
  RxList<ModelInOutDay> listGunlukGirisCixislar = List<ModelInOutDay>.empty(growable: true).obs;
  RxList<UserModel> listUsers = List<UserModel>.empty(growable: true).obs;
  Rx<MercDataModel> selectedMercBaza=MercDataModel().obs;
  Rx<MercCustomersDatail> selectedCustomers=MercCustomersDatail().obs;
  RxList<ModelTamItemsGiris> listTabItems = List<ModelTamItemsGiris>.empty(growable: true).obs;
  RxList<Widget> listPagesHeader = List<Widget>.empty(growable: true).obs;
  String totalIsSaati="0";
  String hefteninGunu = "";
  bool userHasPermitionEditRutSira=true;
  LocalUserServices userLocalService=LocalUserServices();
  LoggedUserModel loggedUserModel=LoggedUserModel();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler=ExeptionHandler();
  UserPermitionsHelper userPermitionSercis = UserPermitionsHelper();
  String languageIndex = "az";



  @override
  Future<void> onInit() async {
    await userLocalService.init();
    await localBaseDownloads.init();
    loggedUserModel=userLocalService.getLoggedUser();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    Get.delete<ControllerMercPref>();
    // TODO: implement dispose
    super.dispose();
  }


  ////umumi cariler hissesi
  Future<void> getAllCariler(MercDataModel model, List<ModelMainInOut> listGirisCixis,List<UserModel> listUser)async {
    listRutGunleri.clear();
    modelInOut.clear();
    listZiyeretEdilmeyenler.clear();
    listMercBaza.clear();
    listTabItems.clear();
    ////////////////////////
    selectedMercBaza.value=model;
    modelInOut.value=listGirisCixis;
    if(listGirisCixis.isNotEmpty){
      for (var element in modelInOut.first.modelInOutDays) {
        listGunlukGirisCixislar.add(element);
      }
      for (var element in listGunlukGirisCixislar) {
        listGirisCixislar.addAll(element.modelInOut);
      }
    }
    listUsers.value=listUser;
    listMercBaza.clear();
    for (MercCustomersDatail model in model.mercCustomersDatail!) {
      model.ziyaretSayi = listGirisCixislar.where((a) => a.customerCode==model.code).toList().length;
      model.sndeQalmaVaxti = curculateTimeDistanceForVisit(listGirisCixislar.where((e) => e.customerCode == model.code).toList());
      listMercBaza.add(model);
    }
    listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==1)).toList();
    listZiyeretEdilmeyenler.value = listMercBaza.where((p0) => p0.ziyaretSayi==0).toList();
    listTabItems.value = [
      ModelTamItemsGiris(
          icon: Icons.list_alt,
          color: Colors.green,
          label: "umumiMusteri".tr,
          selected: true,
          keyText: "um"),
      ModelTamItemsGiris(
          icon: Icons.calendar_month,
          color: Colors.green,
          label: "rutgunleri".tr,
          selected: false,
          keyText: "rh"),
    ];
    if(listGirisCixis.isNotEmpty){
    if(listZiyeretEdilmeyenler.isNotEmpty){
      listTabItems.add(ModelTamItemsGiris(
          icon: Icons.visibility_off_outlined,
          color: Colors.green,
          label: "ziyaretEdilmeyen".tr,
          selected: false,
          keyText: "zem"));
    }
    listTabItems.add(ModelTamItemsGiris(
        icon: Icons.share_arrival_time,
        color: Colors.green,
        label: "ziyaretTarixcesi".tr,
        selected: false,
        keyText: "um"
    ));}
    melumatlariGuneGoreDoldur();
    update();
  }

  void melumatlariGuneGoreDoldur() {
    DateTime dateTime = DateTime.now();
    switch (dateTime.weekday) {
      case 1:
        hefteninGunu = "gun1";
        break;
      case 2:
        hefteninGunu = "gun2";
        break;
      case 3:
        hefteninGunu = "gun3";
        break;
      case 4:
        hefteninGunu = "gun4";
        break;
      case 5:
        hefteninGunu = "gun5";
        break;
      case 6:
        hefteninGunu = "gun6";
        break;
    }
    changeRutGunu(dateTime.weekday);
    update();

  }


  String curculateTimeDistanceForVisit(List<ModelInOut> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
      if(element.outDate!=null) {
        difference = difference +
            DateTime.parse(element.outDate.toString()).difference(
                DateTime.parse(element.inDate.toString()));
      }
    }
    hours = hours + difference.inHours % 24;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      totalIsSaati="$minutes deq";
      return "$minutes deq";
    } else {
      totalIsSaati="$hours saat $minutes deq";
      return "$hours saat $minutes deq";

    }
  }


  String prettify(double d) {
    return d.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');
  }


  /// rut gunleri hissesi////

  String prettifya(String d) {
    return d.substring(0).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void changeRutGunu(int tr) {
    listRutGunleri.clear();
    switch (tr) {
      case 1:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==1)).toList();
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,1);
        break;
      case 2:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==2)).toList();
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,2);
        break;
      case 3:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==3)).toList();
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,3);
        break;
      case 4:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==4)).toList();
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,4);
        break;
      case 5:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==5)).toList();
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,5);
        break;
      case 6:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==6)).toList();
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,6);
        break;
    }
    update();
  }

  List<MercCustomersDatail> sortListByDayOrderNumber(List<MercCustomersDatail> listRutGunleri,int rutgunu) {
    List<MercCustomersDatail> newList = [];
    final Map<String, MercCustomersDatail> profileMap = {};
    for (var item in listRutGunleri) {
      profileMap[item.days!
          .where((element) => element.day == rutgunu)
          .first
          .orderNumber
          .toString()] = item;
    }
    var mapEntries = profileMap.entries.toList()
      ..sort(((a, b) => a.key.compareTo(b.key)));
    profileMap
      ..clear()
      ..addEntries(mapEntries);
    for (var element in profileMap.values) {
        newList.add(element);
    }
    return newList;
  }

  void intentMercCustamersDatail(MercCustomersDatail element, bool rutSirasiGorunsun) {
    selectedCustomers.value=element;
    Get.toNamed(RouteHelper.screenMercMusteriDetail,arguments: [this]);
  update();
  }

  void updateData(ModelUpdateMercCustomers modelUpdateMercCustomers, bool mustDelate, List<SellingData> selectedSellingDatas) {
    if(mustDelate){
       listMercBaza.removeWhere((element) => element.code==modelUpdateMercCustomers.customerCode);
      listRutGunleri.removeWhere((element) => element.code==modelUpdateMercCustomers.customerCode);
    }else{
      MercCustomersDatail model=listMercBaza.where((p) => p.code==modelUpdateMercCustomers.customerCode).first;
      listRutGunleri.remove(model);
      listMercBaza.remove(model);
      for (var element in selectedSellingDatas) {
        model.sellingDatas!.removeWhere((e) => e.forwarderCode==element.forwarderCode);
      }
      model.totalPlan=model.sellingDatas!.fold(0, (sum, element) => sum!+element.plans);
      model.totalSelling=model.sellingDatas!.fold(0, (sum, element) => sum!+element.selling);
      model.totalRefund=model.sellingDatas!.fold(0, (sum, element) => sum!+element.refund);
      listMercBaza.add(model);
      listRutGunleri.add(model);
      selectedCustomers.value=model;
    }
    update();
  }

  void getNewDatasFromServer(BuildContext context) {
    showMonthPicker(context,
        onSelected: (month, year) async {
          List<MercDataModel> data=await getAllMercCariBazaMotivasiya(month,year);
          List<ModelMainInOut> girisCixislar=await getAllGirisCixis(year,month);
          if(data.isNotEmpty){
            ModelDownloads model= ModelDownloads(
                name: "currentBase".tr,
                donloading: false,
                code: "enter",
                info: "currentBaseExplain".tr,
                lastDownDay: DateTime.now().toIso8601String(),
                musteDonwload: false);
            await localBaseDownloads.addDownloadedBaseInfo(model);
            await localBaseDownloads.addAllToMercBase(data);
            await getAllCariler(data.first,girisCixislar,listUsers);
          }
        },
        initialSelectedMonth: DateTime.now().month,
        initialSelectedYear: DateTime.now().year,
        firstEnabledMonth: 12,
        lastEnabledMonth: DateTime.now().month,
        firstYear: 2015,
        lastYear: DateTime.now().year,
        selectButtonText: 'OK',
        cancelButtonText: 'Cancel',
        highlightColor: Colors.blue,
        textColor: Colors.white,
        contentBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white
    );
  }

  Future<List<MercDataModel>> getAllMercCariBazaMotivasiya(int month, int year) async {
    List<MercDataModel> listUsers = [];
    List<UserModel> listConnectedUsers = [];
    languageIndex = await getLanguageIndex();
    DialogHelper.showLoading("cmendirilir",false);
    List<String> secilmisTemsilciler = [];
    await localBaseDownloads.init();
    LoggedUserModel loggedUserModel = userLocalService.getLoggedUser();
    List<UserModel> listUsersSelected =
    localBaseDownloads.getAllConnectedUserFromLocal();
    if (listUsersSelected.isEmpty) {
      secilmisTemsilciler.add(loggedUserModel.userModel!.code!);
    } else {
      for (var element in listUsersSelected) {
        secilmisTemsilciler.add(element.code!);
      }
    }
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      var response;
      if (userPermitionSercis.hasUserPermition(UserPermitionsHelper.canEnterOtherMerchCustomers,
          loggedUserModel.userModel!.permissions!)) {
        response = await ApiClient().dio(false).get(
          "${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-my-region",
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
      } else {
        response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-merch",
          data: jsonEncode(secilmisTemsilciler),
          options: Options(
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
      }
      if (response.statusCode == 200) {
        var dataModel = json.encode(response.data['result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          listUsers.add(MercDataModel.fromJson(i));
          listConnectedUsers.add(UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            code: MercDataModel.fromJson(i).user!.code,
            name: MercDataModel.fromJson(i).user!.name,
            gender: 0,
          ));
        }
      }
    }
    await localBaseDownloads.addConnectedUsers(listConnectedUsers);
    return listUsers;
  }

  Future<List<ModelMainInOut>> getAllGirisCixis(int year,int month) async {
    List<ModelMainInOut> listUsers = [];
    var date = DateTime(year, month, 1).toString();
    var date2 = DateTime(year, month, DateTime.now().day).toString();
    DateTime dateParse = DateTime.parse(date);
    DateTime dateParse2 = DateTime.parse(date2);
    String ilkGun = intl.DateFormat('yyyy/MM/dd').format(dateParse);
    String songun = intl.DateFormat('yyyy/MM/dd').format(dateParse2);
    LoggedUserModel loggedUserModel = userLocalService.getLoggedUser();
    ModelRequestInOut model=ModelRequestInOut(
        userRole: [UserRole(code: selectedMercBaza.value.user!.code, role: "23")],
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
        final response = await ApiClient().dio(false).post(
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
    DialogHelper.hideLoading();

    return listUsers;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
