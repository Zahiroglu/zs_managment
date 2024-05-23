import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zs_managment/companents/hesabatlar/user_hesabatlar/liveTrack/model_live_track_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'dart:ui' as ui;

import 'package:zs_managment/companents/hesabatlar/user_hesabatlar/liveTrack/screen_livetrack_report.dart';

class ControllerLiveTrackReport extends GetxController{
  RxList<MyConnectedUsersCurrentLocationReport> listTrackdata = List<MyConnectedUsersCurrentLocationReport>.empty(growable: true).obs;
  RxList<map.Polyline> polylines = List<map.Polyline>.empty(growable: true).obs;
  Rx<map.LatLng> initialPosition =  const map.LatLng(0, 0).obs;
  RxSet<map.Circle> circles = RxSet();
  RxSet<map.Marker> markers = RxSet<map.Marker>();
  Rx<bool> dataIsLoading=false.obs;
  Rx<MyConnectedUsersCurrentLocationReport> selectedModel=MyConnectedUsersCurrentLocationReport().obs;
  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getAllGirisCixis(List<MyConnectedUsersCurrentLocationReport> listGirisCixis) {
    dataIsLoading.value=true;
    listTrackdata.value=listGirisCixis;
    fillMarkersByListTrack(listTrackdata.value);
    drawPolyLines(listTrackdata);
    dataIsLoading.value=false;
  }


  Future<void> fillMarkersByListTrack(List<MyConnectedUsersCurrentLocationReport> listTrack) async {
    polylines.clear();
    circles.clear();
    markers.clear();
    initialPosition.value=map.LatLng(double.parse(listTrack[0].latitude!), double.parse(listTrack[0].longitude!));
    for (var element in listTrack) {
        markers.add(map.Marker(
            markerId: map.MarkerId("${element.userCode}-${element.locationDate}"+"-"+element.latitude!),
            onTap: () {onPositionPointClick(element,element.type==0);
              customInfoWindowController.addInfoWindow!(widgetCustomInfo(element),map.LatLng(double.parse(element.latitude!),
                  double.parse(element.longitude!)));
            },
            icon: await getClusterBitmapPoint(60,element),
            position: map.LatLng(double.parse(element.latitude!),
                double.parse(element.longitude!))));
    }}

  createCircles(String longitude, String latitudeitude, String ckod, bool? cixisEdilib) {
    circles.add(map.Circle(
        circleId: map.CircleId(ckod),
        center: map.LatLng(double.parse(latitudeitude), double.parse(longitude)),
        radius: 100,
        fillColor: cixisEdilib!?Colors.grey.withOpacity(0.5):Colors.yellow.withOpacity(0.5),
        strokeColor: cixisEdilib?Colors.white:Colors.black,
        strokeWidth: 1));
  }

  void addPolyLineForEnter(bool isIn,String id,String customerLatitude, String customerLongitude,String enterLat, String enterLng,) {
    map.Polyline poly=map.Polyline(polylineId: map.PolylineId(id),
      color: Colors.green,
      endCap: map.Cap.roundCap,
      width: 1,
      points: [map.LatLng(double.parse(customerLatitude), double.parse(customerLongitude)),map.LatLng(double.parse(enterLat), double.parse(enterLng))],
    );
    polylines.add(poly);
    update();
  }


  Future<map.BitmapDescriptor> getClusterBitmapPoint(int size, MyConnectedUsersCurrentLocationReport element) async {
    Color color=Colors.blueAccent;
    switch(element.type){
      case 1:
        color=Colors.red;
        break;
      case 2:
        color=Colors.green;
        break;
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.flag_circle;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7, fontFamily: icon.fontFamily, color:color));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<map.BitmapDescriptor> getClusterBitmapARROW(int size) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.arrow_forward;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7, fontFamily: icon.fontFamily, color:Colors.red));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  
  void drawPolyLines(List<MyConnectedUsersCurrentLocationReport> listTrack) async {
    try {
      map.PolylineId id = map.PolylineId(DateTime.now().microsecond.toString());
        for (int j = 0; j < listTrack.length; j++) {
              if(j<=listTrack.length-1){
          final map.Polyline polyline = map.Polyline(
            polylineId: map.PolylineId(listTrack[j].locationDate!),
            width: 2,
            color: Colors.blue,
            startCap: map.Cap.roundCap,
           endCap: map.Cap.squareCap,
           // endCap: map.Cap.customCapFromBitmap(await getClusterBitmapARROW(100)),
            points:[map.LatLng(double.parse(listTrack[j].latitude!),double.parse(listTrack[j].longitude!)),
              map.LatLng(double.parse(listTrack[j+1].latitude!),double.parse(listTrack[j+1].longitude!)),
            ],
          );
          polylines.value.add(polyline);
          update();
        }}
        update();
    } catch (e) {
      rethrow;
    }
  }


  Future<void> onPositionPointClick(MyConnectedUsersCurrentLocationReport element,bool mustShowMarket) async {
    markers.removeWhere((marker) => marker.markerId == const map.MarkerId("m1"));
    polylines.removeWhere((poly) => poly.polylineId==const map.PolylineId("id1"));
    if(!mustShowMarket){
      markers.add(
          map.Marker(
          markerId: const map.MarkerId("m1"),
          onTap: () {
            onPositionMarkerClick(element);
          },
          icon: await getClusterBitmapMarket(100,element.inOutCustomer!.customerName.toString(),element.inOutCustomer!.outDate!=null),
          position: map.LatLng(double.parse(element.inOutCustomer!.customerLongitude!), double.parse(element.inOutCustomer!.customerLatitude!))));
      createPolylines(element);
    }
    selectedModel.value=element;
    update();
  }

  Future<void> onPositionMarkerClick(MyConnectedUsersCurrentLocationReport element) async {
    update();
  }

  Future<map.BitmapDescriptor> getClusterBitmapMarket(int size,String marketAdi,bool isExited) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.home;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: size * 0.7, fontFamily: icon.fontFamily, color:Colors.blueAccent));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: marketAdi,
      style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: size / 10,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset((size - painter.width) * 0.7, size / 6),
    );
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void createPolylines(MyConnectedUsersCurrentLocationReport listTrack){
    final map.Polyline polyline = map.Polyline(
      polylineId: const map.PolylineId("id1"),
      width: 3,
      color: Colors.red,
      startCap: map.Cap.buttCap,
      endCap: map.Cap.buttCap,
      patterns: const [
        map.PatternItem.dot
      ],
      // endCap: map.Cap.customCapFromBitmap(await getClusterBitmapARROW(100)),
      points: [map.LatLng(double.parse(listTrack.latitude!),double.parse(listTrack.longitude!)),
        map.LatLng(double.parse(listTrack.inOutCustomer!.customerLongitude!),double.parse(listTrack.inOutCustomer!.customerLatitude!)),
      ],
    );
    polylines.value.add(polyline);
  }

  Widget widgetCustomInfo(MyConnectedUsersCurrentLocationReport element) {
    return WidgetInfoWindow(controllerGirisCixis: this,element: element,width: Get.width*0.6,height: 150,);
  }


}
