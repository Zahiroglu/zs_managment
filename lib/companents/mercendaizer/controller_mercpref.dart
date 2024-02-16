import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/screen_giriscixis_list.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_mercbaza.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

import '../ziyaret_tarixcesi/model_gunluk_giriscixis.dart';

class ControllerMercPref extends GetxController {
  RxList<ModelMercBaza> listSelectedMercBaza = List<ModelMercBaza>.empty(growable: true).obs;
  RxList<ModelMercBaza> listRutGunleri = List<ModelMercBaza>.empty(growable: true).obs;
  RxList<ModelMercBaza> listZiyeretEdilmeyenler = List<ModelMercBaza>.empty(growable: true).obs;
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
  void getAllCariler(List<ModelMercBaza> listMercBaza, List<ModelGirisCixis> listGirisCixis) {
    for (var element in listMercBaza) {
      element.ziyaretSayi = listGirisCixis.where((e) => e.cariAd == element.cariad).toList().length;
      element.sndeQalmaVaxti = curculateTimeDistanceForVisit(listGirisCixis.where((e) => e.cariAd == element.cariad).toList());
      listSelectedMercBaza.add(element);
    }
    circulateMotivasion();
    listRutGunleri.value = listSelectedMercBaza.where((p0) => p0.gun1.toString() == "1").toList();
    listZiyeretEdilmeyenler.value = listSelectedMercBaza.where((p0) => p0.ziyaretSayi==0).toList();
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
    ziyaretTarixcesiTablesini(listGirisCixis);
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

  List<ModelMercBaza> createRandomOrdenNumber(List<ModelMercBaza> list) {
    List<ModelMercBaza> yeniList = [];
    // List<ModelMercBaza> listBir = list.where((p) => p.gun1.toString() == "1").toList();
    // List<ModelMercBaza> listIki = list.where((p) => p.gun2.toString() == "1").toList();
    // List<ModelMercBaza> listUc = list.where((p) => p.gun3.toString() == "1").toList();
    // List<ModelMercBaza> listDort = list.where((p) =>p.gun4.toString() == "1").toList();
    // List<ModelMercBaza> listBes = list.where((p) => p.gun5.toString() == "1").toList();
    // List<ModelMercBaza> listAlti = list.where((p) => p.gun6.toString() == "1").toList();
    // for (var i = 1; i <= listBir.length; i++) {
    //   ModelMercBaza model = listBir.elementAt(i - 1);
    //   model.rutSirasi = i;
    //   yeniList.add(model);
    // }
    // for (var i = 1; i <= listIki.length; i++) {
    //   ModelMercBaza model = listIki.elementAt(i - 1);
    //   model.rutSirasi = i;
    //   //listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
    //   yeniList.add(model);
    // }
    // for (var i = 1; i <= listUc.length; i++) {
    //   ModelMercBaza model = listUc.elementAt(i - 1);
    //   model.rutSirasi = i;
    //   //listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
    //   yeniList.add(model);
    // }
    // for (var i = 1; i <= listDort.length; i++) {
    //   ModelMercBaza model = listDort.elementAt(i - 1);
    //   model.rutSirasi = i;
    //   // listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
    //   yeniList.add(model);
    // }
    // for (var i = 1; i <= listBes.length; i++) {
    //   ModelMercBaza model = listBes.elementAt(i - 1);
    //   model.rutSirasi = i;
    //   // listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
    //   yeniList.add(model);
    // }
    // for (var i = 1; i <= listAlti.length; i++) {
    //   ModelMercBaza model = listAlti.elementAt(i - 1);
    //   model.rutSirasi = i;
    //   //listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
    //   yeniList.add(model);
    // }
    // list.where((element) => element.gun1.toString()=="1").toList().sort((a, b) => a.rutSirasi!.compareTo(b.rutSirasi!));
    // list.where((element) => element.gun2.toString()=="1").toList().sort((a, b) =>
    //     a.rutSirasi!.compareTo(b.rutSirasi!));
    // list.where((element) => element.gun3.toString()=="1").toList().sort((a, b) =>
    //     a.rutSirasi!.compareTo(b.rutSirasi!));
    // list.where((element) => element.gun4.toString()=="1").toList().sort((a, b) =>
    //     a.rutSirasi!.compareTo(b.rutSirasi!));
    // list.where((element) => element.gun5.toString()=="1").toList().sort((a, b) =>
    //     a.rutSirasi!.compareTo(b.rutSirasi!));
    // list.where((element) => element.gun6.toString()=="1").toList().sort((a, b) =>
    //     a.rutSirasi!.compareTo(b.rutSirasi!));
    list.sort((a, b) => a.rutSirasi!.compareTo(b.rutSirasi!));

    return list;
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
    double totalSatis = listSelectedMercBaza.fold(
        0.0, (sum, element) => sum + double.parse(element.netsatis!));
    double totalPlan = listSelectedMercBaza.fold(
        0.0, (sum, element) => sum + double.parse(element.plan!));
    double totalZaymal = listSelectedMercBaza.fold(
        0.0, (sum, element) => sum + double.parse(element.qaytarma!));
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
        listRutGunleri.value = listSelectedMercBaza.where((p0) => p0.gun1 == "1").toList();
        break;
      case 2:
        listRutGunleri.value =
            listSelectedMercBaza.where((p0) => p0.gun2 == "1").toList();
        break;
      case 3:
        listRutGunleri.value =
            listSelectedMercBaza.where((p0) => p0.gun3 == "1").toList();
        break;
      case 4:
        listRutGunleri.value =
            listSelectedMercBaza.where((p0) => p0.gun4 == "1").toList();
        break;
      case 5:
        listRutGunleri.value =
            listSelectedMercBaza.where((p0) => p0.gun5 == "1").toList();
        break;
      case 6:
        listRutGunleri.value =
            listSelectedMercBaza.where((p0) => p0.gun6 == "1").toList();
        break;
    }
    update();
  }
}
