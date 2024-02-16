import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/screen_giriscixis_list.dart';
import 'package:zs_managment/companents/hesabatlar/giriscixis_hesabat/companents/widget_listitemsgiriscixis.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScreenGirisCixisUmumiList extends StatefulWidget {
  DrawerMenuController drawerMenuController;
   ScreenGirisCixisUmumiList({required this.drawerMenuController,super.key});

  @override
  State<ScreenGirisCixisUmumiList> createState() => _ScreenGirisCixisUmumiListState();
}

class _ScreenGirisCixisUmumiListState extends State<ScreenGirisCixisUmumiList> {
  late LocationData _currentLocation;
  final _location = Location();
  ControllerGirisCixisYeni controllerGirisCixis =
  Get.put(ControllerGirisCixisYeni());
  bool followMe = false;
  bool dataLoading = true;
  String selectedItemsLabel = "Gunluk Rut";
  ModelCariler selectedCariModel = ModelCariler();
  int marketeGirisIcazeMesafesi = 120000;
  String secilenMarketdenUzaqliqString = "";
  String girisErrorQeyd = "";
  double secilenMarketdenUzaqliq = 0;
  bool secilenMusterininRutGunuDuzluyu = false;
  bool istifadeciRutdanKenarGirisEdebiler = true;
  bool marketeGirisIcazesi = false;
  bool marketeCixisIcazesi = false;
  ScrollController scrollController = ScrollController();
  ModelTamItemsGiris selectedTabItem = ModelTamItemsGiris();

  @override
  void initState() {
    _location.changeSettings(
      accuracy: LocationAccuracy.reduced,
      distanceFilter: 0,
      interval: 5// Minimum distance (in meters) between location updates
    );
    _getStartingLocation().then((value) {
      setState(() {
        controllerGirisCixis.changeTabItemsValue(
            controllerGirisCixis.listTabItems
                .where((p) => p.selected == true)
                .first,
            value);
        dataLoading = false;
      });
    });
    _getFollowingTrack();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ControllerGirisCixisYeni>();
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> enableBackgroundMode() async {
    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      var status = await Permission.locationAlways.request();
      if (status.isGranted) {
        return true;
        //Do some stuff
      } else {
        return false;
        //Do another stuff
      }
    } else {
      return false;
      //previously available, do some stuff or nothing
    }
  }

  void _getFollowingTrack() async {
    try {
      _location.onLocationChanged.listen((event) async {
        if (followMe) {
          _currentLocation = event;
          controllerGirisCixis.changeTabItemsValue(
              controllerGirisCixis.listTabItems
                  .where((p) => p.selected == true)
                  .first,
              event);
          funFlutterToast("Cureent loc :" +
              _currentLocation.longitude.toString() +
              _currentLocation.latitude.toString());
        }
      });
    } on Exception {
      print("xeta bas verdi");
    }
    setState(() {});
  }

  Future<LocationData> _getStartingLocation() async {
    _currentLocation = await _location.getLocation();
    setState(() {});
    print("Location : ${_currentLocation.latitude}|${_currentLocation.longitude}");
    return _currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<ControllerGirisCixisYeni>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(icon: Icon(Icons.supervised_user_circle_outlined,color: Colors.black,),onPressed: (){
                  List<UserModel> listexpeditorlar= controllerGirisCixis.localBaseDownloads.getAllConnectedUserFromLocal();
                  Get.dialog(DialogSimpleUserSelect(selectedUserCode: "",getSelectedUse: (user){

                  },listUsers: listexpeditorlar,vezifeAdi: "exp".tr,));
                }),
              )
            ],
            centerTitle: true,
            title: CustomText(
                labeltext: "Giris-Cixis",
                fontsize: 24,
                fontWeight: FontWeight.w700),
            leading: IconButton(
              onPressed: (){
                widget.drawerMenuController.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),

          ),
          //  floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButton: controllerGirisCixis.marketeGirisEdilib.isFalse
              ? FloatingActionButton(
            onPressed: () {
              setState(() {
                if (followMe) {
                  followMe = false;
                  funFlutterToast("Meni izle dayandirildi");
                } else {
                  followMe = true;
                  funFlutterToast("Meni izle baslatildi");
                }
                print("follow me :" + followMe.toString());
              });
            },
            backgroundColor: followMe ? Colors.green : Colors.white,
            elevation: 10,
            child: Icon(
              Icons.navigation,
              color: followMe ? Colors.white : Colors.red,
            ),
          )
              : SizedBox(),
          body: controller.modelRutPerform.value.snSayi == null
              ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ))
              : _body(context, controller),
        );
      }),
    );
  }

  Widget _body(BuildContext context, ControllerGirisCixisYeni controller) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          controllerGirisCixis.marketeGirisEdilib.isTrue
              ? const SizedBox()
              : widgetTabBar(),
          controllerGirisCixis.marketeGirisEdilib.isTrue
              ? widgetCixisUcun(context)
              : widgetListRutGunu(controller),

        ],
      ),
    );
  }


  Widget widgetTabBar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 115,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.horizontal,
                  children: controllerGirisCixis.listTabItems
                      .map((element) => widgetListTabItems(element))
                      .toList(),
                ),
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
          setState(() {
            controllerGirisCixis.changeTabItemsValue(element, _currentLocation);
            selectedItemsLabel = element.label!;
            selectedTabItem = element;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: element.selected!
                ? const [
              BoxShadow(
                  color: Colors.blueAccent,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0.2,
                  blurStyle: BlurStyle.outer)
            ]
                : [],
            border: element.selected!
                ? Border.all(color: element.color!, width: 2)
                : Border.all(color: Colors.grey, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 100,
        width: element.selected! ? 140 : 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: element.color,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              height: 40,
              width: element.selected! ? 140 : 120,
              child: CustomText(
                  textAlign: TextAlign.center,
                  fontsize: element.selected! ? 14 : 12,
                  labeltext: element.label!.tr,
                  maxline: 2,
                  color: Colors.white,
                  fontWeight:
                  element.selected! ? FontWeight.w700 : FontWeight.normal),
            ),
            SizedBox(
              width: element.selected! ? 140 : 120,
              height: 50,
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
                        fontsize: 18,
                        color: element.color,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        labeltext: "Musteri",
                        textAlign: TextAlign.center,
                        fontsize: 10,
                        color: element.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  element.keyText == "z"
                      ? const SizedBox()
                      : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    width: 1,
                    color: Colors.grey,
                  ),
                  element.keyText == "z"
                      ? const SizedBox()
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        labeltext: "${element.girisSayi}",
                        textAlign: TextAlign.center,
                        fontsize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                      ),
                      CustomText(
                        labeltext: "Ziyaret",
                        textAlign: TextAlign.center,
                        fontsize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget widgetListRutGunu(ControllerGirisCixisYeni controller) {
    return dataLoading
        ? SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height / 2,
        child: Center(
          child: LoagindAnimation(
              textData: "Gps axtarilir...",
              icon: "lottie/locations_search.json",
              isDark: Get.isDarkMode),
        ))
        : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controllerGirisCixis.marketeGirisEdilib.isFalse&&(controllerGirisCixis.listSifarisler.isNotEmpty||controllerGirisCixis.listIadeler.isNotEmpty)?controllerGirisCixis.cardTotalSifarisler(context,false):SizedBox(),
        controllerGirisCixis.listTabItems.indexOf(selectedTabItem) != 1
            ? Padding(
          padding: const EdgeInsets.all(5.0).copyWith(left: 10, bottom: 5),
          child: CustomText(
              labeltext:
              "$selectedItemsLabel (${controllerGirisCixis
                  .listSelectedMusteriler.length})",
              fontsize: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start),
        )
            : const SizedBox(),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: controllerGirisCixis.listTabItems.indexOf(selectedTabItem) !=
               1
                ? ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(0).copyWith(bottom: 25),
              children: controllerGirisCixis.listSelectedMusteriler
                  .map((e) => widgetCustomers(e))
                  .toList(),
            )
                : controllerGirisCixis
                .modelRutPerform.value.listGirisCixislar!.isEmpty
                ? SizedBox()
                : ziyaretEdilenler()),
      ],
    );
  }

  Widget ziyaretEdilenler() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
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
                  border: Border.all(color: Colors.grey.withOpacity(0.1))),
              child: Padding(
                padding:
                const EdgeInsets.all(8.0).copyWith(right: 5, bottom: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                            labeltext: "Ise baslama saati :",
                            fontWeight: FontWeight.w700),
                        CustomText(
                            labeltext: controllerGirisCixis.modelRutPerform
                                .value.listGirisCixislar!.first.girisvaxt!
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
                            labeltext: "SN-de qalma vaxti : ",
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
                            labeltext: "Umumi is vaxti : ",
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
                            labeltext: "Sonuncu cixis : ",
                            fontWeight: FontWeight.w700),
                        CustomText(
                            labeltext: controllerGirisCixis.modelRutPerform
                                .value.listGirisCixislar!.last.cixisvaxt
                                .toString()
                                .substring(10, 19)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            flex: 8,
            child: ListView(
              padding: EdgeInsets.all(0),
              children:
              controllerGirisCixis.modelRutPerform.value.listGirisCixislar!
                  .map((e) =>
                  WigetListItemsGirisCixis(
                    model: e,
                  ))
                  .toList(),
            ))
      ],
    );
  }

  Widget widgetCustomers(ModelCariler e) {
    return InkWell(
      onTap: () {
        setState(() {
          if (selectedCariModel == e) {
            selectedCariModel = ModelCariler();
          } else {
            scrollController.animateTo(
                double.parse(controllerGirisCixis.listSelectedMusteriler
                    .indexOf(e)
                    .toString()) *
                    90,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.bounceOut);
            setState(() {
              _onMarkerClick(e);
            });
          }
        });
        // Get.back(result: e);
      },
      child: Stack(
        children: [
          Card(
            color: selectedCariModel == e
                ? Colors.yellow.withOpacity(0.6)
                : controllerGirisCixis.modelRutPerform.value.listGirisCixislar!
                .where((a) => a.ckod == e.code)
                .isEmpty
                ? Colors.white
                : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            elevation: selectedCariModel == e ? 10 : 5,
            shadowColor: selectedCariModel == e
                ? Colors.grey
                : controllerGirisCixis.modelRutPerform.value.listGirisCixislar!
                .where((a) => a.ckod == e.code).isEmpty?Colors.blueAccent.withOpacity(0.4):Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0).copyWith(left: 8,top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            maxline: 2,
                            labeltext: e.name!,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                            fontsize: selectedCariModel == e ? 18 : 14,
                          ),
                        ),
                        CustomText(
                          labeltext: e.code!,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontsize: 12,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Divider(height: 1, color: Colors.black),
                  ),
                  selectedCariModel == e
                      ? widgetGirisUcun()
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            textAlign: TextAlign.center,
                            labeltext: "sahib".tr,
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
                              labeltext: e.ownerPerson.toString().isEmpty?"mSexsTapilmadi".tr: e.ownerPerson.toString(),
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.social_distance,
                                  color: Colors.green),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                labeltext: e.mesafe ?? "0m",
                                color: Colors.green,
                                fontWeight: FontWeight.normal,
                              ),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            textAlign: TextAlign.center,
                            labeltext: "temKod".tr+" : ",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            textAlign: TextAlign.center,
                            labeltext: "borc".tr,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontsize: 14,
                          ),
                          CustomText(
                            labeltext: " ${e.debt} ₼",
                            color: e.debt
                                .toString()
                                .isNotEmpty
                                ? Colors.red
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          const Spacer(),
                        ],
                      ),
                      controllerGirisCixis.musteriZiyaretDetail(e),
                    ],
                  )
                ],
              ),
            ),
          ),
          e.rutGunu=="Duz"? Positioned(
              left: 5,
              top: 7,
              child: Icon(Icons.bookmark,color: controllerGirisCixis.modelRutPerform.value.listGirisCixislar!
                  .where((a) => a.ckod == e.code).isEmpty?Colors.yellow:Colors.green,)):SizedBox(),
         Positioned(
              right: 10,
              top: 8,
              child: InkWell(
                  onTap: (){
                    Get.toNamed(RouteHelper.getwidgetScreenMusteriDetail(),arguments: [e,controllerGirisCixis.availableMap.value]);
                  },
                  child: const Icon(Icons.info,color: Colors.blue)))
        ],
      ),
    );
  }


  void funFlutterToast(String s) {
    Fluttertoast.showToast(
        msg: s.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: followMe ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget widgetGirisUcun() {
    return dataLoading
        ? SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height / 2,
        child: Center(
          child: LoagindAnimation(
              textData: "Gps axtarilir...",
              icon: "lottie/locations_search.json",
              isDark: Get.isDarkMode),
        ))
        : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(labeltext: "Hesabtalar"),
        SizedBox(
            height: 100,
            child: controllerGirisCixis
                .widgetMusteriHesabatlari(selectedCariModel)),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0)
                      .copyWith(top: 2, bottom: 0),
                  child: CustomText(
                      fontsize: marketeGirisIcazesi ? 14 : 16,
                      labeltext:
                      "Marketden uzaqliq : $secilenMarketdenUzaqliqString"),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0)
                      .copyWith(top: 2, bottom: 0),
                  child: CustomText(
                    maxline: 2,
                      fontsize: marketeGirisIcazesi ? 14 : 16,
                      labeltext: secilenMusterininRutGunuDuzluyu == true
                          ? "Rut duzgunluyu : Duzdur"
                          : "Rut duzgunluyu : Rutdan kenardir",
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
                        width:
                        MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: CustomText(
                            labeltext: girisErrorQeyd,
                            maxline: 3,
                            overflow: TextOverflow.ellipsis)),
                  ],
                )
              ],
            ),
            marketeGirisIcazesi
                ? CustomElevetedButton(
              cllback: () {
                girisEt(selectedCariModel, secilenMarketdenUzaqliqString);
              },
              label: "Giris Et",
              width: 120,
              icon: Icons.exit_to_app,
              borderColor: Colors.blue,
              elevation: 5,
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
    setState(() {
      selectedCariModel = model;
      secilenMusterininRutGunuDuzluyu = controllerGirisCixis.rutGununuYoxla(model);
      secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(
          _currentLocation.latitude,
          _currentLocation.longitude,
          double.parse(model.longitude!),
          double.parse(model.latitude!));
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
        girisErrorQeyd = "Marketden Uzaq oldugunuz ucun giris ede bilmezsiniz!";
      }
    });

  }

  void girisEt(ModelCariler selectedModel, String uzaqliq) async {
    showGirisDialog(selectedModel);
  }

  Future<void> showGirisDialog(ModelCariler model) async {
    DialogHelper.showLoading("mesHesablanir".tr);
    _getStartingLocation().then((value) =>
    {
      selectedCariModel = model,
      secilenMusterininRutGunuDuzluyu = controllerGirisCixis.rutGununuYoxla(model),
      secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(value.latitude, value.longitude, double.parse(model.longitude!), double.parse(model.latitude!)),
      if (secilenMarketdenUzaqliq > 1) {
        secilenMarketdenUzaqliqString =
        "${(secilenMarketdenUzaqliq).round()} km",
      } else {
        secilenMarketdenUzaqliqString =
        "${(secilenMarketdenUzaqliq * 1000).round()} m",
      },
      if (secilenMarketdenUzaqliq < marketeGirisIcazeMesafesi / 1000) {
        if (istifadeciRutdanKenarGirisEdebiler) {
          marketeGirisIcazesi = true,
        } else {
          if (secilenMusterininRutGunuDuzluyu) {
            marketeGirisIcazesi = true,
          } else {
            marketeGirisIcazesi = false,
            girisErrorQeyd ="Rut gunu duz olmadigi ucun giris ede bilmezsiniz!",
          }
        }
      } else {
        marketeCixisIcazesi = false,
        marketeGirisIcazesi = false,
        girisErrorQeyd = "Marketden Uzaq oldugunuz ucun giris ede bilmezsiniz!",
      },
      DialogHelper.hideLoading(),
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
                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.32,
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
                                    labeltext: "dcixis".tr,
                                    fontsize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Expanded(
                          flex:marketeGirisIcazesi ? 4 : 7,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0)
                                .copyWith(left: 20, right: 20),
                            child: marketeGirisIcazesi
                                ? Column(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    labeltext:
                                    "${model.name!} adli marketden giris ucun eminsiniz?",
                                    fontsize: 18,
                                    maxline: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5,),
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
                                  girisErrorQeyd,
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
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.4,
                                  height:40,
                                  textColor: Colors.red,
                                  icon: Icons.exit_to_app_rounded,
                                  elevation: 5,
                                  cllback: () async {
                                    await controllerGirisCixis.pripareForEnter(_currentLocation, model, secilenMarketdenUzaqliqString);
                                    setState(() {
                                      selectedCariModel = ModelCariler();
                                    });
                                    Get.back();
                                  },
                                  label: "giris".tr)
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
          transitionDuration: const Duration(milliseconds: 400))
    });
  }

  Widget widgetCixisUcun(BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shadowColor: Colors.blue,
              elevation: 20,
              margin: const EdgeInsets.all(15),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0)
                        .copyWith(top: 40, bottom: 25, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomText(
                                  labeltext: controllerGirisCixis
                                      .modelgirisEdilmis.value.cariad!,
                                  fontWeight: FontWeight.w600,
                                  fontsize: 18,
                                  maxline: 2),
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
                                      labeltext: "Giris tarixi :",
                                      fontWeight: FontWeight.w700,
                                      fontsize: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                      labeltext: controllerGirisCixis
                                          .modelgirisEdilmis.value.girisvaxt!
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
                                          .modelgirisEdilmis.value.girisvaxt!
                                          .substring(11, 19),
                                      fontWeight: FontWeight.normal,
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "Giris mesafe :",
                                      fontWeight: FontWeight.w700,
                                      fontsize: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                      labeltext: controllerGirisCixis
                                          .modelgirisEdilmis.value.girismesafe!,
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
                                  controllerGirisCixis.girisiSil();
                                },
                                label: "Giris Sil",
                                icon: Icons.delete,
                                textColor: Colors.red,
                                borderColor: Colors.red,
                                elevation: 5,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomElevetedButton(
                                height: 40,
                                cllback: () {
                                  showCixisDialog();
                                },
                                label: "Cixis Et",
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
                        height: 40,
                        child: Center(
                            child: CustomText(
                                labeltext: controllerGirisCixis.snQalmaVaxti
                                    .toString())),
                      ))
                ],
              ),
            ), //cixis ucun olan hisse
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: controllerGirisCixis.cardSifarisler(context),
            ), //satis ucun
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: controllerGirisCixis.cardTapsiriqlar(context),
            ), //tapsiriqlar ucun olan hisse
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
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
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                    child: CustomText(
                        labeltext: "Markete aid hesabatlar",
                        fontsize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  controllerGirisCixis.widgetMusteriHesabatlari(selectedCariModel),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ), //hesabatlar hissesi
          ],
        ),
      ),
    );
  }

  Future<void> showCixisDialog() async {
    DialogHelper.showLoading("Mesafe hesablanir...");
    _getStartingLocation().then((value) =>
    {
      secilenMarketdenUzaqliq = controllerGirisCixis.calculateDistance(value.latitude, value.longitude, double.parse(controllerGirisCixis.modelgirisEdilmis.value.marketgpsUzunluq!), double.parse(controllerGirisCixis.modelgirisEdilmis.value.marketgpsEynilik!)),
      if (secilenMarketdenUzaqliq > 1)
        {
          secilenMarketdenUzaqliqString =
          "${(secilenMarketdenUzaqliq).round()} km",
        }
      else
        {
          secilenMarketdenUzaqliqString =
          "${(secilenMarketdenUzaqliq * 1000).round()} m",
        },
      if (secilenMarketdenUzaqliq < marketeGirisIcazeMesafesi / 1000)
        {
          marketeCixisIcazesi = true,
        }
      else
        {
          marketeCixisIcazesi = false,
        },
      DialogHelper.hideLoading(),
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
                                    labeltext: "Dialog Cixis",
                                    fontsize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
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
                                    "${controllerGirisCixis.modelgirisEdilmis
                                        .value
                                        .cariad!} adli marketden Cixis ucun Eminsiniz?",
                                    fontsize: 18,
                                    maxline: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                TextField(
                                  controller: controllerGirisCixis.ctCixisQeyd,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      hintText: "cxQeyd".tr,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: Colors.redAccent)
                                      )
                                  ),

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
                                  "Marketden $secilenMarketdenUzaqliqString uzaqda oldugunuz ucun cixis ede bilmezsiniz" +
                                      ".Teleb olunan uzaqliq  " +
                                      marketeGirisIcazeMesafesi
                                          .toString() +
                                      " m-dir",
                                  fontsize: 14,
                                  maxline: 4,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
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
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.4,
                                  height:40,
                                  textColor: Colors.red,
                                  icon: Icons.exit_to_app_rounded,
                                  elevation: 5,
                                  cllback: () {
                                    cixisEt(secilenMarketdenUzaqliqString);
                                    Get.back();
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
          transitionDuration: const Duration(milliseconds: 400))
    });
  }

  Future<void> cixisEt(String uzaqliq) async {
    await controllerGirisCixis.cixisUcunHazirliq(
        _currentLocation, uzaqliq, "QEYD");
    setState(() {});
  }
}
