import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/model_merc_customers_edit.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';
import 'package:intl/intl.dart' as intl;

import '../../connected_users/model_main_inout.dart';
import '../../giris_cixis/sceens/reklam_girisCixis/controller_giriscixis_reklam.dart';

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

  @override
  Future<void> onInit() async {
    await userLocalService.init();
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


  ////umumi cariler hissesi
  void getAllCariler(MercDataModel model, List<ModelMainInOut> listGirisCixis,List<UserModel> listUser) {
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
  


  String curculateTimeDistanceForVisit(List<ModelInOut> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
      print("giris vaxt :"+element.inDate);
      if(element.outDate!=null) {
        difference = difference +
            DateTime.parse(element.outDate.toString()).difference(
                DateTime.parse(element.inDate.toString()));
      }print("difference : "+difference.toString());
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
      print("Market silindi");
       listMercBaza.removeWhere((element) => element.code==modelUpdateMercCustomers.customerCode);
      listRutGunleri.removeWhere((element) => element.code==modelUpdateMercCustomers.customerCode);
    }else{
      print("Market update edildi");
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

}
