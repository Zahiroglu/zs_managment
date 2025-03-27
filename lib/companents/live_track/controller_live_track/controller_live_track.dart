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
import 'package:zs_managment/companents/giris_cixis/models/model_request_giriscixis.dart';
import 'package:zs_managment/companents/live_track/model/model_live_track.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import '../../../dio_config/api_client.dart';
import '../../../global_models/custom_enummaptype.dart';
import '../../../global_models/model_appsetting.dart';
import '../../../global_models/model_maptypeapp.dart';
import '../../../helpers/exeption_handler.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../backgroud_task/backgroud_errors/local_backgroud_events.dart';
import '../../backgroud_task/backgroud_errors/model_back_error.dart';
import '../../local_bazalar/local_app_setting.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/logged_usermodel.dart';
import '../model/model_my_connecteduserslocations.dart';

class ControllerLiveTrack extends GetxController {
  TextEditingController ctSearch = TextEditingController();
  RxList<ModelLiveTrack> listTrackdata =List<ModelLiveTrack>.empty(growable: true).obs;
  Rx<MyConnectedUsersCurrentLocation> modelMuyConnectUsers = MyConnectedUsersCurrentLocation().obs;
  RxList<UserModel> listAllConnectedUsers =List<UserModel>.empty(growable: true).obs;
  RxList<UserModel> listIslemeyenUsers = List<UserModel>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  RxSet<map.Marker> markers = RxSet<map.Marker>();
  Rx<ModelLiveTrack> selectedModel = ModelLiveTrack().obs;
  Rx<LastInoutAction> selectedModelAction = LastInoutAction().obs;
  RxList<map.Polyline> polylines = List<map.Polyline>.empty(growable: true).obs;
  Rx<map.LatLng> initialPosition = const map.LatLng(0, 0).obs;
  RxSet<map.Circle> circles = RxSet();
  RxBool userMarkerSelected = false.obs;
  RxBool searcAktive = true.obs;
  Rx<SnappingSheetController> snappingSheetController = SnappingSheetController().obs;
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
              'packages/map_launcher/assets/icons/${CustomMapType.google}.svg').obs;
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
        timer.cancel();
        _startTimerPeriodic(59);
      }
    });
    update();
  }

  @override
  Future<void> onInit() async {
    _startTimerPeriodic(59);
    listAllConnectedUsers.value =localBaseDownloads.getAllConnectedUserFromLocal();
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
                element.currentLocation!.userFullName!,element.currentLocation!.locAccuracy!),
            position: map.LatLng(
                double.parse(element.currentLocation!.latitude!),
                double.parse(element.currentLocation!.longitude!))));
        update();

    }
    update();
  }

  createCircles(String longitude, String latitudeitude, String ckod, bool? cixisEdilib) {
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

  createCirclesUserLocAcure(String longitude, String latitudeitude, String userCode, double acure) {
    circles.add(map.Circle(
        circleId: map.CircleId(userCode),
        center:
            map.LatLng(double.parse(latitudeitude), double.parse(longitude)),
        radius: acure,
        fillColor:Colors.blue.withOpacity(0.4),
        strokeColor: Colors.black.withOpacity(0.2),
        strokeWidth: 1));
  }

  void addPolyLineForEnter(
    bool isIn,
    String id,
    String customerLatitude,
    String customerLongitude,
    String enterLat,
    String enterLng,
  )
  {
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
      int size, String marketAdi, bool isExited) async
  {
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

  Future<map.BitmapDescriptor> getClusterBitmapMenimYerim( int size, bool isOnline, String username, double accuracy) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // İkonu çəkin
    var icon = Icons.man;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.7,
        fontFamily: icon.fontFamily,
        color: isOnline ? Colors.green : Colors.red,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));

    // İstifadəçi adını çəkin
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: username,
      style: TextStyle(
        decoration: TextDecoration.underline,
        fontSize: size / 10,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset((size - painter.width) * 0.7, size / 6),
    );

    // Şəkli tamamlayın
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
    snappingSheetController.value.snapToPosition(
        const SnappingPosition.pixels(positionPixels: 110));
    if (model.lastInoutAction != null) {
      createMarkerCirculeAndPolyline(model);
      selectedModel.value = model;
      update();
    }
  }

  createMarkerCirculeAndPolyline(ModelLiveTrack model) async {
      if (model.lastInoutAction!.outDate == ""||model.lastInoutAction!.customerLongitude!="") {
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
                double.parse(model.lastInoutAction!.customerLatitude!),
                double.parse(model.lastInoutAction!.customerLongitude!))));
      createCircles(model.lastInoutAction!.customerLongitude!, model.lastInoutAction!.customerLatitude!, model.lastInoutAction!.customerCode!,
          model.lastInoutAction!.outDate == null);
          createCirclesUserLocAcure(
            model.currentLocation!.longitude!,
            model.currentLocation!.latitude!,
            model.userCode!,
            model.currentLocation!.locAccuracy!
          );
      addPolyLineForEnter(
      true,
      listTrackdata.indexOf(model).toString(),
      model.lastInoutAction!.customerLatitude!,
      model.lastInoutAction!.customerLongitude!,
      model.currentLocation!.latitude!,
      model.currentLocation!.longitude!);
    }}

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
            listTrackdata.sort((x, y) {
              int xOnline = x.currentLocation!.isOnline!?1:0;
              int yOnline = y.currentLocation!.isOnline!?1:0;
              // Azalan sıralama için `yOnline.compareTo(xOnline)`
              return yOnline.compareTo(xOnline);
            });
            listTrackdata.sort((x, y) {
              int xOnline = x.lastInoutAction!.outDate==""?1:0;
              int yOnline = y.lastInoutAction!.outDate==""?1:0;
              // Azalan sıralama için `yOnline.compareTo(xOnline)`
              return yOnline.compareTo(xOnline);
            });
          }
          await fillMarkersByListTrack(listTrackdata);
        }
      } on DioException catch (e) {
        if (e.response != null) {
        } else {
          // Something happened in setting up or sending the request that triggered an Error
        }
      }
    }
    update();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Future<void> girisiSil(ModelLiveTrack model) async {
   // await sendErrorsToServers("Giris silme","${model.userCode!} kodlu istifadecinin ${model.lastInoutAction!.customerCode!} kodlu musteriye girisi silinmisdir",model);
  await _callApiForVisits(model);
  }

  Future<void> _callApiForVisits(ModelLiveTrack modelGirisCixis) async {
    DialogHelper.showLoading("melumatlar");
    await localUserServices.init();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    ModelRequestGirisCixis model =  ModelRequestGirisCixis(
        inDt: modelGirisCixis.lastInoutAction!.inDate!,
        userPosition: modelGirisCixis.userPosition,
        userCode: modelGirisCixis.userCode,
        customerCode: modelGirisCixis.lastInoutAction!.customerCode,
        );
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final response = await ApiClient().dio(true).post(
      "${loggedUserModel.baseUrl}/GirisCixisSystem/DeleteUserLastEnter",
      data: model.toJson(),
      options: Options(
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
    // 404
    if (response.statusCode == 200) {
      DialogHelper.hideLoading();
    }
    update();
  }

  Future<void> sendErrorsToServers(String xetaBasliq, String xetaaciqlama,ModelLiveTrack modelGirisCixis) async {
    LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
    await localUserServices.init();
    await localBackgroundEvents.init();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    ModelBackErrors model = ModelBackErrors(
      userId: loggedUserModel.userModel!.id,
      deviceId: loggedUserModel.userModel!.deviceId!,
      errCode: xetaBasliq,
      errDate: DateTime.now().toString(),
      errName: xetaaciqlama,
      description: xetaaciqlama,
      locationLatitude: "0",
      locationLongitude: "0",
      sendingStatus: "0",
      userCode: loggedUserModel.userModel!.code,
      userFullName: "${loggedUserModel.userModel!.name} ${loggedUserModel.userModel!.surname}",
      userPosition: loggedUserModel.userModel!.roleId,
    );
    try{
      final response = await ApiClient().dio(true).post(
        "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertNewBackError",
        data: model.toJson(),
        options: Options(
          headers: {
            'Lang': 'az',
            'Device': 1,
            'SMR': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
       await _callApiForVisits(modelGirisCixis);
      }else{
        await localBackgroundEvents.addBackErrorToBase(model);
      }}on DioException catch (e) {
      await localBackgroundEvents.addBackErrorToBase(model);
    }
  }



}



