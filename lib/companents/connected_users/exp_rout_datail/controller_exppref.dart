import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/screen_giriscixis_list.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_gunluk_giriscixis.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ControllerExpPref extends GetxController {
  LocalUserServices userService = LocalUserServices();
  LocalAppSetting appSetting = LocalAppSetting();
  LocalBaseDownloads localBaseDownloads=LocalBaseDownloads();
  late Rx<AvailableMap> availableMap = AvailableMap(
      mapName: CustomMapType.google.name,
      mapType: MapType.google,
      icon:
      'packages/map_launcher/assets/icons/${CustomMapType.google}.svg').obs;
  RxList<ModelCariler> listFilteredUmumiBaza = List<ModelCariler>.empty(growable: true).obs;
  RxList<ModelCariler> listSelectedExpBaza = List<ModelCariler>.empty(growable: true).obs;
  RxList<ModelCariler> listRutGunleri = List<ModelCariler>.empty(growable: true).obs;
  RxList<ModelCariler> listZiyeretEdilmeyenler = List<ModelCariler>.empty(growable: true).obs;
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
  TextEditingController ctSearch = TextEditingController();
  RxInt selectedUmumiMusterilerTabIndex=0.obs;
  RxString fromIntentPage = "list".obs;
  final RxSet<map.Marker> markers = <map.Marker>{}.obs;
  final RxSet<map.Circle> circles = <map.Circle>{}.obs;
  late Rx<ModelCariler> selectedCariModel = ModelCariler().obs;
  RxList<UserModel> listMercs = List<UserModel>.empty(growable: true).obs;

  @override
  void onInit() {
    getAppSetting();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    Get.delete<ControllerExpPref>();
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

  Future<void> getAppSetting() async {
    await userService.init();
    await appSetting.init();
    ModelAppSetting modelSetting = await appSetting.getAvaibleMap();
    if (modelSetting.mapsetting != null) {
      ModelMapApp modelMapApp = modelSetting.mapsetting!;
      CustomMapType? customMapType = modelMapApp.mapType;
      MapType mapType = MapType.values[customMapType!.index];
      if (modelMapApp.name != "null") {
        availableMap.value = AvailableMap(
            mapName: modelMapApp.name!,
            mapType: mapType,
            icon: modelMapApp.icon!);
      }
    }
    update();
  }

  ////umumi cariler hissesi
  void getAllCariler(List<ModelCariler> listMercBaza, List<ModelGirisCixis> listGirisCixis, List<UserModel> listmercendaizers) {
    for (var element in listMercBaza) {
      element.ziyaretSayi = listGirisCixis.where((e) => e.cariKod == element.code).toList().length;
     element.sndeQalmaVaxti = curculateTimeDistanceForVisit(listGirisCixis.where((e) => e.cariKod == element.code).toList());
      listSelectedExpBaza.add(element);
      listFilteredUmumiBaza.add(element);
    }
    listRutGunleri.value = listSelectedExpBaza.where((p0) => p0.day1.toString() == "1").toList();
    listZiyeretEdilmeyenler.value = listSelectedExpBaza.where((p0) => p0.ziyaretSayi==0).toList();
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
    if(listGirisCixis.isNotEmpty) {
      listTabItems.add(ModelTamItemsGiris(
          icon: Icons.share_arrival_time,
          color: Colors.green,
          label: "ziyaretTarixcesi".tr,
          selected: false,
          keyText: "um"
      ));
    }
    ziyaretTarixcesiTablesini(listGirisCixis);
    melumatlariGuneGoreDoldur();
    for (var element in listmercendaizers) {
      listMercs.add(element);
    }
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

  /// rut gunleri hissesi////

  String prettifya(String d) {
    return d.substring(0).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void changeRutGunu(int tr) {
    listRutGunleri.clear();
    switch (tr) {
      case 1:
        listRutGunleri.value = listSelectedExpBaza.where((p0) => p0.day1.toString() == "1").toList();
        break;
      case 2:
        listRutGunleri.value =
            listSelectedExpBaza.where((p0) => p0.day2.toString()  == "1").toList();
        break;
      case 3:
        listRutGunleri.value =
            listSelectedExpBaza.where((p0) => p0.day3.toString()  == "1").toList();
        break;
      case 4:
        listRutGunleri.value =
            listSelectedExpBaza.where((p0) => p0.day4.toString()  == "1").toList();
        break;
      case 5:
        listRutGunleri.value =
            listSelectedExpBaza.where((p0) => p0.day5.toString()  == "1").toList();
        break;
      case 6:
        listRutGunleri.value =
            listSelectedExpBaza.where((p0) => p0.day6.toString()  == "1").toList();
        break;
    }
    update();
  }

  void changeSelectedUmumiMusteriler(int tip) {
    selectedUmumiMusterilerTabIndex.value=tip;
    if(tip==0){
      listFilteredUmumiBaza.value=listSelectedExpBaza.value;
    }else if(tip==1){
      listFilteredUmumiBaza.value=listSelectedExpBaza.where((p0) => p0.action==false).toList();
    }else if(tip==2){
      listFilteredUmumiBaza.value=listSelectedExpBaza.where((p0) => p0.day7.toString()=="1").toList();
    }else{
      listFilteredUmumiBaza.value=listSelectedExpBaza.where((p0) => p0.day1.toString()=="0"&&p0.day2.toString()=="0"&&
          p0.day3.toString()=="0" &&p0.day4.toString()=="0"&&p0.day5.toString()=="0"&&p0.day6.toString()=="0"&&p0.day7.toString()=="0").toList();

    }
    update();
  }

  void filterCustomersBySearchView(String st) {
    listFilteredUmumiBaza.clear();
    if (st.isNotEmpty) {
      listSelectedExpBaza
          .where((p) =>
      p.code!.toUpperCase().contains(st.toUpperCase()) ||
          p.name!.toUpperCase().contains(st.toUpperCase()))
          .forEach((element) {
        listFilteredUmumiBaza.add(element);
      });
    } else {
      for (var element in listSelectedExpBaza) {
        listFilteredUmumiBaza.add(element);
      }
    }
    update();
  }

  void intentEditCustomers(ModelCariler element) async {
    await Get.toNamed(RouteHelper.screenEditMusteriDetailScreen, arguments: [this, RouteHelper.screenExpRoutDetailMap, element]);
    update();
  }

  void _intentAdToMercRut(ModelCariler element) {
    print("list merc count :"+listMercs.length.toString());
    Get.toNamed(RouteHelper.screenMercAdinaMusteriAt,arguments: [element,listMercs.where((p0) => p0.roleId==23).toList(),availableMap.value]);
  }

  void showEditDialog(ModelCariler element, BuildContext context) {
    Get.dialog(
      _dialogEditCustomers(element, context),
      barrierDismissible: true,
    );
  }

  Widget _dialogEditCustomers(ModelCariler element, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            horizontal: MediaQuery
                .of(context)
                .size
                .width * 0.05),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomText(
                            labeltext: element.name!,
                            fontsize: 18,
                            maxline: 2,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomElevetedButton(
                      icon: Icons.edit,
                      elevation: 10,
                      fontWeight: FontWeight.w600,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                      height: 50,
                      cllback: () {
                        Get.back();
                        fromIntentPage.value = "list";
                        intentEditCustomers(element);
                      },
                      label: "Musteri melumatlarini duzelt"),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevetedButton(
                      icon: Icons.add_business,
                      elevation: 10,
                      fontWeight: FontWeight.w600,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                      height: 50,
                      cllback: () {
                        Get.back();
                        _intentAdToMercRut(element);
                      },
                      label: "Mercendaizer rutuna elave et"),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                )),
          ],
        ),
      ),
    );
  }
  Future<void> setAllMarkers() async {
    markers.clear();
    for (ModelCariler model in listFilteredUmumiBaza) {
      markers.add(map.Marker(
          markerId: map.MarkerId(model.code!),
          onTap: () {
            selectedCariModel.value = model;
            addCirculerToMap();
          },
          icon: await getClusterBitmap2(120, model),
          position: map.LatLng(
              double.parse(model.longitude!), double.parse(model.latitude!))));
    }
  }

  Future<map.BitmapDescriptor> getClusterBitmap2(int size,ModelCariler model) async {
    Color colors = Colors.black;
    String rutGunu = "rutsuz".tr;
    if (model.day1 == 1) {
      colors = Colors.blue;
      rutGunu = "1";
    } else if (model.day2 == 1) {
      colors = Colors.orange;
      rutGunu = "2";
    } else if (model.day3 == 1) {
      colors = Colors.green;
      rutGunu = "3";
    } else if (model.day4 == 1) {
      colors = Colors.deepPurple;
      rutGunu = "4";
    } else if (model.day5 == 1) {
      colors = Colors.lightBlueAccent;
      rutGunu = "5";
    } else if (model.day6 == 1) {
      colors = Colors.redAccent;
      rutGunu = "6";
    } else if (model.day7 == 1) {
      colors = Colors.brown;
      rutGunu = "bagli".tr;
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()
      ..color = Colors.transparent;
    canvas.drawCircle(Offset(size / 3.5, size / 2.7), size / 10.0, paint1);
    var icon = Icons.place;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: selectedCariModel.value.code == model.code
                ? size * 0.9
                : size * 0.7,
            fontFamily: icon.fontFamily,
            color: colors));
    textPainter.layout();
    textPainter.paint(
        canvas,
        selectedCariModel.value.code == model.code
            ? Offset(size / 8, size / 8)
            : Offset(size / 4, size / 4));
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: rutGunu,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: selectedCariModel.value.code == model.code
              ? size / 3
              : size / 8,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      selectedCariModel.value.code == model.code ? Offset(
          (size - painter.width) * 0.6, size * -0.05) : Offset(
          (size - painter.width) * 0.6, size / 6),
    );
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  addCirculerToMap() {
    circles.clear;
    circles.value = {
      map.Circle(
          circleId: map.CircleId(selectedCariModel.value.code!),
          center: map.LatLng(double.parse(selectedCariModel.value.longitude!),
              double.parse(selectedCariModel.value.latitude!)),
          radius: 100,
          fillColor: Colors.black.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 1)
    };
  }

  Future<void> changeCustomersInfo(ModelCariler modelCari) async {
    Get.back();
    if (modelCari.code != null) {
      selectedCariModel.value = modelCari;
      modelCari.ziyaretSayi = listSelectedExpBaza.where((e) => e.code == modelCari.code).toList().first.ziyaretSayi;
      modelCari.sndeQalmaVaxti =  listSelectedExpBaza.where((e) => e.code == modelCari.code).toList().first.sndeQalmaVaxti;
      DialogHelper.showLoading("mDeyisdirilir".tr);
      listSelectedExpBaza.remove(listSelectedExpBaza.where((p) => p.code == modelCari.code).first);
      listSelectedExpBaza.insert(0, modelCari);
      listFilteredUmumiBaza.remove(listFilteredUmumiBaza.where((p) => p.code == modelCari.code).first);
      listFilteredUmumiBaza.insert(0, modelCari);
      await Future.delayed(Duration(seconds: 2));
      DialogHelper.hideLoading();
    }
    changeRutGunu(DateTime.now().weekday);

    update();
  }

}
