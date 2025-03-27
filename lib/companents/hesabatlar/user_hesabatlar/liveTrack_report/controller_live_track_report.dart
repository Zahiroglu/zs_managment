import 'dart:async';
import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:zs_managment/companents/hesabatlar/user_hesabatlar/liveTrack_report/screen_livetrack_report.dart';

import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';

import '../../../../dio_config/api_client.dart';
import '../../../../utils/checking_dvice_type.dart';
import '../../../../widgets/simple_info_dialog.dart';
import '../../../live_track/model/model_live_track.dart';
import '../../../login/models/logged_usermodel.dart';
import '../../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'model_live_track_map.dart';

class ControllerLiveTrackReport extends GetxController {
  RxList<MyConnectedUsersCurrentLocationReport> listTrackdata = List<MyConnectedUsersCurrentLocationReport>.empty(growable: true).obs;
  RxList<MercCustomersDatail> listZiyaretEdilmeyenler = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<LastInoutAction> listLastInoutAction = List<LastInoutAction>.empty(growable: true).obs;
  RxList<map.Polyline> polylines = List<map.Polyline>.empty(growable: true).obs;
  Rx<map.LatLng> initialPosition = const map.LatLng(0, 0).obs;
  RxSet<map.Circle> circles = RxSet();
  RxSet<map.Marker> markers = RxSet<map.Marker>();
  Rx<bool> dataIsLoading = true.obs;
  Rx<MyConnectedUsersCurrentLocationReport> selectedModel = MyConnectedUsersCurrentLocationReport().obs;
  Rx<CustomInfoWindowController> customInfoWindowController = CustomInfoWindowController().obs;
  LocalUserServices userServices = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();
  String languageIndex = "az";

  @override
  void dispose() {
    customInfoWindowController.value.dispose();
    Get.delete<ControllerLiveTrackReport>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  Future<void> getMyConnectedUsersCurrentLocations(String temsilcikodu,String roleId, String startDay, String endDay, String rutDay) async {
    await userServices.init();
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    var dataa ={
      "userCode": temsilcikodu,
      "roleId": int.parse(roleId),
      "rutDay": 0,
      "startDate": startDay,
      "endDate": endDay
    };
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(false).post(
              "${loggedUserModel.baseUrl}/GirisCixisSystem/getUserDaylyTrackReport",
          data: dataa,
          options: Options(
                headers: {
                  'Lang': languageIndex,
                  'Device': dviceType,
                  'smr': '12345',
                  "Authorization": "Bearer $accesToken",

                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );

        if (response.statusCode == 200) {
          var listData = response.data['Result']; // JSON verisini doğrudan kullanıyoruz.
          if (listData is List) { // liste olup olmadığını kontrol ediyoruz.
            for (var i in listData) {
              ModelUserDaylyTrackReport model = ModelUserDaylyTrackReport.fromJson(i);
              if(model.listInOuts!.isNotEmpty){
                for (var e in model.listInOuts!) {
                  listLastInoutAction.add(e);
                  listTrackdata.add(MyConnectedUsersCurrentLocationReport(
                      type: 1,
                      longitude: e.customerLongitude,
                      latitude: e.customerLatitude,
                      inputCustomerDistance: e.inDistance,
                      locationDate: e.inDate!,
                      inOutCustomer: e,
                      pastInputCustomerName: e.customerName,
                      pastInputCustomerCode: e.customerCode!
                  ));
                  if(e.outDate!.length>10){//eger cixis edilmeyibse
                    listTrackdata.add(MyConnectedUsersCurrentLocationReport(
                        type: 2,
                        longitude: e.customerLongitude,
                        latitude: e.customerLatitude,
                        inputCustomerDistance: e.outDistance,
                        locationDate: e.outDate!,
                        inOutCustomer: e,
                        pastInputCustomerName: e.customerName,
                        pastInputCustomerCode: e.customerCode!
                    ));
                  }}
              }//giris-cixis edilmis marketler
              if (model.listTrackin != null) {
                for (var e in model.listTrackin!) {
                  e.type=0;
                  listTrackdata.add(e);
                }

            }//sade locationlar
              if (model.unvisitedCustomersInRut != null) {
                listZiyaretEdilmeyenler.value = model.unvisitedCustomersInRut!;
                for (var e in model.unvisitedCustomersInRut!) {
                  listTrackdata.add(MyConnectedUsersCurrentLocationReport(
                      type: 3,
                      longitude: e.longitude.toString(),
                      latitude: e.latitude.toString(),
                      inputCustomerDistance: "0",
                      locationDate:"0",
                      inOutCustomer: null,
                      pastInputCustomerCode: e.code!,
                      pastInputCustomerName: e.name!
                  ));
                  listLastInoutAction.add(LastInoutAction(
                      outDistance: "",
                      outDate: "",
                      customerLongitude: e.longitude.toString(),
                      customerCode: e.code!,
                      customerName: e.name!,
                      inNote: "",
                      customerLatitude: e.latitude.toString()
                  ));
                }
              }//giris edilmemis dukanlar
            }
          } else {
          }

        }
      } on DioException {

      }
    }
    update();
    userServices.init();
    dataIsLoading.value = true;
    listTrackdata.sort((a, b) {
      // '2025.01.15 09:25:02' formatındaki tarihi çözümlemek için uygun bir DateFormat kullanıyoruz
      intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm:ss'); // Düzeltildi

      DateTime dateA = dateFormat.parse(a.locationDate!); // a'nın locationDate'sini DateTime'a çeviriyoruz
      DateTime dateB = dateFormat.parse(b.locationDate!); // b'nin locationDate'sini DateTime'a çeviriyoruz

      return dateA.compareTo(dateB); // Tarihler arasında karşılaştırma yapıyoruz
    });
    if(listTrackdata.isNotEmpty) {
      await fillMarkersByListTrack(listTrackdata);
    //  drawPolyLines(listTrackdata.where((e)=>e.type==0).toList());
      drawPolyLines(listTrackdata);

    }dataIsLoading.value = false;

  }

  Future<void> fillMarkersByListTrack(List<MyConnectedUsersCurrentLocationReport> listTrack) async {
    polylines.clear();
    circles.clear();
    markers.clear();
    if (listTrack.isNotEmpty && listTrack[0].latitude != null && listTrack[0].longitude != null) {
      if (listTrack[0].latitude!.isNotEmpty && listTrack[0].longitude!.isNotEmpty) {
        initialPosition.value = map.LatLng(
            double.parse(listTrack[0].latitude!),
            double.parse(listTrack[0].longitude!)

        );
        for (var element in listTrack) {
          if(element.latitude!="") {
            markers.add(map.Marker(markerId: map.MarkerId("${element.userCode}-${element.locationDate}-${element.latitude!}"),
                onTap: () {
                  onPositionPointClick(element, element.type != 0);
                  update();
                },
                icon: await getClusterBitmapPoint(40, element),
                position: map.LatLng(double.parse(element.latitude!),
                    double.parse(element.longitude!))));
          }  }

      } else {
      }
    } else {
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

  Future<map.BitmapDescriptor> getClusterBitmapPoint( int size, MyConnectedUsersCurrentLocationReport element) async {
    Color color = Colors.deepOrange;
    var icon = Icons.circle_sharp;
    switch (element.type) {
      case 1:
        size=120;
        color = Colors.orange;
        icon = Icons.home;
        break;
      case 3:
        size=120;
        color = Colors.red;
        icon = Icons.home;
        break;
      case 2:
        size=120;
        color = Colors.green;
        icon = Icons.home;
        break;
    }
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle( fontSize: size * 0.7, fontFamily: icon.fontFamily, color: color));
    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));
    if(element.inOutCustomer!=null){
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: (listLastInoutAction.indexOf(element.inOutCustomer)+1).toString(),
      style: TextStyle(
          fontSize: size / 4,
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset((size - painter.width) * 0.6, size / 8),
    );
    }
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<map.BitmapDescriptor> getClusterBitmapARROW(int size, double locationHeading) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    var icon = Icons.arrow_forward;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);

    // Save the current state of the canvas before rotating
    canvas.save();

    // Move the canvas's origin to the center of the arrow to rotate around it
    canvas.translate(size / 2, size / 2);

    // Rotate the canvas based on the location heading (converted to radians)
    canvas.rotate(locationHeading * (3.1415927 / 180));

    // Move the canvas back to the original position after rotating
    canvas.translate(-size / 2, -size / 2);

    // Draw the arrow
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.7,
        fontFamily: icon.fontFamily,
        color: Colors.red,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(size / 4, size / 4));

    // Restore the canvas to its original state
    canvas.restore();

    // Convert the picture to an image
    final img = await pictureRecorder.endRecording().toImage(size, size);

    // Convert the image to byte data
    final data = await img.toByteData(format: ImageByteFormat.png);

    // Return the BitmapDescriptor from the byte data
    return map.BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void drawPolyLines(List<MyConnectedUsersCurrentLocationReport> listTrack) async {
    try {
      if (listTrack.length < 2) {
        print("Yeterli nokta yok!");
        return;
      }
      for (int j = 0; j < listTrack.length - 1; j++) {
        String correctedLatitude = listTrack[j].latitude!.replaceAll(',', '.');
        String correctedLatitudePilus = listTrack[j+1].latitude!.replaceAll(',', '.');
        String correctedLongitude = listTrack[j].longitude!.replaceAll(',', '.');
        String correctedLongitudePilus = listTrack[j+1].longitude!.replaceAll(',', '.');
        if (correctedLatitudePilus!=""&&correctedLatitude!="") {
          final map.Polyline polyline = map.Polyline(
            polylineId: map.PolylineId(listTrack[j].locationDate!),
            width: 2,
            color: Colors.blue,
            endCap: map.Cap.buttCap,
            startCap: map.Cap.buttCap,
            patterns: const [map.PatternItem.dot],
            points: [
              map.LatLng(double.parse(correctedLatitude.trim()),
                  double.parse(correctedLongitude.trim())),
              map.LatLng(double.parse(correctedLatitudePilus.trim()),
                  double.parse(correctedLongitudePilus.trim())),
            ],
          );
          polylines.add(polyline);
          update();
        }
      }
      update();
    } catch (e, stackTrace) {
      print("Hata: $e");
      print("Hata izleme: $stackTrace");
      rethrow;
    }
  }


  Future<void> onPositionPointClick(MyConnectedUsersCurrentLocationReport element, bool mustShowMarket) async {
    selectedModel.value = element;
      customInfoWindowController.value.addInfoWindow!(
          widgetCustomInfo(element, Get.context!,element.type),
          map.LatLng(double.parse(element.latitude!), double.parse(element.longitude!)));
      update();
    //eger sade location deyilse
  }


  Widget widgetCustomInfo(MyConnectedUsersCurrentLocationReport element, BuildContext buildContext, int? type) {
    return WidgetInfoWindow(
      clouse: (v){
        if(v){
          selectedModel.value = MyConnectedUsersCurrentLocationReport();
          customInfoWindowController.value.hideInfoWindow;
          update();
        }
      },
      statusMarker: type!,
      element: element,
      width:type==0? MediaQuery.of(Get.context!).size.width*0.5:MediaQuery.of(Get.context!).size.width*0.8,
      height: type==0?60:150,
    );
  }


  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  sortFilter(bool getSorted){
   listTrackdata.sort((a, b) {
      // '2025.01.15 09:25:02' formatındaki tarihi çözümlemek için uygun bir DateFormat kullanıyoruz
      intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm:ss'); // Düzeltildi

      DateTime dateA = dateFormat.parse(a.locationDate!); // a'nın locationDate'sini DateTime'a çeviriyoruz
      DateTime dateB = dateFormat.parse(b.locationDate!); // b'nin locationDate'sini DateTime'a çeviriyoruz
     if(getSorted) {
       return dateB.compareTo(
           dateA); // Tarihler arasında karşılaştırma yapıyoruz
     }else{
       return dateA.compareTo(
           dateB);
     } });
   update();
  }
}
