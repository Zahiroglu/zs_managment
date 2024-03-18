import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_merc_customers_edit.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/screen_giriscixis_list.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_mercbaza.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

import '../ziyaret_tarixcesi/model_gunluk_giriscixis.dart';

class ControllerMercPref extends GetxController {
  RxList<MercCustomersDatail> listMercBaza = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<MercCustomersDatail> listRutGunleri = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<MercCustomersDatail> listZiyeretEdilmeyenler = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<ModelGirisCixis> listGirisCixislar = List<ModelGirisCixis>.empty(growable: true).obs;
  RxList<UserModel> listUsers = List<UserModel>.empty(growable: true).obs;
  Rx<MercDataModel> selectedMercBaza=MercDataModel().obs;
  Rx<MercCustomersDatail> selectedCustomers=MercCustomersDatail().obs;
  double satisIndex = 0.003;
  double planFizi = 0;
  double zaymalFaizi = 0;
  double netSatisdanPul = 0;
  double plandanPul = 0;
  double cerimePul = 0;
  double totalPrim = 0;
  RxList<ModelTamItemsGiris> listTabItems = List<ModelTamItemsGiris>.empty(growable: true).obs;
  RxList<Widget> listPagesHeader = List<Widget>.empty(growable: true).obs;
  RxList<ModelGunlukGirisCixis> listTarixlerRx = List<ModelGunlukGirisCixis>.empty(growable: true).obs;
  String totalIsSaati="0";
  String hefteninGunu = "";
  bool userHasPermitionEditRutSira=true;

  @override
  void onInit() {
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
  void getAllCariler(MercDataModel model, List<ModelGirisCixis> listGirisCixis,List<UserModel> listUser) {
    selectedMercBaza.value=model;
    listGirisCixislar.value=listGirisCixis;
    listUsers.value=listUser;
    listMercBaza.clear();
    for (MercCustomersDatail model in model.mercCustomersDatail!) {
      model.ziyaretSayi = listGirisCixis.where((e) => e.cariAd == model.name).toList().length;
      model.sndeQalmaVaxti = curculateTimeDistanceForVisit(listGirisCixis.where((e) => e.cariAd == model.name).toList());
      listMercBaza.add(model);
    }
    circulateMotivasion();
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
    ));
    ziyaretTarixcesiTablesini(listGirisCixis);}
    melumatlariGuneGoreDoldur();
    update();
  }
  
  void ziyaretTarixcesiTablesini(List<ModelGirisCixis> listGirisCixis){
    List<String> listTarixler=[];
    listGirisCixis.sort((a, b) {
      int cmp = a.girisTarix.substring(0,10).compareTo(b.girisTarix.substring(0,10));
      if (cmp != 0) return cmp;
      return a.girisTarix.substring(11,15).compareTo(b.girisTarix.substring(11,15));
    });
    for (var element in listGirisCixis) {
      if(!listTarixler.contains(element.girisTarix.substring(0,10))) {
        listTarixler.add(element.girisTarix.substring(0,10));
      }
    }
    listTarixler.sort((a, b) => a.toString().compareTo(b.toString()));
    for(var tarix in listTarixler){
      List<ModelGirisCixis> list=listGirisCixis.where((a) => a.girisTarix.substring(0,10)==tarix).toList();
      listTarixlerRx.add(ModelGunlukGirisCixis(tarix: tarix,
          girisSayi: listGirisCixis.where((e) => e.girisTarix.substring(0,10)==tarix).length,
          umumiIsVaxti:curculateSndeQalmaVaxti( listGirisCixis.where((e) => e.girisTarix.substring(0,10)==tarix).toList().first.girisTarix, listGirisCixis.where((e) => e.girisTarix.substring(0,10)==tarix).toList().last.cixisTarix) ,
          iseBaslamaSaati: listGirisCixis.where((e) => e.girisTarix.substring(0,10)==tarix).toList().first.girisTarix.substring(11,19),
          isiQutarmaSaati: listGirisCixis.where((e) => e.girisTarix.substring(0,10)==tarix).toList().last.cixisTarix.substring(11,19),
          sndeIsvaxti: curculateTimeDistanceForVisit(listGirisCixis.where((e) => e.girisTarix.substring(0,10)==tarix).toList()),
      listgiriscixis: list,
      ));
    }
    totalIsSaati=curculateTotalTimeDistanceForVisit(listGirisCixis);
  }


  String curculateTimeDistanceForVisit(List<ModelGirisCixis> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
      difference = difference +
          DateTime.parse(element.cixisTarix)
              .difference(DateTime.parse(element.girisTarix));
    }
    hours = hours + difference.inHours % 24;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  String curculateTotalTimeDistanceForVisit(List<ModelGirisCixis> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
     difference = difference + DateTime.parse(element.cixisTarix).difference(DateTime.parse(element.girisTarix));
     }
    hours = hours + difference.inHours;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  String curculateSndeQalmaVaxti(String girisVaxti,String cixisTarixi) {
    int hours = 0;
    int minutes = 0;
    Duration difference = DateTime.parse(cixisTarixi).difference(DateTime.parse(girisVaxti));
    hours = hours + difference.inHours % 24;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  String prettify(double d) {
    return d.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void circulateMotivasion() {
    double totalSatis = listMercBaza.fold(
        0.0, (sum, element) => sum + element.totalSelling!);
    double totalPlan = listMercBaza.fold(
        0.0, (sum, element) => sum + element.totalPlan!);
    double totalZaymal = listMercBaza.fold(
        0.0, (sum, element) => sum + element.totalRefund!);
    netSatisdanPul = totalSatis * satisIndex;
    planFizi = (totalSatis / totalPlan) * 100;
    zaymalFaizi = (totalZaymal / totalSatis) * 100;
    switch (planFizi) {
      case >= 109.5:
        plandanPul = 60;
        break;
      case >= 99.5:
        plandanPul = 50;
        break;
      case >= 89.5:
        plandanPul = 30;
        break;
      case >= 79.5:
        plandanPul = 25;
        break;
    }
    switch (zaymalFaizi) {
      case <= 1:
        cerimePul = 20;
      case >= 3.5:
        cerimePul = -35;
        break;
      case >= 2.5:
        cerimePul = -25;
        break;
      case >= 1.5:
        cerimePul = -15;
        break;
    }
    totalPrim = netSatisdanPul + plandanPul + cerimePul;
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
      print("Market silinmelidir");
      print("Market selectedSellingDatas :"+selectedSellingDatas.toString());
      print("Market modelUpdateMercCustomers :"+modelUpdateMercCustomers.toString());
      print("Market movcuddur :"+listMercBaza.any((element) => element.code==modelUpdateMercCustomers.customerCode).toString());
      print("Market sayi : "+listMercBaza.length.toString()+" plan :"+listMercBaza.fold(0.0, (sum, e) => sum+e.totalPlan!).toString());
      listMercBaza.removeWhere((element) => element.code==modelUpdateMercCustomers.customerCode);
      listRutGunleri.removeWhere((element) => element.code==modelUpdateMercCustomers.customerCode);
      print("Silindikden sora Market sayi : "+listMercBaza.length.toString()+" plan :"+listMercBaza.fold(0.0, (sum, e) => sum+e.totalPlan!).toString());

    }else{
      print("Market guncellenmelidir");
      MercCustomersDatail model=listMercBaza.where((p) => p.code==modelUpdateMercCustomers.customerCode).first;
      print("Secilen Market model evvel : "+model.toString());
      print("Secilen Market selling evvel : "+model.sellingDatas.toString());
      listMercBaza.remove(model);
      selectedSellingDatas.forEach((element) {
        model.sellingDatas!.removeWhere((e) => e.forwarderCode==element.forwarderCode);
      });
      model.totalPlan=model.sellingDatas!.fold(0, (sum, element) => sum!+element.plans);
      model.totalSelling=model.sellingDatas!.fold(0, (sum, element) => sum!+element.selling);
      model.totalRefund=model.sellingDatas!.fold(0, (sum, element) => sum!+element.refund);
      print("Secilen Market model sonra : "+model.toString());
      print("Secilen Market selling evvel : "+model.sellingDatas.toString());
      listMercBaza.add(model);
    }
    update();
  }

}
