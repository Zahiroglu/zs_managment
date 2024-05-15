import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

import '../../dio_config/api_client_live.dart';
import '../../utils/checking_dvice_type.dart';
import '../local_bazalar/local_users_services.dart';
import '../login/models/logged_usermodel.dart';
import '../notifications/noty_background_track.dart';
class BackGroudTask{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  LocalUserServices userService = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
    // Load persisted fetch events from SharedPreferences
    // Configure BackgroundFetch.
    try {
      var status = await BackgroundFetch.configure(BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY
      ), _onBackgroundFetch, _onBackgroundFetchTimeout);
      print('[BackgroundFetch] configure success: $status');
      // Schedule a "one-shot" custom-task in 10000ms.
      // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
      // where device must be powered (and delay will be throttled by the OS).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 10000,
          startOnBoot: true,
          periodic: true,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true
      ));
    } on Exception catch(e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  void _onBackgroundFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
    sendDataToServer();

    // Persist fetch events in SharedPreferences
    // if (taskId == "flutter_background_fetch") {
    //   // Perform an example HTTP request.
    //   sendDataToServer();
    // }
    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  Future checkScheduledNotification() async {
    await showNotification();

  }

  Future showNotification() async {
   await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Markete giris etdiniz.Telefonu sondurmeyin", fln: flutterLocalNotificationsPlugin);
  }

  void _onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");

    BackgroundFetch.finish(taskId);
  }

  startBackgorundFetck(){
    BackgroundFetch.start().then((status) async {
      await showNotification();
      print('[BackgroundFetch] start success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] start FAILURE: $e');
    });
  }

  stopBackGroundFetch(){
    BackgroundFetch.stop().then((status) {
      print('[BackgroundFetch] stop success: $status');
    });
  }

  void sendDataToServer() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _sendInfoToDatabase(position);
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
      final response = await ApiClientLive().dio().post(
        "${loggedUserModel.baseUrl}/api/v1/InputOutput/add-user-location",
        data: data,
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
        print("melumat sisteme gonderildi : " + data.toString());
      }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}