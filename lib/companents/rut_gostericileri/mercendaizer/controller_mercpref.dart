import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_inout.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
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
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  RxInt rutGunu=0.obs;
  RxBool dataLoading=true.obs;
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
  Future<void> getAllCariler( MercDataModel model, List<ModelMainInOut> listGirisCixis,List<UserModel> listUser) async {
    totalIsSaati="";
    dataLoading.value=true;
    // Siyahıları təmizləyirik
    listRutGunleri.clear();
    //listUsers.clear();
    modelInOut.clear();
    listZiyeretEdilmeyenler.clear();
    listMercBaza.clear();
    listGunlukGirisCixislar.clear();
    listGirisCixislar.clear();
// Tab elementlərini təyin edirik
    listTabItems.clear();
    listTabItems.value = [
      ModelTamItemsGiris(
        icon: Icons.list_alt,
        color: Colors.green,
        label: "umumiMusteri".tr,
        selected: true,
        keyText: "um",
      ),
      ModelTamItemsGiris(
        icon: Icons.calendar_month,
        color: Colors.green,
        label: "rutgunleri".tr,
        selected: false,
        keyText: "rh",
      ),
      ModelTamItemsGiris(
        icon: Icons.visibility_off_outlined,
        color: Colors.green,
        label: "ziyaretEdilmeyen".tr,
        selected: false,
        keyText: "zem",
      ),
      ModelTamItemsGiris(
        icon: Icons.share_arrival_time,
        color: Colors.green,
        label: "ziyaretTarixcesi".tr,
        selected: false,
        keyText: "um",
      ),

    ];
    // Model dəyərlərini yenidən təyin edirik
    selectedMercBaza.value = model;
    // Giriş-çıxış siyahısı boş deyilsə
    if (listGirisCixis.isNotEmpty) {
      modelInOut.value = listGirisCixis;
      // Giriş-çıxış günlərini əlavə edirik
      listGunlukGirisCixislar.addAll(modelInOut.first.modelInOutDays);
      // Günlük giriş-çıxış siyahısını doldururuq
      for (var element in listGunlukGirisCixislar) {
        listGirisCixislar.addAll(element.modelInOut);
      }
    }
    // İstifadəçilərin siyahısını təyin edirik
   // listUsers.value = listUser;
    // Müştərilərin ziyarət məlumatlarını yeniləyirik
    for (MercCustomersDatail model in model.mercCustomersDatail!) {
      model.ziyaretSayi = listGirisCixislar
          .where((a) => a.customerCode == model.code)
          .length;
      model.sndeQalmaVaxti = curculateTimeDistanceForVisit(listGirisCixislar
          .where((e) => e.customerCode == model.code)
          .toList());
      listMercBaza.add(model);
    }
    // Rut günlərini təyin edirik
    listRutGunleri.value = listMercBaza
        .where((p0) => p0.days!.any((element) => element.day == 1))
        .toList();

    // Ziyarət edilməyən müştəriləri təyin edirik
    listZiyeretEdilmeyenler.value =listMercBaza.where((p0) => p0.ziyaretSayi == 0).toList();


    // Əgər giriş-çıxışlar varsa, ziyarət edilməyənlər üçün əlavə tab yaradırıq
    // if (listGirisCixis.isNotEmpty) {
    //   if (listZiyeretEdilmeyenler.isNotEmpty) {
    //     listTabItems.add(
    //       ModelTamItemsGiris(
    //         icon: Icons.visibility_off_outlined,
    //         color: Colors.green,
    //         label: "ziyaretEdilmeyen".tr,
    //         selected: false,
    //         keyText: "zem",
    //       ),
    //     );
    //   }
    //   listTabItems.add(
    //     ModelTamItemsGiris(
    //       icon: Icons.share_arrival_time,
    //       color: Colors.green,
    //       label: "ziyaretTarixcesi".tr,
    //       selected: false,
    //       keyText: "um",
    //     ),
    //   );
    // }

    // Günə görə məlumatları doldururuq
    melumatlariGuneGoreDoldur();
    // UI yenilənməsi üçün çağırış
    dataLoading.value=false;
    update();
  }

  ////

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

  String prettifya(String d) {
    return d.substring(0).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  Future<void> changeRutGunu(int tr) async {
    await userLocalService.init();
    loggedUserModel=userLocalService.getLoggedUser();
    listRutGunleri.clear();
    switch (tr) {
      case 1:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==1)).toList();
        if(userPermitionSercis.onlyByRutOrderNumber(loggedUserModel.userModel!.configrations!)){
        listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,1);}
        break;
      case 2:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==2)).toList();
        if(userPermitionSercis.onlyByRutOrderNumber(loggedUserModel.userModel!.configrations!)){
          listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,2);}
        break;
      case 3:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==3)).toList();
        if(userPermitionSercis.onlyByRutOrderNumber(loggedUserModel.userModel!.configrations!)){
          listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,3);}
        break;
      case 4:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==4)).toList();
        if(userPermitionSercis.onlyByRutOrderNumber(loggedUserModel.userModel!.configrations!)){
          listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,4);}
        break;
      case 5:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==5)).toList();
        if(userPermitionSercis.onlyByRutOrderNumber(loggedUserModel.userModel!.configrations!)){
          listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,5);}
        break;
      case 6:
        listRutGunleri.value = listMercBaza.where((p0) => p0.days!.any((element) => element.day==6)).toList();
        if(userPermitionSercis.onlyByRutOrderNumber(loggedUserModel.userModel!.configrations!)){
          listRutGunleri.value=sortListByDayOrderNumber(listRutGunleri,6);}
        break;
    }
    update();
  }

  List<MercCustomersDatail> sortListByDayOrderNumber(List<MercCustomersDatail> listRutGunleri,int rutgunu) {
    List<MercCustomersDatail> newList = [];
    final Map<String, MercCustomersDatail> profileMap = {};
    for (var item in listRutGunleri) {
      var matchingDays = item.days!.where((element) => element.day == rutgunu);
      for (var day in matchingDays) {
        // Check if the orderNumber key already exists in profileMap
        if (!profileMap.containsKey((day.orderNumber).toString())) {
          profileMap[(day.orderNumber).toString()] = item;
        }else{
          profileMap[(day.orderNumber+1).toString()] = item;
        }
      }
      // var matchingDays = item.days!.where((element) => element.day == rutgunu);
      // // Add each matching day to the map
      // if(profileMap.containsKey(matchingDays)){
      // for (var day in matchingDays) {
      //   profileMap[(day.orderNumber+1).toString()] = item;
      // }}
    }

    var mapEntries = profileMap.entries.toList()
      ..sort(((a, b) => a.key.compareTo(b.key)));
    profileMap
      ..clear()
      ..addEntries(mapEntries);
    print("Profile map :"+profileMap.toString());

    for (var element in profileMap.values) {
      print("Market : "+element.name.toString()+" Days :" +element.days.toString());
        newList.add(element);
    }
    print("newList map :"+newList.toString());

    return newList;
  }

  void intentMercCustamersDatail(MercCustomersDatail element, bool rutSirasiGorunsun) {
    selectedCustomers.value=element;
    Get.toNamed(RouteHelper.screenMercMusteriDetail,arguments: [this]);
  update();
  }

  void updateData(ModelUpdateMercCustomers model, bool mustDelate, List<SellingData> selectedSellingDatas) {
    if(mustDelate){
      print("Musteri silindi");
       listMercBaza.removeWhere((element) => element.code==model.customerCode);
      listRutGunleri.removeWhere((element) => element.code==model.customerCode);
    }else{
      print("Musteri yenilendi");
      MercCustomersDatail modelYeni=listMercBaza.where((p) => p.code==model.customerCode).first;
      listMercBaza.removeWhere((element) => element.code==model.customerCode);
      listRutGunleri.removeWhere((element) => element.code==model.customerCode);
      modelYeni.sellingDatas=selectedSellingDatas;
      modelYeni.days=model.days;
      modelYeni.totalPlan=selectedSellingDatas.fold(0, (sum, element) => sum!+element.plans);
      modelYeni.totalSelling=selectedSellingDatas.fold(0, (sum, element) => sum!+element.selling);
      modelYeni.totalRefund=selectedSellingDatas.fold(0, (sum, element) => sum!+element.refund);
      listMercBaza.insert(0, modelYeni);
      listRutGunleri.insert(0, modelYeni);
      selectedCustomers.value=modelYeni;
    }
    update();
  }

  Future<void> getNewDatasFromServer(BuildContext context) async{
    showMonthPicker(
      context,
      onSelected: (month, year) async {
        Get.back();
        List<MercDataModel> data = await getAllMercCariBazaMotivasiya(month, year);
        if (data.isNotEmpty) {
          ModelDownloads model = ModelDownloads(
            name: "currentBase".tr,
            donloading: false,
            code: "donwSingleMercBaza",
            info: "currentBaseExplain".tr,
            lastDownDay: DateTime.now().toIso8601String(),
            musteDonwload: false,
          );
          await localBaseDownloads.addDownloadedBaseInfo(model);
          await localBaseDownloads.addAllToMercBase(data);
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
      dialogBackgroundColor: Colors.white,
    );
  }

  Future<List<MercDataModel>> getAllMercCariBazaMotivasiya(int month, int year) async {
    DialogHelper.showLoading("Cari baza yuklenir...");
    List<MercDataModel> listUsers = [];
    languageIndex = await getLanguageIndex();
    await localBaseDownloads.init();
    LoggedUserModel loggedUserModel = userLocalService.getLoggedUser();
    var data=
    {
      "code":loggedUserModel.userModel!.code,
      "companyId": loggedUserModel.userModel!.companyId,
      "roleId": loggedUserModel.userModel!.roleId,
      "il": year,
      "ay": month

    };

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
      var response = await ApiClient().dio(false).post(
        "${loggedUserModel.baseUrl}/MercSystem/getAllMercRout",
        data: data,
        options: Options(
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
      print("respince : "+response.toString());
      if (response.statusCode == 200) {
        var dataModel = json.encode(response.data['Result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          listUsers.add(MercDataModel.fromJson(i));
        }
        modelInOut.value = await getAllGirisCixis(
          listUsers,
          loggedUserModel.userModel!.code!,
          loggedUserModel.userModel!.roleId!.toString(),
          year,
          month,
        );
      }

    }
    DialogHelper.hideLoading();
    return listUsers;
  }


  Future<List<ModelMainInOut>> getAllGirisCixis(List<MercDataModel> listCari,String temsilcikodu, String roleId,int year,int month) async {
    List<ModelMainInOut> listGirisler = [];
    DialogHelper.showLoading("Ziyaretler yuklenir...");
    await localGirisCixisServiz.init();
    var date = DateTime(year, month, 1).toString();
    var date2 = DateTime(year, month, DateTime.now().day).toString();
    DateTime dateParse = DateTime.parse(date);
    DateTime dateParse2 = DateTime.parse(date2);
    String ilkGun = intl.DateFormat('yyyy/MM/dd').format(dateParse);
    String songun = intl.DateFormat('yyyy/MM/dd').format(dateParse2);
    LoggedUserModel loggedUserModel = userLocalService.getLoggedUser();
    ModelRequestInOut model = ModelRequestInOut(
      listConfs: [],
        userRole: [UserRole(code: temsilcikodu, role: roleId)],
        endDate: "$songun 00:01",
        startDate: "$ilkGun 23:59");
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
          "${loggedUserModel.baseUrl}/GirisCixisSystem/GetUserDataByRoleAndDate",
          data: model.toJson(),
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
          var dataModel = json.encode(response.data['Result']);
          List listuser = jsonDecode(dataModel);
          await localGirisCixisServiz.clearAllGirisServer();
          for (var i in listuser) {
            ModelMainInOut model = ModelMainInOut.fromJson(i);
            await localGirisCixisServiz.addSelectedGirisCixisDBServer(model);
            listGirisler.add(model);
          }
          await getAllCariler(listCari.first,listGirisler,listUsers);

        } else {
          exeptionHandler.handleExeption(response);
        }
      } on DioException catch (e) {
        if (e.response != null) {
        } else {
          // Something happened in setting up or sending the request that triggered an Error
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }
    DialogHelper.hideLoading();
    return listGirisler;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
