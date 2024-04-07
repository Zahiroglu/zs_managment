import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/hesabatlar/giriscixis_hesabat/screen_gunlukgiris_cixis.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import '../../base_downloads/models/model_cariler.dart';
import '../controller_giriscixis_yeni.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;

class YeniGirisCixisMap extends StatefulWidget {
  const YeniGirisCixisMap({super.key});

  @override
  State<YeniGirisCixisMap> createState() => _YeniGirisCixisMapState();
}

class _YeniGirisCixisMapState extends State<YeniGirisCixisMap> {
  ControllerGirisCixisYeni controllerGirisCixis =
      Get.put(ControllerGirisCixisYeni());
  final ScrollController listViewController = ScrollController();
  final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  bool showNearestCustomers = false;
  bool followMe = false;
  Completer<map.GoogleMapController> _controllerMap = Completer();
  late LocationData _currentLocation;
  final _location = Location();
  late map.LatLng _initialPosition = const map.LatLng(0, 0);
  final Set<map.Marker> _markers = {};
  final Set<map.Marker> _markersSmoll = {};
  late ModelCariler selectedModel = ModelCariler();
  double zoomLevel = 15;
  int marketeGirisIcazeMesafesi = 6000;
  String secilenMarketdenUzaqliqString = "";
  String girisErrorQeyd = "";
  double secilenMarketdenUzaqliq = 0;
  bool secilenMusterininRutGunuDuzluyu = false;
  bool istifadeciRutdanKenarGirisEdebiler = false;
  bool marketeGirisIcazesi = false;
  bool marketeCixisIcazesi = false;
  bool expandMenuVisible = false;
  bool musteriHesabatiGorunsun = false;
  bool showMusteriHesabatiRutList = false;
  map.GoogleMapController? newgooglemapxontroller;


  @override
  void dispose() {
    Get.delete<ControllerGirisCixisYeni>();
    _controllerMap = Completer();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _location.changeSettings(
      interval: 50,
      accuracy: LocationAccuracy.high,
      distanceFilter:
          10, // Minimum distance (in meters) between location updates
    );
    _getStartingLocation().then((value) {
      setState(() {
        _initialPosition = value;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      onSheetMoved: (positionData) {
        if (positionData.relativeToSnappingPositions > 0.6) {
          setState(() {
            expandMenuVisible = true;
            musteriHesabatiGorunsun = true;
            showMusteriHesabatiRutList = true;
          });
        } else if (positionData.relativeToSnappingPositions >= 0.5) {
          setState(() {
            musteriHesabatiGorunsun = true;
            showMusteriHesabatiRutList = false;
          });
        } else {
          setState(() {
            expandMenuVisible = false;
            musteriHesabatiGorunsun = false;
            showMusteriHesabatiRutList = false;
          });
        }
      },
      controller: snappingSheetController,
      lockOverflowDrag: true,
      snappingPositions: const [
        SnappingPosition.factor(
          positionFactor: 0.0,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 1000),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
        SnappingPosition.factor(
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 1000),
          positionFactor: 0.5,
        ),
        SnappingPosition.factor(
          grabbingContentOffset: GrabbingContentOffset.bottom,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 1000),
          positionFactor: 0.95,
        ),
      ],
      grabbing: selectedModel.code != null ? grappengContainer() : const SizedBox(),
      grabbingHeight: controllerGirisCixis.marketeGirisEdilib.isTrue?MediaQuery.of(context).size.height / 4.5:MediaQuery.of(context).size.height / 3.8,
      sheetAbove: null,
      sheetBelow: SnappingSheetContent(
        draggable: true,
        childScrollController: listViewController,
        child: selectedModel.code != null ?Container(
          color: Colors.white,
          child: controllerGirisCixis.marketeGirisEdilib.isFalse?widgetGirisHesabatlarHissesi(context):widgetCixisUcunHesabat(context),
        ):const SizedBox(),
      ),
      child: widgetGoogleMap(),
    );
  }

  ListView widgetGirisHesabatlarHissesi(BuildContext context) {
    return ListView(
     // controller: listViewController,
      padding: const EdgeInsets.all(0).copyWith(top: 10),
      children: [
        const Divider(height: 2, color: Colors.grey, thickness: 0.2, indent: 2),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: controllerGirisCixis.musteriZiyaretDetail(selectedModel),
            ),
          ),
        ),
        SizedBox(height: 5,),
        musteriHesabatiGorunsun ? controllerGirisCixis.widgetMusteriHesabatlari(selectedModel) : const SizedBox(),
        musteriHesabatiGorunsun?controllerGirisCixis.widgetGunlukGirisCixislar(context) : SizedBox(),
      ],
    );
  }

  Widget grappengContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.5)),
        ],
      ),
      child: Stack(
        children: [
          controllerGirisCixis.marketeGirisEdilib.isFalse
              ? widgetGirisUcun(selectedModel)
              : widgetCixisUcun(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 35,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          expandMenuVisible
              ? Positioned(
                  top: -10,
                  right: 0,
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        snappingSheetController.snapToPosition(
                            const SnappingPosition.pixels(positionPixels: 100));
                      });
                    },
                    icon: Icon(Icons.expand_more),
                  ))
              : SizedBox(),
          selectedModel.rutGunu=="Duz"?Positioned(
              top: -5,
              left: 5,
              child:Icon(Icons.bookmark,size:32,color: controllerGirisCixis.modelRutPerform.value.listGirisCixislar!.any((element) => element.ckod==selectedModel.code)?Colors.green:Colors.yellow,)):SizedBox(),
        ],
      ),
    );
  }

  Widget widgetGirisUcun(ModelCariler element) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 25, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              labeltext: selectedModel.name!,
              fontWeight: FontWeight.w600,
              fontsize: 18,
              maxline: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(8.0).copyWith(top: 2, bottom: 0),
                    child: CustomText(
                        fontsize: marketeGirisIcazesi?16:12,
                        labeltext: "Marketden uzaqliq : $secilenMarketdenUzaqliqString"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(8.0).copyWith(top: 2, bottom: 0),
                    child: CustomText(
                        fontsize: marketeGirisIcazesi?16:12,
                        labeltext: secilenMusterininRutGunuDuzluyu == true
                            ? "Rut duzgunluyu : Duzdur"
                            : "Rut duzgunluyu : Rutdan kenardir",
                        color: secilenMusterininRutGunuDuzluyu == true
                            ? Colors.blue
                            : Colors.red),
                  ),
                  marketeGirisIcazesi ? const SizedBox():Row(
                    children: [
                      const Icon(Icons.error,color: Colors.red,),
                      const SizedBox(width: 5,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width-80,
                          child: Expanded(child: CustomText(labeltext: girisErrorQeyd,maxline: 3,overflow: TextOverflow.ellipsis))),
                    ],
                  ),
                  myCusttomInfoWindowStyleSimpleInfo(selectedModel),
                ],
              ),
              marketeGirisIcazesi
                  ? CustomElevetedButton(
                      cllback: () {
                        girisEt(selectedModel,secilenMarketdenUzaqliqString);
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

        ],
      ),
    );
  }

  Widget widgetCixisUcun() {
    return Padding(
      padding: const EdgeInsets.all(15.0).copyWith(top: 25, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              labeltext: selectedModel.name!,
              fontWeight: FontWeight.w600,
              fontsize: 18,
              maxline: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.all(8.0).copyWith(top: 2, bottom: 0),
                    child: CustomText(
                        fontsize:controllerGirisCixis.modelgirisEdilmis.value.ckod!=selectedModel.code||marketeCixisIcazesi?16:12,
                        labeltext: "Marketden uzaqliq : $secilenMarketdenUzaqliqString"),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.all(8.0).copyWith(top: 2, bottom: 0),
                    child: CustomText(
                        fontsize: controllerGirisCixis.modelgirisEdilmis.value.ckod!=selectedModel.code||marketeCixisIcazesi?16:12,
                        labeltext: secilenMusterininRutGunuDuzluyu == true
                            ? "Rut duzgunluyu : Duzdur"
                            : "Rut duzgunluyu : Rutdan kenardir",
                        color: secilenMusterininRutGunuDuzluyu == true
                            ? Colors.blue
                            : Colors.red),
                  ),
                  controllerGirisCixis.modelgirisEdilmis.value.ckod==selectedModel.code?marketeCixisIcazesi ? const SizedBox():Row(
                    children: [
                      const Icon(Icons.error,color: Colors.red,),
                      const SizedBox(width: 5,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width-80,
                          child: CustomText(labeltext: girisErrorQeyd,maxline: 3,overflow: TextOverflow.ellipsis)),
                    ],
                  ):SizedBox(),
                  myCusttomInfoWindowStyleSimpleInfo(selectedModel),
                ],
              ),
              controllerGirisCixis.modelgirisEdilmis.value.ckod==selectedModel.code?marketeCixisIcazesi
                  ? CustomElevetedButton(
                cllback: () {
                  cixisEt(selectedModel,secilenMarketdenUzaqliqString);
                },
                label: "Cixis Et",
                width: 120,
                icon: Icons.exit_to_app,
                borderColor: Colors.red,
                elevation: 5,
              )
                  : const SizedBox():SizedBox()
            ],
          ),

        ],
      ),
    );

  }
  
  Widget widgetCixisUcunHesabat(BuildContext context) {
    return Obx(() => controllerGirisCixis.modelgirisEdilmis.value.ckod==selectedModel.code?SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: controllerGirisCixis.cardSifarisler(context),
            ), //s
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: Column(
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
                        labeltext: "Qeyde alinmis tabsiriq yoxdur",
                        fontsize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ), //tapsiriqlar ucun olan hisse
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: Column(
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
              ),
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
                  controllerGirisCixis
                      .widgetMusteriHesabatlari(selectedModel),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ), //hesabatlar hissesi
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                    child: CustomText(
                        labeltext: "Rut Melumatlar",
                        fontsize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  controllerGirisCixis.widgetGunlukGirisCixislar(context),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ), //rut melumatlar hissesi
          ],
        ),
      ),
    ):widgetGirisHesabatlarHissesi(context));
  }

  Widget widgetLeftsideMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: SizedBox(
            height: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            width: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  shape: const CircleBorder(),
                  elevation: 10,
                  backgroundColor: Colors.grey.withOpacity(0.8),
                ),
                onPressed: () {
                  openCustomersSearchScreen();
                  setState(() {});
                },
                child: const Center(child: Icon(Icons.search_outlined))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: SizedBox(
            height: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            width: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  shape: const CircleBorder(),
                  elevation: 10,
                  backgroundColor: Colors.grey.withOpacity(0.8),
                ),
                onPressed: () async {
                  // await localDbGirisCixis.clearAllGiris();
                  // setState(() {
                  //   girisEdilib = false;
                  // });
                },
                child: const Center(child: Icon(Icons.sort_outlined))),
          ),
        ),
      ],
    );
  }

  Widget widgetRightsideMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
          child: SizedBox(
            height: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            width: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            child: followMe
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.center,
                      shape: const CircleBorder(),
                      elevation: 10,
                      backgroundColor: Colors.green.withOpacity(0.6),
                    ),
                    onPressed: () {
                      updateFollowMe(false);
                      setState(() {});
                    },
                    child: const Center(
                        child:
                            Icon(Icons.navigation_outlined, color: Colors.red)))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.center,
                      shape: const CircleBorder(),
                      elevation: 10,
                      backgroundColor: Colors.grey.withOpacity(0.6),
                    ),
                    onPressed: () {
                      updateFollowMe(true);
                      setState(() {});
                    },
                    child: const Center(child: Icon(Icons.navigation))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
          child: SizedBox(
            height: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            width: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  shape: const CircleBorder(),
                  elevation: 10,
                  backgroundColor: Colors.grey.withOpacity(0.8),
                ),
                onPressed: () {
                  changeZoomLevel(true);
                },
                child: const Center(child: Icon(Icons.add))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
          child: SizedBox(
            height: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            width: controllerGirisCixis.slidePanelVisible.isTrue ? 35 : 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  shape: const CircleBorder(),
                  elevation: 10,
                  backgroundColor: Colors.grey.withOpacity(0.8),
                ),
                onPressed: () {
                  changeZoomLevel(false);
                },
                child: const Center(child: Icon(Icons.remove))),
          ),
        ),
      ],
    );
  }

  Widget widgetGoogleMap() {
    return Stack(
      children: [
        map.GoogleMap(
          initialCameraPosition: map.CameraPosition(target: _initialPosition),
          onTap: (v) {
            setState(() {
              selectedModel = ModelCariler();
              listViewController.animateTo(0,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOut);
            });
          },
          markers: zoomLevel <= 14 ? _markersSmoll : _markers,
          circles: controllerGirisCixis.circles,
          polygons: controllerGirisCixis.polygon,
          onCameraMove: (possition) {
            snappingSheetController.snapToPosition(const SnappingPosition.pixels(positionPixels: 80));
            setState(() {
              showNearestCustomers = false;
            });
          },
          padding: const EdgeInsets.all(2),
          mapToolbarEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          compassEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: map.MapType.normal,
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer()))
            ..add(Factory<HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer()))
            ..add(Factory<ScaleGestureRecognizer>(
                () => ScaleGestureRecognizer())),
          onCameraIdle: () {
            setState(() {});
          },
          onMapCreated: _onMapCreated,
        ),
        Positioned(
            top: MediaQuery.of(context).size.height / 2.5,
            left: 0,
            child: widgetLeftsideMenu()),
        Positioned(
            top: MediaQuery.of(context).size.height / 3,
            right: 0,
            child: widgetRightsideMenu()),
        controllerGirisCixis.marketeGirisEdilib.isTrue?Positioned(
            top: 25,
            right: MediaQuery.of(context).size.width/(controllerGirisCixis.modelgirisEdilmis.value.cariad!.length)*4,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(labeltext: controllerGirisCixis.modelgirisEdilmis.value.cariad!,color: Colors.white,maxline: 2,fontsize: 18,textAlign: TextAlign.center,),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Icon(Icons.timer,color: Colors.white,),
                      const SizedBox(width: 5,),
                      CustomText(labeltext: controllerGirisCixis.snQalmaVaxti.toString(),color: Colors.white,maxline: 1,fontsize: 16,),
                    ],
                  )
                ],
              ),
            )):SizedBox(),
        Positioned(
          left: 0,
          top: 50,
          child:         controllerGirisCixis.cardTotalSifarisler(context,true),)
      ],
    );
  }

  void _onMapCreated(map.GoogleMapController controller) {
    _controllerMap.complete(controller);
    newgooglemapxontroller = controller;
    _getCurrentLocation();
  }

  void fillMarkersFromBase() async {
    DialogHelper.showLoading("Musteriler yuklenir", false);
    for (ModelCariler model in controllerGirisCixis.listCariler) {
      _markers.add(map.Marker(
          markerId: map.MarkerId(model.code!),
          onTap: () {
            _onMarkerClick(model);
          },
          icon: await getClusterBitmap(120, model, model.ziyaret??"0",
              controllerGirisCixis.marketeGirisEdilib.value),
          position: map.LatLng(
              double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString()))));
      _markersSmoll.add(map.Marker(
          markerId: map.MarkerId(model.code!),
          icon: await getClusterBitmapSmole(40, model),
          position: map.LatLng(
              double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString()))));
    }
    if (controllerGirisCixis.marketeGirisEdilib.isTrue) {
      // controllerGirisCixis.addMarkersAndPlygane(
      //     controllerGirisCixis.modelgirisEdilmis.value.marketgpsUzunluq!,
      //     controllerGirisCixis.modelgirisEdilmis.value.marketgpsEynilik!,
      //     _currentLocation);
    }
    DialogHelper.hideLoading();
    if (mounted) {
      setState(() {});
    }
  }

  void _onMarkerClick(ModelCariler model) {
    controllerGirisCixis.getSatisMelumatlariByCary();
    snappingSheetController.snapToPosition(const SnappingPosition.pixels(positionPixels: 80));
    setState(() {
      selectedModel = model;
      secilenMusterininRutGunuDuzluyu = controllerGirisCixis.rutGununuYoxla(model);
      secilenMarketdenUzaqliq = calculateDistance(
          _currentLocation.latitude,
          _currentLocation.longitude,
          double.parse(model.longitude!.toString()),
          double.parse(model.latitude!.toString()));
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

  Future<void> openCustomersSearchScreen() async {
    final map.GoogleMapController controller = await _controllerMap.future;
    String listmesafe = "";
    String uzaqliq = "0";
    bool girisIcazesi = false;
    for (ModelCariler element in controllerGirisCixis.listCariler) {
      double hesabMesafe = calculateDistance(
          _currentLocation.latitude,
          _currentLocation.longitude,
          double.parse(element.longitude!.toString()),
          double.parse(element.latitude!.toString()));
      if (hesabMesafe > 1) {
        listmesafe = "${(hesabMesafe).round()} km";
      } else {
        listmesafe = "${(hesabMesafe * 1000).round()} m";
      }
      element.mesafe = listmesafe;
      element.mesafeInt = hesabMesafe;
    }
    ModelCariler model = await Get.toNamed(
        RouteHelper.mobileSearchMusteriMobile,
        arguments: controllerGirisCixis.listCariler);
    if (model.toString().isNotEmpty) {
      double hesabMesafe = calculateDistance(
          _currentLocation.latitude,
          _currentLocation.longitude,
          double.parse(model.longitude!.toString()),
          double.parse(model.latitude!.toString()));
      if (hesabMesafe > 1) {
        uzaqliq = "${(hesabMesafe).round()} km";
      } else {
        uzaqliq = "${(hesabMesafe * 1000).round()} m";
      }
      if (hesabMesafe < marketeGirisIcazeMesafesi / 1000) {
        girisIcazesi = true;
      } else {
        girisIcazesi = false;
      }
      setState(() {
        selectedModel = model;
      });
      controller
          .animateCamera(map.CameraUpdate.newCameraPosition(map.CameraPosition(
        bearing: 0,
        target: map.LatLng(double.parse(model.longitude.toString()),
            double.parse(model.latitude.toString())),
        zoom: zoomLevel,
      )));
    }
  }

  Future<map.BitmapDescriptor> getClusterBitmap(
      int size, ModelCariler model, String ziyaret, bool girisEdilib) async {
    size = controllerGirisCixis.marketeGirisEdilib.isTrue
        ? model.ziyaret == "1"
            ? size + 10
            : model.ziyaret == "2"
                ? size
                : size - 50
        : size;
    Color color = model.ziyaret == "1"
        ? Colors.blue
        : model.ziyaret == "2"
            ? Colors.green
            : Colors.grey;
    if (controllerGirisCixis.marketeGirisEdilib.isFalse) {
      color = model.ziyaret == "1"
          ? Colors.blue
          : model.ziyaret == "2"
              ? Colors.green
              : Colors.red;
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()
      ..color =
          model.rutGunu == "Duz" ? Colors.lightBlueAccent : Colors.transparent;
    canvas.drawCircle(Offset(size / 3.5, size / 2.7), size / 10.0, paint1);
    var icon = Icons.local_grocery_store;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7, fontFamily: icon.fontFamily, color: color));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: model.name!,
      style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: size / 10,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
    if (controllerGirisCixis.marketeGirisEdilib.isFalse) {
      painter.layout();
      painter.paint(
        canvas,
        Offset((size - painter.width) * 0.7, size / 6),
      );
    } else {
      if (model.ziyaret == "1" || model.ziyaret == "2") {
        painter.layout();
        painter.paint(
          canvas,
          Offset((size - painter.width) * 0.7, size / 6),
        );
      }
    }
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<map.BitmapDescriptor> getClusterBitmapSmole(
      int size, ModelCariler model) async {
    Color color = model.ziyaret == "1"
        ? Colors.blue
        : model.ziyaret == "2"
            ? Colors.green
            : Colors.grey;
    if (controllerGirisCixis.marketeGirisEdilib.isFalse) {
      if (model.rutGunu == "Duz") {
        color = model.ziyaret == "1"
            ? Colors.blue
            : model.ziyaret == "2"
                ? Colors.green
                : Colors.red;
      } else {
        color = model.ziyaret == "1"
            ? Colors.blue
            : model.ziyaret == "2"
                ? Colors.green
                : Colors.grey;
      }
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.circle;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7, fontFamily: icon.fontFamily, color: color));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Widget myCusttomInfoWindowStyleSimpleInfo(ModelCariler selectedModel) {
    return Hero(
      tag: selectedModel.code!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width/2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevetedButton(
                textsize: 14,
                textColor: Colors.blueAccent,
                icon: Icons.info,
                hasshadow: true,
                height: 35,
                width: 90,
                cllback: () {
                  openScreenMusteriDetail(selectedModel);
                },
                label: "Melumatlar",
                surfaceColor: Colors.white,
                borderColor: Colors.blueAccent,
                elevation: 10,
              ),
              CustomElevetedButton(
                textsize: 14,
                hasshadow: true,
                height: 35,
                width: 80,
                cllback: () {
                  createRoutBetweenTwoPoints(
                      selectedModel);
                },
                label: "Yol cek",
                surfaceColor: Colors.white,
                borderColor: Colors.green,
                elevation: 10,
                isSvcFile: true,
                svcFile: controllerGirisCixis.availableMap.value.icon,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> openScreenMusteriDetail(ModelCariler selectedModel) async {
    String listmesafe = "";
    double hesabMesafe = calculateDistance(
        _currentLocation.latitude,
        _currentLocation.longitude,
        double.parse(selectedModel.longitude!.toString()),
        double.parse(selectedModel.latitude!.toString()));
    if (hesabMesafe > 1) {
      listmesafe = "${(hesabMesafe).round()} km";
    } else {
      listmesafe = "${(hesabMesafe * 1000).round()} m";
    }
    selectedModel.mesafe = listmesafe;
    await Get.toNamed(RouteHelper.mobileScreenMusteriDetail,
        arguments: [selectedModel, controllerGirisCixis.availableMap.value]);
  }

  Future<void> createRoutBetweenTwoPoints(ModelCariler selectedModel) async {
    Coords cordEnd = Coords(double.parse(selectedModel.longitude.toString()),
        double.parse(selectedModel.latitude.toString()));
    Coords cordBaslangic =
        Coords(_currentLocation.latitude!, _currentLocation.longitude!);
    print(
        "cordEnd :${map.LatLng(double.parse(selectedModel.latitude.toString()), double.parse(selectedModel.longitude.toString()))}");
    print(
        "cordBaslangic :${map.LatLng(_currentLocation.latitude!, _currentLocation.longitude!)}");
    try {
      await MapLauncher.showDirections(
        mapType: controllerGirisCixis.availableMap.value.mapType,
        destination: cordBaslangic,
        origin: cordEnd,
        originTitle: selectedModel.name.toString(),
      );
    } catch (exp) {
      Get.dialog(ShowInfoDialog(
        messaje:
            "Secmis oldugunuz ${controllerGirisCixis.availableMap.value.mapName} hal hazirda cavab vermir.Basqa programla evez edin!",
        icon: Icons.info_outlined,
        callback: (va) {
          if (va) {
            // openMapSettingScreen();
          }
        },
      ));
    }
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

  void _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
    } on Exception {
      _currentLocation = await _location.getLocation();
    }

    map.CameraPosition cameraPosition = map.CameraPosition(  target:
    map.LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
      zoom: zoomLevel,);
    fillMarkersFromBase();
    Future.delayed(const Duration(milliseconds: 200))
        .whenComplete(() =>  newgooglemapxontroller!.animateCamera(map.CameraUpdate.newCameraPosition(cameraPosition)));


  }

  Future<map.BitmapDescriptor> getClusterBitmapMyPlace(int size) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.navigation;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7,
            fontFamily: icon.fontFamily,
            color: Colors.yellow));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _getFollowingTrack() async {
    final map.GoogleMapController controller = await _controllerMap.future;
    try {
      _location.onLocationChanged.listen((event) async {
        if (controllerGirisCixis.marketeGirisEdilib.isTrue) {
          controllerGirisCixis.polygon.update((value) {
            value!.first.points.first.latitude == _currentLocation.latitude;
            value.first.points.first.longitude == _currentLocation.longitude;
          });
        }
        if (followMe) {
          //zoomLevel = 18;
          _currentLocation = event;
          map.CameraPosition cameraPosition = map.CameraPosition(  target:
          map.LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
            zoom: zoomLevel,);
          newgooglemapxontroller!.animateCamera(map.CameraUpdate.newCameraPosition(cameraPosition));

        } else {
          _currentLocation = event;
        }
      });
    } on Exception {
      print("xeta bas verdi");
    }
  }

  Future<map.LatLng> _getStartingLocation() async {
    _currentLocation = await _location.getLocation();
    return map.LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
  }

  void updateFollowMe(bool bool) {
    setState(() {
      followMe = bool;
      _getFollowingTrack();
    });
  }

  void changeZoomLevel(bool bool) {}

  void girisEt(ModelCariler selectedModel, String uzaqliq) async {
    // await controllerGirisCixis.pripareForEnter(
    //     _currentLocation, selectedModel, uzaqliq);
    // cixisXeritesiniQur(
    //     selectedModel.longitude!, selectedModel.latitude!, selectedModel.code!);
  }

  /////////////Cixis Et hissesi//////////////
  Future<void> cixisXeritesiniQur(
      String longitude, String latitude, String ckod) async {
    updateMarkers();
    updateFollowMe(false);
    setState(() {});
  }

  void girisiSil() {
    updateFollowMe(false);
    controllerGirisCixis.girisiSil();
    updateMarkers();
  }

  void updateMarkers() {
    _markers.clear();
    _markersSmoll.clear();
    fillMarkersFromBase();
  }

  Future<void> cixisEt(ModelCariler selectedModel, String uzaqliq) async {
    // await controllerGirisCixis.cixisUcunHazirliq(
    //     _currentLocation, uzaqliq, "QEYD");
    updateMarkers();
    setState(() {});
  }

////panel Hisse/////
}
