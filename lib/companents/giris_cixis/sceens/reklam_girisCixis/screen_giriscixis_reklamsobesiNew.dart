

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:zs_managment/companents/backgroud_task/bacgroud_location_fulltime.dart';
import 'package:zs_managment/companents/backgroud_task/bacgroud_location_serviz.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/controller_giriscixis_reklamOld.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/unsended_errors.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/cari_ziyaret_hesabati/widget_giriscixis_item.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/cari_ziyaret_hesabati/widget_giriscixis_item_gonderilmeyen.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/permitions/permitions_controller.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/user_permitions_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

import '../../../hesabatlar/cari_hesabat/model_cari_hesabatlar.dart';

class ScreenGirisCixisReklamNew extends StatefulWidget {
  DrawerMenuController drawerMenuController;

  ScreenGirisCixisReklamNew({required this.drawerMenuController, super.key});

  @override
  State<ScreenGirisCixisReklamNew> createState() => _ScreenGirisCixisReklamNewState();
}

class _ScreenGirisCixisReklamNewState extends State<ScreenGirisCixisReklamNew> with WidgetsBindingObserver {
  ControllerGirisCixisReklamOld controllerGirisCixis = Get.put(ControllerGirisCixisReklamOld());
  PageController pageController = PageController();
  late LocationData _currentLocation;
  Location location = Location();
  int defaultTargetPlatform = 0;
  bool followMe = true;
  String selectedItemsLabel = "Gunluk Rut";
  ModelCariler selectedCariModel = ModelCariler();
  int marketeGirisIcazeMesafesi = 1;
  String secilenMarketdenUzaqliqString = "";
  String girisErrorQeyd = "";
  double secilenMarketdenUzaqliq = 0;
  bool secilenMusterininRutGunuDuzluyu = false;
  bool istifadeciRutdanKenarGirisEdebiler = true;
  bool marketeGirisIcazesi = false;
  bool marketeCixisIcazesi = false;
  ScrollController scrollController = ScrollController();
  LocalUserServices userService = LocalUserServices();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  UserPermitionsHelper permitionsHelper = UserPermitionsHelper();
  BackgroudLocationServiz backgroudLocationServiz=BackgroudLocationServiz();
  BackgroudLocationServizFullTime backgroudLocationServizFull=BackgroudLocationServizFullTime();
  LocalPermissionsController permitionController = LocalPermissionsController();

  bool gpsNotFound=false;
  @override
  void initState() {
    initConfigrations();
    WidgetsBinding.instance.addObserver(this);
    getAllCustomers();
    super.initState();
  }

  Future<void> getAllCustomers() async {
    controllerGirisCixis.dataLoading.value=true;
    if(await permitionController.checkGPSStatusWithPermissionHandler()){
      if(mounted){
        setState(() {
        gpsNotFound=false;
      });}
      await location.getLocation().then((v) {
      if (controllerGirisCixis.initialized) {
        controllerGirisCixis.getGirisEdilmisCari(LatLng(v.latitude!, v.longitude!));
      }
      if(mounted){
        setState(() {
        _currentLocation=v;
        controllerGirisCixis.dataLoading.value = false;
      });}
    });}else{
    if(mounted){
      setState(() {
        gpsNotFound=true;
      });
    }
      Get.dialog(ShowInfoDialog(
          messaje: "gpsError".tr,
          icon: Icons.gps_off,
          callback: () async {
            controllerGirisCixis.dataLoading.value=false;
            Get.back();
          }));
    }
   // _toggleListening();
  }

  Future<void> initConfigrations() async {
    await userService.init();
    loggedUserModel = userService.getLoggedUser();
    marketeGirisIcazeMesafesi = permitionsHelper.getEnterDistance(loggedUserModel.userModel!.configrations!);
    istifadeciRutdanKenarGirisEdebiler = !permitionsHelper.getOnlyByRutDay(loggedUserModel.userModel!.configrations!);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    pageController.dispose();
    if (controllerGirisCixis.marketeGirisEdilib.isFalse) {
      Get.delete<ControllerGirisCixisReklamOld>();
    }
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
      if (state == AppLifecycleState.paused) {
          followMe = false;
          Get.back();
        }else if(state== AppLifecycleState.resumed){
         followMe = true;
         Get.back();
        }
    }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<ControllerGirisCixisReklamOld>(builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                controllerGirisCixis.marketeGirisEdilib.isFalse
                    ? Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: IconButton(
                            icon: const Icon(
                              Icons.supervised_user_circle_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controllerGirisCixis.getExpListDialog(LatLng(
                                  _currentLocation.latitude!,
                                  _currentLocation.longitude!));
                            }),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(
                      icon: const Icon(
                        Icons.error,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ScreenUnsendedErrors()),
                        );
                      }),
                )
              ],
              centerTitle: true,
              title: CustomText(
                  labeltext: "giriscixis".tr,
                  fontsize: 24,
                  fontWeight: FontWeight.w700),
              leading: IconButton(
                onPressed: () {
                  widget.drawerMenuController.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            ),
            body: Obx(() => controller.dataLoading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                :
            !gpsNotFound?
            controller.dataLoading.isTrue?const Center(child: CircularProgressIndicator(color: Colors.green,),):_body(context, controller)
                :NoDataFound(height: 200,width: 200,callBack: (){
              getAllCustomers();
            },mustReloud: true,)));

      }),
    );
  }

  Widget _body(BuildContext context, ControllerGirisCixisReklamOld controller) {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controllerGirisCixis.marketeGirisEdilib.isTrue
                ? Expanded(child: widgetCixisUcun(context))
                : Expanded(child: widgetListRutGunu(controller))
          ],
        ));
  }

  Widget widgetTabBar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Obx(() => ListView(
                      padding: const EdgeInsets.all(0),
                      scrollDirection: Axis.horizontal,
                      children: controllerGirisCixis
                          .listTabItemsRutGostericileri
                          .map((element) => widgetListTabItems(element))
                          .toList(),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetListTabItems(ModelTamItemsGiris element) {
    return InkWell(
      onTap: () {
        if (controllerGirisCixis.marketeGirisEdilib.isFalse) {
          if(mounted) {
            setState(() {
              controllerGirisCixis.changeTabItemsValue(
                  element);
              selectedItemsLabel = element.label!;
              element.selected = true;
              controllerGirisCixis.selectedTabItem.value = element;
            });
          }}
      },
      child: Obx(() => Container(
            decoration: BoxDecoration(
                boxShadow: element.keyText ==
                        controllerGirisCixis.selectedTabItem.value.keyText
                    ? [
                        BoxShadow(
                            color: element.color!,
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 0.1,
                            blurStyle: BlurStyle.outer)
                      ]
                    : [],
                border: element.keyText ==
                        controllerGirisCixis.selectedTabItem.value.keyText
                    ? Border.all(color: element.color!, width: 2)
                    : Border.all(color: Colors.grey, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: element.keyText ==
                    controllerGirisCixis.selectedTabItem.value.keyText
                ? 150
                : 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: element.color,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  height: element.keyText ==
                          controllerGirisCixis.selectedTabItem.value.keyText
                      ? 40
                      : 40,
                  width: element.keyText ==
                          controllerGirisCixis.selectedTabItem.value.keyText
                      ? 150
                      : 120,
                  child: Center(
                    child: CustomText(
                        textAlign: TextAlign.center,
                        fontsize: element.keyText ==
                                controllerGirisCixis
                                    .selectedTabItem.value.keyText
                            ? 16
                            : 14,
                        labeltext: element.label!.tr,
                        maxline: 2,
                        color: Colors.white,
                        fontWeight: element.keyText ==
                                controllerGirisCixis
                                    .selectedTabItem.value.keyText
                            ? FontWeight.w700
                            : FontWeight.normal),
                  ),
                ),
                SizedBox(
                  width: element.keyText ==
                          controllerGirisCixis.selectedTabItem.value.keyText
                      ? 150
                      : 120,
                  height: element.keyText ==
                          controllerGirisCixis.selectedTabItem.value.keyText
                      ? 55
                      : 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            labeltext: element.marketSayi.toString(),
                            textAlign: TextAlign.center,
                            fontsize: element.keyText ==
                                    controllerGirisCixis
                                        .selectedTabItem.value.keyText
                                ? 24
                                : 18,
                            color: element.color,
                            fontWeight: element.keyText ==
                                    controllerGirisCixis
                                        .selectedTabItem.value.keyText
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          CustomText(
                            labeltext: "musteri".tr,
                            textAlign: TextAlign.center,
                            fontsize: 10,
                            color: element.color,
                            fontWeight: element.keyText ==
                                    controllerGirisCixis
                                        .selectedTabItem.value.keyText
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ],
                      ),
                      element.keyText == "z" ||
                              element.keyText == "zedilmeyen" ||
                              element.keyText == "gz"
                          ? const SizedBox()
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: element.keyText ==
                                      controllerGirisCixis
                                          .selectedTabItem.value.keyText
                                  ? 55
                                  : 45,
                              width: 1,
                              color: Colors.grey,
                            ),
                      element.keyText == "z" ||
                              element.keyText == "zedilmeyen" ||
                              element.keyText == "gz"
                          ? const SizedBox()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  labeltext: "${element.girisSayi}",
                                  textAlign: TextAlign.center,
                                  fontsize: element.keyText ==
                                          controllerGirisCixis
                                              .selectedTabItem.value.keyText
                                      ? 24
                                      : 18,
                                  color: Colors.green,
                                  fontWeight: element.keyText ==
                                          controllerGirisCixis
                                              .selectedTabItem.value.keyText
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                CustomText(
                                  labeltext: "visit".tr,
                                  textAlign: TextAlign.center,
                                  fontsize: 10,
                                  color: Colors.green,
                                  fontWeight: element.keyText ==
                                          controllerGirisCixis
                                              .selectedTabItem.value.keyText
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                )
                              ],
                            ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget widgetListRutGunu(ControllerGirisCixisReklamOld controller) {
    return controllerGirisCixis.dataLoading.value
        ? SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: LoagindAnimation(
          textData: "gpsAxtarilir".tr,
          icon: "lottie/locations_search.json",
          isDark: Get.isDarkMode,
        ),
      ),
    )
        : RefreshIndicator(
      onRefresh: getAllCustomers,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widgetTabBar(),
            if (controllerGirisCixis.selectedTabItem.value.keyText != "z" &&
                controllerGirisCixis.selectedTabItem.value.keyText != "gz")
              Padding(
                padding: const EdgeInsets.all(5.0).copyWith(left: 20, bottom: 0,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      labeltext: controllerGirisCixis.selectedTemsilci.value.code == "u"
                          ? "$selectedItemsLabel (${controllerGirisCixis.listSelectedMusteriler.length})"
                          : "${controllerGirisCixis.selectedTemsilci.value.name!} ( ${controllerGirisCixis.listSelectedMusteriler.length} )",
                      fontsize: 18,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                    controllerGirisCixis.marketeGirisEdilib.isFalse?IconButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(10), // Kölgə dərinliyi
                          // shape: WidgetStateProperty.all(
                          //   CircleBorder(), // Dairəvi forma
                          // ),
                          backgroundColor: WidgetStateProperty.all(Colors.blue.withOpacity(0.1)), // Arxa fon rəngi
                          foregroundColor: WidgetStateProperty.all(Colors.white), // İkon rəngi
                        ),
                        onPressed: () async {
                      if(mounted){
                          if (followMe) {
                            funFlutterToast("Meni izle dayandirildi");
                            setState(() {
                              followMe = false;
                            });
                          } else {
                            //confiqGeolocatior();
                         //   _toggleListening();
                            funFlutterToast("Meni izle baslatildi");
                            setState(() {
                              followMe = true;
                            });
                          }
                      }
                    },
                        icon: Icon(
                          followMe ?Icons.gps_fixed: Icons.navigation,
                      color: followMe ? Colors.green : Colors.red,
                    )):const SizedBox()
                  ],
                ),
              )
            else
              const SizedBox(),
            controllerGirisCixis.marketeGirisEdilib.isFalse &&
                (controllerGirisCixis.listSifarisler.isNotEmpty ||
                    controllerGirisCixis.listIadeler.isNotEmpty)
                ? controllerGirisCixis.cardTotalSifarisler(context, false)
                : const SizedBox(),
            Expanded(
              child: controllerGirisCixis.selectedTabItem.value.keyText != "z" &&
                  controllerGirisCixis.selectedTabItem.value.keyText != "gz"
                  ? ListView(
                physics: const ScrollPhysics(),
                controller: scrollController,
                padding: const EdgeInsets.all(0).copyWith(bottom: 0),
                children: controllerGirisCixis.listSelectedMusteriler
                    .map((e) => widgetCustomers(e))
                    .toList(),
              )
                  : controllerGirisCixis
                  .modelRutPerform.value.listGirisCixislar!.isEmpty &&
                  controllerGirisCixis.modelRutPerform.value
                      .listGonderilmeyenZiyaretler!.isEmpty
                  ? const SizedBox()
                  : ziyaretEdilenler(
                controllerGirisCixis.selectedTabItem.value.keyText == "z",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ziyaretEdilenler(bool showZiyaretler) {
    return showZiyaretler
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 0.2,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Colors.grey.withOpacity(0.1))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0)
                        .copyWith(right: 5, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CustomText(
                                labeltext: "${"iseBaslamaVaxti".tr} : ",
                                fontWeight: FontWeight.w700),
                            CustomText(
                                labeltext: controllerGirisCixis
                                    .modelRutPerform
                                    .value
                                    .listGirisCixislar!
                                    .first
                                    .inDate
                                    .toString()
                                    .substring(10, 19)
                                    .toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            CustomText(
                                labeltext: "${"marketdeISvaxti".tr} : ",
                                fontWeight: FontWeight.w700),
                            CustomText(
                                labeltext: controllerGirisCixis
                                    .modelRutPerform.value.snlerdeQalma
                                    .toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            CustomText(
                                labeltext: "${"erazideIsVaxti".tr} : ",
                                fontWeight: FontWeight.w700),
                            CustomText(
                                labeltext: controllerGirisCixis
                                    .modelRutPerform.value.umumiIsvaxti
                                    .toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            CustomText(
                                labeltext: "${"sonuncuCixis".tr} : ",
                                fontWeight: FontWeight.w700),
                            CustomText(
                                labeltext: controllerGirisCixis
                                    .modelRutPerform
                                    .value
                                    .listGirisCixislar!
                                    .last
                                    .outDate
                                    .toString()
                                    .substring(10, 19)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: controllerGirisCixis
                        .modelRutPerform.value.listGirisCixislar!
                        .map((e) => WidgetGirisCixisItem(
                              element: e,
                            ))
                        .toList(),
                  ))
            ],
          )
        : Column(
            children: [
              Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0)
                          .copyWith(left: 10, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(2.0).copyWith(left: 15),
                              child: CustomText(
                                labeltext: "melumatlariGonder".tr,
                                maxline: 2,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                controllerGirisCixis
                                    .checkAllVisitsForTotalSend();
                              },
                              child: const Icon(Icons.refresh))
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 20,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: controllerGirisCixis
                        .modelRutPerform.value.listGonderilmeyenZiyaretler!
                        .map((e) => WidgetGirisCixisItemGonderilmeyen(
                              element: e,
                            ))
                        .toList(),
                  ))
            ],
          );
  }

  Widget widgetCustomers(ModelCariler e) {
    return InkWell(
      onTap: () {
        if(mounted) {
          setState(() {
            if (selectedCariModel == e) {
              selectedCariModel = ModelCariler();
            } else {
              // scrollController.animateTo(double.parse(controllerGirisCixis.listSelectedMusteriler.indexOf(e).toString()),
              //     duration: const Duration(milliseconds: 1000),
              //     curve: Curves.bounceOut);
              //scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeIn);
              setState(() {
                selectedCariModel = e;
                _onMarkerClick(e);
              });
            }
          });
          // Get.back(result: e);
        }},
      child: e.postalCode == "region"
          ? widgetOfisGiris(e)
          : Stack(
              children: [
                Card(
                  color: selectedCariModel == e
                      ? Colors.yellow.withOpacity(0.6)
                      : controllerGirisCixis
                              .modelRutPerform.value.listGirisCixislar!
                              .where((a) => a.customerCode == e.code)
                              .isEmpty
                          ? Colors.white
                          : Colors.white,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  elevation: selectedCariModel == e ? 10 : 5,
                  shadowColor: selectedCariModel == e
                      ? Colors.grey
                      : controllerGirisCixis
                              .modelRutPerform.value.listGirisCixislar!
                              .where((a) => a.customerCode == e.code)
                              .isEmpty
                          ? Colors.blueAccent.withOpacity(0.4)
                          : Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0)
                              .copyWith(left: 8, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  maxline: 2,
                                  labeltext: e.name!,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w700,
                                  fontsize: selectedCariModel == e ? 18 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Divider(height: 1, color: Colors.black),
                        ),
                        selectedCariModel == e
                            ? widgetGirisUcun(e)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              textAlign: TextAlign.center,
                                              labeltext: "${"temKod".tr} : ",
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontsize: 14,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                fontsize: 12,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                labeltext: e.forwarderCode!,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              Icons.social_distance,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                fontsize: 12,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                labeltext: e.mesafe!,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0)
                                        .copyWith(left: 2, bottom: 2),
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: _infoMarketRout(e, context),
                                        )),
                                  ),
                                  controllerGirisCixis.musteriZiyaretDetail(e),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                e.rutGunu == "Duz"
                    ? Positioned(
                        left: 5,
                        top: 7,
                        child: Icon(
                          Icons.bookmark,
                          color: controllerGirisCixis
                                  .modelRutPerform.value.listGirisCixislar!
                                  .where((a) => a.customerCode == e.code)
                                  .isEmpty
                              ? Colors.yellow
                              : Colors.green,
                        ))
                    : const SizedBox(),
                Positioned(
                    right: 15,
                    top: 15,
                    child: Row(
                      children: [
                        CustomText(
                          labeltext: e.code!,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontsize: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () {
                              Get.toNamed(
                                  RouteHelper.getwidgetScreenMusteriDetail(),
                                  arguments: [
                                    e,
                                    controllerGirisCixis.availableMap.value
                                  ]);
                            },
                            child: const Icon(
                                size: 18, Icons.info, color: Colors.blue)),
                      ],
                    ))
              ],
            ),
    );
  }

  Widget _infoMarketRout(ModelCariler element, BuildContext context) {
    int valuMore = 0;
    if (element.days != null) {
      if (element.days!.any((element) => element.day == 1)) {
        valuMore = valuMore + 1;
      }
      if (element.days!.any((element) => element.day == 2)) {
        valuMore = valuMore + 1;
      }
      if (element.days!.any((element) => element.day == 3)) {
        valuMore = valuMore + 1;
      }
      if (element.days!.any((element) => element.day == 4)) {
        valuMore = valuMore + 1;
      }
      if (element.days!.any((element) => element.day == 5)) {
        valuMore = valuMore + 1;
      }
      if (element.days!.any((element) => element.day == 6)) {
        valuMore = valuMore + 1;
      }
      return SizedBox(
        height: valuMore > 5 ? 28 : 28,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            element.days!.any((element) => element.day == 1)
                ? WidgetRutGunu(
                    rutGunu: "gun1".tr, loggedUserModel: loggedUserModel)
                : const SizedBox(),
            element.days!.any((element) => element.day == 2)
                ? WidgetRutGunu(
                    rutGunu: "gun2".tr, loggedUserModel: loggedUserModel)
                : const SizedBox(),
            element.days!.any((element) => element.day == 3)
                ? WidgetRutGunu(
                    rutGunu: "gun3".tr, loggedUserModel: loggedUserModel)
                : const SizedBox(),
            element.days!.any((element) => element.day == 4)
                ? WidgetRutGunu(
                    rutGunu: "gun4".tr, loggedUserModel: loggedUserModel)
                : const SizedBox(),
            element.days!.any((element) => element.day == 5)
                ? WidgetRutGunu(
                    rutGunu: "gun5".tr, loggedUserModel: loggedUserModel)
                : const SizedBox(),
            element.days!.any((element) => element.day == 6)
                ? WidgetRutGunu(
                    rutGunu: "gun6".tr, loggedUserModel: loggedUserModel)
                : const SizedBox(),
            element.days!.any((element) => element.day == 7)
                ? WidgetRutGunu(
                    rutGunu: "bagli".tr,
                    loggedUserModel: loggedUserModel,
                  )
                : const SizedBox(),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void funFlutterToast(String s) {
    Fluttertoast.showToast(
        msg: s.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: followMe ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget widgetGirisUcun(ModelCariler e) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        e.postalCode == "region"
            ? const SizedBox()
            :ModelCariHesabatlar().getAllCariHesabatlarListy(loggedUserModel.userModel!.permissions!).isNotEmpty? SizedBox(
          height: 150,
                child: controllerGirisCixis
                    .widgetMusteriHesabatlari(selectedCariModel)):SizedBox(),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(5.0).copyWith(top: 2, bottom: 0),
                    child: CustomText(
                        fontsize: marketeGirisIcazesi ? 14 : 16,
                        labeltext:
                            "${e.postalCode == "region" ? "ofisdenUzaqliq".tr : "marketdenUzaqliq".tr} : $secilenMarketdenUzaqliqString"),
                  ),
                  e.postalCode == "region"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(5.0)
                              .copyWith(top: 2, bottom: 0),
                          child: CustomText(
                              maxline: 2,
                              fontsize: marketeGirisIcazesi ? 14 : 16,
                              labeltext: secilenMusterininRutGunuDuzluyu == true
                                  ? "rutDuzgunluyuDuz".tr
                                  : "rutDuzgunluyuKenar".tr,
                              color: secilenMusterininRutGunuDuzluyu == true
                                  ? Colors.blue
                                  : Colors.red),
                        ),
                  marketeGirisIcazesi
                      ? const SizedBox()
                      : Row(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                child: CustomText(
                                    labeltext: girisErrorQeyd,
                                    maxline: 3,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        )
                ],
              ),
            ),
            marketeGirisIcazesi
                ? Expanded(
                    flex: 3,
                    child: CustomElevetedButton(
                      cllback: () {
                        girisUcunDialogAc(
                          selectedCariModel,
                          secilenMarketdenUzaqliqString,
                        );
                      },
                      label: "giriset".tr,
                      width: 120,
                      icon: Icons.exit_to_app,
                      borderColor: Colors.blue,
                      elevation: 5,
                    ),
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void _onMarkerClick(ModelCariler model) {
    if(mounted) {
      setState(() {
        selectedCariModel = model;
        secilenMusterininRutGunuDuzluyu =
            controllerGirisCixis.rutGununuYoxla(model);
        secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(
            _currentLocation.latitude,
            _currentLocation.longitude,
            double.parse(model.latitude.toString()),
            double.parse(model.longitude.toString()));
        if (secilenMarketdenUzaqliq > 1) {
          secilenMarketdenUzaqliqString =
          "${(secilenMarketdenUzaqliq).round()} km";
        } else {
          secilenMarketdenUzaqliqString =
          "${(secilenMarketdenUzaqliq * 1000).round()} m";
        }
        if (secilenMarketdenUzaqliq < marketeGirisIcazeMesafesi / 1000) {
          if (istifadeciRutdanKenarGirisEdebiler) {
            marketeCixisIcazesi = true;
            marketeGirisIcazesi = true;
          } else {
            if (secilenMusterininRutGunuDuzluyu) {
              marketeCixisIcazesi = true;
              marketeGirisIcazesi = true;
            } else {
              marketeCixisIcazesi = false;
              marketeGirisIcazesi = false;
              girisErrorQeyd =
              "Rut gunu duz olmadigi ucun giris ede bilmezsiniz!";
            }
          }
        } else {
          marketeCixisIcazesi = false;
          marketeGirisIcazesi = false;
          girisErrorQeyd =
          "${"girisErrorQeyd".tr} : $marketeGirisIcazeMesafesi m";
        }
      });
    }}

  void girisUcunDialogAc(ModelCariler selectedModel, String uzaqliq) async {
    showGirisDialog(selectedModel);
  }

  Future<void> showGirisDialog(ModelCariler model) async {
    DialogHelper.showLoading("mesafeHesablanir".tr);
    secilenMarketdenUzaqliq=marketeGirisIcazeMesafesi+100;
    if (await permitionController.checkBackgroundLocationPermission()) {
      if (await permitionController.checkNotyPermission()) {
      if (await permitionController.checkGPSStatusWithPermissionHandler()) {
        await location.getLocation().then((e) {
          selectedCariModel = model;
          _currentLocation = e;
          secilenMusterininRutGunuDuzluyu =model.rutGunu=="Duz"?true:false;
          secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(
              e.latitude,
              e.longitude,
              model.latitude!,
              model.longitude!);
          if (secilenMarketdenUzaqliq > 1) {
            secilenMarketdenUzaqliqString =
            "${(secilenMarketdenUzaqliq).toStringAsFixed(2)} km";
          } else {
            secilenMarketdenUzaqliqString =
            "${(secilenMarketdenUzaqliq * 1000).toStringAsFixed(2)} m";
          }
          if (secilenMarketdenUzaqliq < marketeGirisIcazeMesafesi / 1000) {
            if (istifadeciRutdanKenarGirisEdebiler) {
              marketeGirisIcazesi = true;
            } else {
              if (secilenMusterininRutGunuDuzluyu) {
                marketeGirisIcazesi = true;
              } else {
                marketeGirisIcazesi = false;
                girisErrorQeyd = "rutGunuError".tr;
              }
            }
          } else {
            marketeCixisIcazesi = false;
            marketeGirisIcazesi = false;
            girisErrorQeyd = "girisErrorQeyd".tr;
          }
          DialogHelper.hideLoading();
          Get.dialog(
              Material(
                color: Colors.transparent,
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery
                            .of(context)
                            .size
                            .height * 0.32,
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.1),
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
                                        labeltext: "dgiris".tr,
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
                              flex: marketeGirisIcazesi ? 4 : 7,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0)
                                    .copyWith(left: 20, right: 20),
                                child: marketeGirisIcazesi
                                    ? Column(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        labeltext:
                                        model.name! + "girisXeber".tr,
                                        fontsize: 18,
                                        maxline: 3,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          CustomText(
                                            labeltext: "${"mesafe".tr} : ",
                                            fontsize: 14,
                                            maxline: 1,
                                            textAlign: TextAlign.start,
                                          ),
                                          CustomText(
                                            labeltext: secilenMarketdenUzaqliqString,
                                            fontsize: 14,
                                            maxline: 1,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                )
                                    : Column(
                                  children: [
                                    const Icon(Icons.info,
                                        color: Colors.green, size: 40),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomText(
                                      labeltext: girisErrorQeyd,
                                      fontsize: 14,
                                      maxline: 4,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: marketeGirisIcazesi ? 3 : 0,
                              child: marketeGirisIcazesi
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomElevetedButton(
                                      borderColor: Colors.black,
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      height: 40, textColor: Colors.green,
                                      icon: Icons.exit_to_app_rounded,
                                      elevation: 5, cllback: () async {
                                        girisEt(secilenMarketdenUzaqliqString, secilenMarketdenUzaqliq,
                                            e, model);
                                      },label: "giris".tr)
                                ],
                              )
                                  : const SizedBox(),
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
              ),
              barrierDismissible: false,
              transitionCurve: Curves.easeOut,
              transitionDuration: const Duration(milliseconds: 400));
        });
      } else {
        Get.dialog(ShowInfoDialog(
            messaje: "gpsError".tr,
            icon: Icons.gps_off,
            callback: () async {
              controllerGirisCixis.dataLoading.value = false;
              Get.back();
            }));
      }
    }else {
      Get.dialog(ShowInfoDialog(
          messaje: "requestForNoty".tr,
          icon: Icons.nearby_error_outlined,
          callback: () {
            permitionController.requestNotyPermission();
            Get.back();
          }));
    }
    } else {
      Get.dialog(ShowInfoDialog(
          messaje: "requestAlweysLocation".tr,
          icon: Icons.nearby_error_outlined,
          callback: () {
            permitionController.requestBackgroundLocationPermission();
            Get.back();
          }));
    }
  }

  Widget widgetCixisUcun(BuildContext context) {
    return Obx(() => Column(
          children: [
            Card(
              shadowColor: Colors.blue,
              elevation: 20,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0)
                        .copyWith(top: 10, bottom: 15, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: CustomText(
                                    labeltext: controllerGirisCixis
                                            .modelgirisEdilmis
                                            .value
                                            .customerName ??
                                        "",
                                    fontWeight: FontWeight.w800,
                                    fontsize: 18,
                                    maxline: 2),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "girisTarixi".tr,
                                      fontWeight: FontWeight.w700,
                                      fontsize: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                      labeltext: controllerGirisCixis
                                          .modelgirisEdilmis.value.inDate
                                          .toString()
                                          .substring(0, 10),
                                      fontWeight: FontWeight.normal,
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "Giris saati :",
                                      fontWeight: FontWeight.w700,
                                      fontsize: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                      labeltext: controllerGirisCixis
                                          .modelgirisEdilmis.value.inDate
                                          .toString()
                                          .substring(11, 19),
                                      fontWeight: FontWeight.normal,
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"mesafe".tr} : ",
                                      fontWeight: FontWeight.w700,
                                      fontsize: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                      labeltext: controllerGirisCixis
                                          .snDenGirisUzaqligi.value,
                                      fontWeight: FontWeight.normal,
                                      fontsize: 14),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomElevetedButton(
                                height: 40,
                                cllback: () {
                                  controllerGirisCixis.girisiSil(_currentLocation);
                                },
                                label: "Giris Sil",
                                icon: Icons.delete,
                                textColor: Colors.red,
                                borderColor: Colors.red,
                                elevation: 5,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomElevetedButton(
                                height: 40,
                                cllback: () {
                                  showCixisDialog();
                                },
                                label: "cixiset".tr,
                                icon: Icons.exit_to_app,
                                surfaceColor: Colors.blue,
                                borderColor: Colors.white,
                                textColor: Colors.white,
                                elevation: 5,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5).copyWith(left: 15),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15))),
                        height: 30,
                        child: Center(
                            child: CustomText(
                                labeltext: controllerGirisCixis.snQalmaVaxti
                                    .toString())),
                      ))
                ],
              ),
            ), //cixis ucun olan hisse
            Expanded(
             // height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      shadowColor: Colors.black,
                      elevation: 5,
                      margin:
                          const EdgeInsets.all(10).copyWith(bottom: 5, top: 0),
                      child: controllerGirisCixis.cardSifarisler(context),
                    ), //satis ucun
                    // Card(
                    //   shadowColor: Colors.black,
                    //   elevation: 5,
                    //   margin: const EdgeInsets.all(10).copyWith(bottom: 5),
                    //   child: controllerGirisCixis.cardTapsiriqlar(context),
                    // ), //tapsiriqlar ucun olan hisse
                    Card(
                      shadowColor: Colors.black,
                      elevation: 5,
                      margin: const EdgeInsets.all(10).copyWith(bottom: 5),
                      child: controllerGirisCixis.cardSekilElavesi(context),
                    ), //sekil elave etmek ucun
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(15).copyWith(bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ModelCariHesabatlar().getAllCariHesabatlarListy(loggedUserModel.userModel!.permissions!).isNotEmpty?
                          controllerGirisCixis.widgetMusteriHesabatlari(selectedCariModel):const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ), //hesabatlar hissesi
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> showCixisDialog() async {
    DialogHelper.showLoading("mesafeHesablanir".tr);
    if (await permitionController.checkBackgroundLocationPermission()) {
      if (await permitionController.checkNotyPermission()) {
        if (await permitionController.checkGPSStatusWithPermissionHandler()) {
          await location.getLocation().then((v) {
            secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(
                v.latitude,
                v.longitude,
                double.parse(
                    controllerGirisCixis.modelgirisEdilmis.value
                        .customerLatitude!),
                double.parse(controllerGirisCixis.modelgirisEdilmis.value
                    .customerLongitude!));
            if (secilenMarketdenUzaqliq > 1) {
              secilenMarketdenUzaqliqString =
              "${(secilenMarketdenUzaqliq).round()} km";
            } else {
              secilenMarketdenUzaqliqString =
              "${(secilenMarketdenUzaqliq * 1000).round()} m";
            }
            if (secilenMarketdenUzaqliq < marketeGirisIcazeMesafesi / 1000) {
              marketeCixisIcazesi = true;
            } else {
              marketeCixisIcazesi = false;
            }
            DialogHelper.hideLoading();
            Get.dialog(
                Material(
                  color: Colors.transparent,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.symmetric(
                          vertical: MediaQuery
                              .of(context)
                              .size
                              .height * 0.28,
                          horizontal: MediaQuery
                              .of(context)
                              .size
                              .width * 0.1),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomText(
                                          labeltext: "dcixis".tr,
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
                                flex: marketeCixisIcazesi ? 6 : 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0)
                                      .copyWith(left: 20, right: 20),
                                  child: marketeCixisIcazesi
                                      ? Column(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          labeltext:
                                          "${controllerGirisCixis
                                              .modelgirisEdilmis
                                              .value
                                              .customerName!} ${"cixiEtmekIsteyi"
                                              .tr}",
                                          fontsize: 18,
                                          maxline: 3,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                        controller:
                                        controllerGirisCixis.ctCixisQeyd,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                            hintText: "cxQeyd".tr,
                                            focusedBorder:
                                            const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color:
                                                    Colors.redAccent))),
                                      ),
                                    ],
                                  )
                                      : Column(
                                    children: [
                                      const Icon(Icons.info,
                                          color: Colors.red, size: 40),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomText(
                                        labeltext:
                                        "${"merketdenUzaqCixisXeta"
                                            .tr}$marketeGirisIcazeMesafesi m-dir",
                                        fontsize: 14,
                                        maxline: 4,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CustomText(
                                          labeltext: "mesafe".tr,
                                          fontsize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CustomText(
                                          labeltext: secilenMarketdenUzaqliqString,
                                          fontsize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                flex: marketeCixisIcazesi ? 3 : 0,
                                child: marketeCixisIcazesi
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomElevetedButton(
                                        borderColor: Colors.black,
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.4,
                                        height: 40,
                                        textColor: Colors.green,
                                        icon: Icons.exit_to_app_rounded,
                                        elevation: 5,
                                        cllback: () async {
                                          if(!permitionsHelper.liveTrack(loggedUserModel.userModel!.configrations!)){
                                          await backgroudLocationServiz
                                              .stopBackGroundFetch().then((a) {
                                            if (a) {
                                              cixisEt(secilenMarketdenUzaqliqString, v);
                                              Get.back();
                                            } else {
                                              Get.dialog(ShowInfoDialog(
                                                  messaje: "cixisError".tr,
                                                  icon: Icons.error,
                                                  callback: () {}));
                                            }
                                          });}else{
                                            cixisEt(secilenMarketdenUzaqliqString, v);
                                            Get.back();
                                          }
                                        },
                                        label: "cixiset".tr)
                                  ],
                                )
                                    : const SizedBox(),
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
                ),
                barrierDismissible: false,
                transitionCurve: Curves.easeOut,
                transitionDuration: const Duration(milliseconds: 400));
          }).catchError((error) {
          });
        } else {
          Get.dialog(ShowInfoDialog(
              messaje: "gpsError".tr,
              icon: Icons.gps_off,
              callback: () async {
                controllerGirisCixis.dataLoading.value = false;
                Get.back();
              }));
        }
      }
      else {
      Get.dialog(ShowInfoDialog(
          messaje: "requestForNoty".tr,
          icon: Icons.nearby_error_outlined,
          callback: () {
            permitionController.requestNotyPermission();
            Get.back();
          }));
    }
    } else {
      Get.dialog(ShowInfoDialog(
          messaje: "requestAlweysLocation".tr,
          icon: Icons.nearby_error_outlined,
          callback: () {
            permitionController.requestBackgroundLocationPermission();
            Get.back();
          }));
    }
  }

  Future<void> cixisEt(String uzaqliq, LocationData value) async {
    await controllerGirisCixis.pripareForExit(value, uzaqliq, selectedCariModel)
        .then((e) {
      //_toggleListening();
      if(mounted){
        setState(() {});}
      ;
    });
  }

  Future<void> girisEt(String uzaqliqString, double uzaqliq, LocationData value,ModelCariler model) async {
       await controllerGirisCixis.pripareForEnter(uzaqliqString, value, model, secilenMarketdenUzaqliq)
           .then((e) async {
         setState(()  {
           selectedCariModel = ModelCariler();
           });
       });

  }

  widgetOfisGiris(ModelCariler e) {
    return Stack(
      children: [
        Card(
          color: selectedCariModel == e
              ? Colors.yellow.withOpacity(0.6)
              : controllerGirisCixis.modelRutPerform.value.listGirisCixislar!
                      .where((a) => a.customerCode == e.code)
                      .isEmpty
                  ? Colors.white
                  : Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          elevation: selectedCariModel == e ? 10 : 5,
          shadowColor: selectedCariModel == e
              ? Colors.grey
              : controllerGirisCixis.modelRutPerform.value.listGirisCixislar!
                      .where((a) => a.customerCode == e.code)
                      .isEmpty
                  ? Colors.blueAccent.withOpacity(0.4)
                  : Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0).copyWith(left: 8, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "images/office.png",
                            width: 35,
                            height: 50,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            maxline: 2,
                            labeltext: e.name!,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                            fontsize: selectedCariModel == e ? 18 : 16,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.social_distance,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            fontsize: 12,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            labeltext: e.mesafe!,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                selectedCariModel == e ? widgetGirisUcun(e) : const SizedBox()
              ],
            ),
          ),
        ),
        Positioned(
            right: 15,
            top: 15,
            child: Row(
              children: [
                CustomText(
                  labeltext: e.code!,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontsize: 12,
                ),
              ],
            ))
      ],
    );
  }

}
