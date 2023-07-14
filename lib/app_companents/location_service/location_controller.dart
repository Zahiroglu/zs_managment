import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zs_managment/customwidgets/simple_dialog.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:zs_managment/login/service/users_apicontroller.dart';




class LocationController extends GetxController {
  /// Declare the postion also the lat long just for example
  static late Position? posinitial;
  var lat = 0.0.obs, lng = 0.0.obs;
  bool enabled = true;
  int status = 0;
  static UsersApiController serverWithGet=UsersApiController();
  static String girisCixisMelumat="";
  @override
  void onInit() async {
    serverWithGet=Get.put(UsersApiController());
    //serverWithGet=Get.put(UsersApiController());    /// Run through here
    super.onInit();
  }

  changeGirisStatus(int action){
    if(action==0){
      startServicesetAsBackground();
    }else{
      stopService();
    }
    update();
  }


  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    /// OPTIONAL, using custom notification channel id
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
        ),
      );
    }
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStartServiz,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'ZS-MANAGMENT',
        initialNotificationContent: 'Giris edilir...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStartServiz,
        // you have to enable background fetch capability on xcode project
        onBackground: onBackground,
      ),
    );

  }

  @pragma('vm:entry-point')
  static Future<bool> onBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    // posinitial = await determinePosition();
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.reload();
    // final log = preferences.getStringList('log') ?? <String>[];
    // log.add(posinitial!.latitude.toString()+"-"+posinitial!.longitude.toString());
    // await preferences.setStringList('log', log);

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.reload();
    // final log = preferences.getStringList('log') ?? <String>[];
    // log.add(DateTime.now().toIso8601String());
    // await preferences.setStringList('log', log);
    return true;
  }

  @pragma('vm:entry-point')
 static void onStartServiz(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.setString("hello", "world");

    /// OPTIONAL when use custom notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // bring to foreground
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          flutterLocalNotificationsPlugin.show(
            888,
            'Xeberdarliq',
             "Giris etmisiniz zehmet olmasa gozleyin!Ne var ne yox?Ozun necesen?Evde Es",
            const NotificationDetails(
              android: AndroidNotificationDetails(
                importance: Importance.max,
                priority:Priority.high,
                onlyAlertOnce: true,
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ticker: 'ticker',
                ongoing: true,
                styleInformation: DefaultStyleInformation(true, true),

              ),
            ),
          );

          // if you don't using custom notification, uncomment this
          // service.setForegroundNotificationInfo(
          //   title: "My App Service",
          //   content: "Updated at ${DateTime.now()}",
          // );
        }
      }

      /// you can see this log in logcat etmek istedini burda ede bilersen
      print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
      posinitial = await determinePosition();
      if(posinitial!=null){
        serverWithGet.sendUserLocationToServer(1,1,posinitial);
      }


      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": "Android",
        },
      );
    });
  }

  void startServicesetAsBackground(){
    initializeService();
    FlutterBackgroundService().invoke("setAsBackground");
    update();
  }

  void startServicesetAsForeground()async{
    bool isrunninc=await FlutterBackgroundService().isRunning();
    if(!isrunninc){
      initializeService().whenComplete((){
      FlutterBackgroundService().invoke("setAsForeground");
      });
    }
    update();
  }

  void stopService()async{
    bool isrunninc=await FlutterBackgroundService().isRunning();
    if(isrunninc){
    FlutterBackgroundService().invoke("stopService");
    }
    update();
  }

  getPositionData() async{
    await permissionForLocation().then((value) async {
      posinitial = await determinePosition();
    }).whenComplete(() {
    });
    // try to log the data if its not empty
    if (posinitial != null) {
      if(!posinitial!.isMocked){
        log("${posinitial!.latitude}",name:"latitude");
        log("${posinitial!.longitude}",name:"longtitude");
        /// just pass this to ui to use
        lat(posinitial!.latitude);
        lng(posinitial!.longitude);
      }else{
        print("Mock location qosulmusdur");
      }

    }
    update();
  }

  static Future permissionForLocation() async {
    final request = await [Permission.location].request();
    log(request[Permission.location].toString());
    final status = await Permission.location.status;
    if (status.isDenied) {
      request;
      Get.dialog(ShowInfoDialog(messaje: "Gps-i aktivlesdirin",icon: Icons.gps_off_outlined,));
      return false;
    } else if (status.isRestricted) {
      Get.dialog(ShowInfoDialog(messaje: "Gps-i aktivlesdirin",icon: Icons.gps_off_outlined,));
      request;
      return false;
    } else if (status.isLimited) {
      Get.dialog(ShowInfoDialog(messaje: "Gps-i aktivlesdirin",icon: Icons.gps_off_outlined,));
      request;
      return false;
    } else {
      return true;
    }
  }

  static Future<Position>? determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.dialog(ShowInfoDialog(messaje: "Gps-i aktivlesdirin",icon: Icons.gps_off_outlined,));
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.openAppSettings();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.whileInUse) {
      Geolocator.openAppSettings();
      return Future.error(
          'Tam yetki verin');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> requestAlwaysPermission() async {
    try {
      final status = await Geolocator.requestPermission();
      return status == LocationPermission.always;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

}
class ModelLocation {
  String? userCode;
  int? roleId;
  String? latitude;
  String? longitude;
  String? lastSendTime;

  ModelLocation({
    this.userCode,
    this.roleId,
    this.latitude,
    this.longitude,
    this.lastSendTime,
  });

  ModelLocation copyWith({
    String? userCode,
    int? roleId,
    String? latitude,
    String? longitude,
    String? lastSendTime,
  }) =>
      ModelLocation(
        userCode: userCode ?? this.userCode,
        roleId: roleId ?? this.roleId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        lastSendTime: lastSendTime ?? this.lastSendTime,
      );

  factory ModelLocation.fromRawJson(String str) => ModelLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelLocation.fromJson(Map<String, dynamic> json) => ModelLocation(
    userCode: json["userCode"],
    roleId: json["roleId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    lastSendTime: json["lastSendTime"],
  );

  Map<String, dynamic> toJson() => {
    "userCode": userCode,
    "roleId": roleId,
    "latitude": latitude,
    "longitude": longitude,
    "lastSendTime": lastSendTime,
  };
}
