import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import '../../utils/checking_dvice_type.dart';
import '../local_bazalar/local_users_services.dart';
import '../login/models/logged_usermodel.dart';
import '../notifications/noty_background_track.dart';
class BackGroudTask{
  final Location location = Location();
  late LocationData _locationData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  LocalUserServices userService = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();
  //late Position position;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    location.enableBackgroundMode(enable: true);
    NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
    // Load persisted fetch events from SharedPreferences
    // Configure BackgroundFetch.
    try {
      var status = await BackgroundFetch.configure(BackgroundFetchConfig(
          minimumFetchInterval: 1,
          forceAlarmManager: true,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY
      ), _onBackgroundFetch, _onBackgroundFetchTimeout);
      // Schedule a "one-shot" custom-task in 10000ms.
      // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
      // where device must be powered (and delay will be throttled by the OS).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 5000,
          startOnBoot: true,
          periodic: true,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true
      ));
    } on Exception catch(e) {
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  void _onBackgroundFetch(String taskId) async {
    sendDataToServer();
    BackgroundFetch.finish(taskId);
  }

  Future checkScheduledNotification() async {
    await showNotification();

  }

  Future showNotification() async {
   await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Markete giris etdiniz.Telefonu sondurmeyin", fln: flutterLocalNotificationsPlugin);
  }
  Future showNotificationUpdate(LocationData locationData) async {
    await NotyBackgroundTrack.showBigTextNotificationUpdate(title: "Diqqet", body: "Location yenilendi "+DateTime.now().toString()+"Gps :"+locationData.latitude.toString()+","+locationData.longitude.toString(), fln: flutterLocalNotificationsPlugin);
  }

  void _onBackgroundFetchTimeout(String taskId) {

    BackgroundFetch.finish(taskId);
  }

  startBackgorundFetck(){
    BackgroundFetch.start().then((status) async {
      await showNotification();
      sendDataToServer();
    }).catchError((e) {
    });
  }

  stopBackGroundFetch(){
    BackgroundFetch.stop().then((status) async {
      await flutterLocalNotificationsPlugin.cancel(0);
      sendDataToServer();
    });
  }

  void sendDataToServer() async{
    _locationData = await location.getLocation();
    showNotificationUpdate(_locationData);
    _sendInfoToDatabase2(_locationData.latitude!,_locationData.longitude!);
  }

  Future<void> _sendInfoToDatabase2(double latitude,double lng) async {
    await userService.init();

    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    var data = {
      "userCode": loggedUserModel.userModel!.code!,
      "userPosition": loggedUserModel.userModel!.roleId!,
      "userFullName":
      "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
      "latitude": latitude,
      "longitude": lng,
      "locationDate": DateTime.now().toString()
    };
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      /// baglanti xetasi var
    } else {
      final response = await ApiClient().dio(false).post(
        "${loggedUserModel.baseUrl}/api/v1/InputOutput/add-user-location",
        data: data,
        options: Options(
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
      }
    }
  }
  Future<void> _sendInfoToDatabase(Position location) async {
    await userService.init();

    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    var data = {
      "userCode": loggedUserModel.userModel!.code!,
      "userPosition": loggedUserModel.userModel!.roleId!,
      "userFullName":
      "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
      "latitude": location.latitude,
      "longitude": location.longitude,
      "locationDate": DateTime.now().toString()
    };
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      /// baglanti xetasi var
    } else {
      final response = await ApiClient().dio(false).post(
        "${loggedUserModel.baseUrl}/api/v1/InputOutput/add-user-location",
        data: data,
        options: Options(
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
      }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
