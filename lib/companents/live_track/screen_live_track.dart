import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_inout.dart';
import 'package:zs_managment/companents/live_track/screen_search_live_users.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';

import '../../helpers/user_permitions_helper.dart';
import '../../widgets/simple_info_dialog.dart';
import '../hesabatlar/cari_hesabat/marketuzre_hesabatlar.dart';
import '../hesabatlar/user_hesabatlar/useruzre_hesabatlar.dart';
import 'controller_live_track/controller_live_track.dart';
import 'model/model_live_track.dart';
import 'package:intl/intl.dart' as intel;

class ScreenLiveTrack extends StatefulWidget {
 final DrawerMenuController drawerMenuController;

  const ScreenLiveTrack({required this.drawerMenuController, super.key});

  @override
  State<ScreenLiveTrack> createState() => _ScreenLiveTrackState();
}

class _ScreenLiveTrackState extends State<ScreenLiveTrack> with WidgetsBindingObserver{
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
  UserPermitionsHelper userPermitionsHelper=UserPermitionsHelper();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    configGeolocatior();
    _determinePosition().then((value) {
     if(mounted){
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
     }
    });

    super.initState();
  }

  @override
  void dispose() {
    // Observer kaldırma
    WidgetsBinding.instance.removeObserver(this);
    // Completer sıfırlama
    _controllerMap = Completer();
    // Timer iptali
    controllerGirisCixis.timer?.cancel();

    // ScrollController serbest bırakılması
    listViewController.dispose();
    // Google Map Controller serbest bırakılması
    newgooglemapxontroller?.dispose();

    // GetX Controller kaldırma
     Get.delete<ControllerLiveTrack>();

    // Super çağrısı
    super.dispose();
  }


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      controllerGirisCixis.timer!.cancel();
      // Tətbiq yenidən açıldıqda background xidmətini aktiv et
    }
  }

  configGeolocatior() {
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
    return Obx(() => SizedBox(
      height: MediaQuery.of(context).size.height, // Constrained height
      child: Column(
        children: [
        Expanded(
            flex: controllerGirisCixis.searcAktive.isTrue?10:2,
            child: SnappingSheet(
          onSheetMoved: (positionData) {
            if (positionData.relativeToSnappingPositions > 0.6) {
              if(mounted){
              setState(() {
                expandMenuVisible = true;
                userHesabatlarMustVisible = true;
              });}
            }
            else if (positionData.relativeToSnappingPositions >= 0.30) {
              if(mounted){
              setState(() {
                scrrolOpened=true;
              });}
            }
            else {
              if(mounted){
              setState(() {
                scrrolOpened=false;
                expandMenuVisible = false;
                userHesabatlarMustVisible = false;
              });}
            }
          },
          controller: controllerGirisCixis.snappingSheetController.value,
          lockOverflowDrag: true,
          snappingPositions: controllerGirisCixis.userMarkerSelected.isTrue ? [
            const SnappingPosition.factor(
              positionFactor: 0.00,
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
              positionFactor: 0.35,
            ),
          ],
          grabbing: Obx(() {

            return controllerGirisCixis.selectedModel.value.lastInoutAction==null?const SizedBox(): grappengContainer(context) ;
          }),
          grabbingHeight: controllerGirisCixis.userMarkerSelected.isFalse
              ? MediaQuery.of(context).size.height / 5
              : userHesabatlarMustVisible?MediaQuery.of(context).size.height/2.8 :MediaQuery.of(context).size.height / 2.5,
          sheetAbove: null,
          sheetBelow: SnappingSheetContent(
            draggable: true,
            childScrollController: listViewController,
            child:controllerGirisCixis.selectedModel.value.userCode!=null?controllerGirisCixis.userMarkerSelected.isTrue
                ? _hesabatHisseUser(context)
                : _hesabatHisseMartker(context):const SizedBox(),
          ),
          child: widgetGoogleMap(),
        )),
          if (controllerGirisCixis.searcAktive.isTrue&&controllerGirisCixis.listTrackdata.isNotEmpty)
            Expanded(
              flex: 20,
              child: searchUsers(context),
            ),
      ],),
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
                width: 50,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          // expandMenuVisible
          //     ? Positioned(
          //   top: -15,
          //   right: -5,
          //   child: IconButton(
          //     iconSize: 40,
          //     onPressed: () {
          //       setState(() {
          //         controllerGirisCixis.userMarkerSelected.isFalse
          //             ? controllerGirisCixis.snappingSheetController.value
          //             .snapToPosition(const SnappingPosition.pixels(
          //             positionPixels: 80))
          //             : controllerGirisCixis.snappingSheetController.value
          //             .snapToPosition(const SnappingPosition.pixels(
          //             positionPixels: 100));
          //       });
          //     },
          //     icon: const Icon(Icons.expand_more),
          //   ),
          // )
          //     : const SizedBox(),
          Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  CustomText(
                      fontsize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      labeltext: controllerGirisCixis.selectedModel.value.currentLocation!.locationDate.toString().substring(10,16)),
                  Lottie.asset(controllerGirisCixis.selectedModel.value.currentLocation!.isOnline!?"lottie/pointyasil.json":"lottie/pointqirmizi.json",height: 25,filterQuality: FilterQuality.medium,fit: BoxFit.fill),
                ],
              )),
          Positioned(
            top: 5,
            left: 5,
            child: Icon(
              controllerGirisCixis.selectedModel.value.lastInoutAction!.outLatitude != null
                  ? Icons.label_important
                  : Icons.label_important_outline,
              color: controllerGirisCixis.selectedModel.value.lastInoutAction!.outLatitude != null
                  ? Colors.blueAccent
                  : Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetGoogleMap() {
    return Obx(()=>Stack(
      children: [
        map.GoogleMap(
          initialCameraPosition: map.CameraPosition(target: _initialPosition),
          onTap: (v) {
            if(mounted) {
              setState(() {
                String marketMarkerId = "${controllerGirisCixis.selectedModel
                    .value.lastInoutAction!.customerCode}-${controllerGirisCixis
                    .selectedModel.value.lastInoutAction!.inDate}";
                controllerGirisCixis.markers.removeWhere((e) =>
                e.markerId.value == marketMarkerId);
                controllerGirisCixis.circles.clear();
                controllerGirisCixis.polylines.clear();
                controllerGirisCixis.selectedModel.value = ModelLiveTrack();
                controllerGirisCixis.userMarkerSelected.isFalse
                    ? controllerGirisCixis.snappingSheetController.value
                    .snapToPosition(
                    const SnappingPosition.pixels(positionPixels: 80))
                    : controllerGirisCixis.snappingSheetController.value
                    .snapToPosition(
                    const SnappingPosition.pixels(positionPixels: 80));
              });
            }},
          polylines: controllerGirisCixis.polylines.toSet(),
          markers: controllerGirisCixis.markers,
          circles: controllerGirisCixis.circles.toSet(),
          onCameraMove: (possition) {
            if(mounted) {
              setState(() {});
            }},
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
          },
          onMapCreated: _onMapCreated,
        ),
    controllerGirisCixis.searcAktive.isFalse ?Positioned(
            right:10,
            top: 70,
            child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.withOpacity(0.3),
                child: InkWell(
                  onTap: () {
              if(mounted){
              setState(() {
                controllerGirisCixis.selectedModel.value = ModelLiveTrack();
                controllerGirisCixis.userMarkerSelected.value=true;
                controllerGirisCixis.searcAktive.value=true;
                scrrolOpened=false;
              });}
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green.withOpacity(0.8))),
                        child: const Center(
                            child:Icon(Icons.search_outlined)),
                      ),
                      Positioned(
                          top: -0,
                          right: -0,
                          child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: SizedBox(
                                  width: 20,
                                  child: Center(
                                      child: CustomText(
                                        labeltext: controllerGirisCixis
                                            .listTrackdata.length
                                            .toString(),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontsize: 12,
                                      )))))
                    ],
                  ),
                )
            )):const SizedBox(),
        // controllerGirisCixis.searcAktive.isTrue?const SizedBox():Positioned(
        //     right: controllerGirisCixis.dataLoading.isFalse? 60:10,
        //     top: 15,
        //     child: CircleAvatar(
        //       radius: 20,
        //       backgroundColor: Colors.grey.withOpacity(0.5),
        //       child: IconButton(
        //         icon: const Icon(Icons.search_outlined),
        //         onPressed: (){
        //           if(mounted){
        //           setState(() {
        //             controllerGirisCixis.selectedModel.value = ModelLiveTrack();
        //             controllerGirisCixis.userMarkerSelected.value=true;
        //             controllerGirisCixis.searcAktive.value=true;
        //             scrrolOpened=false;
        //           });}
        //           //openSearchScreen();
        //         },
        //       ),
        //     )),
        controllerGirisCixis.dataLoading.isFalse?Positioned(
            right: 10,
            top: 15,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () async {
                  await controllerGirisCixis.getAllDatFromServer();
                },
              ),
            )):const SizedBox(),
        controllerGirisCixis.dataLoading.isFalse?Positioned(
            left: 18,
            top: 45,
            child: Row(
              children: [
                controllerGirisCixis.sonYenilenme.isEmpty?const SizedBox(): CustomText(labeltext:"${"lastRefresh".tr}: ${controllerGirisCixis.sonYenilenme.value.substring(11,19)}",color: Colors.black,fontsize: 12,fontWeight: FontWeight.bold,),
              ],
            )):const SizedBox(),
        controllerGirisCixis.dataLoading.isTrue?Positioned(
            left: MediaQuery.of(context).size.width*0.3,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white)

              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)),
                  const SizedBox(width: 10,),
                  CustomText(labeltext: "${"mDeyisdirilir".tr}...",color: Colors.white,),
                ],
              ),
            )):const SizedBox(),
        controllerGirisCixis.dataLoading.isFalse?Positioned(
            left: 5,
            top: 70,
            child: InkWell(
              onTap: (){
                Get.toNamed(RouteHelper.screenNotInWorkUsers,arguments: [controllerGirisCixis.modelMuyConnectUsers.value.notInWorkUsers,controllerGirisCixis.localUserServices.getLoggedUser()]);
              },
              child: Stack(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.5),
                      shape: BoxShape.circle,

                    ),
                    child: const Center(child: Icon(Icons.person_off_outlined)),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: SizedBox(
                              width: 20,
                              child: Center(child: CustomText(labeltext: controllerGirisCixis.modelMuyConnectUsers.value.notInWorkUserCount.toString(),color: Colors.white,fontWeight: FontWeight.bold,fontsize: 12,)))))
                ],
              ),
            )):const SizedBox(),
        controllerGirisCixis.dataLoading.isFalse?Positioned(
            left: 5,
            top: 130,
            child: InkWell(
              onTap: (){
                final now = DateTime.now();
                var date1 = DateTime(now.year, now.month,now.day,00,01);
                var date2 = DateTime(now.year, now.month,now.day,23,59);
                String ilkTarix = intel.DateFormat('yyyy-MM-dd ss:mm').format(date1);
                intel.DateFormat('yyyy-MM-dd ss:mm').format(date2);
                List<UserRole> listRollar=[];
                for (var e in controllerGirisCixis.listTrackdata) {
                  listRollar.add(UserRole(code: e.userCode!,role: e.userPosition!));
                }
                Get.toNamed(RouteHelper.screenErrorsReport,arguments: [false,date1,date2,"","",listRollar]);

              },
              child: Stack(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26)

                    ),
                    child: const Center(child: Icon(Icons.crisis_alert_outlined,color: Colors.red,)),
                  ),
                  Positioned(
                      top: -0,
                      right: -0,
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: SizedBox(
                              width: 20,
                              child: Center(child: CustomText(labeltext: controllerGirisCixis.modelMuyConnectUsers.value.errorCount.toString(),color: Colors.white,fontWeight: FontWeight.bold,fontsize: 12,)))))
                ],
              ),
            )):const SizedBox(),

        Positioned(
            top: 20,
            left: 15,
            child: InkWell(
                onTap: () {
                  widget.drawerMenuController.keyScaff.currentState!
                      .openDrawer();
                },
                child: const Icon(Icons.menu))),
        controllerGirisCixis.searcAktive.isTrue?Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
                onTap: () {
                  controllerGirisCixis.searcAktive.value=false;
                  if(mounted){
                  setState(() {});}
                },
                child: const Icon(Icons.zoom_out_map))):const SizedBox()
      ],
    ));
  }

  void _onMapCreated(map.GoogleMapController controller) {
    _controllerMap.complete(controller);
    newgooglemapxontroller = controller;
    //_getCurrentLocation();
  }

  _widgetMarketInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10),
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
                      controllerGirisCixis.selectedModel.value.lastInoutAction!.customerName!,
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  labeltext: controllerGirisCixis
                      .selectedModel.value.lastInoutAction!.inDate!.toString().substring(0,10),
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
                      " ${controllerGirisCixis.selectedModel.value.currentLocation!.userFullName}  (${controllerGirisCixis.selectedModel.value.userCode!})"),
            ],
          ),
          controllerGirisCixis.selectedModel.value.lastInoutAction!.inDate==""?const SizedBox():_widgetInfoZiyaret()
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
         Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
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
                   controllerGirisCixis.selectedModel.value.lastInoutAction!.inDate==""?const SizedBox(): CustomText(
                       labeltext:
                       " ${controllerGirisCixis.selectedModel.value.lastInoutAction!.inDate.toString().substring(11,16)}"),
                 ],
               ),
               const SizedBox(
                 width: 20,
               ),
               Row(
                 children: [
                   const Icon(
                     Icons.social_distance,
                     size: 12,
                   ),
                   CustomText(
                       labeltext:
                       " ${controllerGirisCixis.selectedModel.value.lastInoutAction!.inDistance??""}"),
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
                   controllerGirisCixis.selectedModel.value.lastInoutAction!.outDate!.length>5
                       ? CustomText(
                       labeltext:
                       " ${controllerGirisCixis.selectedModel.value.lastInoutAction!.outDate.toString().substring(10,16)}")
                       : CustomText(labeltext: "cixisedilmeyib".tr),
                 ],
               ),
               const SizedBox(
                 width: 20,
               ),
               controllerGirisCixis.selectedModel.value.lastInoutAction!.outDate!.length>5
                   ? Row(
                 children: [
                   const Icon(
                     Icons.social_distance,
                     size: 12,
                   ),
                   CustomText(
                       labeltext:
                       " ${controllerGirisCixis.selectedModel.value.lastInoutAction!.outDistance??""}"),
                 ],
               )
                   : const SizedBox()
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
                         labeltext: "${"marketdeISvaxti".tr} : ",
                         fontsize: 14,
                         fontWeight: FontWeight.w600),
                     CustomText(
                         labeltext:
                         " ${controllerGirisCixis.selectedModel.value.lastInoutAction!.workTimeInCustomer}"),
                   ],
                 ),
               ],
             ),
         ],),
            userPermitionsHelper.canRemuveUserEnter(controllerGirisCixis.localUserServices.getLoggedUser().userModel!.permissions!)?
           Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CustomElevetedButton(
              height: 20,
                width: 25,
                textVisible: false,
                elevation: 5,
                hasshadow: true,
                textColor: Colors.red,
                icon: Icons.delete,
                surfaceColor: Colors.white,
                cllback: (){
                _showDialogGirisSil();
                }, label: ""),
          ):const SizedBox(),
        ],),

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
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: controllerGirisCixis.selectedModel.value.currentLocation!.screenState!=
                      "b"? Image.asset(controllerGirisCixis.selectedModel.value.currentLocation!.screenState==
                      "off"?"images/screenOff.png":"images/screenUnlock.png",fit: BoxFit.contain,
                    width: 30,height: 45,
                  ):const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        overflow: TextOverflow.ellipsis,
                        labeltext:
                        "${controllerGirisCixis.selectedModel.value.userCode!}-${controllerGirisCixis.selectedModel.value.currentLocation!.userFullName!}",
                        fontsize: 16,
                        maxline: 1,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("images/locaccuracy.png",width: 20,height: 20,fit: BoxFit.fill,),
                                          CustomText(
                                              fontsize: 12,
                                              color: Colors.black87,
                                              labeltext: "${controllerGirisCixis.selectedModel.value.currentLocation!.locAccuracy} m"),
                                        ],
                                      ),
                                      const SizedBox(width: 5,),
                                      Row(
                                        children: [
                                          Image.asset("images/batterystatus.png",width: 15,height: 12,fit: BoxFit.fill,),
                                          const SizedBox(width: 0,),
                                          CustomText(
                                              fontsize: 12,
                                              color: Colors.black87,
                                              labeltext: "${controllerGirisCixis.selectedModel.value.currentLocation!.batteryLevel} %"),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Row(
                                        children: [
                                          Image.asset("images/userspeed.png",width: 15,height: 12,fit: BoxFit.fill,),
                                          const SizedBox(width: 5,),
                                          CustomText(
                                              fontsize: 12,
                                              color: Colors.black87,
                                              labeltext: "${controllerGirisCixis.selectedModel.value.currentLocation!.speed} m/s"),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      controllerGirisCixis.selectedModel.value.currentLocation!.isMoving!?
                                      Container(
                                        height: 15,
                                        padding: const EdgeInsets.only(left: 5,right: 5),
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:BorderRadius.all( Radius.circular(5))
                                        ),
                                        child: CustomText(labeltext: "hereketdedir".tr),
                                      ):Container(
                                        height: 15,
                                        padding: const EdgeInsets.only(left: 5,right: 5),
                                        decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:BorderRadius.all( Radius.circular(5))
                                        ),
                                        child: CustomText(labeltext: "stabildir".tr,),)
                                    ],
                                  ),
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: const EdgeInsets.all(5),
                                        child: controllerGirisCixis.selectedModel.value.lastInoutAction!.outDate!.length>5?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                              decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:BorderRadius.all( Radius.circular(5))
                                              ),
                                              child: CustomText(labeltext: "${"cixisEdilib".tr} : ${controllerGirisCixis.selectedModel.value.lastInoutAction!.outDate.toString().substring(11,16)}",),
                                            ),
                                            const SizedBox(width: 20,),
                                          ],
                                        ):Container(
                                          padding: const EdgeInsets.only(left: 0,right: 5,top: 2,bottom: 2),
                                          decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:BorderRadius.all( Radius.circular(5))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0).copyWith(left: 5),
                                            child: CustomText(labeltext: "${"marketdedir".tr} : ${controllerGirisCixis.selectedModel.value.currentLocation!.inputCustomerDistance!} m",),
                                          ),),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           Padding(
             padding: const EdgeInsets.only(right: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 CustomElevetedButton(
                     icon: Icons.visibility,
                     textColor: Colors.green,
                     borderColor: Colors.green,
                     height: 20,
                     width: 110,
                     cllback: (){
                       getGunlukHesabat();
                     }, label: "todeyRut".tr),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap:(){
                        openWhatsAppChat(phone: controllerGirisCixis.selectedModel.value.phoneNumber!.toString());
                      },

                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset("images/whatsapp.png"),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        launchPhoneDialer(phone: controllerGirisCixis.selectedModel.value.phoneNumber!.toString());
                      },
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset("images/mobilecall.png"),
                      ),
                    ) ,
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        createRoutBetweenTwoPoints(controllerGirisCixis
                            .selectedModel.value.currentLocation!);
                      },
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset("images/directionmap.png"),
                      ),
                    )
                  ],
                           ),
               ],
             ),
           ),
          const SizedBox(
            height: 5,
          ),
          userHesabatlarMustVisible&&controllerGirisCixis.selectedModel.value.lastInoutAction==null?const SizedBox():Column(
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
                height: 1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      labeltext:
                      controllerGirisCixis.selectedModel.value.lastInoutAction!.customerName!,
                      fontsize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      labeltext: controllerGirisCixis
                          .selectedModel.value.lastInoutAction!.customerCode!,
                      fontsize: 12,
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          userHesabatlarMustVisible&&controllerGirisCixis.selectedModel.value.lastInoutAction!.inDate==""?const SizedBox():_widgetInfoZiyaret(),
        ],
      ),
    );
  }

  void getGunlukHesabat() {
    DateTime now = DateTime.now();
    final String formattedDate = intel.DateFormat('yyyy-MM-dd').format(now);
    String starDate = "$formattedDate 00:01";
    String endDate = "$formattedDate 23:59";
    Get.toNamed(RouteHelper.screenLiveTrackReport, arguments: [
      controllerGirisCixis.selectedModel.value.userPosition,
      controllerGirisCixis.selectedModel.value.userCode,
      starDate,
      endDate
    ]);
  }
  Future<void> createRoutBetweenTwoPoints(CurrentLocation modelCariler) async {
    Coords cordEnd = Coords(double.parse(modelCariler.latitude.toString()),
        double.parse(modelCariler.longitude.toString()));
    try {
      await MapLauncher.showMarker(mapType: controllerGirisCixis.availableMap.value.mapType,
          coords: cordEnd,
          title: modelCariler.userFullName!);
    } catch (exp) {
      Get.dialog(ShowInfoDialog(
        messaje: "Secmis oldugunuz ${controllerGirisCixis.availableMap.value.mapType.name} hal hazirda cavab vermir.Basqa programla evez edin!",
        icon: Icons.info_outlined,
        callback: (va) {
          if (va) {
            openMapSettingScreen();
          }
        },
      ));
    }
  }

  Future<void> openMapSettingScreen() async {
    controllerGirisCixis.availableMap = await Get.toNamed(RouteHelper.mobileMapSettingMobile);
    if(mounted) {
      setState(() {});
    }}


  Future<void> launchPhoneDialer({required String phone}) async {
    String formattedPhone = phone.replaceAll(RegExp(r'[^+\d]'), '');  // Yalnız '+' və rəqəmlər qalır
    Get.dialog(ShowSualDialog(messaje: "$formattedPhone nomresine zeng etmeye eminsiniz?", callBack: (v) async {
      if(v){
        Get.back();
        bool? res = await FlutterPhoneDirectCaller.callNumber(formattedPhone);
        if (res == null || !res) {
          throw 'Could not launch phone dialer.';
        }
      }
    }));
  }

  // openWhatsAppChat({required String phone}) async {
  //   String formattedPhone = phone.replaceAll(RegExp(r'[^+\d]'), '');
  //   var whatsappAndroid =Uri.parse("whatsapp://send?phone=$formattedPhone&text=hello");
  //   if (await canLaunchUrl(whatsappAndroid)) {
  //     await launchUrl(whatsappAndroid);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("WhatsApp is not installed on the device"),
  //       ),
  //     );
  //   }
  // }

  Future<void> openWhatsAppChat({required String phone}) async {
    String formattedPhone = phone.replaceAll(RegExp(r'[^+\d]'), '');

    final whatsappUrl = 'https://wa.me/$formattedPhone';  // WhatsApp üçün
    final businessUrl = 'whatsapp-business://send?phone=$formattedPhone';  // WhatsApp Business üçün

    var whatsappUrlUri = Uri.parse(whatsappUrl);
    var bizneswhatsappUrlUri = Uri.parse(businessUrl);

    try {
      // WhatsApp URL-ni açmağa çalışırıq
      bool canLaunchWhatsapp = await canLaunchUrl(whatsappUrlUri);
      if (canLaunchWhatsapp) {
        await launchUrl(whatsappUrlUri);
      } else {
        // WhatsApp Business URL-ni açmağa çalışırıq
        bool canLaunchBusiness = await canLaunchUrl(bizneswhatsappUrlUri);
        if (canLaunchBusiness) {
          await launchUrl(bizneswhatsappUrlUri);
        } else {
          // Heç bir tətbiq tapılmadığı halda istifadəçiyə xəbər veririk
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("WhatsApp və ya WhatsApp Business tətbiqi cihazda tapılmadı"),
            ),
          );
        }
      }
    } catch (e) {
      // Xəta baş verərsə istifadəçiyə xəbər veririk
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bir xəta baş verdi, xahiş edirik yenidən cəhd edin."),
        ),
      );
    }
  }


  _hesabatHisseMartker(BuildContext context) {
    return controllerGirisCixis.selectedModel.value.lastInoutAction!= null
        ? Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WidgetCarihesabatlar(
                    loggedUser: controllerGirisCixis.localUserServices.getLoggedUser(),
                    height: 100,
                    ckod: controllerGirisCixis.selectedModel.value.lastInoutAction!.customerCode!,
                    cad: controllerGirisCixis.selectedModel.value.lastInoutAction!.customerName!,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  _hesabatHisseUser(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            WidgetRuthesabatlar(
              listP: controllerGirisCixis.localUserServices.getLoggedUser().userModel!.permissions!.where((e)=>e.category==3).toList(),
              roleId: controllerGirisCixis.selectedModel.value.userPosition.toString(),height: 100,temsilciKodu: controllerGirisCixis.selectedModel.value.userCode!, onClick: () async {
              await Future.delayed(const Duration(milliseconds: 100));
            },),
          ],
        ),
      ),
    );
  }


  Widget searchUsers(BuildContext context){
   return  SearchLiveUsers(
     controllerLive: controllerGirisCixis,
     callBackGunluk: (v){
       controllerGirisCixis.timer!.cancel();
     },
     callBack: (element){
     if(element.userCode!=null){
       controllerGirisCixis.createMarkerCirculeAndPolyline(element);
       controllerGirisCixis.searcAktive.value=false;
       controllerGirisCixis.selectedModel.value=element;
       controllerGirisCixis.userMarkerSelected.value=true;
       map.CameraPosition cameraPosition = map.CameraPosition(target: map.LatLng(double.parse(element.currentLocation!.latitude!),double.parse(element.currentLocation!.longitude!)), zoom: 18,
       );
       if( controllerGirisCixis.selectedModel.value.lastInoutAction==null){
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
   },
   );
  }

  void _showDialogGirisSil() {
    Get.dialog(ShowSualDialog(messaje: "Girisi silmeye eminsiniz?", callBack: (v){
      if(v){
        controllerGirisCixis.girisiSil(controllerGirisCixis.selectedModel.value);
      }

    }));
  }
}
