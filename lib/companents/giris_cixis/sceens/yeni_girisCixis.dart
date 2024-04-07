import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
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

class YeniGirisCixis extends StatefulWidget {
  const YeniGirisCixis({super.key});

  @override
  State<YeniGirisCixis> createState() => _YeniGirisCixisState();
}

class _YeniGirisCixisState extends State<YeniGirisCixis> {
  ControllerGirisCixisYeni controllerGirisCixis =
      Get.put(ControllerGirisCixisYeni());
  double _panelHeightOpen = 250;
  double _panelHeightClosed = 0.0;
  final double _initButtonHeight = 90.0;
  double _buttonsHeight = 130;
  bool showNearestCustomers = false;
  bool followMe = false;
  Completer<map.GoogleMapController> _controllerMap = Completer();
  late LocationData _currentLocation;
  final _location = Location();
  late map.LatLng _initialPosition = const map.LatLng(0, 0);
   final Set<map.Marker> _markers = {};
   final Set<map.Marker> _markersSmoll = {};
  String selectedClusterId = "";
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  late ModelCariler selectedModel;
  double zoomLevel=15;
  int marketeGirisIcazeMesafesi=5000;

  @override
  void dispose() {
    Get.delete<ControllerGirisCixisYeni>();
    _customInfoWindowController.dispose();
    _controllerMap = Completer();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _location.changeSettings(
      interval: 50,
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Minimum distance (in meters) between location updates
    );
    _getStartingLocation().then((value) {
      setState(()  {
        _initialPosition = value;
      });
    });

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .90;
    _panelHeightClosed = MediaQuery.of(context).size.height * .35;
    return Material(
      child: GetBuilder<ControllerGirisCixisYeni>(builder: (controller) {
        return Scaffold(
            body: Obx(
          () => controller.dataLoading.isTrue
              ? LoagindAnimation(
                  isDark: Get.isDarkMode,
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _initialPosition.longitude == 0
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : SlidingUpPanel(
                            backdropEnabled: true,
                            panelSnapping: true,
                            defaultPanelState:
                                controllerGirisCixis.slidePanelVisible.isTrue
                                    ? PanelState.OPEN
                                    : PanelState.CLOSED,
                            maxHeight: _panelHeightOpen,
                            minHeight:
                                controllerGirisCixis.marketeGirisEdilib.isTrue
                                    ? _panelHeightClosed
                                    : 0,
                            parallaxEnabled: true,
                            parallaxOffset: .5,
                            body: widgetGoogleMap(),
                            onPanelClosed: () {
                              controllerGirisCixis.slidePanelVisible.value = false;
                              controllerGirisCixis.leftSideMenuVisible.value=true;
                              controllerGirisCixis.rightSideMenuVisible.value=true;
                              setState(() {});
                            },
                            onPanelOpened: () {
                              controllerGirisCixis.leftSideMenuVisible.value=false;
                              controllerGirisCixis.rightSideMenuVisible.value=false;
                              controllerGirisCixis.slidePanelVisible.value = true;
                              // controllerGirisCixis.leftSideMenuVisible=false;
                              setState(() {});
                            },
                            panelBuilder: (sc) => _panel(sc, context),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18.0),
                                topRight: Radius.circular(18.0)),
                            onPanelSlide: (double pos) => {
                              setState(() {
                                 _buttonsHeight = pos * _panelHeightOpen + 300;
                                controllerGirisCixis.slidePanelVisible.value = true;

                                // if (pos < 0.35) {
                                //   controllerGirisCixis.slidePanelVisible.value = false;
                                //   _buttonsHeight = MediaQuery.of(context).size.width / 2 + _initButtonHeight;
                                // } else {
                                //   controllerGirisCixis.slidePanelVisible.value = true;
                                //   _buttonsHeight = pos * _panelHeightOpen + 100;
                                // }
                              })
                            },
                          ),
                    controllerGirisCixis.leftSideMenuVisible.isTrue
                        ? Positioned(
                            bottom:
                                controllerGirisCixis.slidePanelVisible.isTrue
                                    ? _buttonsHeight
                                    : MediaQuery.of(context).size.height / 2 -
                                        _initButtonHeight,
                            left: 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.bounceIn,
                              child: widgetLeftsideMenu(),
                            ))
                        : const SizedBox(),
                    controllerGirisCixis.rightSideMenuVisible.isTrue
                        ? Positioned(
                            bottom:
                                controllerGirisCixis.slidePanelVisible.isTrue
                                    ? _buttonsHeight
                                    : MediaQuery.of(context).size.height / 2 -
                                        _initButtonHeight,
                            right: 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.bounceIn,
                              child: widgetRightsideMenu(),
                            ))
                        : SizedBox(),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: MediaQuery.of(context).size.height / 2.8,
                      width: 300,
                      offset: 20,
                    ),
                    showNearestCustomers
                        ? Positioned(
                            top: 20,
                            left: 50,
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.3,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                      labeltext:
                                          controller.listCariler.first.name!,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.directions,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        labeltext: controller
                                            .listCariler.first.mesafe!,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                        : SizedBox()
                  ],
                ),
        ));
      }),
    );
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
          double.parse(model.longitude!.toString().toString()),
          double.parse(model.latitude!.toString().toString()));
      if (hesabMesafe > 1) {
        uzaqliq = "${(hesabMesafe).round()} km";
      } else {
        uzaqliq = "${(hesabMesafe * 1000).round()} m";
      }
      if (hesabMesafe < marketeGirisIcazeMesafesi/1000) {
        girisIcazesi = true;
      } else {
        girisIcazesi = false;
      }
      setState(() {
        selectedModel = model;
        if(controllerGirisCixis.marketeGirisEdilib.isTrue){
          _customInfoWindowController.addInfoWindow!(
              myCusttomInfoWindowStyleSimpleInfo(selectedModel, uzaqliq, girisIcazesi),
              map.LatLng(
                  double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString())));
        }else {
          if(girisIcazesi){
            _customInfoWindowController.addInfoWindow!(
                myCusttomInfoWindowStyleGiris(
                    selectedModel, uzaqliq, girisIcazesi),
                map.LatLng(
                    double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString())));
          }else{
            _customInfoWindowController.addInfoWindow!(
                myCusttomInfoWindowStyleSimpleInfo(selectedModel, uzaqliq, girisIcazesi),
                map.LatLng(
                    double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString())));
          }

        }});
      controller.animateCamera(map.CameraUpdate.newCameraPosition(
        map.CameraPosition(
        bearing: 0,
        target:  map.LatLng(double.parse(model.longitude.toString()),
            double.parse(model.latitude.toString())),
        zoom: zoomLevel,
      )));


    }
  }

  widgetGoogleMap() {
    return map.GoogleMap(
      initialCameraPosition: map.CameraPosition(target: _initialPosition),
      onTap: (v) {
        setState(() {
          controllerGirisCixis.leftSideMenuVisible.value = true;
          controllerGirisCixis.rightSideMenuVisible.value = true;
          _customInfoWindowController.hideInfoWindow!();
          selectedClusterId = "";
        });
      },
      markers: zoomLevel<=14?_markersSmoll:_markers,
      circles: controllerGirisCixis.circles,
      polygons: controllerGirisCixis.polygon,
      onCameraMove: (possition) {
        zoomLevel=possition.zoom;
        _customInfoWindowController.onCameraMove!();
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
      //minMaxZoomPreference: const map.MinMaxZoomPreference(10, 21),
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer()))
        ..add(Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
      onCameraIdle: () {
        setState(() {});
      },
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(map.GoogleMapController controller) {
      _controllerMap.complete(controller);
    _getCurrentLocation();
    setState(() {
      controller.animateCamera(map.CameraUpdate.newCameraPosition(
        map.CameraPosition(
          bearing: 0,
          target: map.LatLng(
              _currentLocation.latitude!, _currentLocation.longitude!),
          zoom: zoomLevel,
        ),
      ));
      fillMarkersFromBase();
    });
    _customInfoWindowController.googleMapController = controller;
  }

  fillMarkersFromBase() async {
    DialogHelper.showLoading("Musteriler yuklenir",false);
    for (ModelCariler model in controllerGirisCixis.listCariler) {
      _markers.add(map.Marker(
          markerId: map.MarkerId(model.code!),
          onTap: () {
            if(controllerGirisCixis.marketeGirisEdilib.isFalse) {
              onMarketClickGiris(model);
            }else{
              onMarketClickCixis(model);
            }
            },
          icon: await getClusterBitmap(120, model,model.ziyaret!,controllerGirisCixis.marketeGirisEdilib.value),
          position: map.LatLng(double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString()))));
      _markersSmoll.add(map.Marker(
        markerId: map.MarkerId(model.code!),
        icon: await getClusterBitmapSmole(40,model),
          position: map.LatLng(double.parse(model.longitude!.toString()), double.parse(model.latitude!.toString()))));
    }
    if(controllerGirisCixis.marketeGirisEdilib.isTrue){
     // controllerGirisCixis.addMarkersAndPlygane(controllerGirisCixis.modelgirisEdilmis.value.marketgpsUzunluq!,controllerGirisCixis.modelgirisEdilmis.value.marketgpsEynilik!,_currentLocation);
    }
    DialogHelper.hideLoading();
    if(mounted){
    setState(() {});}
  }

  void onMarketClickGiris(ModelCariler element) {
    String uzaqliq = "";
    bool girisicaze = false;
    double hesabMesafe = calculateDistance(
        _currentLocation.latitude,
        _currentLocation.longitude,
        double.parse(element.longitude!.toString()),
        double.parse(element.latitude!.toString()));
    if (hesabMesafe > 1) {
      uzaqliq = "${(hesabMesafe).round()} km";
    } else {
      uzaqliq = "${(hesabMesafe * 1000).round()} m";
    }
    if (hesabMesafe < marketeGirisIcazeMesafesi/1000) {
      girisicaze = true;
    } else {
      girisicaze = false;
    }
    print("hesabMesafe :"+hesabMesafe.toString());
    print("marketeGirisIcazeMesafesi :"+(marketeGirisIcazeMesafesi/1000).toString());
    setState(() {
      selectedModel = element;
      _customInfoWindowController.addInfoWindow!(
          girisicaze?myCusttomInfoWindowStyleGiris(selectedModel, uzaqliq, girisicaze):myCusttomInfoWindowStyleSimpleInfo(selectedModel, uzaqliq, girisicaze),
          map.LatLng(double.parse(element.longitude!.toString()), double.parse(element.latitude!.toString())));
      controllerGirisCixis.leftSideMenuVisible.value = false;
      controllerGirisCixis.rightSideMenuVisible.value = false;
    });
  }

  void onMarketClickCixis(ModelCariler element) {
    String uzaqliq = "";
    bool cixisIcaze = false;
    bool cixisEdilmeliMarketdir=controllerGirisCixis.modelgirisEdilmis.value.ckod==element.code;
    double hesabMesafe = calculateDistance(
        _currentLocation.latitude,
        _currentLocation.longitude,
        double.parse(element.longitude!.toString()),
        double.parse(element.latitude!.toString()));
    if (hesabMesafe > 1) {
      uzaqliq = "${(hesabMesafe).round()} km";
    } else {
      uzaqliq = "${(hesabMesafe * 1000).round()} m";
    }
    if (hesabMesafe <marketeGirisIcazeMesafesi/1000) {
      cixisIcaze = true;
    } else {
      cixisIcaze = false;
    }
    setState(() {
      selectedModel = element;
      _customInfoWindowController.addInfoWindow!(
         cixisEdilmeliMarketdir?
          myCusttomInfoWindowStyleCixis(selectedModel, uzaqliq, cixisIcaze):
          myCusttomInfoWindowStyleSimpleInfo(selectedModel, uzaqliq, cixisIcaze),
          map.LatLng(double.parse(element.longitude!.toString()), double.parse(element.latitude!.toString())));
      controllerGirisCixis.leftSideMenuVisible.value = false;
      controllerGirisCixis.rightSideMenuVisible.value = false;
    }
    );
  }

  Widget myCusttomInfoWindowStyleSimpleInfo(ModelCariler selectedModel, String uzaqliq, bool girisicaze) {
    return Hero(
      tag: selectedModel.code!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.green, blurRadius: 4, offset: Offset(0, 2)),
                ]),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomText(
                    labeltext: selectedModel.name.toString(),
                    textAlign: TextAlign.center,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                    maxline: 2,
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Marketed Uzaqliq : "),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(Icons.moving),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(uzaqliq),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Rut gunu :"),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              controllerGirisCixis.rutGununuYoxla(selectedModel)
                                  ? Icons.check_circle
                                  : Icons.dangerous,
                              color: controllerGirisCixis
                                      .rutGununuYoxla(selectedModel)
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(controllerGirisCixis
                                    .rutGununuYoxla(selectedModel)
                                ? "Duz"
                                : "Yalnis"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         CustomElevetedButton(
                           textsize: 14,
                           textColor: Colors.blueAccent,
                           icon: Icons.info,
                           hasshadow: true,
                           height: 35,
                           width: 100,
                           cllback: () {
                             openScreenMusteriDetail(selectedModel);
                           },
                           label: "Melumatlar",
                           surfaceColor: Colors.white,
                           borderColor: Colors.blueAccent,
                           elevation: 10,
                         ),
                         const SizedBox(
                           width: 20,
                         ),
                         CustomElevetedButton(
                           textsize: 14,
                           hasshadow: true,
                           height: 35,
                           width: 100,
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
                     )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: Colors.green.withOpacity(0.8),
              height: 15,
              width: 50,
            ),
          )
        ],
      ),
    );
  }

  Widget myCusttomInfoWindowStyleGiris(ModelCariler selectedModel, String uzaqliq, bool girisicaze) {
    return Hero(
      tag: selectedModel.code!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.green, blurRadius: 4, offset: Offset(0, 2)),
                ]),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomText(
                    labeltext: selectedModel.name.toString(),
                    textAlign: TextAlign.center,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                    maxline: 2,
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(labeltext: "marketdistance".tr),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(Icons.moving),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomText(labeltext:uzaqliq),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(labeltext: "rutgunu".tr),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              controllerGirisCixis.rutGununuYoxla(selectedModel)
                                  ? Icons.check_circle
                                  : Icons.dangerous,
                              color: controllerGirisCixis
                                      .rutGununuYoxla(selectedModel)
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomText(labeltext: controllerGirisCixis
                                    .rutGununuYoxla(selectedModel)
                                ? "right".tr
                                : "wrong".tr),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                              onTap: () {
                                girisEt(selectedModel, uzaqliq);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        girisicaze ? Colors.green : Colors.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                height: 50,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Center(
                                    child:CustomText(labeltext: "giriset".tr,)),
                              ),
                            )

                    ],
                  ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: Colors.green.withOpacity(0.8),
              height: 15,
              width: 50,
            ),
          )
        ],
      ),
    );
  }

  Widget myCusttomInfoWindowStyleCixis(ModelCariler selectedModel, String uzaqliq, bool girisicaze) {
    return Hero(
      tag: selectedModel.code!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.green, blurRadius: 4, offset: Offset(0, 2)),
                ]),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomText(
                    labeltext: selectedModel.name.toString(),
                    textAlign: TextAlign.center,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                    maxline: 2,
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      girisicaze?Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Marketed Uzaqliq : "),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.moving),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(uzaqliq),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(labeltext: "Rut gunu :"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  controllerGirisCixis.rutGununuYoxla(selectedModel)
                                      ? Icons.check_circle
                                      : Icons.dangerous,
                                  color: controllerGirisCixis
                                      .rutGununuYoxla(selectedModel)
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(labeltext: controllerGirisCixis
                                    .rutGununuYoxla(selectedModel)
                                    ? "Duz"
                                    : "Yalnis"),
                              ],
                            ),
                          ),
                        ],
                      ):CustomText(
                          maxline: 2,
                          textAlign: TextAlign.center,
                          labeltext: "Marketden cox uzaqsiniz.Ya markete yaxinlasin yada girisi silin"),
                      const SizedBox(
                        height: 20,
                      ),
                      girisicaze?InkWell(
                              onTap: () {
                                cixisEt(selectedModel, uzaqliq);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        girisicaze ? Colors.green : Colors.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                height: 50,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Center(
                                    child: CustomText(labeltext:"cixiset".tr,)),
                              ),
                            ):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevetedButton(
                            textsize: 14,
                            textColor: Colors.blueAccent,
                            icon: Icons.info,
                            hasshadow: true,
                            height: 35,
                            width: 100,
                            cllback: () {
                              openScreenMusteriDetail(selectedModel);
                            },
                            label: "Melumatlar",
                            surfaceColor: Colors.white,
                            borderColor: Colors.blueAccent,
                            elevation: 10,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CustomElevetedButton(
                            textsize: 14,
                            hasshadow: true,
                            height: 35,
                            width: 100,
                            cllback: () {
                              girisiSil();
                            },
                            label: "Girisi Sil",
                            surfaceColor: Colors.white,
                            borderColor: Colors.red,
                            elevation: 10,
                            isSvcFile: false,
                            icon: Icons.delete_outline,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: Colors.green.withOpacity(0.8),
              height: 15,
              width: 50,
            ),
          )
        ],
      ),
    );
  }

  Future<map.BitmapDescriptor> getClusterBitmap(int size, ModelCariler model,String ziyaret,bool girisEdilib) async {
    size=controllerGirisCixis.marketeGirisEdilib.isTrue?model.ziyaret == "1"?size+10:model.ziyaret=="2"?size:size-50:size;
    Color color=model.ziyaret == "1"?Colors.blue:model.ziyaret=="2"?Colors.green:Colors.grey;
    if(controllerGirisCixis.marketeGirisEdilib.isFalse){
      color=model.ziyaret == "1"?Colors.blue:model.ziyaret=="2"?Colors.green:Colors.red;
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()
      ..color = model.rutGunu == "Duz" ? Colors.lightBlueAccent : Colors.transparent;
    canvas.drawCircle(Offset(size / 3.5, size / 2.7), size / 10.0, paint1);
    var icon = Icons.local_grocery_store;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7,
            fontFamily: icon.fontFamily,
            color: color));
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
    if(controllerGirisCixis.marketeGirisEdilib.isFalse){
      painter.layout();
      painter.paint(canvas, Offset((size - painter.width) * 0.7, size / 6),);
    }else{
    if(model.ziyaret == "1"||model.ziyaret == "2") {
      painter.layout();
      painter.paint(canvas, Offset((size - painter.width) * 0.7, size / 6),);
    }}
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<map.BitmapDescriptor> getClusterBitmapSmole(int size,ModelCariler model) async {
    Color color=model.ziyaret == "1"?Colors.blue:model.ziyaret=="2"?Colors.green:Colors.grey;
    if(controllerGirisCixis.marketeGirisEdilib.isFalse){
      if(model.rutGunu=="Duz"){
        color=model.ziyaret == "1"?Colors.blue:model.ziyaret=="2"?Colors.green:Colors.red;

      }else{
        color=model.ziyaret == "1"?Colors.blue:model.ziyaret=="2"?Colors.green:Colors.grey;
      }
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.circle;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7,
            fontFamily: icon.fontFamily,
            color: color));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
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
    Coords cordBaslangic =Coords(_currentLocation.latitude!, _currentLocation.longitude!);
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
    final map.GoogleMapController controller = await _controllerMap.future;
    try {
      _currentLocation = await _location.getLocation();
    } on Exception {
      _currentLocation = await _location.getLocation();
    }
    Future.delayed(const Duration(seconds: 2)).whenComplete(() => fillMarkersFromBase()
    );
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
        if(controllerGirisCixis.marketeGirisEdilib.isTrue){
        controllerGirisCixis.polygon.update((value) {
          value!.first.points.first.latitude ==_currentLocation.latitude;
          value.first.points.first.longitude ==_currentLocation.longitude;

        });}
        if (followMe) {
          zoomLevel=18;
            map.Marker markerMen = _markers.where((element) => element.markerId.value=="1").toList().first;
            markerMen.position.longitude==event.longitude;
            markerMen.position.latitude==event.latitude;
            markerMen.rotation==event.heading;
            markerMen.anchor==const Offset(5, 5);
            markerMen.flat==true;
          _currentLocation = event;
          controller.animateCamera(map.CameraUpdate.newCameraPosition(
            map.CameraPosition(
              bearing: event.heading!,
              target: map.LatLng(event.latitude!, event.longitude!),
              zoom: zoomLevel,
            ),

          ));

        }else{
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
    // await controllerGirisCixis.pripareForEnter(_currentLocation, selectedModel, uzaqliq);
    // _customInfoWindowController.hideInfoWindow!();
    cixisXeritesiniQur(selectedModel.longitude!.toString(), selectedModel.latitude!.toString(), selectedModel.code!);
  }

  /////////////Cixis Et hissesi//////////////
  Future<void> cixisXeritesiniQur(String longitude, String latitude, String ckod) async {

    updateMarkers();
    updateFollowMe(false);
    setState(() {
      _panelHeightOpen = MediaQuery.of(context).size.height * .70;
      _panelHeightClosed = MediaQuery.of(context).size.height * .35;
    });
  }

  void girisiSil() {
    updateFollowMe(false);
    controllerGirisCixis.girisiSil();
    _customInfoWindowController.hideInfoWindow!();
    updateMarkers();
    _panelHeightClosed = 0;
  }

  void updateMarkers() {
    _markers.clear();
    _markersSmoll.clear();
    fillMarkersFromBase();
  }

  Future<void> cixisEt(ModelCariler selectedModel, String uzaqliq) async {
    _customInfoWindowController.hideInfoWindow!();
    // await controllerGirisCixis.cixisUcunHazirliq(_currentLocation, uzaqliq,"QEYD");
    updateMarkers();
    setState(() {});
  }

  ////panel Hisse/////
  Widget _panel(ScrollController sc, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                height: 10,
                width: 40,
              ),
            ),
          ), //panel cubugu
          const SizedBox(
            height: 10,
          ),
          controllerGirisCixis.slidePanelVisible.isTrue?SizedBox(
              height: 120,
              child: SizedBox()):SizedBox(),
        ],
      ),
    );
  }

}
