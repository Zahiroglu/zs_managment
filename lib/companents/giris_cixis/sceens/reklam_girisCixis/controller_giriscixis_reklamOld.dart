import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:ntp/ntp.dart';
import 'package:zs_managment/companents/backgroud_task/bacgroud_location_serviz.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_giriscixis.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/marketuzre_hesabatlar.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
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
import 'package:zs_managment/helpers/user_permitions_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';
import '../../../../dio_config/custim_interceptor.dart';
import '../../../../helpers/exeption_handler.dart';
import '../../../backgroud_task/bacgroud_location_fulltime.dart';
import '../../../permitions/permitions_controller.dart';
import '../../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import '../../../tapsiriqlar/model_task_responce.dart';
import '../../models/model_customers_visit.dart';
import 'package:intl/intl.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class ControllerGirisCixisReklamOld extends GetxController {
  RxList<ModelCariler> listCariler =List<ModelCariler>.empty(growable: true).obs;
  LocalUserServices userService = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  RxBool dataLoading = true.obs;
  RxDouble zoomLevel = 15.0.obs;
  LocalGirisCixisServiz localDbGirisCixis = LocalGirisCixisServiz();
  LocalBaseDownloads localBase = LocalBaseDownloads();
  RxBool marketeGirisEdilib = false.obs;
  Rx<ModelCustuomerVisit> modelgirisEdilmis = ModelCustuomerVisit().obs;
  RxSet<map.Marker> markers = RxSet();
  RxBool leftSideMenuVisible = true.obs;
  RxBool rightSideMenuVisible = true.obs;
  RxBool slidePanelVisible = false.obs;
  Rx<map.LatLng> possition=const map.LatLng(0,0).obs;
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
  Rx<ModelCariler> expandedItem = ModelCariler().obs;
  ScrollController listScrollController = ScrollController();
  RxList<ModelTamItemsGiris> listTabItemsRutGostericileri = List<ModelTamItemsGiris>.empty(growable: true).obs;
  RxList<ModelCariler> listSelectedMusteriler =List<ModelCariler>.empty(growable: true).obs;
  RxList<ModelSifarislerTablesi> listTabSifarisler = List<ModelSifarislerTablesi>.empty(growable: true).obs;
  RxString snQalmaVaxti = "0".obs;
  RxString snDenGirisUzaqligi = "0".obs;
  Timer? _timer;
  TextEditingController ctCixisQeyd = TextEditingController();
  LocalBaseSatis localBaseSatis = LocalBaseSatis();
  RxList<ModelCariHereket> listSifarisler =List<ModelCariHereket>.empty(growable: true).obs;
  RxList<ModelCariHereket> listIadeler =List<ModelCariHereket>.empty(growable: true).obs;
  RxList<ModelCariKassa> listKassa =List<ModelCariKassa>.empty(growable: true).obs;
  RxList<ModelCariKassa> selectedlistKassa = List<ModelCariKassa>.empty(growable: true).obs;
  TextEditingController ctKassaDialog = TextEditingController();
  Rx<UserModel> selectedTemsilci = UserModel(code: "h", name: "hamisi".tr).obs;
  //BackGroudTask backgroudLocationServiz = BackGroudTask();
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler = ExeptionHandler();
  UserPermitionsHelper userPermitionHelper = UserPermitionsHelper();
  LocalPermissionsController permitionController = LocalPermissionsController();
  RxList<UserModel> listexpeditorlar = List<UserModel>.empty(growable: true).obs;
  Rx<ModelTamItemsGiris> selectedTabItem = ModelTamItemsGiris().obs;
  ///list tapsiriqlar
  RxList<ModelResponceTask> listTapsiriqlar = List<ModelResponceTask>.empty(growable: true).obs;

  @override
  Future<void> onInit() async {
    await userService.init();
    loggedUserModel = userService.getLoggedUser();
    await localBaseDownloads.init();
    getAppSetting();

    /// getGirisEdilmisCari();
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

  getGirisEdilmisCari(map.LatLng possitiona) async {
    dataLoading.value == true;
    possition.value=possitiona;
    await localDbGirisCixis.init();
    modelgirisEdilmis.value = await localDbGirisCixis.getGirisEdilmisMarket();
    if (modelgirisEdilmis.value.userCode == null) {
      listCariler.clear();
      await explistiniDoldur();
      marketeGirisEdilib.value = false;
      slidePanelVisible.value = false;
      dataLoading.value = false;
    } else {
      listTapsiriqlar.value = ModelResponceTask().getListOfTask();
      double secilenMarketdenUzaqliq = calculateDistance(
          modelgirisEdilmis.value.customerLatitude,
          modelgirisEdilmis.value.customerLongitude,
          modelgirisEdilmis.value.inLatitude,
          modelgirisEdilmis.value.inLongitude);
      if (secilenMarketdenUzaqliq > 1) {
        snDenGirisUzaqligi.value =
            "${(secilenMarketdenUzaqliq).toStringAsFixed(2)} km";
      } else {
        snDenGirisUzaqligi.value =
            "${(secilenMarketdenUzaqliq * 1000).toStringAsFixed(2)} m";
      }
      createCircles(
          double.parse(modelgirisEdilmis.value.customerLatitude!),
          double.parse(modelgirisEdilmis.value.customerLongitude!),
          modelgirisEdilmis.value.customerCode!);
      marketeGirisEdilib.value = true;
      slidePanelVisible.value = false;
      dataLoading.value = false;
      sndeQalmaVaxtiniHesabla();
    }
    //getSatisMelumatlari();
    getSatisMelumatlari();
    update();
  } // eger markete giris edilibse cixis sehfesi acilmalidir

  Future<void> getExpListDialog(map.LatLng latLng) async {
    Get.dialog(DialogSimpleUserSelect(
      selectedUserCode: selectedTemsilci.value.code!,
      getSelectedUse: (user) {
        selectedTemsilci.value = user;
        selectedTemsilci.value.name ??= "melumattapilmadi".tr;
        getAllDataFormLocale(user.code!);
      },
      listUsers: listexpeditorlar,
      vezifeAdi: "Merchendaizer",
    ));
    update();
  }

  Future<void> explistiniDoldur() async {
    listexpeditorlar.clear();
    localBaseDownloads.getAllConnectedUserFromLocal().toList().forEach((e) {
      listexpeditorlar.add(e);
    });
    if (loggedUserModel.userModel!.roleId != 2 &&
        loggedUserModel.userModel!.roleId != 3 &&
        loggedUserModel.userModel!.roleId != 4) {
      listexpeditorlar.insert(0, UserModel(code: "h", name: "hamisi".tr));
      selectedTemsilci.value = UserModel(code: "h", name: "hamisi".tr);
      update();
    } else {
      if (userPermitionHelper.getOnlyByRutDay(loggedUserModel.userModel!.configrations!)) {
        listexpeditorlar.insert(0, UserModel(code: "m", name: "myRut".tr));
        selectedTemsilci.value = UserModel(code: "m", name: "myRut".tr);
        update();
      } else {
        listexpeditorlar.insert(0, UserModel(code: "h", name: "hamisi".tr));
        listexpeditorlar.insert(1, UserModel(code: "m", name: "myRut".tr));
        selectedTemsilci.value = UserModel(code: "m", name: "myRut".tr);
        update();
      }
    }
    listexpeditorlar.removeWhere((elemebta) =>
        elemebta.code == loggedUserModel.userModel!.code &&
        elemebta.roleId == loggedUserModel.userModel!.roleId);
    await getAllDataFormLocale(selectedTemsilci.value.code!);
    update();
  }

  Future<void> getAllDataFormLocale(String userCode) async {
    listCariler.clear();
    listSelectedMusteriler.clear();
    listCariler.add(ModelCariler(
        forwarderCode: loggedUserModel.userModel!.code.toString(),
        name: loggedUserModel.userModel!.regionName.toString(),
        code: loggedUserModel.userModel!.regionCode.toString(),
        latitude: loggedUserModel.userModel!.regionLatitude,
        longitude: loggedUserModel.userModel!.regionLongitude,
        postalCode: "region"));
    List<MercDataModel> listmodel = await localBase.getAllMercDatail();
    if (listmodel.isNotEmpty) {
      for (MercDataModel model in listmodel) {
        List<MercCustomersDatail> musteriler = model.mercCustomersDatail!;
        for (MercCustomersDatail modelMerc in musteriler) {
          if(!listCariler.any((e)=>e.name==modelMerc.name)){
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
        update();
      }
      if (userCode == "m") {
        listSelectedMusteriler.value = listCariler
            .where((elent) =>
                elent.forwarderCode == loggedUserModel.userModel!.code!)
            .toList();
        await changeSelectedUsersCari(
            loggedUserModel.userModel!.code!);
      }
      else {
        listSelectedMusteriler.value = listCariler
            .where((elent) => elent.forwarderCode == userCode)
            .toList();
        await changeSelectedUsersCari(userCode);
      }
    }
    update();
  } //butun carilerin listini bazadan ceken

  Future<void> changeSelectedDistance(UserModel model, map.LatLng possition) async {
    listSelectedMusteriler.value = carculateDistanceList(listSelectedMusteriler, possition);
    update();
  }

  Future<void> changeSelectedUsersCari(String userCode) async {
    listSelectedMusteriler.clear();
    if (userCode == loggedUserModel.userModel!.code!) {
      if (userPermitionHelper.getOnlyByRutDay(loggedUserModel.userModel!.configrations!)) {
        await getRutPerformToday(false, userCode);
        listSelectedMusteriler.value = carculateDistanceList(modelRutPerform.value.listGunlukRut!, possition.value);
        update();
      } else {
        await getRutPerformToday(false, userCode);
        listSelectedMusteriler.value = carculateDistanceList(
            listCariler
                .where((elent) =>
                    elent.forwarderCode == loggedUserModel.userModel!.code)
                .toList(),
            possition.value);
        update();
      }
    } else if (userCode == "h") {
      await getRutPerformToday(true, userCode);
      listSelectedMusteriler.value =carculateDistanceList(listCariler, possition.value);
      update();
    } else {
      await getRutPerformToday(false, userCode);
      listSelectedMusteriler.value = carculateDistanceList(listCariler.where((p0) => p0.forwarderCode == userCode).toList(),
          possition.value);
      update();
    }
    update();
  }

  Future<ModelRutPerform> getRutPerformToday(
      bool butunCariler, String selectedUser) async
  {
    listTabItemsRutGostericileri.clear();
    if (butunCariler) {
      await localBaseDownloads.getRutDatailForMerc(butunCariler, selectedUser, loggedUserModel.userModel!.code!).then((value) {
        modelRutPerform.value = value;
        listTabItemsRutGostericileri.add(ModelTamItemsGiris(
            icon: Icons.people_outline_outlined,
            label: "umumiMusteri".tr,
            girisSayi: value.duzgunZiya! + value.rutkenarZiya!,
            keyText: "Gumumi",
            marketSayi: listCariler.length,
            selected: true,
            color: Colors.deepPurple));
        listTabItemsRutGostericileri.add(ModelTamItemsGiris(
            icon: Icons.verified_user_outlined,
            label: "ziyaretler".tr,
            girisSayi: value.listGirisCixislar!.length,
            keyText: "z",
            marketSayi: value.listGirisCixislar!.length,
            selected: false,
            color: Colors.green));
      });
      update();
    } else {
      await localBaseDownloads.getRutDatailForMerc(butunCariler, selectedUser, loggedUserModel.userModel!.code!).then((value) {
        modelRutPerform.value = value;
        if (userPermitionHelper.getOnlyByRutDay(loggedUserModel.userModel!.configrations!)) {
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.people_outline_outlined,
              label: "todeyRut".tr,
              girisSayi: value.duzgunZiya,
              keyText: "Grut",
              marketSayi: value.rutSayi,
              selected: true,
              color: Colors.blue));
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.person_off_outlined,
              label: "unVisited".tr,
              girisSayi: 0,
              keyText: "zedilmeyen",
              marketSayi: value.ziyaretEdilmeyen,
              selected: false,
              color: Colors.orange));
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.verified_user_outlined,
              label: "ziyaretler".tr,
              girisSayi: value.listGirisCixislar!.length,
              keyText: "z",
              marketSayi: value.listGirisCixislar!.length,
              selected: false,
              color: Colors.green));
          update();
        } else {
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.people_outline_outlined,
              label: "umumiMusteri".tr,
              girisSayi: value.duzgunZiya! + value.rutkenarZiya!,
              keyText: "Gumumi",
              marketSayi: value.snSayi,
              selected: true,
              color: Colors.deepPurple));
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.people_outline_outlined,
              label: "todeyRut".tr,
              girisSayi: value.duzgunZiya,
              keyText: "Grut",
              marketSayi: value.rutSayi,
              selected: false,
              color: Colors.blue));
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.person_off_outlined,
              label: "unVisited".tr,
              girisSayi: 0,
              keyText: "zedilmeyen",
              marketSayi: value.ziyaretEdilmeyen,
              selected: false,
              color: Colors.orange));
          listTabItemsRutGostericileri.add(ModelTamItemsGiris(
              icon: Icons.verified_user_outlined,
              label: "ziyaretler".tr,
              girisSayi: value.listGirisCixislar!.length,
              keyText: "z",
              marketSayi: value.listGirisCixislar!.length,
              selected: false,
              color: Colors.green));
          update();
        }
      });
      update();
    }
    if (modelRutPerform.value.listGonderilmeyenZiyaretler!.isNotEmpty) {
      listTabItemsRutGostericileri.insert(
          0,
          ModelTamItemsGiris(
              icon: Icons.unpublished,
              label: "gonderilmeyenler".tr,
              girisSayi:
                  modelRutPerform.value.listGonderilmeyenZiyaretler!.length,
              keyText: "gz",
              marketSayi:
                  modelRutPerform.value.listGonderilmeyenZiyaretler!.length,
              selected: true,
              color: Colors.red));
      update();
    }
    selectedTabItem.value = listTabItemsRutGostericileri.first;
    update();
    return modelRutPerform.value;
  } // bu gune aid rut gunleri,ziyaretler v.s Local bazadan

  Future<void> changeTabItemsValue( ModelTamItemsGiris element) async {
    for (var element2 in listTabItemsRutGostericileri) {
      if (element2.label == element.label) {
        element2.selected = true;
        update();
      } else {
        element2.selected = false;
        update();
      }
    }
    await changeSelectedUsersCari(selectedTemsilci.value.code!)
        .then((e) {
      if (selectedTemsilci.value.code == "h") {
        switch (element.keyText) {
          case "Grut":
            listSelectedMusteriler.value = carculateDistanceList(
                modelRutPerform.value.listGunlukRut!, possition.value);
            update();
            break;
          case "Gumumi":
            listSelectedMusteriler.value =
                carculateDistanceList(listCariler, possition.value);
            update();
            break;
          case "zedilmeyen":
            listSelectedMusteriler.value = carculateDistanceList(
                modelRutPerform.value.listZiyaretEdilmeyen!, possition.value);
            update();
            break;
        }
      } else {
        switch (element.keyText) {
          case "Grut":
            listSelectedMusteriler.value = carculateDistanceList(
                modelRutPerform.value.listGunlukRut!, possition.value);
            update();
            break;
          case "Gumumi":
            if(selectedTemsilci.value.code == "m") {
              listSelectedMusteriler.value = carculateDistanceList(listCariler.where((elent) => elent.forwarderCode == loggedUserModel.userModel!.code!).toList(), possition.value);

            }else{
              listSelectedMusteriler ==
                  carculateDistanceList(listCariler.where((elent) =>
                  elent.forwarderCode == selectedTemsilci.value.code).toList(),
                      possition.value);
            }
            update();
            break;
          case "zedilmeyen":
            listSelectedMusteriler.value = carculateDistanceList(
                modelRutPerform.value.listZiyaretEdilmeyen!, possition.value);
            update();
            break;
        }
      }
    });
    selectedTabItem.value = element;
    update();
  }

  Future<void> changeSelectedCustomersDistance(
      map.LatLng currentLocation) async {
    listSelectedMusteriler.value =
        carculateDistanceList(listSelectedMusteriler, currentLocation);
    update();
  }

  void sndeQalmaVaxtiniHesabla() {
    snQalmaVaxti = "".obs;
    if (marketeGirisEdilib.isTrue) {
      DateTime timeGiris =
          DateTime.parse(modelgirisEdilmis.value.inDate.toString());
      snQalmaVaxti.value =
          carculateTimeDistace(timeGiris.toString(), DateTime.now().toString());
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        timeGiris.add(const Duration(seconds: 5));
        snQalmaVaxti.value = carculateTimeDistace(
            timeGiris.toString(), DateTime.now().toString());
        update();
      });
    }
  } // giris edilmis marketin vaxtini hesablayan ve timer qosan

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
    listSifarisler.value = localBaseSatis
        .getAllHereketbyCariKod(modelgirisEdilmis.value.customerCode!);
    listIadeler.value = localBaseSatis
        .getAllIadelerbyCariKod(modelgirisEdilmis.value.customerCode!);
    listKassa.value = localBaseSatis
        .getAllKassabyCariKod(modelgirisEdilmis.value.customerCode!);
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
  createCircles(double longitude, double latitude, String ckod) {
    circles.clear();
    circles.value = {
      map.Circle(
          circleId: map.CircleId(ckod),
          center: map.LatLng(longitude, latitude),
          radius: 100,
          fillColor: Colors.yellow.withOpacity(0.5),
          strokeColor: Colors.black,
          strokeWidth: 1)
    };
  }

  void addMarkersAndPlygane(
      String latitude, String longitude, LocationData currentLocation) {
    polygon.clear();
    pointsPoly.clear();
    pointsPoly.add(map.LatLng(
        currentLocation.latitude!, currentLocation.longitude!));
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
    int hefteningunu = DateTime.now().weekday;
    if (selectedModel.days != null) {
      switch (hefteningunu) {
        case 1:
          if (selectedModel.days!.any((element) => element.day == 1)) {
            rutgun = true;
          }
          break;
        case 2:
          if (selectedModel.days!.any((element) => element.day == 2)) {
            rutgun = true;
          }
          break;
        case 3:
          if (selectedModel.days!.any((element) => element.day == 3)) {
            rutgun = true;
          }
          break;
        case 4:
          if (selectedModel.days!.any((element) => element.day == 4)) {
            rutgun = true;
          }
          break;
        case 5:
          if (selectedModel.days!.any((element) => element.day == 5)) {
            rutgun = true;
          }
          break;
        case 6:
          if (selectedModel.days!.any((element) => element.day == 6)) {
            rutgun = true;
          }
          break;
        default:
          rutgun = false;
      }
    }
    return rutgun;
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
        .where((element) => element.customerCode == kod!)
        .forEach((element) {
      Duration difference = element.outDate!.difference(element.inDate!);
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
        .where((element) => element.customerCode == s)
        .isNotEmpty) {
      return ("Bu gun ziyaret edilib", 1);
    } else {
      return ("Ziyaret Edilmeyib", 0);
    }
  }

  //widgetss
  Widget widgetMusteriHesabatlari(ModelCariler selectedCariModel) {
    return Expanded(
      child: WidgetCarihesabatlar(
        height: 150,
        loggedUser: loggedUserModel,
          cad: selectedCariModel.name ?? "",
          ckod: selectedCariModel.code ?? "",
          ),
    );
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
              margin: const EdgeInsets.all(5).copyWith(left: 10, right: 10),
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
        : const SizedBox();
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

  Widget widgetListGirisItems(ModelCustuomerVisit model) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: model.isRutDay == true ? Colors.red : Colors.green,
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
                      labeltext: model.customerName!,
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
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: model.inDate.toString().substring(11, 19)),
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
                    CustomText(
                        labeltext: model.outDate.toString().substring(11, 19)),
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
                            model.inDate.toString(), model.outDate.toString())),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                        labeltext: model.outDate.toString().substring(0, 11)),
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
                      color:
                          model.isRutDay == false ? Colors.red : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                labeltext:
                    model.isRutDay == false ? "rutdanKenar".tr : "rutgunu".tr,
                color: model.isRutDay == false ? Colors.red : Colors.green,
              ),
            ))
      ],
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
                      padding: const EdgeInsets.all(5),
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
                              icon: const Icon(Icons.expand_less))
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
                width: MediaQuery.of(Get.context!).size.width / 1.7,
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

  List<ModelCariler> carculateDistanceList(List<ModelCariler> listMusteriler, map.LatLng event) {
    List<ModelCariler> list = [];
    for (ModelCariler element in listMusteriler) {
      String listmesafe = "0m";
      double hesabMesafe = calculateDistance(event.latitude, event.longitude, element.latitude ?? 0, element.longitude ?? 0);
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
    double latitude1 = double.parse(lat1.toString());
    double latitude2 = double.parse(lat2.toString());
    double longitude1 = double.parse(lon1.toString());
    double longitude2 = double.parse(lon2.toString());
    var p = 0.017453292519943295;
    var c = cos;
    // var a = 0.5 -
    //     c((lat2 - lat1) * p) / 2 +
    //     c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var a = 0.5 -
        c((longitude2 - latitude1) * p) / 2 +
        c(latitude1 * p) *
            c(longitude2 * p) *
            (1 - c((latitude2 - longitude1) * p)) /
            2;
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
              icon: const Icon(Icons.add_a_photo),
              padding: const EdgeInsets.all(0),
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
              labeltext: "${"tasks".tr} (${listTapsiriqlar.length})",
              fontsize: 18,
              fontWeight: FontWeight.bold),
        ),
        listTapsiriqlar.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0)
                    .copyWith(top: 0, right: 15, left: 10, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                          itemCount: listTapsiriqlar.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return itemsOfTasks(
                                listTapsiriqlar.elementAt(index));
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                          labeltext: "Icra edilmeli tapsiriq sayi : ",
                          color: Colors.red,
                        ),
                        CustomText(
                          labeltext: listTapsiriqlar
                              .where((p0) =>
                                  p0.taskIsComplated == false &&
                                  p0.taskIsImportand == true)
                              .length
                              .toString(),
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
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

  Widget itemsOfTasks(ModelResponceTask model) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.screenComplateCariTask,
            arguments: [model, loggedUserModel]);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 10, top: 2),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 80,
                    child: CustomText(
                      labeltext: model.taskHeader!,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    )),
                SizedBox(
                    width: 120,
                    child: CustomText(
                      labeltext: model.taskTitle!,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 8,
                    )),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child: Row(
                  children: [
                    const Icon(
                      Icons.perm_contact_calendar_outlined,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: model.taskCreaterFullName!,
                          fontsize: 12,
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        CustomText(
                          labeltext: model.taskCreatorRole!,
                          fontsize: 8,
                        )
                      ],
                    )
                  ],
                )),
            Positioned(
                top: -2,
                right: -1,
                child: model.taskIsComplated!
                    ? const Icon(
                        Icons.verified,
                        size: 18,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.error,
                        size: 18,
                        color: Colors.red,
                      ))
          ],
        ),
      ),
    );
  }

  Widget widgetListItemsSifarisler(
      ModelSifarislerTablesi elementAt, BuildContext context) {
    return InkWell(
      onTap: () async {
        switch (elementAt.type) {
          case "s":
            ModelCariler model = listCariler
                .where((p) => p.code == modelgirisEdilmis.value.customerCode)
                .first;
            var deyer = await Get.toNamed(RouteHelper.getScreenSatis(),
                arguments: [model, "s"]);
            if (deyer == "OK") {
              await getSatisMelumatlariByCary();
            }

            break;
          case "i":
            ModelCariler model = listCariler
                .where((p) => p.code == modelgirisEdilmis.value.customerCode)
                .first;
            String deyer = await Get.toNamed(RouteHelper.getScreenSatis(),
                arguments: [model, "i"]);
            if (deyer == "OK") {
              await getSatisMelumatlariByCary();
            }
          case "k":
            Get.dialog(
                transitionDuration: const Duration(milliseconds: 100),
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
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 5)
            ],
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
            .where((a) => a.customerCode == e.code)
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
                                .where(
                                    (element) => element.customerCode == e.code)
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
        : const SizedBox();
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
                            labeltext: "${"satis".tr} : ",
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
                            labeltext: "${"iade".tr} : ",
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
                            labeltext: "${"kassa".tr} : ",
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
        : const SizedBox();
  }

  Widget cardSifarisler(BuildContext context) {
    //   bool canSell=userPermitionHelper.canSellProducts(loggedUserModel.userModel!.permissions!);
    bool canSell = true;
    // bool canCash = loggedUserModel.userModel!.permissions!
    //     .any((element) => element.code == "canCash");
    bool canCash = true;
    bool canReturn = loggedUserModel.userModel!.permissions!
        .any((element) => element.code == "canReturn");

    return !canSell || !canCash || !canReturn
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
              const SizedBox(
                height: 5,
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
                  : const SizedBox(),
            ],
          )
        : const SizedBox();
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
                                    cariKod:
                                        modelgirisEdilmis.value.customerCode!,
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

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void funFlutterToast(String s, bool isSucces) {
    Fluttertoast.showToast(
        msg: s.tr,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: isSucces ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  /////checkAllUnsendedVisits

  ///giris ucun hazirliq
  Future<void> pripareForEnter(
      String uzaqliqDtring,
      LocationData currentLocation,
      ModelCariler selectedModel,
      double uzaqliq) async
  {
    dataLoading.value=true;
    snDenGirisUzaqligi.value = uzaqliqDtring;
    DialogHelper.hideLoading();
    DialogHelper.showLoading("girisMelumatlariYoxlanir".tr);
    await localDbGirisCixis.init();
    String lookupAddress = "time.google.com";
    DateTime myTime = DateTime.now();
    DateTime ntpTime = DateTime.now();
    myTime = DateTime.now();
    try {
      final int offset = await NTP.getNtpOffset(
          localTime: myTime,
          lookUpAddress: lookupAddress,
          timeout: const Duration(seconds: 10));
      ntpTime = myTime.add(Duration(milliseconds: offset));
      int ferq = myTime.difference(ntpTime).inMinutes;
      if (ferq > 1 || ferq < -1) {
        Get.dialog(
          ShowInfoDialog(
              messaje: "phoneTimeError".tr,
              icon: Icons.phonelink_erase_rounded,
              callback: () {
                DialogHelper.hideLoading();
                Get.back();
                // OpenSettings.openDateSetting();
              }),
        );
      } else {
        if (currentLocation.isMock!) {
          ShowInfoDialog(
              messaje: "phoneFikeLocationError".tr,
              icon: Icons.phonelink_erase_rounded,
              callback: () {
                DialogHelper.hideLoading();
                Get.back();
              });
        } else {
          checkAllVisits(currentLocation, selectedModel, uzaqliqDtring, true);
          DialogHelper.hideLoading();
        }
      }
    } catch (ex) {
      Get.dialog(
        ShowInfoDialog(
            messaje: "internetError".tr,
            icon: Icons.signal_cellular_connected_no_internet_0_bar_sharp,
            callback: () {
              Get.back();
            }),
      );
    }
    dataLoading.value=false;
    update();
  }

  void girisiSil(LocationData currentLocation) async {
    Get.dialog(ShowSualDialog(
        messaje: "Girisi silseniz butun emeliyyatlar silinecek.Silmeye eminsiniz?",
        callBack: (va) async {
          if (va) {
            _timer!.cancel();
            circles.clear();
            polygon.clear();
            pointsPoly.clear();
            await localDbGirisCixis.init();
            await localDbGirisCixis.deleteItem(modelgirisEdilmis.value);
            marketeGirisEdilib.value = false;
            modelgirisEdilmis.value = ModelCustuomerVisit();
            getSatisMelumatlari();
            if (!userPermitionHelper.liveTrack(loggedUserModel.userModel!.configrations!)) {
               BackgroudLocationServiz backgroudLocationServiz=BackgroudLocationServiz();
               await backgroudLocationServiz.stopBackGroundFetch();
            }
            ctCixisQeyd.text = "";
            getGirisEdilmisCari(map.LatLng(currentLocation.latitude!, currentLocation.longitude!));
            update();
          }
          Get.back();
        }));
  }

  ///cixis ucun hazirliq
  Future<void> pripareForExit(LocationData currentLocation, String uzaqliq,
      ModelCariler selectedModel) async
  {
    dataLoading.value=true;
    await localDbGirisCixis.init();
    DialogHelper.showLoading("cixisMelumatlariYoxlanir".tr);
    String lookupAddress = "time.google.com";
    DateTime myTime = DateTime.now();
    DateTime ntpTime = DateTime.now();
    myTime = DateTime.now();
    try {
      final int offset = await NTP.getNtpOffset(
          localTime: myTime,
          lookUpAddress: lookupAddress,
          timeout: const Duration(seconds: 10));
      ntpTime = myTime.add(Duration(milliseconds: offset));
      int ferq = myTime.difference(ntpTime).inMinutes;
      if (ferq > 1 || ferq < -1) {
        Get.dialog(
          ShowInfoDialog(
              messaje: "phoneTimeError".tr,
              icon: Icons.phonelink_erase_rounded,
              callback: () {
                DialogHelper.hideLoading();
                Get.back();
                Get.back();
                // OpenSettings.openDateSetting();
              }),
        );
      } else {
        if (currentLocation.isMock!) {
          Get.dialog(
            ShowInfoDialog(
                messaje: "phoneFikeLocationError".tr,
                icon: Icons.phonelink_erase_rounded,
                callback: () {
                  Get.back();
                  // backgroudLocationServiz.sendErrorsToServers(
                  //     "Block",
                  //     selectedModel.code.toString() +
                  //         "adlimarkerBlockMock".tr);
                }),
          );
        } else {
          checkAllVisits(currentLocation, selectedModel, uzaqliq, false);
          DialogHelper.hideLoading();
        }
      }
    } catch (ex) {
      Get.dialog(
        ShowInfoDialog(
            messaje: "internetError".tr,
            icon: Icons.phonelink_erase_rounded,
            callback: () {
              Get.back();
            }),
      );
    }
    dataLoading.value=false;
    update();
  }

  Future<void> checkAllVisits(LocationData currentLocation,
      ModelCariler selectedModel, String uzaqliq, bool isEnter) async {
    ModelCustuomerVisit modela = ModelCustuomerVisit();
    if (isEnter) {
      modela = ModelCustuomerVisit(
          userId:  loggedUserModel.userModel!.id!,
          operationType: "in",
          customerName: selectedModel.name,
          customerCode: selectedModel.code,
          inLatitude: currentLocation.latitude.toString(),
          inLongitude: currentLocation.longitude.toString(),
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          inDistance: uzaqliq.toString(),
          inDate: DateTime.now(),
          gonderilme: "0",
          outNote: "",
          outLatitude: "0.0",
          outLongitude: "0.0",
          outDistance: "0",
          outDate: null,
          isRutDay:rutGununuYoxla(selectedModel),
          inDt: DateTime.now(),
          userFullName: userService.getLoggedUser().userModel!.name.toString(),
          userCode: userService.getLoggedUser().userModel!.code.toString(),
          userPosition:userService.getLoggedUser().userModel!.roleId.toString(),
          customerLatitude: selectedModel.latitude.toString(),
          customerLongitude: selectedModel.longitude.toString());
    } else {
      modela = ModelCustuomerVisit(
          userId:  loggedUserModel.userModel!.id!,
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          operationType: "out",
          customerName: modelgirisEdilmis.value.customerName,
          customerCode: modelgirisEdilmis.value.customerCode,
          inLatitude: modelgirisEdilmis.value.inLatitude,
          inLongitude: modelgirisEdilmis.value.inLongitude,
          inDistance: modelgirisEdilmis.value.inDistance,
          inDate: modelgirisEdilmis.value.inDate!,
          gonderilme: "0",
          outNote: ctCixisQeyd.text,
          outLatitude: currentLocation.latitude.toString(),
          outLongitude: currentLocation.longitude.toString(),
          outDistance: uzaqliq.toString(),
          outDate: DateTime.now(),
          isRutDay:rutGununuYoxla(selectedModel),
          inDt: modelgirisEdilmis.value.inDt,
          userFullName: userService.getLoggedUser().userModel!.name.toString(),
          userCode: userService.getLoggedUser().userModel!.code.toString(),
          userPosition: userService.getLoggedUser().userModel!.roleId.toString(),
          workTimeInCustomer: carculateTimeDistace(modelgirisEdilmis.value.inDate.toString(), DateTime.now().toString()),
          customerLatitude: modelgirisEdilmis.value.customerLatitude,
          customerLongitude: modelgirisEdilmis.value.customerLongitude);
    }
    int countUnsended = localDbGirisCixis.getAllUnSendedGirisCixis().length;
    if (countUnsended > 0) {
      ModelCustuomerVisit model =
          localDbGirisCixis.getAllUnSendedGirisCixis().first;
      await _callApiForSendUnsededs(
          model, currentLocation, uzaqliq, selectedModel, isEnter, modela);
    } else {
      _callApiForVisits(
          currentLocation, uzaqliq, selectedModel, isEnter, modela);
    }
  }

  Future<void> _callApiForSendUnsededs(
      ModelCustuomerVisit modelvisit,
      LocationData currentLocation,
      String uzaqliq,
      ModelCariler selectedModel,
      bool isEnter,
      ModelCustuomerVisit mainVisitModel) async {
    DialogHelper.showLoading("Kohne melumatlar gonderilir");
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestGirisCixis model = ModelRequestGirisCixis();
    if (modelvisit.operationType == "in") {
      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(modelvisit.inDate!);
      model = ModelRequestGirisCixis(
          userId:loggedUserModel.userModel!.id!,
          isRutDay: modelvisit.isRutDay,
          userName: "${loggedUserModel.userModel!.name!.toUpperCase()} ${loggedUserModel.userModel!.surname!.toUpperCase()}",
          userPosition: modelvisit.userPosition.toString(),
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          customerCode: modelvisit.customerCode.toString(),
          note: "",
          operationLatitude: modelvisit.inLatitude.toString(),
          operationLongitude: modelvisit.inLongitude.toString(),
          operationDate: formattedDate,
          inDt: formattedDate,
          operationType: "In",
          userCode: modelvisit.userCode.toString());
    } else {
      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(modelgirisEdilmis.value.inDate!);
      model = ModelRequestGirisCixis(
          userId:loggedUserModel.userModel!.id!,
          isRutDay: modelvisit.isRutDay,
          userName: "${loggedUserModel.userModel!.name!.toUpperCase()} ${loggedUserModel.userModel!.surname!.toUpperCase()}",
          inDt: formattedDate,
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          userPosition: modelvisit.userPosition.toString(),
          customerCode: modelvisit.customerCode.toString(),
          note: modelvisit.outNote.toString(),
          operationLatitude: modelvisit.outLatitude.toString(),
          operationLongitude: modelvisit.outLongitude.toString(),
          operationType: "Out",
          operationDate: modelvisit.outDate.toString(),
          userCode: modelvisit.userCode.toString());
    }
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    try {
      final response = await ApiClient().dio(false).post(
            "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertInOutToSystem",
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
      // 404
      if (response.statusCode == 200) {
        DialogHelper.hideLoading();
        modelvisit.gonderilme = "1";
        localDbGirisCixis.updateSelectedValue(modelvisit);
        checkAllVisits(currentLocation, selectedModel, uzaqliq, isEnter);
      } else {
        if (ModelExceptions.fromJson(response.data['Exception']).code != null) {
          String expCode = ModelExceptions.fromJson(response.data['Exception']).code.toString();
          String messsaje = ModelExceptions.fromJson(response.data['Exception']).message.toString();
          if (expCode == "010") {
            DialogHelper.hideLoading();
            Get.dialog(ShowInfoDialog(
                messaje: messsaje, icon: Icons.error, callback: () {}));
          } else if (expCode == "006") {
            DialogHelper.hideLoading();
            Get.dialog(ShowSualDialog(
                messaje:
                    "$messsaje.Sistemi yeniden baslatmaq lazimdir.Yeniden baslasin?",
                callBack: (val) {
                  if (val) {
                    Get.offAllNamed(RouteHelper.mobileLoginFistScreen);
                  }
                }));
          } else {
            DialogHelper.hideLoading();
            if (isEnter) {
              girisiLocaldaTesdiqleLast(currentLocation, uzaqliq, mainVisitModel, selectedModel);
            } else {
              cixisiLocaldaTesdiqleLast(currentLocation, uzaqliq, ctCixisQeyd.text, mainVisitModel);
            }
          }
        } else {
          DialogHelper.hideLoading();
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        DialogHelper.hideLoading();
        if (isEnter) {
          girisiLocaldaTesdiqleLast(
              currentLocation, uzaqliq, mainVisitModel, selectedModel);
        } else {
          cixisiLocaldaTesdiqleLast(
              currentLocation, uzaqliq, ctCixisQeyd.text, mainVisitModel);
        }
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: e.message!,
            icon: Icons.error,
            callback: () {
              DialogHelper.hideLoading();
            }));
      }
    }
    update();
  }

  Future<void> _callApiForVisits(LocationData currentLocation, String uzaqliq, ModelCariler selectedModel, bool isEnter,
      ModelCustuomerVisit modelVisit) async {
    DialogHelper.showLoading("Kohne melumatlar gonderilir");
    await userService.init();
    final String formattedDate =DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestGirisCixis model = ModelRequestGirisCixis();
    if (isEnter) {
      model = ModelRequestGirisCixis(
        userId:  loggedUserModel.userModel!.id!,
        isRutDay: selectedModel.rutGunu == "Duz" ? true : false,
        userName: "${loggedUserModel.userModel!.name!.toUpperCase()} ${loggedUserModel.userModel!.surname!.toUpperCase()}",
        inDt: formattedDate,
        userPosition: loggedUserModel.userModel!.roleId.toString(),
        userPositionName: loggedUserModel.userModel!.roleName.toString(),
        userCode: loggedUserModel.userModel!.code.toString(),
        customerCode: selectedModel.code.toString(),
        note: "",
        operationLatitude: currentLocation.latitude.toString(),
        operationLongitude: currentLocation.longitude.toString(),
        operationDate: formattedDate,
        operationType: "In",
      );
    } else {
      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(modelgirisEdilmis.value.inDate!);
      model = ModelRequestGirisCixis(
          userId:  loggedUserModel.userModel!.id!,
          userName: "${loggedUserModel.userModel!.name!.toUpperCase()} ${loggedUserModel.userModel!.surname!.toUpperCase()}",
          inDt: formattedDate,
          userPosition: loggedUserModel.userModel!.roleId.toString(),
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          userCode: loggedUserModel.userModel!.code.toString(),
          customerCode: modelgirisEdilmis.value.customerCode.toString(),
          note: ctCixisQeyd.text,
          operationLatitude: currentLocation.latitude.toString(),
          operationLongitude: currentLocation.longitude.toString(),
          operationDate:
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          operationType: "Out");
    }
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertInOutToSystem",
          data: model.toJson(),
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
    // 404
    if (response.statusCode == 200) {
      DialogHelper.hideLoading();
      modelVisit.gonderilme = "1";
      if (isEnter) {
          if (userPermitionHelper.liveTrack(loggedUserModel.userModel!.configrations!)) {
                BackgroudLocationServizFullTime backgroudLocationServizFullTime = Get.put(BackgroudLocationServizFullTime());
                await backgroudLocationServizFullTime.startBackgorundFetckFull(modelVisit).then((v) {
                funFlutterToast("ugurluApiGiris", true);
                girisiLocaldaTesdiqleLast(currentLocation, uzaqliq, modelVisit, selectedModel);
              });

          }
          else{
                BackgroudLocationServiz backgroudLocationServiz = Get.put(BackgroudLocationServiz());
                await backgroudLocationServiz.startBackgorundFetck(modelVisit).then((v) {
              funFlutterToast("ugurluApiGiris", true);
              girisiLocaldaTesdiqleLast(currentLocation, uzaqliq, modelVisit, selectedModel);
            });
          }
        }
      else {
                funFlutterToast("ugurluApiCixis", true);
                cixisiLocaldaTesdiqleLast(currentLocation, uzaqliq, ctCixisQeyd.text, modelVisit);
      }
    }
    else if(response.statusCode==400){
      if (ModelExceptions.fromJson(response.data['Exception']).code != null) {
        String expCode = ModelExceptions.fromJson(response.data['Exception']).code.toString();
        // if(expCode!="400"){
        //   DialogHelper.hideLoading();
        //   modelVisit.gonderilme = "0";
        //   if (userPermitionHelper.liveTrack(loggedUserModel.userModel!.configrations!)) {
        //     bg.State state = await bg.BackgroundGeolocation.state;
        //     if(!state.enabled){
        //       BackgroudLocationServizFullTime backgroudLocationServizFullTime = Get.put(BackgroudLocationServizFullTime());
        //       await backgroudLocationServizFullTime.startBackgorundFetckFull(modelVisit).then((v) {
        //         funFlutterToast("ugurluApiGiris", true);
        //         girisiLocaldaTesdiqleLast(currentLocation, uzaqliq, modelVisit, selectedModel);
        //       });
        //     }else{
        //       funFlutterToast("ugurluApiGiris", true);
        //       girisiLocaldaTesdiqleLast(currentLocation, uzaqliq, modelVisit, selectedModel);
        //     }
        //   }
        //   else {
        //     funFlutterToast("errorApiCixis", false);
        //     cixisiLocaldaTesdiqleLast(currentLocation, uzaqliq, ctCixisQeyd.text, modelVisit);
        //   }
        // }
        //else
          if(expCode=="zs003"){
          DialogHelper.hideLoading();
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
              messaje: ModelExceptions.fromJson(response.data['Exception']).message!, icon: Icons.error, callback: () {}));
        }
      }
    }
    update();
  }

  Future<void> cixisiLocaldaTesdiqleLast(LocationData currentLocation, String uzaqliq, String qeyd, ModelCustuomerVisit? modela) async {
    if (listCariler.any((a) => a.code == modelgirisEdilmis.value.customerCode)) {
      ModelCariler modelCari = listCariler.where((a) => a.code == modelgirisEdilmis.value.customerCode).first;
      modelCari.ziyaret = "2";
      modela!.girisEdilenRutCodu = selectedTemsilci.value.code;
      if (selectedTemsilci.value.code == "m") {
        modela.girisEdilenRutCodu = loggedUserModel.userModel!.code!;
      }
      await localDbGirisCixis.addSelectedGirisCixisDB(modela);
      await localBase.updateModelCari(modelCari);
    } else {
      modela!.girisEdilenRutCodu = selectedTemsilci.value.code;
      if (selectedTemsilci.value.code == "m") {
        modela.girisEdilenRutCodu = loggedUserModel.userModel!.code!;
      }
      await localDbGirisCixis.addSelectedGirisCixisDB(modela);
    }
    marketeGirisEdilib.value = false;
    slidePanelVisible.value = false;
    modelgirisEdilmis.value = ModelCustuomerVisit();
    if (_timer != null) {
      _timer!.cancel();
    }
    pointsPoly.clear();
    ctKassaDialog.text = "";
    ctCixisQeyd.text = "";
    if (selectedlistKassa.isNotEmpty) {
      addKassaTobase(selectedlistKassa.first);
    }
    DrawerMenuController controller = Get.put(DrawerMenuController());
    controller.onInit();
    controller.addPermisionsInDrawerMenu(loggedUserModel);
    listTapsiriqlar.clear();
    await getGirisEdilmisCari(map.LatLng(
      currentLocation.latitude!,
      currentLocation.longitude!,
    ));
    update();
  }

  Future<void> girisiLocaldaTesdiqleLast(
      LocationData currentLocation,
      String uzaqliq,
      ModelCustuomerVisit? modela,
      ModelCariler? selectedModel) async {
    createCircles(selectedModel!.longitude!, selectedModel.latitude!, selectedModel.code!);
    ModelCariler modelCari = listCariler.where((a) => a.code == modela!.customerCode).first;
    modelCari.ziyaret = "1";
    await localBase.updateModelCari(modelCari);
    modela!.girisEdilenRutCodu = selectedTemsilci.value.code;
    if (selectedTemsilci.value.code == "m") {
      modela.girisEdilenRutCodu = loggedUserModel.userModel!.code!;
    }
    await localDbGirisCixis.addSelectedGirisCixisDB(modela);
    addMarkersAndPlygane(selectedModel.longitude!.toString(),
        selectedModel.latitude!.toString(), currentLocation);
    slidePanelVisible.value = false;
    leftSideMenuVisible.value = true;
    rightSideMenuVisible.value = true;
    //listTapsiriqlar.value = ModelResponceTask().getListOfTask();
    marketeGirisEdilib.value = true;
    modelgirisEdilmis.value = modela;
    sndeQalmaVaxtiniHesabla();
    update();
  }

  Future<void> checkAllVisitsForTotalSend() async {
    int countUnsended = localDbGirisCixis.getAllUnSendedGirisCixis().length;
    if (countUnsended > 0) {
      ModelCustuomerVisit model =
          localDbGirisCixis.getAllUnSendedGirisCixis().first;
      _callApiForSendUnsededsTotalSend(model);
    } else {
      Get.dialog(ShowInfoDialog(
          messaje: "btMelumUgurlaGonde".tr,
          icon: Icons.verified,
          callback: () {}));
    }
  }

  Future<void> _callApiForSendUnsededsTotalSend(
      ModelCustuomerVisit modelvisit) async {
    DialogHelper.showLoading("allDataSending".tr);
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestGirisCixis model = ModelRequestGirisCixis();
    if (modelvisit.operationType == "in") {
      final String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(modelvisit.inDate!);

      model = ModelRequestGirisCixis(
          isRutDay: modelvisit.isRutDay,
          userName: "${loggedUserModel.userModel!.name!.toUpperCase()} ${loggedUserModel.userModel!.surname!.toUpperCase()}",
          userPosition: modelvisit.userPosition.toString(),
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          customerCode: modelvisit.customerCode.toString(),
          note: "",
          operationLatitude: modelvisit.inLatitude.toString(),
          operationLongitude: modelvisit.inLongitude.toString(),
          operationDate: formattedDate,
          inDt: formattedDate,
          operationType: "In",
          userCode: modelvisit.userCode.toString());
    } else {
      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(modelvisit.inDate!);
      model = ModelRequestGirisCixis(
          userPositionName: loggedUserModel.userModel!.roleName.toString(),
          userName: "${loggedUserModel.userModel!.name!.toUpperCase()} ${loggedUserModel.userModel!.surname!.toUpperCase()}",
          userPosition: modelvisit.userPosition.toString(),
          customerCode: modelvisit.customerCode.toString(),
          note: modelvisit.outNote.toString(),
          operationLatitude: modelvisit.outLatitude.toString(),
          operationLongitude: modelvisit.outLongitude.toString(),
          operationType: "Out",
          inDt: formattedDate,
          operationDate: modelvisit.outDate.toString(),
          userCode: modelvisit.userCode.toString());
    }
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    try {
      final response = await ApiClient().dio(false).post(
            "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertInOutToSystem",
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
      // 404
      if (response.statusCode == 200) {
        DialogHelper.hideLoading();
        modelvisit.gonderilme = "1";
        localDbGirisCixis.updateSelectedValue(modelvisit);
        checkAllVisitsForTotalSend();
      }
    } on DioException catch (e) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
          messaje: e.message!,
          icon: Icons.error,
          callback: () {
            DialogHelper.hideLoading();
          }));
    }
    update();
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

class ModelTamItemsGiris {
  String? label;
  IconData? icon;
  bool? selected;
  int? marketSayi;
  int? girisSayi;
  String? keyText;
  Color? color;

  ModelTamItemsGiris(
      {this.label,
      this.icon,
      this.selected,
      this.marketSayi,
      this.girisSayi,
      this.keyText,
      this.color});

  @override
  String toString() {
    return 'ModelTamItemsGiris{label: $label, icon: $icon, selected: $selected, marketSayi: $marketSayi, girisSayi: $girisSayi, keyText: $keyText, color: $color}';
  }
}

enum PositionItemType {
  log,
  position,
}
