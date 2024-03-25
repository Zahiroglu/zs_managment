import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/widgetHesabatListItems.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';

import '../hesabatlar/cari_hesabat/marketuzre_hesabatlar.dart';
import '../hesabatlar/user_hesabatlar/useruzre_hesabatlar.dart';
import 'controller_live_track/controller_live_track.dart';
import 'model/model_live_track.dart';

class ScreenLiveTrack extends StatefulWidget {
  DrawerMenuController drawerMenuController;

  ScreenLiveTrack({required this.drawerMenuController, super.key});

  @override
  State<ScreenLiveTrack> createState() => _ScreenLiveTrackState();
}

class _ScreenLiveTrackState extends State<ScreenLiveTrack> {
  ControllerLiveTrack controllerGirisCixis = Get.put(ControllerLiveTrack());
  final ScrollController listViewController = ScrollController();
  bool expandMenuVisible = false;
  late map.LatLng _initialPosition = const map.LatLng(0, 0);
  late Position _currentLocation;
  late LocationSettings locationSettings;
  map.GoogleMapController? newgooglemapxontroller;
  Completer<map.GoogleMapController> _controllerMap = Completer();
  bool userHesabatlarMustVisible = false;
  bool scrrolOpened=false;

  @override
  void initState() {
    confiqGeolocatior();
    _determinePosition().then((value) {
      setState(() {
        _currentLocation = value;
        _initialPosition = map.LatLng(_currentLocation.latitude, _currentLocation.longitude);
        map.CameraPosition cameraPosition = map.CameraPosition(
          target: map.LatLng(_currentLocation.latitude, _currentLocation.longitude), zoom: 15,
        );
        Future.delayed(const Duration(milliseconds: 200)).whenComplete(() =>
            newgooglemapxontroller!.animateCamera(
                map.CameraUpdate.newCameraPosition(cameraPosition)));
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controllerMap = Completer();
    Get.delete<ControllerLiveTrack>();
    super.dispose();
  }

  confiqGeolocatior() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
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
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
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

  @override
  Widget build(BuildContext context) {
    return Obx(() => SnappingSheet(
          onSheetMoved: (positionData) {
            if (positionData.relativeToSnappingPositions > 0.6) {
              setState(() {
                expandMenuVisible = true;
                userHesabatlarMustVisible = true;
              });
            } else if (positionData.relativeToSnappingPositions >= 0.3) {
              setState(() {
                scrrolOpened=true;
              });
            } else {
              setState(() {
                scrrolOpened=false;
                expandMenuVisible = false;
                userHesabatlarMustVisible = false;
              });
            }
          },
          controller: controllerGirisCixis.snappingSheetController.value,
          lockOverflowDrag: true,
          snappingPositions: controllerGirisCixis.userMarkerSelected.isTrue ? [
                  const SnappingPosition.factor(
                    positionFactor: 0.0,
                    snappingCurve: Curves.easeOutExpo,
                    snappingDuration: Duration(milliseconds: 1000),
                    grabbingContentOffset: GrabbingContentOffset.top,
                  ),
                  const SnappingPosition.factor(
                    grabbingContentOffset: GrabbingContentOffset.bottom,
                    snappingCurve: Curves.easeOutExpo,
                    snappingDuration: Duration(milliseconds: 1000),
                    positionFactor: 0.75,
                  )
                ] : [
                  const SnappingPosition.factor(
                    positionFactor: 0.0,
                    snappingCurve: Curves.easeOutExpo,
                    snappingDuration: Duration(milliseconds: 1000),
                    grabbingContentOffset: GrabbingContentOffset.top,
                  ),
                  const SnappingPosition.factor(
                    snappingCurve: Curves.easeOutExpo,
                    snappingDuration: Duration(milliseconds: 1000),
                    positionFactor: 0.3,
                  ),
                ],
          grabbing: Obx(() {
            return controllerGirisCixis.selectedModel.value.modelCariTrack!= null ? grappengContainer(context) : SizedBox();
          }),
          grabbingHeight: controllerGirisCixis.userMarkerSelected.isFalse
              ? MediaQuery.of(context).size.height / 5 : userHesabatlarMustVisible?MediaQuery.of(context).size.height / 8.2:MediaQuery.of(context).size.height / 4,
          sheetAbove: null,
          sheetBelow: SnappingSheetContent(
            draggable: true,
            childScrollController: listViewController,
            child: controllerGirisCixis.selectedModel.value.userCode!=null?controllerGirisCixis.userMarkerSelected.isTrue
                ? _hesabatHisseUser(context)
                : _hesabatHisseMartker(context):SizedBox(),
          ),
          child: widgetGoogleMap(),
        ));
  }

  Widget grappengContainer(BuildContext context) {
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
          controllerGirisCixis.userMarkerSelected.isFalse
              ? _widgetMarketInfo(context)
              : _widgetUserInfo(context),
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
                  top: -15,
                  right: -5,
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        controllerGirisCixis.userMarkerSelected.isFalse
                            ? controllerGirisCixis.snappingSheetController.value
                                .snapToPosition(const SnappingPosition.pixels(
                                    positionPixels: 80))
                            : controllerGirisCixis.snappingSheetController.value
                                .snapToPosition(const SnappingPosition.pixels(
                                    positionPixels: 100));
                      });
                    },
                    icon: const Icon(Icons.expand_more),
                  ))
              : const SizedBox(),
          controllerGirisCixis.selectedModel.value.modelCariTrack!.rutGunu == "1"
              ? const Positioned(
                  top: 5,
                  left: 5,
                  child: Icon(
                    Icons.label_important,
                    color: Colors.blueAccent,
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
          initialCameraPosition: map.CameraPosition(target: _initialPosition),
          onTap: (v) {
            setState(() {
              controllerGirisCixis.selectedModel.value = ModelLiveTrack();
              controllerGirisCixis.userMarkerSelected.isFalse
                  ? controllerGirisCixis.snappingSheetController.value
                      .snapToPosition(
                          const SnappingPosition.pixels(positionPixels: 80))
                  : controllerGirisCixis.snappingSheetController.value
                      .snapToPosition(
                          const SnappingPosition.pixels(positionPixels: 80));
            });
          },
          polylines: controllerGirisCixis.polylines.value.toSet(),
          markers: controllerGirisCixis.markers.value,
          circles: controllerGirisCixis.circles.value.toSet(),
          onCameraMove: (possition) {
            setState(() {});
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
          right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: (){
                openSearchScreen();
              },
            )),
        Positioned(
            top: 20,
            left: 15,
            child: InkWell(
                onTap: () {
                  widget.drawerMenuController.keyScaff.currentState!
                      .openDrawer();
                },
                child: Icon(Icons.menu)))
      ],
    );
  }

  void _onMapCreated(map.GoogleMapController controller) {
    _controllerMap.complete(controller);
    newgooglemapxontroller = controller;
    //_getCurrentLocation();
  }

  _widgetMarketInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 8,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext:
                      controllerGirisCixis.selectedModel.value.modelCariTrack!.marketName!,
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: controllerGirisCixis
                      .selectedModel.value.actionTrackIn!.date!,
                  fontsize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  labeltext: "${"ziyaretci".tr} : ",
                  fontsize: 15,
                  fontWeight: FontWeight.w600),
              CustomText(
                  labeltext:
                      " ${controllerGirisCixis.selectedModel.value.userName!}  (${controllerGirisCixis.selectedModel.value.userCode!})"),
            ],
          ),
          _widgetInfoZiyaret()
        ],
      ),
    );
  }

  _widgetInfoZiyaret() {
    return Column(
      children: [
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "${"girisVaxt".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                CustomText(
                    labeltext:
                        " ${controllerGirisCixis.selectedModel.value.actionTrackIn!.time!}"),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.social_distance,
                  size: 12,
                ),
                CustomText(
                    labeltext:
                        " ${controllerGirisCixis.selectedModel.value.actionTrackIn!.distance!}"),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "${"cixisVaxt".tr} : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                controllerGirisCixis.selectedModel.value.modelCariTrack!.cixisEdilib!
                    ? CustomText(
                        labeltext:
                            " ${controllerGirisCixis.selectedModel.value.actionTrackOut!.time!}")
                    : CustomText(labeltext: "cixisedilmeyib"),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            controllerGirisCixis.selectedModel.value.modelCariTrack!.cixisEdilib!
                ? Row(
                    children: [
                      const Icon(
                        Icons.social_distance,
                        size: 12,
                      ),
                      CustomText(
                          labeltext:
                              " ${controllerGirisCixis.selectedModel.value.actionTrackOut!.distance!}"),
                    ],
                  )
                : SizedBox()
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                    labeltext: "marketdeISvaxti".tr + " : ",
                    fontsize: 14,
                    fontWeight: FontWeight.w600),
                CustomText(
                    labeltext:
                        " ${controllerGirisCixis.selectedModel.value.modelCariTrack!.marketdeQalmaVaxti}"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _widgetUserInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 8,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext:
                      "${controllerGirisCixis.selectedModel.value.userCode!}-${controllerGirisCixis.selectedModel.value.userName!}",
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: controllerGirisCixis
                              .selectedModel.value.userCurrentPosition!.isOnline
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black)),
                  child: Center(
                      child: CustomText(
                    labeltext: controllerGirisCixis
                            .selectedModel.value.userCurrentPosition!.isOnline
                        ? "Online"
                        : "Offline",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  labeltext: "${"sonYenilenme".tr} : ",
                  fontsize: 15,
                  fontWeight: FontWeight.w600),
              CustomText(
                  labeltext: controllerGirisCixis
                      .selectedModel.value.userCurrentPosition!.lastTime),
            ],
          ),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      labeltext: "${"surret".tr} : ",
                      fontsize: 15,
                      fontWeight: FontWeight.w600),
                  CustomText(
                      labeltext: "${controllerGirisCixis
                              .selectedModel.value.userCurrentPosition!.speed} km"),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              controllerGirisCixis
                          .selectedModel.value.userCurrentPosition!.speed ==
                      "0"
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            labeltext: "${"hereket".tr} : ",
                            fontsize: 15,
                            fontWeight: FontWeight.w600),
                        CustomText(
                            labeltext: controllerGirisCixis.selectedModel.value
                                        .userCurrentPosition!.speed ==
                                    "0"
                                ? ""
                                : "hereketdedir".tr),
                      ],
                    ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          userHesabatlarMustVisible||controllerGirisCixis.selectedModel.value.modelCariTrack!.marketName==null?SizedBox():Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                labeltext: "sonuncuZiyaret",
                fontWeight: FontWeight.w800,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 2,
              ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      labeltext:
                      controllerGirisCixis.selectedModel.value.modelCariTrack!.marketName!,
                      fontsize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      labeltext: controllerGirisCixis
                          .selectedModel.value.actionTrackIn!.date!,
                      fontsize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          userHesabatlarMustVisible||controllerGirisCixis.selectedModel.value.modelCariTrack!.marketName==null?SizedBox():_widgetInfoZiyaret(),
        ],
      ),
    );
  }

  _hesabatHisseMartker(BuildContext context) {
    return controllerGirisCixis.selectedModel.value.modelCariTrack!= null
        ? Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WidgetCarihesabatlar(
                    height: 100,
                    ckod: controllerGirisCixis.selectedModel.value.modelCariTrack!.marketCode!,
                    cad: controllerGirisCixis.selectedModel.value.modelCariTrack!.marketName!,
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  _hesabatHisseUser(BuildContext context) {
    return controllerGirisCixis.selectedModel.value.roleId!=null?Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            WidgetRuthesabatlar(roleId: controllerGirisCixis.selectedModel.value.roleId!,height: 100,temsilciKodu: controllerGirisCixis.selectedModel.value.userCode!),
          ],
        ),
      ),
    ):SizedBox();
  }

  Future<void> openSearchScreen() async {
    ModelLiveTrack model=await Get.toNamed(RouteHelper.searchLiveUsers,arguments: controllerGirisCixis.listTrackdata.value);
    if(model.userCode!=null){
      controllerGirisCixis.selectedModel.value=model;
      controllerGirisCixis.userMarkerSelected.value=true;
      map.CameraPosition cameraPosition = map.CameraPosition(target: map.LatLng(double.parse(model.userCurrentPosition!.lat),double.parse(model.userCurrentPosition!.lng)), zoom: 12,
      );
      if( controllerGirisCixis.selectedModel.value.modelCariTrack!.marketName==null){
        controllerGirisCixis.snappingSheetController.value.snapToPosition(
            const SnappingPosition.pixels(positionPixels: 40));
      }else {
        controllerGirisCixis.snappingSheetController.value.snapToPosition(
            const SnappingPosition.pixels(positionPixels: 110));
      }
      Future.delayed(const Duration(milliseconds: 200)).whenComplete(() =>
          newgooglemapxontroller!.animateCamera(
              map.CameraUpdate.newCameraPosition(cameraPosition)));
    }
  }

}
