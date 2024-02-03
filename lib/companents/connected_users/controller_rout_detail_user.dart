import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ControllerRoutDetailUser extends GetxController {
  LocalUserServices userService = LocalUserServices();
  LocalAppSetting appSetting = LocalAppSetting();
  late Rx<AvailableMap> availableMap = AvailableMap(
      mapName: CustomMapType.google.name,
      mapType: MapType.google,
      icon:
      'packages/map_launcher/assets/icons/${CustomMapType.google}.svg').obs;
  RxList<UserModel> listUsers = List<UserModel>.empty(growable: true).obs;
  RxList<UserModel> filteredListUsers = List<UserModel>.empty(growable: true).obs;
  RxList<ModelCariler> listSelectedCustomers = List<ModelCariler>.empty(
      growable: true).obs;
  RxList<ModelMercBaza> listSelectedMercBaza = List<ModelMercBaza>.empty(
      growable: true).obs;
  RxList<ModelCariler> listFilteredCustomers = List<ModelCariler>.empty(
      growable: true).obs;
  RxList<ModelMercBaza> listFilteredMercBaza = List<ModelMercBaza>.empty(
      growable: true).obs;
  RxList<ModelGirisCixis> listGirisCixis = List<ModelGirisCixis>.empty(
      growable: true).obs;
  RxBool dataLoading = true.obs;
  TextEditingController ctSearch = TextEditingController();
  TextEditingController ctTemsilciKodu = TextEditingController();
  String soapadress = "http://193.105.123.215:9689/WebService1.asmx";
  String soaphost = "193.105.123.215";
  RxList<ModelSifarislerTablesi> listTabSifarisler = List<
      ModelSifarislerTablesi>.empty(growable: true).obs;
  late Rx<ModelSifarislerTablesi> selectedTab = ModelSifarislerTablesi().obs;
  RxBool routDataLoading = true.obs;
  RxString fromIntentPage = "list".obs;
  final RxSet<map.Marker> markers = <map.Marker>{}.obs;
  final RxSet<map.Circle> circles = <map.Circle>{}.obs;
  late Rx<ModelCariler> selectedCariModel = ModelCariler().obs;
  RxString fistTabSelected = "Exp".obs;

  @override
  void onInit() {
    getAllUsers();
    getAppSetting();
    super.onInit();
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

  void getAllUsers() {
    dataLoading.value = true;
    listUsers.value = [
      UserModel(
          roleName: "Expeditor",
          roleId: 1,
          username: "Asif Memmedov",
          code: "112",
          gender: 0),
      UserModel(
          roleName: "Expeditor",
          roleId: 1,
          username: "Zaur Eliyev",
          code: "132",
          gender: 0),
      UserModel(
          roleName: "Expeditor-Mercendaizer",
          roleId: 1,
          username: "Arzu Haciyeva",
          code: "142",
          gender: 1),
      UserModel(
          roleName: "Expeditor",
          roleId: 1,
          username: "Eli Qasimov",
          code: "31",
          gender: 0),
      UserModel(
          roleName: "Mercendaizer",
          roleId: 2,
          username: "Zuleyxa Kerimova",
          code: "A1",
          gender: 1),
      UserModel(
          roleName: "Mercendaizer",
          roleId: 2,
          username: "Nazile Qasimli",
          code: "A2",
          gender: 1),
      UserModel(
          roleName: "Mercendaizer",
          roleId: 2,
          username: "Aysu Qemberova",
          code: "B2",
          gender: 1),
      UserModel(
          roleName: "Mercendaizer",
          roleId: 2,
          username: "Qaragoz Afdandilova",
          code: "B2",
          gender: 1),
      UserModel(
          roleName: "Mercendaizer",
          roleId: 2,
          username: "Qafuq Memmedob",
          code: "MIN01",
          gender: 0),
    ];
    filteredListUsers.value = listUsers.where((p0) => p0.roleId == 1).toList();
    dataLoading.value = false;
    update();
  }

  Future<void> setAllMarkers() async {
    markers.clear();
    for (ModelCariler model in listFilteredCustomers) {
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

  Future<map.BitmapDescriptor> getClusterBitmap2(int size,
      ModelCariler model) async {
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

  void createDialogTogetExpCode(BuildContext context) {
    Get.dialog(_widgetDialogExpCode(context), barrierDismissible: false);
  }

  Widget _widgetDialogExpCode(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery
                .of(context)
                .size
                .height * 0.34,
            horizontal: MediaQuery
                .of(context)
                .size
                .width * 0.1),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                          labeltext: "Temsilci secimi",
                          fontsize: 18,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.all(8.0).copyWith(left: 20, right: 20),
                    child: Expanded(
                        child: CustomTextField(
                            obscureText: false,
                            updizayn: true,
                            align: TextAlign.center,
                            controller: ctTemsilciKodu,
                            inputType: TextInputType.text,
                            hindtext: "Temsilci kodu...",
                            fontsize: 14)),
                  ),
                  CustomElevetedButton(
                    cllback: () {
                      ctTemsilciKodu.clear();
                      Get.back();
                      temsilciMelumatlariniGetir(ctTemsilciKodu.text,);
                    },
                    label: "Tesdiqle",
                    fontWeight: FontWeight.w700,
                    borderColor: Colors.grey,
                    elevation: 5,
                    height: 30,
                    width: 200,
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                    ctTemsilciKodu.clear();
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

  Future<void> temsilciMelumatlariniGetir(String temKod) async {
    listSelectedCustomers.clear();
    listFilteredCustomers.clear();
    DialogHelper.showLoading("Cari melumatlar endirilir...");
    if (fistTabSelected.value == "Exp") {
      listSelectedCustomers.value = await getDataFromServerUmumiCariler(temKod);
      listSelectedCustomers.value =
          createRandomOrdenNumber(listSelectedCustomers);
      DialogHelper.hideLoading();
      if (listSelectedCustomers.isNotEmpty) {
        tabMelumatlariYukle();
        changeSelectedTabItems(listTabSifarisler.first);
        Get.toNamed(RouteHelper.screenExpRoutDetail, arguments: this);
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "Melumat tapilmadi",
            icon: Icons.error,
            callback: () {
              Get.back();
            }));
      }
      tabMelumatlariYukle();
    } else {
      listSelectedMercBaza.value = await getDataFromServerMercBaza(temKod);
      listGirisCixis.value=await getDataFromServerGirisCixis(temKod);
      DialogHelper.hideLoading();
      if (listSelectedMercBaza.isNotEmpty) {
        Get.toNamed(RouteHelper.screenMercRoutDatail, arguments: [listSelectedMercBaza,listGirisCixis,listUsers.where((p0) => p0.roleId==1).toList()]);
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "Melumat tapilmadi",
            icon: Icons.error,
            callback: () {
              Get.back();
            }));
      }
    }
  }


  List<ModelCariler> createRandomOrdenNumber(List<ModelCariler> list) {
    List<ModelCariler> yeniList = [];
    List<ModelCariler> listBir = list.where((p) => p.day1 == 1).toList();
    List<ModelCariler> listIki = list.where((p) => p.day2 == 1).toList();
    List<ModelCariler> listUc = list.where((p) => p.day3 == 1).toList();
    List<ModelCariler> listDort = list.where((p) => p.day4 == 1).toList();
    List<ModelCariler> listBes = list.where((p) => p.day5 == 1).toList();
    List<ModelCariler> listAlti = list.where((p) => p.day6 == 1).toList();
    for (var i = 1; i <= listBir.length; i++) {
      ModelCariler model = listBir.elementAt(i - 1);
      model.orderNumber = i;
      yeniList.add(model);
    }
    for (var i = 1; i <= listIki.length; i++) {
      ModelCariler model = listIki.elementAt(i - 1);
      model.orderNumber = i;
      //listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
      yeniList.add(model);
    }
    for (var i = 1; i <= listUc.length; i++) {
      ModelCariler model = listUc.elementAt(i - 1);
      model.orderNumber = i;
      //listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
      yeniList.add(model);
    }
    for (var i = 1; i <= listDort.length; i++) {
      ModelCariler model = listDort.elementAt(i - 1);
      model.orderNumber = i;
      // listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
      yeniList.add(model);
    }
    for (var i = 1; i <= listBes.length; i++) {
      ModelCariler model = listBes.elementAt(i - 1);
      model.orderNumber = i;
      // listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
      yeniList.add(model);
    }
    for (var i = 1; i <= listAlti.length; i++) {
      ModelCariler model = listAlti.elementAt(i - 1);
      model.orderNumber = i;
      //listSelectedCustomers.remove(listSelectedCustomers.where((p0) => p0.code==model.code).first);
      yeniList.add(model);
    }
    yeniList.where((element) => element.day1 == 1).toList().sort((a, b) =>
        a.orderNumber!.compareTo(b.orderNumber!));
    yeniList.where((element) => element.day2 == 1).toList().sort((a, b) =>
        a.orderNumber!.compareTo(b.orderNumber!));
    yeniList.where((element) => element.day3 == 1).toList().sort((a, b) =>
        a.orderNumber!.compareTo(b.orderNumber!));
    yeniList.where((element) => element.day4 == 1).toList().sort((a, b) =>
        a.orderNumber!.compareTo(b.orderNumber!));
    yeniList.where((element) => element.day5 == 1).toList().sort((a, b) =>
        a.orderNumber!.compareTo(b.orderNumber!));
    yeniList.where((element) => element.day6 == 1).toList().sort((a, b) =>
        a.orderNumber!.compareTo(b.orderNumber!));

    return yeniList;
  }

  void tabMelumatlariYukle() {
    listTabSifarisler.clear();
    listTabSifarisler.value = [
      ModelSifarislerTablesi(
          label: "Umumi cariler",
          summa: double.tryParse(listSelectedCustomers.length.toString()),
          type: "uc",
          color: Colors.blue),
      ModelSifarislerTablesi(
          label: "Passiv cariler",
          summa: double.tryParse(listSelectedCustomers
              .where((p) => p.action == false)
              .length
              .toString()),
          type: "pc",
          color: Colors.orange),
      ModelSifarislerTablesi(
          label: "Bagli cariler",
          summa: double.tryParse(listSelectedCustomers
              .where((p) => p.day7.toString() == "1")
              .length
              .toString()),
          type: "bc",
          color: Colors.red),
      ModelSifarislerTablesi(
          label: "Rutsuz cariler",
          summa: double.tryParse(listSelectedCustomers
              .where((p) =>
          p.day1.toString() == "0" &&
              p.day2.toString() == "0" &&
              p.day3.toString() == "0" &&
              p.day4.toString() == "0" &&
              p.day5.toString() == "0" &&
              p.day6.toString() == "0" &&
              p.day7.toString() == "0")
              .length
              .toString()),
          type: "rc",
          color: Colors.deepPurple),
    ];
    update();
  }

  void changeSelectedTabItems(ModelSifarislerTablesi element) {
    routDataLoading.value = true;
    selectedTab.value = element;
    listFilteredCustomers.clear();
    switch (element.type) {
      case "uc":
        listSelectedCustomers.toList().forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
      case "pc":
        listSelectedCustomers
            .where((p) => p.action == false)
            .toList()
            .forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
      case "bc":
        listSelectedCustomers
            .where((p) => p.day7.toString() == "1")
            .toList()
            .forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
      case "rc":
        listSelectedCustomers
            .where((p) =>
        p.day1.toString() == "0" &&
            p.day2.toString() == "0" &&
            p.day3.toString() == "0" &&
            p.day4.toString() == "0" &&
            p.day5.toString() == "0" &&
            p.day6.toString() == "0" &&
            p.day7.toString() == "0")
            .toList()
            .forEach((a) {
          listFilteredCustomers.add(a);
        });
        break;
    }
    routDataLoading.value = false;
    update();
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
                    ctTemsilciKodu.clear();
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

  void intentEditCustomers(ModelCariler element) async {
    await Get.toNamed(RouteHelper.screenEditMusteriDetailScreen,
        arguments: [this, RouteHelper.screenExpRoutDetailMap, element]);
    update();
  }

  void _intentAdToMercRut(ModelCariler element) {}


  Future<void> changeCustomersInfo(ModelCariler modelCari) async {
    Get.back();
    if (modelCari.code != null) {
      selectedCariModel.value = modelCari;
      DialogHelper.showLoading("mDeyisdirilir".tr);
      listSelectedCustomers.remove(listSelectedCustomers
          .where((p) => p.code == modelCari.code)
          .first);
      listSelectedCustomers.insert(0, modelCari);
      listFilteredCustomers.remove(listFilteredCustomers
          .where((p) => p.code == modelCari.code)
          .first);
      listFilteredCustomers.insert(0, modelCari);
      await Future.delayed(Duration(seconds: 2));
      tabMelumatlariYukle();
      changeSelectedTabItems(selectedTab.value);
      DialogHelper.hideLoading();
    }
    tabMelumatlariYukle();
    update();
  }

  void changeUsers(String s) {
    if (s == "Exp") {
      filteredListUsers.value =
          listUsers.where((p0) => p0.roleId == 1).toList();
    } else {
      filteredListUsers.value =
          listUsers.where((p0) => p0.roleId == 2).toList();
    }
    update();
  }

  void filterCustomersBySearchView(String st) {
    listFilteredCustomers.clear();
    if (st.isNotEmpty) {
      listSelectedCustomers
          .where((p) =>
      p.code!.toUpperCase().contains(st.toUpperCase()) ||
          p.name!.toUpperCase().contains(st.toUpperCase()))
          .forEach((element) {
        listFilteredCustomers.add(element);
      });
    } else {
      for (var element in listSelectedCustomers) {
        listFilteredCustomers.add(element);
      }
    }
    update();
  }

  ////Cari Baza endirme/////////
  Future<List<ModelMercBaza>> getDataFromServerMercBaza(
      String temsilcikodu) async {
    String temp = "'" + temsilcikodu + "'";
    String audit = "";
    String supervaizer = "";
    String ay = "01";
    var envelopeaUmumicariler = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
    <mercler xmlns="http://tempuri.org/">
      <ay>$ay</ay>
      <audit>$audit</audit>
      <merc>$temp</merc>
      <srv>$supervaizer</srv>
    </mercler>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url, headers: {
      "Content-Type": "text/xml; charset=utf-8",
      "SOAPAction": "http://tempuri.org/mercler",
      // "Host": "85.132.97.2"
      "Host": soaphost
      //"Accept": "text/xml"
    }, body: envelopeaUmumicariler);
    var rawXmlResponse = "";
    if (response.statusCode == 200) {
      rawXmlResponse = response.body;
      print(" response.body :" + response.body.toString());
    } else {
      Get.dialog(ShowInfoDialog(
        messaje: "Xeta BAs Verdi",
        icon: Icons.error,
        callback: () {
          DialogHelper.hideLoading();
        },
      ));
    }
    update();
    return _parsingCarilerMerc(rawXmlResponse);
  }

  Future<List<ModelMercBaza>> _parsingCarilerMerc(var _response) async {
    List<ModelMercBaza> listKodrdinar = [];
    print("_responce :" + _response.toString());
    var document = xml.parse(_response);
    Iterable<xml.XmlElement> items = document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var _kode = _getValue(item.findElements("merc_cari_kod"));
      var _name = _getValue(item.findElements("cari_ad"));
      var _rutadi = _getValue(item.findElements("merc_kod"));
      var mercAdi = _getValue(item.findElements("merc_ad"));
      var _audit = _getValue(item.findElements("merc_audit"));
      var _gun1 = _getValue(item.findElements("merc_gun1"));
      var _gun2 = _getValue(item.findElements("merc_gun2"));
      var _gun3 = _getValue(item.findElements("merc_gun3"));
      var _gun4 = _getValue(item.findElements("merc_gun4"));
      var _gun5 = _getValue(item.findElements("merc_gun5"));
      var _gun6 = _getValue(item.findElements("merc_gun6"));
      var _gun7 = _getValue(item.findElements("merc_gun7"));
      var _uzunluq = _getValue(item.findElements("merc_gps_uz"));
      var _eynilik = _getValue(item.findElements("merc_gps_en"));
      var _netsatis = _getValue(item.findElements("NET_SATIS"));
      var _plan = _getValue(item.findElements("merc_plan"));
      var _qaytarma = _getValue(item.findElements("ZAY_QAYTARMA"));
      var _expkodu = _getValue(item.findElements("merc_tem_kod"));
      var _spr = _getValue(item.findElements("merc_srv_kod"));
      ModelMercBaza modelKordinat = ModelMercBaza(
          supervaizer: _spr,
          expeditor: _expkodu,
          carikod: _kode,
          mercadi: mercAdi,
          gpsUzunluq: _uzunluq,
          gpsEynilik: _eynilik,
          audit: _audit,
          cariad: _name,
          gun1: _gun1,
          gun2: _gun2,
          gun3: _gun3,
          gun4: _gun4,
          gun5: _gun5,
          gun6: _gun6,
          gun7: _gun7,
          netsatis: _netsatis,
          plan: _plan,
          qaytarma: _qaytarma,
          rutadi: _rutadi
      );
      listKodrdinar.add(modelKordinat);
      //  itemsList.add(_addResult);
    }).toList();
    return listKodrdinar;
  }


  /////Merc baza////////////
  Future<List<ModelCariler>> getDataFromServerUmumiCariler(
      String temsilcikodu) async {
    var envelopeaUmumicariler = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
    <Umumi_list xmlns="http://tempuri.org/">
      <tem>$temsilcikodu</tem>
    </Umumi_list>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/Umumi_list",
          // "Host": "85.132.97.2"
          "Host": soaphost
          //"Accept": "text/xml"
        },
        body: envelopeaUmumicariler);
    var rawXmlResponse = "";
    if (response.statusCode == 200) {
      rawXmlResponse = response.body;
    } else {
      Get.dialog(ShowInfoDialog(
        messaje: "Xeta BAs Verdi",
        icon: Icons.error,
        callback: () {
          DialogHelper.hideLoading();
        },
      ));
    }
    update();
    return _parsingCariler(rawXmlResponse);
  }

  Future<List<ModelCariler>> _parsingCariler(var _response) async {
    List<ModelCariler> listKodrdinar = [];
    var document = xml.parse(_response);
    Iterable<xml.XmlElement> items = document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var _kode = _getValue(item.findElements("kod"));
      var _name = _getValue(item.findElements("ad"));
      var _expkodu = _getValue(item.findElements("tem"));
      var _tamunvan = _getValue(item.findElements("tamun"));
      var _mesulsexs = _getValue(item.findElements("mesulsexs"));
      var _voun = _getValue(item.findElements("voun"));
      var _telefon = _getValue(item.findElements("telefon"));
      var _sticker = _getValue(item.findElements("sticker"));
      var _sahe = _getValue(item.findElements("sahe"));
      var _kateq = _getValue(item.findElements("kateq"));
      var _bolgekodu = _getValue(item.findElements("bolgekodu"));
      var _qaliq = _getValue(item.findElements("qaliq"));
      var _rayon = _getValue(item.findElements("rayon"));
      var _gun1 = _getValue(item.findElements("gun1"));
      var _gun2 = _getValue(item.findElements("gun2"));
      var _gun3 = _getValue(item.findElements("gun3"));
      var _gun4 = _getValue(item.findElements("gun4"));
      var _gun5 = _getValue(item.findElements("gun5"));
      var _gun6 = _getValue(item.findElements("gun6"));
      var _gun7 = _getValue(item.findElements("gun7"));
      var _hereket = _getValue(item.findElements("h1"));
      var _anacari = _getValue(item.findElements("ana_cari"));
      var _uzunluq = _getValue(item.findElements("uzunluq"));
      var _eynilik = _getValue(item.findElements("eynilik"));
      bool actions = false;
      if (_hereket.toString() == "1") {
        print("_hereket true :" + _hereket.toString());
        actions = true;
      } else {
        print("_hereket false :" + _hereket.toString());
        actions = false;
      }
      ModelCariler modelKordinat = ModelCariler(
          forwarderCode: _expkodu,
          code: _kode,
          name: _name,
          longitude: _uzunluq,
          latitude: _eynilik,
          fullAddress: _tamunvan,
          ownerPerson: _mesulsexs,
          tin: _voun,
          phone: _telefon,
          postalCode: _sticker,
          area: _sahe,
          category: _kateq,
          regionalDirectorCode: _bolgekodu,
          debt: double.parse(
              _qaliq.toString() != "null" ? _qaliq.toString() : "0"),
          district: _rayon,
          day1: int.parse(_gun1),
          day2: int.parse(_gun2),
          day3: int.parse(_gun3),
          day4: int.parse(_gun4),
          day5: int.parse(_gun5),
          day6: int.parse(_gun6),
          day7: int.parse(_gun7),
          action: actions,
          mainCustomer: _anacari,
          ziyaret: "0");
      modelKordinat.rutGunu = rutDuzgunluyuYoxla(modelKordinat);
      modelKordinat.orderNumber = 0;
      modelKordinat.mesafeInt = 0;
      modelKordinat.mesafe = "s";
      listKodrdinar.add(modelKordinat);
      //  itemsList.add(_addResult);
    }).toList();
    listKodrdinar.forEach((element) {
      print("element :" + element.toString());
    });
    return listKodrdinar;
  }

  _getValue(Iterable<xml.XmlElement> items) {
    var textValue;
    items.map((xml.XmlElement node) {
      textValue = node.text;
    }).toList();
    return textValue;
  }

  bool rutGununuYoxla(ModelCariler model) {
    bool rutgunu = false;
    final now = DateTime.now();
    int day = now.weekday;
    int irutgunu = 0;
    if (model.day1 == "1") {
      irutgunu = 1;
    } else if (model.day2 == 1) {
      irutgunu = 2;
    } else if (model.day3 == 1) {
      irutgunu = 3;
    } else if (model.day4 == 1) {
      irutgunu = 4;
    } else if (model.day5 == 1) {
      irutgunu = 5;
    } else if (model.day6 == 1) {
      irutgunu = 6;
    } else {
      rutgunu = false;
    }
    if (irutgunu == day) {
      rutgunu = true;
    } else {
      false;
    }
    return rutgunu;
  }

  String rutDuzgunluyuYoxla(ModelCariler selectedModel) {
    String rutgun = "Sef";
    int hefteningunu = DateTime
        .now()
        .weekday;
    switch (hefteningunu) {
      case 1:
        if (selectedModel.day1 == 1) {
          rutgun = "Duz";
        }
        break;
      case 2:
        if (selectedModel.day2 == 1) {
          rutgun = "Duz";
        }
        break;
      case 3:
        if (selectedModel.day3 == 1) {
          rutgun = "Duz";
        }
        break;
      case 4:
        if (selectedModel.day4 == 1) {
          rutgun = "Duz";
        }
        break;
      case 5:
        if (selectedModel.day5 == 1) {
          rutgun = "Duz";
        }
        break;
      case 6:
        if (selectedModel.day6 == 1) {
          rutgun = "Duz";
        }
        break;
      default:
        rutgun = "Sef";
    }
    return rutgun;
  }

////giris cixis
  Future<List<ModelGirisCixis>> getDataFromServerGirisCixis(String temsilcikodu) async {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    DateTime dateParse = DateTime.parse(date);
    String ilkGun = intl.DateFormat('yyyyMMdd').format(dateParse);
    String songun = intl.DateFormat('yyyyMMdd').format(now);
    print("ilkGun :"+ilkGun);
    print("songun :"+songun);
    String tkod="'"+temsilcikodu+"'";
    print("temsilcikodu :"+tkod);

    var envelopeaUmumicariler = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
    <Rutlarimiz_izl xmlns="http://tempuri.org/">
      <tem1>$tkod</tem1>
      <t1>$ilkGun</t1>
      <t2>$songun</t2>
    </Rutlarimiz_izl>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/Rutlarimiz_izl",
          // "Host": "85.132.97.2"
          "Host": soaphost
          //"Accept": "text/xml"
        },
        body: envelopeaUmumicariler);
    var rawXmlResponse = "";
    print(response.body.toString());
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      rawXmlResponse = response.body;
    } else {
      Get.dialog(ShowInfoDialog(
        messaje: "Xeta BAs Verdi",
        icon: Icons.error,
        callback: () {
          DialogHelper.hideLoading();
        },
      ));
    }
    update();
    return _parsingGirisler(rawXmlResponse);
  }

  Future<List<ModelGirisCixis>> _parsingGirisler(var _response) async {
    List<ModelGirisCixis> listKodrdinar = [];
    var document = xml.parse(_response);
    Iterable<xml.XmlElement> items = document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var izl_cari_kod = _getValue(item.findElements("izl_cari_kod"));
      var izl_cari_ad = _getValue(item.findElements("izl_cari_ad"));
      var izl_vezife = _getValue(item.findElements("izl_vezife"));
      var izl_tem_mer_kod = _getValue(item.findElements("izl_tem_mer_kod"));
      var izl_tem_mer_ad = _getValue(item.findElements("izl_tem_mer_ad"));
      var izl_gir_tarix = _getValue(item.findElements("izl_gir_tarix"));
      var izl_gir_mesf = _getValue(item.findElements("izl_gir_mesf"));
      var izl_gir_kon = _getValue(item.findElements("izl_gir_kon"));
      var izl_cix_tarix = _getValue(item.findElements("izl_cix_tarix"));
      var izl_cix_mesf = _getValue(item.findElements("izl_cix_mesf"));
      var izl_cix_kon = _getValue(item.findElements("izl_cix_kon"));
      var izl_aciqlama = _getValue(item.findElements("izl_aciqlama"));
      var izl_rut_uyg = _getValue(item.findElements("izl_rut_uyg"));
      var boy = _getValue(item.findElements("boy"));
      var en = _getValue(item.findElements("en"));
      ModelGirisCixis model = ModelGirisCixis(cariKod: izl_cari_kod,
          cariAd: izl_cari_ad,
          vezifeId: izl_vezife,
          temKod: izl_tem_mer_kod,
          temAd: izl_tem_mer_ad,
          girisTarix: izl_gir_tarix,
          girisMesafe: izl_gir_mesf,
          girisGps: izl_gir_kon,
          cixisTarix: izl_cix_tarix,
          cixisMesafe: izl_cix_mesf,
          cixisGps: izl_cix_kon,
          ziyaretQeyd: izl_aciqlama,
          rutUygunluq: izl_rut_uyg,
          marketUzunluq: boy??"0",
          marketEynilik: en??"0");
      listKodrdinar.add(model);
      //  itemsList.add(_addResult);
    }).toList();
    return listKodrdinar;
  }
}
