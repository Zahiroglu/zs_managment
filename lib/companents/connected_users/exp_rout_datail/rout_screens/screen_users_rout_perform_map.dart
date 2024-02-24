import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:hive/hive.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/connected_users/exp_rout_datail/controller_exppref.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

class ScreenUserRoutPerformMap extends StatefulWidget {
  ControllerExpPref controllerRoutDetailUser;

  ScreenUserRoutPerformMap({required this.controllerRoutDetailUser, super.key});

  @override
  State<ScreenUserRoutPerformMap> createState() =>
      _ScreenUserRoutPerformMapState();
}

class _ScreenUserRoutPerformMapState extends State<ScreenUserRoutPerformMap> {
  late map.LatLng _initialPosition = const map.LatLng(0, 0);
  Completer<map.GoogleMapController> _controllerMap = Completer();
  map.GoogleMapController? newgooglemapxontroller;
  bool expandMenuVisible = false;
  bool musteriHesabatiGorunsun = false;
  bool showMusteriHesabatiRutList = false;
  final SnappingSheetController snappingSheetController =SnappingSheetController();
  final ScrollController listViewController = ScrollController();
  Set<map.Polygon> _polygon = HashSet<map.Polygon>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnappingSheet(
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
            positionFactor: 0.4,
          ),
        ],
        grabbing:
            widget.controllerRoutDetailUser.selectedCariModel.value.code != null ? grappengContainer() : const SizedBox(),
        grabbingHeight: MediaQuery.of(context).size.height / 5,
        sheetAbove: null,
        sheetBelow: SnappingSheetContent(
          draggable: true,
          childScrollController: listViewController,
          child: widget.controllerRoutDetailUser.selectedCariModel.value.code != null
              ? Container(
                  color: Colors.white,
                  child: _rutHesabati(),
                )
              : const SizedBox(),
        ),
        child: widgetGoogleMap(),
      ),
      //body: widgetGoogleMap(),
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
          infoMarket(widget.controllerRoutDetailUser.selectedCariModel.value),
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
          widget.controllerRoutDetailUser.selectedCariModel.value.rutGunu == "Duz"
              ? const Positioned(
                  top: -5,
                  left: 5,
                  child: Icon(
                    Icons.bookmark,
                    size: 32,
                    color: Colors.green,
                  ))
              : SizedBox(),
        ],
      ),
    );
  }

  Widget widgetGoogleMap() {
    return Stack(
      children: [
        map.GoogleMap(
          polygons: _polygon,
          circles: widget.controllerRoutDetailUser.circles,
          initialCameraPosition: map.CameraPosition(target: _initialPosition),
          onTap: (v) {
            setState(() {
              widget.controllerRoutDetailUser.selectedCariModel.value =
                  ModelCariler();
              listViewController.animateTo(0,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOut);
            });
          },
          markers: widget.controllerRoutDetailUser.markers,
          onCameraMove: (possition) {},
          padding: const EdgeInsets.all(2),
          mapToolbarEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          compassEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: map.MapType.normal,
          onCameraIdle: () {
            setState(() {});
          },
          onMapCreated: _onMapCreated,
        ),
        Positioned(
            top: 30,
            left: 0,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            )),
        Positioned(
            left: 5,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            child: widgetLeftsideMenu())
      ],
    );
  }

  void _onMapCreated(map.GoogleMapController controller) {
    _controllerMap.complete(controller);
    newgooglemapxontroller = controller;
    getAllCustomers();
   // createPoly();
  }

  Future<void> getAllCustomers() async {
    DialogHelper.showLoading("Cariler yuklenir...");
    await widget.controllerRoutDetailUser.setAllMarkers();
    map.CameraPosition cameraPosition = map.CameraPosition(
      target: map.LatLng(
          widget.controllerRoutDetailUser.markers.first.position.latitude,  widget.controllerRoutDetailUser.markers.first.position.longitude),
      zoom: 14,
    );
    Future.delayed(const Duration(milliseconds: 1)).whenComplete(() =>
        newgooglemapxontroller!
            .animateCamera(map.CameraUpdate.newCameraPosition(cameraPosition)));
    DialogHelper.hideLoading();
  }

  Future<void> getAllDataUfterChange() async {
    DialogHelper.showLoading("Melumatlar yeniden yuklenir...");
    await widget.controllerRoutDetailUser.setAllMarkers();
    map.CameraPosition cameraPosition = map.CameraPosition(
      target: map.LatLng(
         double.parse( widget.controllerRoutDetailUser.selectedCariModel.value.longitude!),   double.parse( widget.controllerRoutDetailUser.selectedCariModel.value.latitude!)),
      zoom: 14,
    );
    Future.delayed(const Duration(milliseconds: 1)).whenComplete(() =>
        newgooglemapxontroller!
            .animateCamera(map.CameraUpdate.newCameraPosition(cameraPosition)));
    DialogHelper.hideLoading();
    setState(() {
    });
  }

  Widget widgetLeftsideMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: SizedBox(
            height: 50,
            width: 50,
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
                },
                child: const Center(child: Icon(Icons.search_outlined))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: SizedBox(
            height: 50,
            width: 50,
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

  Future<void> openCustomersSearchScreen() async {
    final map.GoogleMapController controller = await _controllerMap.future;
    ModelCariler model = await Get.toNamed(
        RouteHelper.mobileSearchMusteriMobile,
        arguments: widget.controllerRoutDetailUser.listFilteredUmumiBaza);
    if (model.toString().isNotEmpty) {
      widget.controllerRoutDetailUser.selectedCariModel.value = model;
      widget.controllerRoutDetailUser.addCirculerToMap();
      controller
          .animateCamera(map.CameraUpdate.newCameraPosition(map.CameraPosition(
        bearing: 0,
        target: map.LatLng(double.parse(model.longitude.toString()),
            double.parse(model.latitude.toString())),
        zoom: 14,
      )));
    }
  }

  Widget infoMarket(ModelCariler element) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 25, bottom: 0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                    overflow: TextOverflow.ellipsis,
                    labeltext: widget.controllerRoutDetailUser.selectedCariModel.value.name!,
                    fontWeight: FontWeight.w600,
                    fontsize: 16,
                    maxline: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 5, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            labeltext: "${"mesulsexs".tr} : ",
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          Expanded(
                              child: CustomText(
                                  labeltext: element.ownerPerson!,
                                  overflow: TextOverflow.clip,
                                  maxline: 2,
                                  fontsize: 12)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomText(
                            labeltext: "${"Rut gunu".tr} : ",
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Wrap(
                                children: [
                                  element.days!.any((a) => a.day==1)
                                      ? widgetRutGunuItems("gun1".tr)
                                      : const SizedBox(),
                                  element.days!.any((a) => a.day==2)
                                      ? widgetRutGunuItems("gun2".tr)
                                      : const SizedBox(),
                                  element.days!.any((a) => a.day==3)
                                      ? widgetRutGunuItems("gun3".tr)
                                      : const SizedBox(),
                                  element.days!.any((a) => a.day==4)
                                      ? widgetRutGunuItems("gun4".tr)
                                      : const SizedBox(),
                                  element.days!.any((a) => a.day==5)
                                      ? widgetRutGunuItems("gun5".tr)
                                      : const SizedBox(),
                                  element.days!.any((a) => a.day==6)
                                      ? widgetRutGunuItems("gun6".tr)
                                      : const SizedBox(),
                                  element.days!.any((a) => a.day==7)
                                      ? widgetRutGunuItems("bagli".tr)
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            labeltext: "${"borc".tr} : ",
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          Expanded(
                              child: CustomText(
                            labeltext: "${element.debt!} ${"manatSimbol".tr}",
                            overflow: TextOverflow.clip,
                            maxline: 2,
                            fontsize: 12,
                            color: element.debt == "0" ||
                                    element.debt.toString().contains("-")
                                ? Colors.blue
                                : Colors.red,
                            fontWeight: FontWeight.w700,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 15,
              right: 0,
              child: InkWell(
                  onTap: () {
                    openScreenMusteriDetail(widget.controllerRoutDetailUser.selectedCariModel.value);
                  },
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.lightBlueAccent,
                  ))),
          Positioned(
              top: -2,
              left: 0,
              child: CustomText(
                labeltext: widget.controllerRoutDetailUser.selectedCariModel.value.code!,
                fontsize: 12,
              )),
          Positioned(
              bottom: 5,
              right: 0,
              child: CustomElevetedButton(
                cllback: () async {
                  await Get.toNamed(RouteHelper.screenEditMusteriDetailScreen, arguments: [widget.controllerRoutDetailUser, RouteHelper.screenExpRoutDetailMap, element]);
                  widget.controllerRoutDetailUser.fromIntentPage.value="map";
                  getAllDataUfterChange();
                },
                label: "duzelt".tr,
                width: 100,
                height: 35,
                borderColor: Colors.blue,
                elevation: 5,
              ))
        ],
      ),
    );
  }

  Future<void> openScreenMusteriDetail(ModelCariler selectedModel) async {
    String listmesafe = "";
    double hesabMesafe = 0;
    if (hesabMesafe > 1) {
      listmesafe = "${(hesabMesafe).round()} km";
    } else {
      listmesafe = "${(hesabMesafe * 1000).round()} m";
    }
    selectedModel.mesafe = listmesafe;
    await Get.toNamed(RouteHelper.mobileScreenMusteriDetail, arguments: [
      selectedModel,
      widget.controllerRoutDetailUser.availableMap.value
    ]);
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

  Widget _rutHesabati() {
    int rutsuzMusteriSayi=widget.controllerRoutDetailUser.listSelectedExpBaza.where((p) => p.days!.any((element) => element.day!=1)
        && p.days!.any((element) => element.day!=2)&&p.days!.any((element) => element.day!=3)&&p.days!.any((element) => element.day!=4)&&p.days!.any((element) => element.day!=5)&&p.days!.any((element) => element.day!=6)).toList().length;
    return Padding(
      padding: const EdgeInsets.all(5.0).copyWith(left: 15),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                labeltext: 'Rut Hesabati',
                fontsize: 18,
                fontWeight: FontWeight.w700,
              ),
              Divider(
                height: 1,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 10,),
              DecoratedBox(decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0,1),
                    color: Colors.black12,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0.0,
                    blurRadius: 5
                  )
                ],
                color: Colors.lightBlue.withOpacity(0.2),
          
              ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width,height: 0,),
                      Row(
                        children: [
                          CustomText(labeltext: "${"umumiMusteri".tr} : ",fontWeight: FontWeight.w800),
                          CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.length.toString(),fontWeight: FontWeight.w600),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"aktivMusteri".tr} : ",fontWeight: FontWeight.w800),
                          CustomText(labeltext: "${widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.action=true).toList().length} ${"musteri".tr}  |  ${((widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.action=true).toList().length/widget.controllerRoutDetailUser.listSelectedExpBaza.length)*100).toString().substring(0,4)} %",fontWeight: FontWeight.w600),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"passivMusteri".tr} : ",fontWeight: FontWeight.w800),
                          CustomText(labeltext: "${widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.action=false).toList().length} ${"musteri".tr}  |  ${((widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.action=false).toList().length/widget.controllerRoutDetailUser.listSelectedExpBaza.length)*100).toString().substring(0,(widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.action=false).toList().length/widget.controllerRoutDetailUser.listSelectedExpBaza.length).toString().length>4?4:(widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.action=false).toList().length/widget.controllerRoutDetailUser.listSelectedExpBaza.length).toString().length)} %",fontWeight: FontWeight.w600),
                        ],
                      ),
                      const SizedBox(height: 1,),
                      const Divider(height: 1,color: Colors.white,thickness: 0.5,),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          CustomText(labeltext: "${"bagliMusteri".tr} : ",fontWeight: FontWeight.normal),
                          CustomText(labeltext: "${widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=7)).length} ${"musteri".tr}",fontWeight: FontWeight.normal,fontsize: 16,),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"rutsuzMusteri".tr} : ",fontWeight: FontWeight.normal),
                          CustomText(labeltext:"$rutsuzMusteriSayi ${"musteri".tr}",fontWeight: FontWeight.normal,fontsize: 16),
                        ],
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0).copyWith(left: 30,right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             // Spacer(),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"gun1".tr} : ",fontWeight: FontWeight.w800),
                                      CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=1)).length.toString(),fontWeight: FontWeight.w600),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"gun2".tr} : ",fontWeight: FontWeight.w800),
                                      CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=2)).length.toString(),fontWeight: FontWeight.w600),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"gun3".tr} : ",fontWeight: FontWeight.w800),
                                      CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=3)).length.toString(),fontWeight: FontWeight.w600),
                                    ],
                                  ),
          
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"gun4".tr} : ",fontWeight: FontWeight.w800),
                                      CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=4)).length.toString(),fontWeight: FontWeight.w600),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"gun5".tr} : ",fontWeight: FontWeight.w800),
                                      CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=5)).length.toString(),fontWeight: FontWeight.w600),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(labeltext: "${"gun6".tr} : ",fontWeight: FontWeight.w800),
                                      CustomText(labeltext: widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day!=6)).length.toString(),fontWeight: FontWeight.w600),
                                    ],
                                  ),
          
                                ],
                              ),
                             // Spacer()
          
                            ],
                          ),
                        ),
                      )
          
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void createPoly(){
    List<List<map.LatLng>> listmap=[];
    List<map.LatLng> listmapP=[];
    widget.controllerRoutDetailUser.listSelectedExpBaza.where((p0) => p0.days!.any((element) => element.day==1)).toList().forEach((element) {
      listmap.add([map.LatLng(double.parse(element.longitude.toString()), double.parse(element.latitude.toString()))]);
      listmapP.add(map.LatLng(double.parse(element.longitude.toString()), double.parse(element.latitude.toString())));
    });
    map.Polygon maskedArea1 = map.Polygon(
        fillColor: Colors.blue.withOpacity(0.5),
        strokeWidth: 1,
        polygonId: map.PolygonId('gun1'),
        holes: listmap,
        points:listmapP
    );
    _polygon.add(maskedArea1);
    setState(() {

    });
  }

}
