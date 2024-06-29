import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zs_managment/companents/live_track/model/model_live_track.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import '../../../dio_config/api_client.dart';
import '../../../helpers/exeption_handler.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/logged_usermodel.dart';
import '../model/model_my_connecteduserslocations.dart';

class ControllerLiveTrack extends GetxController{
  RxList<ModelLiveTrack> listTrackdata = List<ModelLiveTrack>.empty(growable: true).obs;
  Rx<MyConnectedUsersCurrentLocation> modelMuyConnectUsers=MyConnectedUsersCurrentLocation().obs;
  RxList<UserModel> listAllConnectedUsers = List<UserModel>.empty(growable: true).obs;
  RxList<UserModel> listIslemeyenUsers = List<UserModel>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  RxSet<map.Marker> markers = RxSet<map.Marker>();
  Rx<ModelLiveTrack> selectedModel=ModelLiveTrack().obs;
  Rx<LastInoutAction> selectedModelAction=LastInoutAction().obs;
  RxList<map.Polyline> polylines = List<map.Polyline>.empty(growable: true).obs;
  Rx<map.LatLng> initialPosition =  const map.LatLng(0, 0).obs;
  RxSet<map.Circle> circles = RxSet();
  RxBool userMarkerSelected=false.obs;
  Rx<SnappingSheetController> snappingSheetController = SnappingSheetController().obs;
  ExeptionHandler exeptionHandler=ExeptionHandler();
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  RxString sonYenilenme="".obs;
  LocalBaseDownloads localBaseDownloads=LocalBaseDownloads();
  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void _startTimerPeriodic(int millisec) {
    timer=Timer.periodic(Duration(seconds: millisec), (Timer timer) async {
      await getAllDatFromServer();
      if (millisec == 0) {
       print( "yenilenme basladi");
        timer.cancel();
        _startTimerPeriodic(59);
      }
    });
    update();
  }

  @override
  void onInit() {
    _startTimerPeriodic(59);
    listAllConnectedUsers.value=localBaseDownloads.getAllConnectedUserFromLocal();
    getAllDatFromServer();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getAllDatFromServer()async{
   dataLoading.value=true;
   listTrackdata.clear();
   listTrackdata.value=await getAllDataFromServer();
   fillMarkersByListTrack(listTrackdata.value);
   dataLoading.value=false;
   update();
  }

  Future<void> fillMarkersByListTrack(List<ModelLiveTrack> listTrack) async {
    polylines.clear();
    circles.clear();
    markers.clear();
    for (var element in listTrack) {
      //markerin markerini yaratmaq
      if(element.lastInoutAction!=null) {
        markers.add(map.Marker(
            markerId: map.MarkerId("${element.lastInoutAction!.customerCode}-${element.userCode}"),
            onTap: () {
              selectedModel.value = element;
              _onMarketMarkerClick(element);
            },
            icon: await getClusterBitmapMarket(140, element.lastInoutAction!.customerName.toString(), element.lastInoutAction!.outDate==null),
            position: map.LatLng(double.parse(element.lastInoutAction!.customerLongitude!), double.parse(element.lastInoutAction!.customerLatitude!))));
        createCircles(element.lastInoutAction!.customerLatitude!,
            element.lastInoutAction!.customerLongitude!,
            element.lastInoutAction!.customerCode!,
            element.lastInoutAction!.outDate==null);
        markers.add(map.Marker(
            markerId: map.MarkerId(
                "${element.userCode}-${element.currentLocation!.locationDate}"),
            onTap: () {
              onPositionMarkerClick(element.lastInoutAction, element);
            },
            icon: await getClusterBitmapMenimYerim(100, element.currentLocation!.isOnline!, element.currentLocation!.userFullName!),
            position: map.LatLng(double.parse(element.currentLocation!.latitude!),
                double.parse(element.currentLocation!.longitude!))));
        addPolyLineForEnter(true,
            listTrack.indexOf(element).toString(),
            element.lastInoutAction!.customerLongitude!,
            element.lastInoutAction!.customerLatitude!,
            element.currentLocation!.latitude!, element.currentLocation!.longitude!);
      }else{
        markers.add(map.Marker(
            markerId: map.MarkerId("${element.userCode}-${element.currentLocation!.locationDate}"),
            onTap: () {
              onPositionMarkerClick(element.lastInoutAction, element);
            },
            icon: await getClusterBitmapMenimYerim(100, element.currentLocation!.isOnline!, element.currentLocation!.userFullName!),
            position: map.LatLng(double.parse(element.currentLocation!.latitude!), double.parse(element.currentLocation!.longitude!))));
      } }
  }

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

  void onPositionMarkerClick(LastInoutAction? actionTrackIn, ModelLiveTrack model) {
    userMarkerSelected.value=true;
    snappingSheetController.value.snapToPosition(const SnappingPosition.pixels(positionPixels: 110));
    selectedModel.value=model;
    update();
  }

  Future<List<ModelLiveTrack>> getAllDataFromServer() async {
    List<ModelLiveTrack> listTrack = [];
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler = [];
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(isLiveTrack: true).get(
          "${loggedUserModel.baseUrl}/api/v1/InputOutput/my-connected-users-current-location",
          data: jsonEncode(secilmisTemsilciler),
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'abs': '123456',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        if (response.statusCode == 200) {
          var dataModel = json.encode(response.data['result']);
            modelMuyConnectUsers.value = MyConnectedUsersCurrentLocation.fromJson(jsonDecode(dataModel));
            sonYenilenme.value = DateTime.now().toIso8601String();
            for (var element in modelMuyConnectUsers.value.userLocation!) {
              listTrack.add(element);
            }
         // listTrack=modelMuyConnectUsers.value.userLocation!;

        }
      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
        }
      }
    }
    return listTrack;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

}