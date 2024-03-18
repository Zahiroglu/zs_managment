import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/screen_giriscixis_list.dart';
import 'package:zs_managment/companents/hesabatlar/giriscixis_hesabat/companents/widget_listitemsgiriscixis.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenGirisCixisUmumiList extends StatefulWidget {
  DrawerMenuController drawerMenuController;
   ScreenGirisCixisUmumiList({required this.drawerMenuController,super.key});

  @override
  State<ScreenGirisCixisUmumiList> createState() => _ScreenGirisCixisUmumiListState();
}

class _ScreenGirisCixisUmumiListState extends State<ScreenGirisCixisUmumiList> {
  ControllerGirisCixisYeni controllerGirisCixis =
  Get.put(ControllerGirisCixisYeni());
  late Position _currentLocation;
  late LocationSettings locationSettings;
  int defaultTargetPlatform=0;

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
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    print("list olaraq burdatam umumi list");
    confiqGeolocatior();
    _determinePosition().then((value) {
      setState(() {
        controllerGirisCixis.changeTabItemsValue(controllerGirisCixis.listTabItems.where((p) => p.selected == true).first, value);
        _currentLocation=value;
        dataLoading = false;
      });
    });
    _toggleListening();
    // TODO: implement initState
    super.initState();
  }


  confiqGeolocatior(){
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          )
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        if (followMe) {
          _currentLocation == position;
          controllerGirisCixis.changeTabItemsValue(
              controllerGirisCixis.listTabItems
                  .where((p) => p.selected == true)
                  .first,
              position);
          funFlutterToast("Cureent loc :" +
              _currentLocation.longitude.toString() +
              _currentLocation.latitude.toString());
        }});
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  void _updatePositionList(PositionItemType type, String displayValue) {
    print("positions :"+displayValue);
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<ControllerGirisCixisYeni>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              controllerGirisCixis.marketeGirisEdilib.isFalse?Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(icon: Icon(Icons.supervised_user_circle_outlined,color: Colors.black,),onPressed: (){
               controllerGirisCixis.getExpList();
                }),
              ):SizedBox()
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
                  element.keyText == "z"|| element.keyText == "zedilmeyen"
                      ? const SizedBox()
                      : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    width: 1,
                    color: Colors.grey,
                  ),
                  element.keyText == "z"|| element.keyText == "zedilmeyen"
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
        selectedTabItem.keyText!="z"
            ? Padding(
          padding: const EdgeInsets.all(5.0).copyWith(left: 10, bottom: 5),
          child: CustomText(
              labeltext:controllerGirisCixis.selectedTemsilci.value.code=="u"?
              "$selectedItemsLabel (${controllerGirisCixis
                  .listSelectedMusteriler.length})":"${controllerGirisCixis.selectedTemsilci.value.name!} ( ${controllerGirisCixis
                  .listSelectedMusteriler.length} )",
              fontsize: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start),
        )
            : const SizedBox(),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child:         selectedTabItem.keyText!="z"

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
            scrollController.animateTo(double.parse(controllerGirisCixis.listSelectedMusteriler.indexOf(e).toString()) * 90,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.bounceOut);
            setState(() {
              selectedCariModel = e;
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
                    padding: const EdgeInsets.all(2.0).copyWith(left: 8,top: 10),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0).copyWith(left: 2,bottom: 2),
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: _infoMarketRout(e,context),
                                )),
                          ),
                          const SizedBox(width: 10,),
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
                  child: const Icon(
                      size: 18,
                      Icons.info,color: Colors.blue)))
        ],
      ),
    );
  }
  Widget _infoMarketRout(ModelCariler element, BuildContext context) {
    int valuMore = 0;
    if (element.days!.any((element) => element.day==1)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==2)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==3)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==4)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==5)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==6)) {
      valuMore = valuMore + 1;
    }
    return SizedBox(
      height: valuMore > 5 ? 28 : 28,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          element.days!.any((element) => element.day==1)
              ? WidgetRutGunu(rutGunu: "gun1".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day==2)
              ? WidgetRutGunu(rutGunu: "gun2".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day==3)
              ? WidgetRutGunu(rutGunu: "gun3".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day==4)
              ? WidgetRutGunu(rutGunu: "gun4".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day==5)
              ? WidgetRutGunu(rutGunu: "gun5".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day==6)
              ? WidgetRutGunu(rutGunu: "gun6".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day==7)
              ? WidgetRutGunu(rutGunu: "bagli".tr)
              : const SizedBox(),
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
        SizedBox(
            height: 130,
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
    _determinePosition().then((value) =>
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
    _determinePosition().then((value) =>
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
