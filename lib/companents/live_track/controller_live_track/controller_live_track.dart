import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zs_managment/companents/live_track/model/model_live_track.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import '../../../dio_config/api_client.dart';
import '../../../global_models/custom_enummaptype.dart';
import '../../../global_models/model_appsetting.dart';
import '../../../global_models/model_maptypeapp.dart';
import '../../../helpers/exeption_handler.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../local_bazalar/local_app_setting.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/logged_usermodel.dart';
import '../model/model_my_connecteduserslocations.dart';

class ControllerLiveTrack extends GetxController {
  RxList<ModelLiveTrack> listTrackdata =
      List<ModelLiveTrack>.empty(growable: true).obs;
  Rx<MyConnectedUsersCurrentLocation> modelMuyConnectUsers =
      MyConnectedUsersCurrentLocation().obs;
  RxList<UserModel> listAllConnectedUsers =
      List<UserModel>.empty(growable: true).obs;
  RxList<UserModel> listIslemeyenUsers =
      List<UserModel>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  RxSet<map.Marker> markers = RxSet<map.Marker>();
  Rx<ModelLiveTrack> selectedModel = ModelLiveTrack().obs;
  Rx<LastInoutAction> selectedModelAction = LastInoutAction().obs;
  RxList<map.Polyline> polylines = List<map.Polyline>.empty(growable: true).obs;
  Rx<map.LatLng> initialPosition = const map.LatLng(0, 0).obs;
  RxSet<map.Circle> circles = RxSet();
  RxBool userMarkerSelected = false.obs;
  RxBool searcAktive = true.obs;
  Rx<SnappingSheetController> snappingSheetController =
      SnappingSheetController().obs;
  ExeptionHandler exeptionHandler = ExeptionHandler();
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices localUserServices = LocalUserServices();
  RxString sonYenilenme = "".obs;
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  LocalAppSetting appSetting = LocalAppSetting();
  late Rx<AvailableMap> availableMap = AvailableMap(
          mapName: CustomMapType.google.name,
          mapType: MapType.google,
          icon:
              'packages/map_launcher/assets/icons/${CustomMapType.google}.svg')
      .obs;
  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void _startTimerPeriodic(int millisec) {
    timer = Timer.periodic(Duration(seconds: millisec), (Timer timer) async {
      await getAllDatFromServer();
      if (millisec == 0) {
        print("yenilenme basladi");
        timer.cancel();
        _startTimerPeriodic(59);
      }
    });
    update();
  }

  @override
  Future<void> onInit() async {
    _startTimerPeriodic(59);
    listAllConnectedUsers.value =
        localBaseDownloads.getAllConnectedUserFromLocal();
    await appSetting.init();
    await localUserServices.init();
    ModelAppSetting modelSetting = await appSetting.getAvaibleMap();
    if (modelSetting.mapsetting != null) {
      ModelMapApp modelMapApp = modelSetting.mapsetting!;
      CustomMapType? customMapType = modelMapApp.mapType;
      MapType mapType = MapType.values[customMapType!.index];
      if (modelMapApp.name != "null") {
        availableMap.value = AvailableMap(
            mapName: modelMapApp.name!,
            mapType: mapType,
            icon: modelMapApp.icon!);
      }
    }
    getAllDatFromServer();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getAllDatFromServer() async {
    dataLoading.value = true;
    await getAllDataFromServer();
    dataLoading.value = false;
    update();
  }

  Future<void> fillMarkersByListTrack(List<ModelLiveTrack> listTrack) async {
    polylines.clear();
    circles.clear();
    for (var element in listTrack) {
      if (element.lastInoutAction != null) {
        if (element.lastInoutAction!.outDate == ""&&element.lastInoutAction!.customerLongitude!="") {
          String marketMarkerId="${element.lastInoutAction!.customerCode}-${element.lastInoutAction!.inDate}";
           markers.removeWhere((e)=>e.markerId.value==marketMarkerId);
            markers.add(map.Marker(
              markerId: map.MarkerId(marketMarkerId),
              onTap: () {
                selectedModel.value = element;
                _onMarketMarkerClick(element);
              },
              icon: await getClusterBitmapMarket(
                  120,
                  element.lastInoutAction!.customerName.toString(),
                  element.lastInoutAction!.outDate == null),
              position: map.LatLng(
                  double.parse(element.lastInoutAction!.customerLongitude!),
                  double.parse(element.lastInoutAction!.customerLatitude!))));
          createCircles(
              element.lastInoutAction!.customerLatitude!,
              element.lastInoutAction!.customerLongitude!,
              element.lastInoutAction!.customerCode!,
              element.lastInoutAction!.outDate == null);
          addPolyLineForEnter(
              true,
              listTrack.indexOf(element).toString(),
              element.lastInoutAction!.customerLongitude!,
              element.lastInoutAction!.customerLatitude!,
              element.currentLocation!.latitude!,
              element.currentLocation!.longitude!);
        }
        String userMarkerId="${element.userCode}-${element.userPosition}";
        markers.removeWhere((e)=>e.markerId.value==userMarkerId);
        markers.add(map.Marker(
            markerId: map.MarkerId(userMarkerId),
            onTap: () {
              onPositionMarkerClick(element.lastInoutAction, element);
            },
            icon: await getClusterBitmapMenimYerim( 120,
                element.currentLocation!.isOnline!,
                element.currentLocation!.userFullName!),
            position: map.LatLng(
                double.parse(element.currentLocation!.latitude!),
                double.parse(element.currentLocation!.longitude!))));
        update();
      }
        String userMarkerId="${element.userCode}-${element.userPosition}";
        markers.removeWhere((e)=>e.markerId.value==userMarkerId);
        markers.add(map.Marker(
            markerId: map.MarkerId(userMarkerId),
            onTap: () {
              onPositionMarkerClick(element.lastInoutAction, element);
            },
            icon: await getClusterBitmapMenimYerim(
                120,
                element.currentLocation!.isOnline!,
                element.currentLocation!.userFullName!),
            position: map.LatLng(
                double.parse(element.currentLocation!.latitude!),
                double.parse(element.currentLocation!.longitude!))));
        update();

    }
    update();
  }

  createCircles(
      String longitude, String latitudeitude, String ckod, bool? cixisEdilib) {
    circles.add(map.Circle(
        circleId: map.CircleId(ckod),
        center:
            map.LatLng(double.parse(latitudeitude), double.parse(longitude)),
        radius: 100,
        fillColor: cixisEdilib!
            ? Colors.grey.withOpacity(0.5)
            : Colors.yellow.withOpacity(0.5),
        strokeColor: cixisEdilib ? Colors.white : Colors.black,
        strokeWidth: 1));
  }

  void addPolyLineForEnter(
    bool isIn,
    String id,
    String customerLatitude,
    String customerLongitude,
    String enterLat,
    String enterLng,
  ) {
    map.Polyline poly = map.Polyline(
      polylineId: map.PolylineId(id),
      color: Colors.green,
      endCap: map.Cap.roundCap,
      width: 1,
      points: [
        map.LatLng(
            double.parse(customerLatitude), double.parse(customerLongitude)),
        map.LatLng(double.parse(enterLat), double.parse(enterLng))
      ],
    );
    polylines.add(poly);
    update();
  }

  Future<map.BitmapDescriptor> getClusterBitmapMarket(
      int size, String marketAdi, bool isExited) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.home;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7,
            fontFamily: icon.fontFamily,
            color: isExited ? Colors.black26 : Colors.blueAccent));
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

  Future<map.BitmapDescriptor> getClusterBitmapMenimYerim(
      int size, bool isOnline, String username) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var icon = Icons.man;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size * 0.7,
            fontFamily: icon.fontFamily,
            color: isOnline ? Colors.green : Colors.red));
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
    userMarkerSelected.value = false;
    snappingSheetController.value
        .snapToPosition(const SnappingPosition.pixels(positionPixels: 80));
    selectedModel.value = model;
    update();
  }

  Future<void> onPositionMarkerClick(LastInoutAction? actionTrackIn, ModelLiveTrack model) async {
    userMarkerSelected.value = true;
    searcAktive.value = false;
    snappingSheetController.value .snapToPosition(const SnappingPosition.pixels(positionPixels: 110));
    print("Iconda ustune basildi");
    if (model.lastInoutAction != null) {
      print("model.lastInoutAction != null");

      if (model.lastInoutAction!.outDate == ""||model.lastInoutAction!.customerLongitude!="") {
        print("model.lastInoutAction!.outDate == ""&&model.lastInoutAction!.customerLongitude!=""");

        String marketMarkerId="${model.lastInoutAction!.customerCode}-${model.lastInoutAction!.inDate}";
        markers.removeWhere((e)=>e.markerId.value==marketMarkerId);
        markers.add(map.Marker(
            markerId: map.MarkerId(marketMarkerId),
            onTap: () {
              selectedModel.value = model;
              _onMarketMarkerClick(model);
            },
            icon: await getClusterBitmapMarket(
            120,
                model.lastInoutAction!.customerName.toString(),
                model.lastInoutAction!.outDate == null),
            position: map.LatLng(
                double.parse(model.lastInoutAction!.customerLongitude!),
                double.parse(model.lastInoutAction!.customerLatitude!))));
    createCircles(
        model.lastInoutAction!.customerLatitude!,
        model.lastInoutAction!.customerLongitude!,
        model.lastInoutAction!.customerCode!,
        model.lastInoutAction!.outDate == null);
    String userMarkerId="${model.userCode}-${model.userPosition}";
    markers.removeWhere((e)=>e.markerId.value==userMarkerId);
    markers.add(map.Marker(
    markerId: map.MarkerId(userMarkerId),
    onTap: () {
    onPositionMarkerClick(model.lastInoutAction, model);
    },
    icon: await getClusterBitmapMenimYerim( 120,
        model.currentLocation!.isOnline!,
        model.currentLocation!.userFullName!),
    position: map.LatLng(
    double.parse(model.currentLocation!.latitude!),
    double.parse(model.currentLocation!.longitude!))));
    update();
    }}

    selectedModel.value = model;
    update();
  }

  Future<void> getAllDataFromServer() async {
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(false).post(
              "${loggedUserModel.baseUrl}/GirisCixisSystem/GetUsersLastLocations",
              options: Options(
                receiveTimeout: const Duration(seconds: 60),
                headers: {
                  'Lang': languageIndex,
                  'Device': dviceType,
                  'smr': '12345',
                  "Authorization": "Bearer $accesToken"
                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );

        if (response.statusCode == 200) {
          var dataModel = json.encode(response.data['Result']);
          modelMuyConnectUsers.value =MyConnectedUsersCurrentLocation.fromJson(jsonDecode(dataModel));
          sonYenilenme.value = DateTime.now().toIso8601String();
          for (var element in modelMuyConnectUsers.value.userLocation!) {
            listTrackdata.removeWhere((e) => e.userCode == element.userCode);
            listTrackdata.add(element);
          }
          await fillMarkersByListTrack(listTrackdata);
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
    update();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}

class UserRole {
  String? code;
  String? role;

  UserRole({
    this.code,
    this.role,
  });

  // Factory constructor to create an instance from JSON
  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      code: json['code'] as String?,
      role: json['role'] as String?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'role': role,
    };
  }

  // Factory constructor to create an instance from raw JSON string
  factory UserRole.fromRawJson(String str) =>
      UserRole.fromJson(json.decode(str));

  // Method to convert instance to raw JSON string
  String toRawJson() => json.encode(toJson());
}
