import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:ntp/ntp.dart';
import 'package:zs_managment/companents/giris_cixis/bacgroud_location_serviz.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_giriscixis.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/marketuzre_hesabatlar.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/satisGirisCixis/screen_giriscixis_list.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carihereket.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carikassa.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';

import '../../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';

class ControllerGirisCixisReklam extends GetxController {
  RxList<ModelCariler> listCariler = List<ModelCariler>.empty(growable: true).obs;
  LocalUserServices userService = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  RxBool dataLoading = true.obs;
  RxDouble zoomLevel = 15.0.obs;
  LocalGirisCixisServiz localDbGirisCixis = LocalGirisCixisServiz();
  LocalBaseDownloads localBase = LocalBaseDownloads();
  RxBool marketeGirisEdilib = false.obs;
  Rx<ModelGirisCixis> modelgirisEdilmis = ModelGirisCixis().obs;
  RxSet<map.Marker> markers = RxSet();
  RxBool leftSideMenuVisible = true.obs;
  RxBool rightSideMenuVisible = true.obs;
  RxBool slidePanelVisible = false.obs;
  RxSet<map.Circle> circles = RxSet();
  RxList<map.LatLng> pointsPoly = List<map.LatLng>.empty(growable: true).obs;
  final RxSet<map.Polygon> polygon = RxSet<map.Polygon>();
  LocalAppSetting appSetting = LocalAppSetting();
  late Rx<AvailableMap> availableMap = AvailableMap(
          mapName: CustomMapType.google.name,
          mapType: MapType.google,
          icon:
              'packages/map_launcher/assets/icons/${CustomMapType.google}.svg').obs;
  Rx<ModelRutPerform> modelRutPerform = ModelRutPerform().obs;
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  List<String> listTab = ["girisCixislar".tr, "todeyRut".tr, "unVisited".tr];
  RxString selectedTabItem = "girisCixislar".tr.obs;
  Rx<ModelCariler> expandedItem = ModelCariler().obs;
  ScrollController listScrollController = ScrollController();
  RxList<ModelTamItemsGiris> listTabItems = List<ModelTamItemsGiris>.empty(growable: true).obs;
  RxList<ModelCariler> listSelectedMusteriler = List<ModelCariler>.empty(growable: true).obs;
  RxList<ModelSifarislerTablesi> listTabSifarisler = List<ModelSifarislerTablesi>.empty(growable: true).obs;
  RxString snQalmaVaxti = "".obs;
  Timer? _timer;
  TextEditingController ctCixisQeyd = TextEditingController();
  LocalBaseSatis localBaseSatis = LocalBaseSatis();
  RxList<ModelCariHereket> listSifarisler = List<ModelCariHereket>.empty(growable: true).obs;
  RxList<ModelCariHereket> listIadeler = List<ModelCariHereket>.empty(growable: true).obs;
  RxList<ModelCariKassa> listKassa = List<ModelCariKassa>.empty(growable: true).obs;
  RxList<ModelCariKassa> selectedlistKassa = List<ModelCariKassa>.empty(growable: true).obs;
  TextEditingController ctKassaDialog = TextEditingController();
  Rx<UserModel> selectedTemsilci = UserModel(code: "", name: "hamisi".tr).obs;
  BackgroudLocationServiz backgroudLocationServiz = BackgroudLocationServiz();
  late CheckDviceType checkDviceType = CheckDviceType();
  @override
  Future<void> onInit() async {
    await userService.init();
    loggedUserModel = userService.getLoggedUser();
    await localBaseDownloads.init();
    getAppSetting();
    _getGirisEdilmisCari();
    //getRutPerformToday();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    _timer!.cancel();
    ctCixisQeyd.dispose();
    super.dispose();
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

  _getGirisEdilmisCari() async {
    listCariler.clear();
    await localDbGirisCixis.init();
    modelgirisEdilmis.value = await localDbGirisCixis.getGirisEdilmisMarket();
    if (modelgirisEdilmis.value.girisvaxt == null) {
      getAllDataFormLocale();
      if (loggedUserModel.userModel!.roleId == 23 ||
          loggedUserModel.userModel!.roleId == 24) {
        await getRutPerformToday(false, selectedTemsilci.value);
      } else {
        await getRutPerformToday(true, selectedTemsilci.value);
      }
      marketeGirisEdilib.value = false;
      slidePanelVisible.value = false;
    } else {
      getAllDataFormLocale();
      createCircles(
          modelgirisEdilmis.value.marketgpsUzunluq!,
          modelgirisEdilmis.value.marketgpsEynilik!,
          modelgirisEdilmis.value.ckod!);
      marketeGirisEdilib.value = true;
      slidePanelVisible.value = false;
    }
    // listCariler.sort((a, b) {
    //   int cmp = b.rutGunu!.compareTo(a.rutGunu!);
    //   if (cmp != 0) return cmp;
    //   return b.rutSirasi!.compareTo(a.rutSirasi!);
    // });
    sndeQalmaVaxtiniHesabla();
    getSatisMelumatlari();
  } // eger markete giris edilibse cixis sehfesi acilmalidir

  Future<void> getAllDataFormLocale() async {
    listCariler.clear();
    List<MercDataModel> listmodel = await localBase.getAllMercDatail();
    for (MercDataModel model in listmodel) {
      List<MercCustomersDatail> musteriler = model.mercCustomersDatail!;
      for (MercCustomersDatail modelMerc in musteriler) {
        ModelCariler modelCari = ModelCariler(
            name: modelMerc.name,
            code: modelMerc.code,
            forwarderCode: model.user!.code,
            fullAddress: modelMerc.fullAddress,
            days: modelMerc.days,
            action: modelMerc.action,
            area: modelMerc.area,
            category: modelMerc.category,
            district: modelMerc.district,
            latitude: modelMerc.latitude,
            longitude: modelMerc.longitude,
            debt: modelMerc.debt,
            mainCustomer: modelMerc.mainCustomer,
            mesafe: "",
            mesafeInt: 0,
            ownerPerson: modelMerc.ownerPerson,
            phone: modelMerc.phone,
            postalCode: modelMerc.postalCode,
            regionalDirectorCode: modelMerc.regionalDirectorCode,
            rutGunu: "",
            salesDirectorCode: modelMerc.salesDirectorCode,
            tin: modelMerc.tin,
            ziyaretSayi: 0);
        bool rutGunu = rutGununuYoxla(modelCari);
        modelCari.rutGunu = rutGunu ? "Duz" : "Sef";
        listCariler.add(modelCari);
      }
    }
    dataLoading = false.obs;
    update();
  } //butun carilerin listini bazadan ceken

  void sndeQalmaVaxtiniHesabla() {
    snQalmaVaxti = "".obs;
    if (marketeGirisEdilib.isTrue) {
      DateTime timeGiris =
          DateTime.parse(modelgirisEdilmis.value.girisvaxt.toString());
      snQalmaVaxti.value =
          carculateTimeDistace(timeGiris.toString(), DateTime.now().toString());
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        timeGiris.add(const Duration(minutes: 1));
        snQalmaVaxti.value = carculateTimeDistace(
            timeGiris.toString(), DateTime.now().toString());
        update();
      });
    }
  } // giris edilmis marketin vaxtini hesablayan ve timer qosan

  Future<void> getRutPerformToday(bool butunCariler, UserModel selected) async {
    listTabItems.clear();
    if (butunCariler) {
      modelRutPerform.value = await localBaseDownloads.getRutDatailForMerc(butunCariler,selected.code!);
      listTabItems.add(ModelTamItemsGiris(
            icon: Icons.people_outline_outlined,
            label: "umumiMusteri".tr,
            girisSayi: modelRutPerform.value.duzgunZiya! +
                modelRutPerform.value.rutkenarZiya!,
            keyText: "Gumumi",
            marketSayi: listCariler.length,
            selected: true,
            color: Colors.deepPurple),);
      listTabItems.add(ModelTamItemsGiris(
          icon: Icons.verified_user_outlined,
          label: "ziyaretler".tr,
          girisSayi: modelRutPerform.value.listGirisCixislar!.length,
          keyText: "z",
          marketSayi: modelRutPerform.value.listGirisCixislar!.length,
          selected: false,
          color: Colors.green));
    } else {
      modelRutPerform.value = await localBaseDownloads.getRutDatailForMerc(butunCariler,selected.code!);
      listTabItems.add(
        ModelTamItemsGiris(
            icon: Icons.people_outline_outlined,
            label: "umumiMusteri".tr,
            girisSayi: modelRutPerform.value.duzgunZiya! +
                modelRutPerform.value.rutkenarZiya!,
            keyText: "Gumumi",
            marketSayi: listCariler.length,
            selected: true,
            color: Colors.deepPurple),
      );
      listTabItems.add(ModelTamItemsGiris(
          icon: Icons.people_outline_outlined,
          label: "todeyRut".tr,
          girisSayi: modelRutPerform.value.duzgunZiya,
          keyText: "Grut",
          marketSayi: modelRutPerform.value.rutSayi,
          selected: false,
          color: Colors.blue));
      listTabItems.add(ModelTamItemsGiris(
          icon: Icons.person_off_outlined,
          label: "unVisited".tr,
          girisSayi: 0,
          keyText: "zedilmeyen",
          marketSayi: modelRutPerform.value.ziyaretEdilmeyen,
          selected: false,
          color: Colors.orange));
      listTabItems.add(ModelTamItemsGiris(
          icon: Icons.verified_user_outlined,
          label: "ziyaretler".tr,
          girisSayi: modelRutPerform.value.listGirisCixislar!.length,
          keyText: "z",
          marketSayi: modelRutPerform.value.listGirisCixislar!.length,
          selected: false,
          color: Colors.green));
    }

    update();
  } // bu gune aid rut gunleri,ziyaretler v.s Local bazadan

  Future<void> getSatisMelumatlari() async {
    await localBaseSatis.init();
    listTabSifarisler.clear();
    listIadeler.clear();
    listKassa.clear();
    listSifarisler.value = localBaseSatis.getAllHereket();
    listIadeler.value = localBaseSatis.getAllIadeler();
    listKassa.value = localBaseSatis.getAllKassa();
    listTabSifarisler.value = [
      ModelSifarislerTablesi(
          label: "Satis",
          icon: "images/sales.png",
          summa: listSifarisler.fold(
              0, (sum, element) => sum! + element.netSatis!),
          type: "s",
          color: Colors.blue),
      ModelSifarislerTablesi(
          label: "Iade",
          icon: "images/dollar.png",
          summa:
              listIadeler.fold(0, (sum, element) => sum! + element.netSatis!),
          type: "i",
          color: Colors.deepPurple),
      ModelSifarislerTablesi(
          label: "Kassa",
          icon: "images/payment.png",
          summa:
              listKassa.fold(0, (sum, element) => sum! + element.kassaMebleg!),
          type: "k",
          color: Colors.green),
    ];
    update();
  } //bu gune satisa aid melumatlari getirmek local bazadan

  Future<void> getSatisMelumatlariByCary() async {
    await localBaseSatis.init();
    listTabSifarisler.clear();
    listIadeler.clear();
    listKassa.clear();
    listSifarisler.value =
        localBaseSatis.getAllHereketbyCariKod(modelgirisEdilmis.value.ckod!);
    listIadeler.value =
        localBaseSatis.getAllIadelerbyCariKod(modelgirisEdilmis.value.ckod!);
    listKassa.value =
        localBaseSatis.getAllKassabyCariKod(modelgirisEdilmis.value.ckod!);
    bool canSell = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canSell");
    bool canCash = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canCash");
    bool canReturn = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canReturn");
    if (canSell) {
      listTabSifarisler.add(ModelSifarislerTablesi(
          label: "satis".tr,
          icon: "images/sales.png",
          summa: listSifarisler.fold(
              0, (sum, element) => sum! + element.netSatis!),
          type: "s",
          color: Colors.blue));
    }
    if (canCash) {
      listTabSifarisler.add(ModelSifarislerTablesi(
          label: "iade".tr,
          icon: "images/dollar.png",
          summa:
              listIadeler.fold(0, (sum, element) => sum! + element.netSatis!),
          type: "i",
          color: Colors.deepPurple));
    }
    if (canReturn) {
      listTabSifarisler.add(ModelSifarislerTablesi(
          label: "kassa".tr,
          icon: "images/payment.png",
          summa:
              listKassa.fold(0, (sum, element) => sum! + element.kassaMebleg!),
          type: "k",
          color: Colors.green));
    }
    update();
  } //bu gune aid cari uzre satis melumatlari localdan

  /// xeriteni confiq elemek ucun  //////////////////////////
  createCircles(String longitude, String latitude, String ckod) {
    circles.clear();
    circles.value = {
      map.Circle(
          circleId: map.CircleId(ckod),
          center: map.LatLng(double.parse(longitude), double.parse(latitude)),
          radius: 100,
          fillColor: Colors.yellow.withOpacity(0.5),
          strokeColor: Colors.black,
          strokeWidth: 1)
    };
  }

  void addMarkersAndPlygane(String latitude, String longitude, Position currentLocation) {
    polygon.clear();
    pointsPoly.clear();
    pointsPoly
        .add(map.LatLng(currentLocation.latitude, currentLocation.longitude));
    pointsPoly.add(map.LatLng(double.parse(latitude), double.parse(longitude)));
    polygon.add(map.Polygon(
      polygonId: const map.PolygonId('1'),
      points: pointsPoly,
      fillColor: Colors.black.withOpacity(0.3),
      strokeColor: Colors.blue,
      geodesic: true,
      strokeWidth: 2,
    ));
    update();
  }

  /////////////////////////////////////////////////////////////

  bool rutGununuYoxla(ModelCariler selectedModel) {
    bool rutgun = false;
    int hefteningunu = DateTime
        .now()
        .weekday;
    if(selectedModel.days!=null){
      switch (hefteningunu) {
        case 1:
          if (selectedModel.days!.any((element) => element.day==1)) {
            rutgun = true;
          }
          break;
        case 2:
          if (selectedModel.days!.any((element) => element.day==2)) {
            rutgun = true;
          }
          break;
        case 3:
          if (selectedModel.days!.any((element) => element.day==3)) {
            rutgun = true;
          }
          break;
        case 4:
          if (selectedModel.days!.any((element) => element.day==4)) {
            rutgun = true;
          }
          break;
        case 5:
          if (selectedModel.days!.any((element) => element.day==5)) {
            rutgun = true;
          }
          break;
        case 6:
          if (selectedModel.days!.any((element) => element.day==6)) {
            rutgun = true;
          }
          break;
        default:
          rutgun = false;
      }}
    return rutgun;
  }

  ///giris ucun hazirliq
  Future<void> pripareForEnter(Position currentLocation, ModelCariler selectedModel, String uzaqliq) async {
    DialogHelper.showLoading("Giris edilir...");
    await localDbGirisCixis.init();
    String lookupAddress = "time.google.com";
    DateTime myTime = DateTime.now();
    DateTime ntpTime = DateTime.now();
    myTime = DateTime.now();
    try {
      final int offset = await NTP.getNtpOffset(
          localTime: myTime, lookUpAddress: lookupAddress);
      ntpTime = myTime.add(Duration(milliseconds: offset));
    } catch (ex) {
      Get.dialog(
        ShowInfoDialog(
            messaje: "Sebeke xetasi movcuddur",
            icon: Icons.phonelink_erase_rounded,
            callback: (val) {
              Get.back();
            }),
      );
    }
    int ferq = myTime.difference(ntpTime).inMinutes;
    if (ferq > 5) {
      Get.dialog(
        ShowInfoDialog(
            messaje: "Vaxt ayarlarini duzeldin!",
            icon: Icons.phonelink_erase_rounded,
            callback: (val) {
              Get.back();
            }),
      );
    } else {
      if (currentLocation.isMocked) {
        Get.dialog(
          ShowInfoDialog(
              messaje: "Telefonda fake location aktivdir.Sondurun!",
              icon: Icons.phonelink_erase_rounded,
              callback: (val) {
                Get.back();
              }),
        );
      } else {
        DialogHelper.hideLoading();
        await _callApiForEnter(currentLocation, selectedModel, uzaqliq, myTime);
      }
    }
  }

  void girisiSil() async {
    Get.dialog(ShowSualDialog(
        messaje: "Girisi silseniz butun emeliyyatlar silinecek.Silmeye eminsiniz?",
        callBack: (va) async {
          if (va) {
            _timer!.cancel();
            circles.clear();
            polygon.clear();
            pointsPoly.clear();
            await localDbGirisCixis.init();
            await localDbGirisCixis.deleteItem(modelgirisEdilmis.value.ckod!,
                modelgirisEdilmis.value.girisvaxt!);
            ModelCariler modelCari = listCariler.where((a) => a.code == modelgirisEdilmis.value.ckod).first;
            modelCari.ziyaret = "0";
            await localBase.updateModelCari(modelCari);
            marketeGirisEdilib.value = false;
            modelgirisEdilmis.value = ModelGirisCixis();
            getSatisMelumatlari();
            ctKassaDialog.text = "";
            ctCixisQeyd.text = "";
            update();
            backgroudLocationServiz.stopServiz();

          }
          Get.back();
        }));
  }


  ///cixis ucun hazirliq
  pripareForExit(Position currentLocation, String uzaqliq) async {
    await localDbGirisCixis.init();
    DialogHelper.showLoading("Cixis edilir...");
    String lookupAddress = "time.google.com";
    DateTime myTime = DateTime.now();
    DateTime ntpTime = DateTime.now();
    myTime = DateTime.now();
    try {
      final int offset = await NTP.getNtpOffset(
          localTime: myTime, lookUpAddress: lookupAddress);
      ntpTime = myTime.add(Duration(milliseconds: offset));
    } catch (ex) {
      Get.dialog(
        ShowInfoDialog(
            messaje: "Sebeke xetasi movcuddur",
            icon: Icons.phonelink_erase_rounded,
            callback: (val) {
              Get.back();
            }),
      );
    }
    int ferq = myTime.difference(ntpTime).inMinutes;
    if (ferq > 5) {
      Get.dialog(
        ShowInfoDialog(
            messaje: "Vaxt ayarlarini duzeldin!",
            icon: Icons.phonelink_erase_rounded,
            callback: (val) {
              Get.back();
            }),
      );
    } else {
      if (currentLocation.isMocked) {
        Get.dialog(
          ShowInfoDialog(
              messaje: "Telefonda Fake Location aktivdir.Sondurun!",
              icon: Icons.phonelink_erase_rounded,
              callback: (val) {
                Get.back();
              }),
        );
      } else {
        _callApiForExit(currentLocation, uzaqliq, myTime, ctCixisQeyd.text);
        DialogHelper.hideLoading();
      }
    }
  }


  String carculateTimeDistace(String? girisvaxt, String? cixisvaxt) {
    Duration difference =
        DateTime.parse(cixisvaxt!).difference(DateTime.parse(girisvaxt!));
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  String curculateTimeDistanceForVisit(String? kod) {
    int hours = 0;
    int minutes = 0;
    modelRutPerform.value.listGirisCixislar!
        .where((element) => element.ckod == kod!)
        .forEach((element) {
      Duration difference = DateTime.parse(element.cixisvaxt!)
          .difference(DateTime.parse(element.girisvaxt!));
      hours = hours + difference.inHours % 24;
      minutes = minutes + difference.inMinutes % 60;
    });
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  (String, int) checkIfVisited(String s) {
    if (modelRutPerform.value.listGirisCixislar!
        .where((element) => element.ckod == s)
        .isNotEmpty) {
      return ("Bu gun ziyaret edilib", 1);
    } else {
      return ("Ziyaret Edilmeyib", 0);
    }
  }

  //widgetss
  Widget widgetMusteriHesabatlari(ModelCariler selectedCariModel) {
    return WidgetCarihesabatlar(
        cad: selectedCariModel.name ?? "",
        ckod: selectedCariModel.code ?? "",
        height: 110);
  }

  Widget widgetGunlukGirisCixislar(BuildContext context) {
    return modelRutPerform.value.snSayi != null
        ? InkWell(
            onTap: () async {
              await Get.toNamed(RouteHelper.mobileGirisCixisHesabGunluk,
                  arguments: modelRutPerform.value);
            },
            child: Container(
              //height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(5).copyWith(left: 10, right: 10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widgetSimpleTextInfo("Umumi musteriler : ",
                            modelRutPerform.value.snSayi.toString()),
                        widgetSimpleTextInfo("Cari rut : ",
                            modelRutPerform.value.rutSayi.toString()),
                        widgetSimpleTextInfo("Duz ziyaret : ",
                            modelRutPerform.value.duzgunZiya.toString()),
                        widgetSimpleTextInfo("Sef ziyaret : ",
                            modelRutPerform.value.rutkenarZiya.toString()),
                        widgetSimpleTextInfo(
                            "Umumi ziyaret : ",
                            modelRutPerform.value.listGirisCixislar!.length
                                .toString()),
                        widgetSimpleTextInfo("Ziyaret edilmeyen : ",
                            modelRutPerform.value.ziyaretEdilmeyen.toString()),
                        widgetSimpleTextInfo("Sn-lerde is vaxti : ",
                            modelRutPerform.value.snlerdeQalma.toString()),
                        widgetSimpleTextInfo("Umumi is vaxti : ",
                            modelRutPerform.value.umumiIsvaxti.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        chartWidget(),
                        CustomText(labeltext: "Ziyaret Diagrami", fontsize: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }

  Widget widgetShowListRutInfo(
      BuildContext context, ScrollController listViewController) {
    ScreenUtil.init(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: listTab
                  .map((element) => widgetListTabItems(element))
                  .toList(),
            ),
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: listTab.first.toString() == selectedTabItem.value.toString()
                ? listviewGirisCixislar()
                : listViewCariler())
      ],
    );
  }

  ListView listviewGirisCixislar() {
    return ListView(
      padding: const EdgeInsets.all(0),
      controller: listScrollController,
      physics: const PageScrollPhysics(),
      children: modelRutPerform.value.listGirisCixislar!
          .map((e) => widgetListGirisItems(e))
          .toList(),
    );
  }

  Widget widgetListGirisItems(ModelGirisCixis model) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: model.rutgunu == "Sef" ? Colors.red : Colors.green,
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                      labeltext: model.cariad!,
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      overflow: TextOverflow.ellipsis,
                      maxline: 2,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                    CustomText(labeltext: "Giris vaxti :"),
                    SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.girisvaxt!.substring(11, 19)),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.red,
                    ),
                    CustomText(labeltext: "Cixis vaxti :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.cixisvaxt!.substring(11, 19)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: "Vaxt :"),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: carculateTimeDistace(
                            model.girisvaxt!, model.cixisvaxt!)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                        labeltext: "${model.girisvaxt!.substring(0, 11)}"),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: model.rutgunu == "Sef" ? Colors.red : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                labeltext: model.rutgunu == "Sef" ? "Rutdan kenar" : "Rut gunu",
                color: model.rutgunu == "Sef" ? Colors.red : Colors.green,
              ),
            ))
      ],
    );
  }

  ListView listViewCariler() {
    return ListView(
      padding: const EdgeInsets.all(0),
      physics: const PageScrollPhysics(),
      controller: listScrollController,
      children: selectedTabItem.value.toString() == listTab.last.toString()
          ? modelRutPerform.value.listZiyaretEdilmeyen!
              .map((e) => widgetCustomers(e))
              .toList()
          : modelRutPerform.value.listGunlukRut!
              .map((e) => widgetCustomers(e))
              .toList(),
    );
  }

  Widget widgetCustomers(ModelCariler e) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: CustomText(
                        labeltext: e.name!,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomText(
                        labeltext: e.code!,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontsize: 12,
                      ),
                      expandedItem.value.code != e.code
                          ? IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 30),
                              onPressed: () {
                                expandedItem.value = e;
                              },
                              icon: const Icon(Icons.expand_more))
                          : IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 30),
                              onPressed: () {
                                expandedItem.value = ModelCariler();
                              },
                              icon: Icon(Icons.expand_less))
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Divider(height: 1, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage("images/externalvisit.png"),
                    color: checkIfVisited(e.code!).$2 == 0
                        ? Colors.red
                        : Colors.green,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomText(
                      fontsize: 12,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      labeltext: checkIfVisited(e.code!).$1,
                      color: checkIfVisited(e.code!).$2 == 0
                          ? Colors.black
                          : Colors.green,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              expandedItem.value.code == e.code
                  ? widgetMoreDataForItems(e)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetListTabItems(String element) {
    String deyer = listTab.first.toString() == element.toString()
        ? modelRutPerform.value.listGirisCixislar!.length.toString()
        : listTab.last.toString() == element.toString()
            ? modelRutPerform.value.listZiyaretEdilmeyen!.length.toString()
            : modelRutPerform.value.listGunlukRut!.length.toString();
    return InkWell(
      onTap: () {
        selectedTabItem.value = element;
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: selectedTabItem.value != element.toString()
                    ? Border.all(color: Colors.grey, width: 0.5)
                    : Border.all(color: Colors.blue, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            height: selectedTabItem.value == element.toString() ? 40 : 30,
            child: CustomText(
                fontsize: selectedTabItem.value == element.toString() ? 16 : 14,
                labeltext: element.tr,
                fontWeight: selectedTabItem.value == element.toString()
                    ? FontWeight.w700
                    : FontWeight.normal),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 0.1)),
                child: CustomText(
                  color: Colors.white,
                  fontsize: 8,
                  labeltext: deyer,
                ),
              ))
        ],
      ),
    );
  }

  widgetMoreDataForItems(ModelCariler e) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Divider(
            height: 2,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Rut Gunu",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                width: 5,
              ),
              const SizedBox(
                width: 5,
              ),
              Wrap(
                children: [
                  e.days!.any((a) => a.day == 1)
                      ? widgetRutGunuItems("gun1".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day == 2)
                      ? widgetRutGunuItems("gun2".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day == 3)
                      ? widgetRutGunuItems("gun3".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day == 4)
                      ? widgetRutGunuItems("gun4".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day == 5)
                      ? widgetRutGunuItems("gun5".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day == 6)
                      ? widgetRutGunuItems("gun6".tr)
                      : const SizedBox(),
                  e.days!.any((a) => a.day == 7)
                      ? widgetRutGunuItems("bagli".tr)
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                labeltext: "Tam Unvan",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: ScreenUtil.defaultSize.width / 1.7,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  labeltext: "${e.fullAddress}",
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Rayon",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.district}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Sahe",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.area}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Kateqoriya",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.category}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Telefon",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.phone}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "Voun",
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                labeltext: " : ${e.tin}",
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container widgetRutGunuItems(String s) => Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: CustomText(labeltext: s, color: Colors.white, fontsize: 12),
      );

  Widget widgetSimpleTextInfo(String lable, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 150,
            child: CustomText(labeltext: lable, fontWeight: FontWeight.w600)),
        Expanded(child: CustomText(labeltext: value)),
      ],
    );
  }

  Widget chartWidget() {
    final List<ChartData> chartData = [
      ChartData(
          "Rut gunu",
          modelRutPerform.value.rutSayi! - modelRutPerform.value.duzgunZiya!,
          Colors.red),
      ChartData('Ziyaret', modelRutPerform.value.duzgunZiya!, Colors.green),
    ];
    return SimpleChart(
      listCharts: chartData,
      height: 120,
      width: 150,
    );
  }

  ///////////////////////////////////////////////////////////////////////
  Future<void> changeTabItemsValue(ModelTamItemsGiris element, Position currentLocation) async {
    for (var element2 in listTabItems) {
      if (element2.label == element.label) {
        element2.selected = true;
      } else {
        element2.selected = false;
      }
    }
    if (selectedTemsilci.value.code == "") {
      //getRutPerformToday(true,selectedTemsilci.value);
      switch (element.keyText) {
        case "Grut":
          listSelectedMusteriler.value = carculateDistanceList(
              modelRutPerform.value.listGunlukRut!, currentLocation);
          break;
        case "Gumumi":
          listSelectedMusteriler.value =
              carculateDistanceList(listCariler, currentLocation);
          break;
        case "zedilmeyen":
          listSelectedMusteriler.value = carculateDistanceList(
              modelRutPerform.value.listZiyaretEdilmeyen!, currentLocation);
          break;
      }
    } else {
      await getRutPerformToday(false, selectedTemsilci.value);
      switch (element.keyText) {
        case "Grut":
          listSelectedMusteriler.value = carculateDistanceList(
              modelRutPerform.value.listGunlukRut!
                  .where((element) =>
                      element.forwarderCode == selectedTemsilci.value.code)
                  .toList(),
              currentLocation);
          break;
        case "Gumumi":
          listSelectedMusteriler.value = carculateDistanceList(
              listCariler
                  .where((element) =>
                      element.forwarderCode == selectedTemsilci.value.code)
                  .toList(),
              currentLocation);
          break;
        case "zedilmeyen":
          listSelectedMusteriler.value = carculateDistanceList(
              modelRutPerform.value.listZiyaretEdilmeyen!
                  .where((element) =>
                      element.forwarderCode == selectedTemsilci.value.code)
                  .toList(),
              currentLocation);
          break;
      }
    }
    // if(loggedUserModel.userModel!.roleId==17||loggedUserModel.userModel!.roleId==18||loggedUserModel.userModel!.roleId==23||loggedUserModel.userModel!.roleId==24){
    // switch (element.keyText) {
    //   case "Grut":
    //     listSelectedMusteriler.value = carculateDistanceList(modelRutPerform.value.listGunlukRut!, currentLocation);
    //     break;
    //   case "Gumumi":
    //     listSelectedMusteriler.value = carculateDistanceList(listCariler, currentLocation);
    //     break;
    //   case "zedilmeyen":
    //     listSelectedMusteriler.value = carculateDistanceList(modelRutPerform.value.listZiyaretEdilmeyen!, currentLocation);
    //     break;
    // }}else{
    //   switch (element.keyText) {
    //     case "Gumumi":
    //       listSelectedMusteriler.value = carculateDistanceList(listCariler, currentLocation);
    //       break;
    //   }
    // }
    update();
  }

  List<ModelCariler> carculateDistanceList(List<ModelCariler> listMusteriler, Position event) {
    List<ModelCariler> list = [];
    for (ModelCariler element in listMusteriler) {
      String listmesafe = "0m";
      double hesabMesafe = calculateDistance(
          event.latitude,
          event.longitude,
          double.parse(element.longitude ?? "0"),
          double.parse(element.latitude ?? "0"));
      if (hesabMesafe > 1) {
        listmesafe = "${(hesabMesafe).round()} km";
      } else {
        listmesafe = "${(hesabMesafe * 1000).round()} m";
      }
      element.mesafe = listmesafe;
      element.mesafeInt = hesabMesafe;
      list.add(element);
    }
    list.sort((a, b) => a.mesafeInt!.compareTo(b.mesafeInt!));
    return list;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double uzaqliq = 12742 * asin(sqrt(a));
    return uzaqliq;
  }

  Widget cardSekilElavesi(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
          width: MediaQuery.of(context).size.width,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0).copyWith(left: 10),
              child: CustomText(
                  labeltext: "Sekil elave etmek (4/0)",
                  fontsize: 18,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_a_photo),
              padding: EdgeInsets.all(0),
            )
          ],
        ),
        SizedBox(
          height: 85,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (c, index) {
                return Container(
                  margin: const EdgeInsets.all(0).copyWith(left: 10),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: CustomText(labeltext: "No Photo"),
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget cardTapsiriqlar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0).copyWith(left: 10),
          child: CustomText(
              labeltext: "Tapsiriqlar",
              fontsize: 18,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomText(
              labeltext: "Qeyde alinmis tabsiriq yoxdur", fontsize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget widgetListItemsSifarisler(ModelSifarislerTablesi elementAt, BuildContext context) {
    return InkWell(
      onTap: () async {
        switch (elementAt.type) {
          case "s":
            ModelCariler model = listCariler
                .where((p) => p.code == modelgirisEdilmis.value.ckod)
                .first;
            var deyer = await Get.toNamed(RouteHelper.getScreenSatis(),
                arguments: [model, "s"]);
            if (deyer == "OK") {
              getSatisMelumatlariByCary();
            }

            break;
          case "i":
            ModelCariler model = listCariler
                .where((p) => p.code == modelgirisEdilmis.value.ckod)
                .first;
            String deyer = await Get.toNamed(RouteHelper.getScreenSatis(),
                arguments: [model, "i"]);
            if (deyer == "OK") {
              getSatisMelumatlariByCary();
            }
          case "k":
            Get.dialog(
                transitionDuration: Duration(milliseconds: 100),
                barrierDismissible: false,
                barrierColor: Colors.transparent,
                showKassaDialog(context));
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        height: 115,
        width: 110,
        decoration: BoxDecoration(
            color: elementAt.color,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey.withOpacity(0.5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CustomText(
                      labeltext: elementAt.label!,
                      fontWeight: FontWeight.w800,
                      fontsize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    elementAt.icon!,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              height: 2,
              color: Colors.white,
              thickness: 1,
              endIndent: 5,
              indent: 5,
            ),
            const SizedBox(
              height: 2,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    labeltext: prettify(elementAt.summa!),
                    fontsize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  CustomText(
                    labeltext: "AZN",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ////Satis emeliyyatlari////
  Widget musteriZiyaretDetail(ModelCariler e) {
    double sumSatis = listSifarisler
        .where((element) => element.cariKod == e.code)
        .toList()
        .fold(0.0, (sum, element) => sum + element.netSatis!);
    double sumIade = listIadeler
        .where((element) => element.cariKod == e.code)
        .toList()
        .fold(0.0, (sum, element) => sum + element.netSatis!);

    return modelRutPerform.value.listGirisCixislar!
            .where((a) => a.ckod == e.code)
            .isNotEmpty
        ? SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(2.0).copyWith(top: 5, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    labeltext: "Ziyaret neticeleri",
                    fontWeight: FontWeight.w800,
                    fontsize: 10,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Divider(
                    height: 0.4,
                    color: Colors.grey,
                    endIndent: 0,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      CustomText(
                          labeltext: "Satis : ",
                          fontWeight: FontWeight.w600,
                          fontsize: 10),
                      CustomText(
                        fontsize: 10,
                        labeltext: "${prettify(sumSatis)} ₼",
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(
                              labeltext: "Iade : ",
                              fontWeight: FontWeight.w600,
                              fontsize: 10),
                          CustomText(
                            fontsize: 10,
                            labeltext: "${prettify(sumIade)} ₼",
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                              labeltext: "Ziyaret sayi : ",
                              fontWeight: FontWeight.w600,
                              fontsize: 10),
                          CustomText(
                            fontsize: 10,
                            labeltext: modelRutPerform.value.listGirisCixislar!
                                .where((element) => element.ckod == e.code)
                                .length
                                .toString(),
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(
                              labeltext: "Kassa : ",
                              fontWeight: FontWeight.w600,
                              fontsize: 10),
                          CustomText(
                            fontsize: 10,
                            labeltext:
                                "${prettify(listKassa.where((p) => p.cariKod == e.code).toList().fold(0, (sum, element) => element.kassaMebleg!))} ₼",
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                              labeltext: "Qalma vaxti : ",
                              fontWeight: FontWeight.w600,
                              fontsize: 10),
                          CustomText(
                            fontsize: 10,
                            labeltext: curculateTimeDistanceForVisit(e.code),
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ))
        : SizedBox();
  }

  Widget cardTotalSifarisler(BuildContext context, bool isMap) {
    return listSifarisler.isNotEmpty || listIadeler.isNotEmpty
        ? Container(
            height: isMap ? 140 : 35,
            width: isMap ? 70 : MediaQuery.of(context).size.height,
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isMap ? Colors.grey.withOpacity(0.7) : Colors.grey,
                border: Border.all(width: 1, color: Colors.grey)),
            child: !isMap
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: "satis".tr + " : ",
                            fontWeight: FontWeight.w800,
                            fontsize: 14,
                            color: Colors.white,
                          ),
                          CustomText(
                            labeltext:
                                "${prettify(listSifarisler.fold(0, (sum, element) => sum + element.netSatis!))} ₼",
                            fontsize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: "iade".tr + " : ",
                            fontWeight: FontWeight.w800,
                            fontsize: 14,
                            color: Colors.white,
                          ),
                          CustomText(
                            labeltext:
                                "${prettify(listIadeler.fold(0, (sum, element) => sum + element.netSatis!))} ₼",
                            fontsize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: "kassa".tr + " : ",
                            fontWeight: FontWeight.w800,
                            fontsize: 14,
                            color: Colors.white,
                          ),
                          CustomText(
                            labeltext:
                                "${prettify(listKassa.fold(0, (sum, element) => sum + element.kassaMebleg!))} ₼",
                            fontsize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: "satis".tr,
                            fontWeight: FontWeight.w800,
                            fontsize: 14,
                            color: Colors.white,
                          ),
                          CustomText(
                            labeltext:
                                "${prettify(listSifarisler.fold(0, (sum, element) => sum + element.netSatis!))} ₼",
                            fontsize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ],
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: "iade".tr,
                            fontWeight: FontWeight.w800,
                            fontsize: 14,
                            color: Colors.white,
                          ),
                          CustomText(
                            labeltext:
                                "${prettify(listIadeler.fold(0, (sum, element) => sum + element.netSatis!))} ₼",
                            fontsize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ],
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: "kassa".tr,
                            fontWeight: FontWeight.w800,
                            fontsize: 14,
                            color: Colors.white,
                          ),
                          CustomText(
                            labeltext:
                                "${prettify(listKassa.fold(0, (sum, element) => sum + element.kassaMebleg!))} ₼",
                            fontsize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                  ),
          )
        : SizedBox();
  }

  Widget cardSifarisler(BuildContext context) {
    loggedUserModel.userModel!.permissions!.forEach((element) {
      print("permitions :" + element.toString());
    });
    bool canSell = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canSell");
    bool canCash = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canCash");
    bool canReturn = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canReturn");
    return canSell || canCash || canReturn
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                child: CustomText(
                    labeltext: "sifarisler".tr,
                    fontsize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: listTabSifarisler
                        .map((element) =>
                            widgetListItemsSifarisler(element, context))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              listIadeler.isNotEmpty || listSifarisler.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(3.0).copyWith(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                              fontWeight: FontWeight.w600,
                              color: (listSifarisler.fold(
                                              0.0,
                                              (sum, element) =>
                                                  sum + element.netSatis!) -
                                          listIadeler.fold(
                                              0,
                                              (sum, element) =>
                                                  sum + element.netSatis!)) <
                                      0
                                  ? Colors.red
                                  : Colors.black,
                              labeltext:
                                  "Net satis : ${prettify(listSifarisler.fold(0.0, (sum, element) => sum + element.netSatis!) - listIadeler.fold(0, (sum, element) => sum + element.netSatis!))}"),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          )
        : SizedBox();
  }

  Widget showKassaDialog(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.35,
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                              labeltext: "Dialog Kassa elave",
                              fontsize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0)
                            .copyWith(left: 20, right: 20),
                        child: Column(
                          children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: ctKassaDialog,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  suffix: CustomText(labeltext: "AZN"),
                                  hintText: "mebleg".tr,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.redAccent))),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomElevetedButton(
                            borderColor: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 35,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.green,
                            icon: Icons.monetization_on,
                            elevation: 5,
                            cllback: () {
                              if (double.parse(ctKassaDialog.text.toString()) >
                                  0) {
                                selectedlistKassa.clear();
                                selectedlistKassa.add(ModelCariKassa(
                                    gonderildi: false,
                                    cariKod: modelgirisEdilmis.value.ckod!,
                                    tarix: DateTime.now().toString(),
                                    kassaMebleg: double.parse(
                                        ctKassaDialog.text.toString())));
                                listTabSifarisler.removeLast();
                                listTabSifarisler.insert(
                                    2,
                                    ModelSifarislerTablesi(
                                        label: "Kassa",
                                        icon: "images/payment.png",
                                        summa: selectedlistKassa.fold(
                                            0,
                                            (sum, element) =>
                                                sum! + element.kassaMebleg!),
                                        type: "k",
                                        color: Colors.green));
                                update();
                                Get.back();
                              } else {
                                Get.back();
                              }
                            },
                            label: "Elave et".tr)
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton.outlined(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.highlight_remove,
                        color: Colors.red,
                      )))
            ],
          )),
    );
  }

  Future<void> addKassaTobase(ModelCariKassa model) async {
    await localBaseSatis.addKassaToBase(model);
    update();
  }

  String prettify(double d) {
    return d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void getExpList() {
    List<UserModel> listexpeditorlar = [];
    listexpeditorlar = localBaseDownloads
        .getAllConnectedUserFromLocal()
        .where((element) => element.roleId == 23)
        .toList();
    if (loggedUserModel.userModel!.roleId == 23 ||
        loggedUserModel.userModel!.roleId == 24) {
      listexpeditorlar.insert(0, UserModel(code: "", name: "myRut".tr));
    } else {
      listexpeditorlar.insert(0, UserModel(code: "", name: "hamisi".tr));
    }
    Get.dialog(DialogSimpleUserSelect(
      selectedUserCode: selectedTemsilci.value.code!,
      getSelectedUse: (user) {
        selectedTemsilci.value = user;
        changeSelectedUsersCari(user);
      },
      listUsers: listexpeditorlar,
      vezifeAdi: "Merchendaizer",
    ));
  }

  Future<void> changeSelectedUsersCari(UserModel model) async {
    if (model.code == "") {
      if (loggedUserModel.userModel!.roleId == 23 || loggedUserModel.userModel!.roleId == 24) {
        await getRutPerformToday(false, model);
      } else {
        await getRutPerformToday(true, model);
      }
      listSelectedMusteriler.value = listCariler;
    } else {
      await getRutPerformToday(false, model);
      String temkodu = model.code!;
      listSelectedMusteriler.value = listCariler.where((p0) => p0.forwarderCode == temkodu).toList();
    }
    update();
  }
  ////cal Api servers for InOut
  Future<void> _callApiForEnter(Position currentLocation, ModelCariler selectedModel, String uzaqliq, DateTime myTime) async {
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestGirisCixis model=ModelRequestGirisCixis(
        userPosition: loggedUserModel.userModel!.roleId!.toString(),
        customerCode: selectedModel.code!.toString(),
        note: "",
        operationLatitude: currentLocation.latitude.toString(),
        operationLongitude: currentLocation.longitude.toString(),
        operationType: "In",
        userCode: loggedUserModel.userModel!.code!.toString()
    );
    DialogHelper.hideLoading();
    DialogHelper.showLoading("girisEdilir".tr, false);
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
      final response = await ApiClient().dio().post(
        "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-to-customer",
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
      if (response.statusCode == 200) {
        girisiLocaldaTesdiqleme(currentLocation, selectedModel, uzaqliq, myTime);
        DialogHelper.hideLoading();
        Get.back();
      }
    }
  }

  Future<void> girisiLocaldaTesdiqleme(Position currentLocation, ModelCariler selectedModel, String uzaqliq, DateTime myTime) async {
    createCircles(selectedModel.longitude!, selectedModel.latitude!, selectedModel.code!);
    ModelGirisCixis modela = ModelGirisCixis(
        cariad: selectedModel.name,
        ckod: selectedModel.code,
        girisgps: "${currentLocation.longitude},${currentLocation.latitude}",
        girismesafe: uzaqliq,
        girisvaxt: myTime.toString(),
        gonderilme: "0",
        qeyd: "",
        cixisgps: "0.0",
        cixismesafe: "0",
        cixisvaxt: "0",
        rutgunu: rutGununuYoxla(selectedModel) == true ? "Duz" : "Sef",
        tarix: DateTime.now().toString(),
        temsilciadi: userService.getLoggedUser().userModel!.name.toString(),
        temsilcikodu: userService.getLoggedUser().userModel!.code.toString(),
        vezifeId: userService.getLoggedUser().userModel!.roleId.toString(),
        marketgpsEynilik: selectedModel.latitude,
        marketgpsUzunluq: selectedModel.longitude);
    await localDbGirisCixis.addSelectedGirisCixisDB(modela);
    ModelCariler modelCari = listCariler.where((a) => a.code == modela.ckod).first;
    modelCari.ziyaret = "1";
    await localBase.updateModelCari(modelCari);
    marketeGirisEdilib.value = true;
    modelgirisEdilmis.value = modela;
    addMarkersAndPlygane(selectedModel.longitude!, selectedModel.latitude!, currentLocation);
    slidePanelVisible.value = false;
    leftSideMenuVisible.value = true;
    rightSideMenuVisible.value = true;
    sndeQalmaVaxtiniHesabla();
    getSatisMelumatlariByCary();
    backgroudLocationServiz.startServiz();
    // startconfigBacgroundService();
    update();
  }

  Future<void> _callApiForExit(Position currentLocation, String uzaqliq, DateTime myTime, String qeyd) async {
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestGirisCixis model=ModelRequestGirisCixis(
        userPosition: loggedUserModel.userModel!.roleId!.toString(),
        customerCode: modelgirisEdilmis.value.ckod!,
        note: qeyd,
        operationLatitude: currentLocation.latitude.toString(),
        operationLongitude: currentLocation.longitude.toString(),
        operationType: "Out",
        userCode: loggedUserModel.userModel!.code!.toString()
    );
    DialogHelper.hideLoading();
    DialogHelper.showLoading("cixisEdilir".tr, false);
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
      final response = await ApiClient().dio().post(
        "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-to-customer",
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
      if (response.statusCode == 200) {
        cixisiLocaldaTesdiqle(currentLocation, uzaqliq, myTime, qeyd);
        DialogHelper.hideLoading();
        Get.back();
      }
    }
  }

  Future<void> cixisiLocaldaTesdiqle(Position currentLocation, String uzaqliq, DateTime myTime, String qeyd) async {
    circles.clear();
    modelgirisEdilmis.value.cixisvaxt = myTime.toString();
    modelgirisEdilmis.value.cixisgps = "${currentLocation.longitude},${currentLocation.latitude}";
    modelgirisEdilmis.value.cixismesafe = uzaqliq;
    modelgirisEdilmis.value.qeyd = qeyd;
    ModelCariler modelCari = listCariler.where((a) => a.code == modelgirisEdilmis.value.ckod).first;
    modelCari.ziyaret = "2";
    modelgirisEdilmis.value.rutgunu = rutGununuYoxla(modelCari) == true ? "Duz" : "Sef";
    await localDbGirisCixis.updateSelectedValue(modelgirisEdilmis.value);
    await localBase.updateModelCari(modelCari);
    marketeGirisEdilib.value = false;
    slidePanelVisible.value = false;
    modelgirisEdilmis.value = ModelGirisCixis();
    _timer!.cancel();
    polygon.clear();
    pointsPoly.clear();
    await getRutPerformToday(false,selectedTemsilci.value);
    getSatisMelumatlari();
    ctKassaDialog.text="";
    ctCixisQeyd.text="";
    if (selectedlistKassa.isNotEmpty) {
      addKassaTobase(selectedlistKassa.first);
    }
    DrawerMenuController controller=Get.put(DrawerMenuController());
    controller.onInit();
    controller.addPermisionsInDrawerMenu(loggedUserModel);
    backgroudLocationServiz.stopServiz();
    update();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}

class ModelSifarislerTablesi {
  String? label;
  String? icon;
  double? summa;
  String? type;
  Color? color;

  ModelSifarislerTablesi(
      {this.label, this.icon, this.summa, this.type, this.color});
}
