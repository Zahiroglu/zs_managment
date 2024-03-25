import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zs_managment/companents/live_track/model/model_live_track.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;

class ControllerLiveTrack extends GetxController{
  RxList<ModelLiveTrack> listTrackdata = List<ModelLiveTrack>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  RxSet<map.Marker> markers = RxSet<map.Marker>();
  Rx<ModelLiveTrack> selectedModel=ModelLiveTrack().obs;
  Rx<ActionTrack> selectedModelAction=ActionTrack().obs;
  RxList<map.Polyline> polylines = List<map.Polyline>.empty(growable: true).obs;
  Rx<map.LatLng> initialPosition =  const map.LatLng(0, 0).obs;
  RxSet<map.Circle> circles = RxSet();
  RxBool userMarkerSelected=false.obs;
  Rx<SnappingSheetController> snappingSheetController = SnappingSheetController().obs;

  @override
  void onInit() {
    getAllDatFromServer();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getAllDatFromServer()async{
   await  Future.delayed(Duration(seconds: 2));
    listTrackdata.add(ModelLiveTrack(userCode: "A1",
        userName: "Selimov Samir",
        roleId: 23,
        roleName: "Mercendaizer",
        modelCariTrack: ModelCariTrack(
          marketCode: "23154",
          marketName: "Bazarstore Xirdalan",
          marketLat: "40.121215",
          marketLng: "49.454512",
          cixisEdilib: true,
          marketdeQalmaVaxti: "30 deq",
          rutGunu: "0",
        ),
        actionTrackIn: ActionTrack(
          date: "2024.03.21",
          distance: "20 m",
          lat: "40.126345",
          long: "49.484652",
          time: "12:21"
        ),
        actionTrackOut: ActionTrack(
          date: "2024.03.21",
          distance: "22 m",
          lat: "40.126375",
          long: "49.458662",
          time: "12:51"
        ),
        userCurrentPosition: UserCurrentPosition(
          isOnline: false,
          lat: "40.121575",
          lng:"49.4149672",
          lastDate:  "2024.03.21",
          lastTime: "12:59",
          speed: "5"
        )));
    listTrackdata.add(ModelLiveTrack(userCode: "A3",
        userName: "Hikmet Memmedov",
        roleId: 23,
        roleName: "Mercendaizer",
        modelCariTrack: ModelCariTrack(
          marketCode: "23182",
          marketName: "AFF Bizim Xirdalan",
          marketLat: "40.521215",
          marketLng: "49.614512",
          cixisEdilib: true,
          rutGunu: "1",
          marketdeQalmaVaxti: "30 deq",
        ),
        actionTrackIn: ActionTrack(
          date: "2024.03.21",
          distance: "20 m",
          lat: "40.581215",
          long: "49.664512",
          time: "12:21"
        ),
        actionTrackOut: ActionTrack(
          date: "2024.03.21",
          distance: "22 m",
          lat: "40.541215",
          long: "49.614512",
          time: "12:51"
        ),
        userCurrentPosition: UserCurrentPosition(
          isOnline: false,
          lat: "40.351215",
          lng:"49.67452",
          lastDate:  "2024.03.21",
          lastTime: "12:45",
          speed: "12"
        )));
    listTrackdata.add(ModelLiveTrack(userCode: "A2",
        userName: "Kamil Memmedov",
        roleId: 23,
        roleName: "Mercendaizer",
        modelCariTrack: ModelCariTrack(
          marketCode: "231505",
          marketName: "Bolmart m-t Xirdalan",
          marketLat: "40.125515",
          marketLng: "49.457212",
          cixisEdilib: false,
          rutGunu:"0",
          marketdeQalmaVaxti: "30 deq",
        ),
        actionTrackIn: ActionTrack(
          date: "2024.03.21",
          distance: "40 m",
          lat: "40.129615",
          long: "49.458217",
          time: "10:21"
        ),
        actionTrackOut: ActionTrack(),
        userCurrentPosition: UserCurrentPosition(
          isOnline: true,
          lat: "40.129615",
          lng:"49.467312",
          lastDate:  "2024.03.21",
          lastTime: "10:24",
          speed: "0"
        )));
    listTrackdata.add(ModelLiveTrack(userCode: "A5",
        userName: "Nurane Tagiyeva",
        roleId: 23,
        roleName: "Mercendaizer",
        modelCariTrack: ModelCariTrack(),
        actionTrackIn: ActionTrack(),
        actionTrackOut: ActionTrack(),
        userCurrentPosition: UserCurrentPosition(
          isOnline: true,
          lat: "40.159615",
          lng:"49.127312",
          lastDate:  "2024.03.21",
          lastTime: "13:24",
          speed: "0"
        )));
   await  Future.delayed(const Duration(seconds: 2));
   fillMarkersByListTrack(listTrackdata.value);
   dataLoading.value=false;
   update();
  }

  Future<void> fillMarkersByListTrack(List<ModelLiveTrack> listTrack) async {
    polylines.clear();
    circles.clear();
    for (var element in listTrack) {
      //markerin markerini yaratmaq
      if(element.modelCariTrack!.marketName!=null) {
        markers.add(map.Marker(
            markerId: map.MarkerId("${element.modelCariTrack!.marketCode}-${element.userCode}"),
            onTap: () {
              selectedModel.value = element;
              _onMarketMarkerClick(element);
            },
            icon: await getClusterBitmapMarket(140, element.modelCariTrack!.marketName.toString(), element.modelCariTrack!.cixisEdilib!),
            position: map.LatLng(double.parse(element.modelCariTrack!.marketLat!), double.parse(element.modelCariTrack!.marketLng!))));
        createCircles(element.modelCariTrack!.marketLng!,
            element.modelCariTrack!.marketLat!,
            element.modelCariTrack!.marketCode!,
            element.modelCariTrack!.cixisEdilib);
        markers.add(map.Marker(
            markerId: map.MarkerId(
                "${element.userCode}-${element.userCurrentPosition!.lastTime}"),
            onTap: () {
              onPositionMarkerClick(element.actionTrackIn, element);
            },
            icon: await getClusterBitmapMenimYerim(100, element.userCurrentPosition!.isOnline, element.userName!),
            position: map.LatLng(double.parse(element.userCurrentPosition!.lat),
                double.parse(element.userCurrentPosition!.lng))));
        addPolyLineForEnter(true,
            listTrack.indexOf(element).toString(),
            element.modelCariTrack!.marketLat!,
            element.modelCariTrack!.marketLng!,
            element.userCurrentPosition!.lat, element.userCurrentPosition!.lng);
      }else{
        markers.add(map.Marker(
            markerId: map.MarkerId("${element.userCode}-${element.userCurrentPosition!.lastTime}"),
            onTap: () {
              onPositionMarkerClick(element.actionTrackIn, element);
            },
            icon: await getClusterBitmapMenimYerim(100, element.userCurrentPosition!.isOnline, element.userName!),
            position: map.LatLng(double.parse(element.userCurrentPosition!.lat), double.parse(element.userCurrentPosition!.lng))));
      } }
  }

  createCircles(String longitude, String latitude, String ckod, bool? cixisEdilib) {
    circles.value.add(map.Circle(
        circleId: map.CircleId(ckod),
        center: map.LatLng(double.parse(latitude), double.parse(longitude)),
        radius: 100,
        fillColor: cixisEdilib!?Colors.grey.withOpacity(0.5):Colors.yellow.withOpacity(0.5),
        strokeColor: cixisEdilib?Colors.white:Colors.black,
        strokeWidth: 1));
  }

  void addPolyLineForEnter(bool isIn,String id,String marketLat, String marketLng,String enterLat, String enterLng,) {
    map.Polyline poly=map.Polyline(polylineId: map.PolylineId(id),
      color: Colors.green,
      endCap: map.Cap.roundCap,
      width: 1,
      points: [map.LatLng(double.parse(marketLat), double.parse(marketLng)),map.LatLng(double.parse(enterLat), double.parse(enterLng))],
    );
    polylines.add(poly);
    update();
  }


  Future<map.BitmapDescriptor> getClusterBitmapMarket(int size,String marketAdi,bool isExited) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.home;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7, fontFamily: icon.fontFamily, color:isExited?Colors.black26:Colors.blueAccent));
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

  Future<map.BitmapDescriptor> getClusterBitmapMenimYerim(int size,bool isOnline, String username) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.man;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7, fontFamily: icon.fontFamily, color:isOnline?Colors.green:Colors.red));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: username,
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

  void _onMarketMarkerClick(ModelLiveTrack model) {
    userMarkerSelected.value=false;
    snappingSheetController.value.snapToPosition(const SnappingPosition.pixels(positionPixels: 80));
    selectedModel.value=model;
    update();
  }

  void onPositionMarkerClick(ActionTrack? actionTrackIn, ModelLiveTrack model) {
    userMarkerSelected.value=true;
    snappingSheetController.value.snapToPosition(const SnappingPosition.pixels(positionPixels: 110));
    selectedModel.value=model;
    update();
  }
}