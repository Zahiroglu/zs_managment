import 'dart:math';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/notifications/noty_background_track.dart';

import '../../dio_config/api_client.dart';
import '../../dio_config/api_client_live.dart';
import '../../utils/checking_dvice_type.dart';
import '../local_bazalar/local_users_services.dart';

class BackgroudLocationServiz extends GetxController {
  LocalUserServices userService = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  startBackgorundFetck(ModelGirisCixis modela, Position currentLocation) {
    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      print('[location] - $location');
      await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :"+location.coords.latitude.toString()+","+location.coords.longitude.toString(), fln: flutterLocalNotificationsPlugin);
      _sendInfoToDatabase(location,modela);
    });
    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (location.isMoving) {
        print('[onMotionChange] Device has just started MOVING ${location}');
      } else {
        print('[onMotionChange] Device has just STOPPED:  ${location}');
      }
    });
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent provider) async {
      switch (provider.status) {
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
          await NotyBackgroundTrack.showBigTextNotificationUpdate(id:2,title: "Xeberdarliq", body: "Gps xidmetine mudaxile etdiyiniz ucun bloklandiniz.Tarix:"+DateTime.now().toString(), fln: flutterLocalNotificationsPlugin);
          _istifadeciIcazeniBagladi(provider);
          break;
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
          // Android & iOS
          // console.log('- Location always granted');
          break;
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
          await NotyBackgroundTrack.showBigTextNotificationUpdate(id:2,title: "Xeberdarliq", body: "Gps xidmetine mudaxile etdiyiniz ucun bloklandiniz.Tarix:"+DateTime.now().toString(), fln: flutterLocalNotificationsPlugin);
          // iOS only
          //console.log('- Location WhenInUse granted');
          _istifadeciIcazeniBagladi(provider);
          break;
      }
    });
    bg.BackgroundGeolocation.onConnectivityChange((connection) async {
      if(!connection.connected){
        await NotyBackgroundTrack.showBigTextNotificationUpdate(title: "Diqqet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek"+DateTime.now().toString(), fln: flutterLocalNotificationsPlugin);
      }else{
        await flutterLocalNotificationsPlugin.cancel(1);

      }

    });
    bg.BackgroundGeolocation.onEnabledChange((bool isEnabled) =>
        {print('[onEnabledChanged] isEnabled? ${isEnabled}')});

    bg.BackgroundGeolocation.ready(bg.Config(
            notification: bg.Notification(
              sticky: true,
              channelId: "zs001",
              channelName: "zsNotall",
              title: 'ZS-CONTROL',
              text: 'System fealiyyet gosterir',
              color: '#FEDD1E',
            ),
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
           // stopOnStationary: false,
        allowIdenticalLocations:false,
        isMoving: true,
        enableHeadless: true,
        stopOnTerminate: false,
        forceReloadOnBoot: true,
        foregroundService: true,
        startOnBoot: true,
        debug: false,
        distanceFilter: 0,
        locationUpdateInterval: 500000,
        backgroundPermissionRationale: PermissionRationale(
          title: "Allow {applicationName} to access to this device's location in the background?",
          message: "This app collects location data to enable tracking even when the app is closed or not in use. Please enable {backgroundPermissionOptionLabel} location permission",
          positiveAction: "Change to {backgroundPermissionOptionLabel}",
          negativeAction: "Cancel"
        ),
        locationAuthorizationAlert: {
          'titleWhenNotEnabled': 'Yo, location-services not enabled',
          'titleWhenOff': 'Yo, location-services OFF',
          'instructions': 'You must enable "Always" in location-services, buddy',
          'cancelButton': 'Cancel',
          'settingsButton': 'Settings'
        },
        logLevel: bg.Config.LOG_LEVEL_VERBOSE)).then((bg.State state) {
      if (!state.enabled) {
        NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
        bg.BackgroundGeolocation.start();
      }
    });
  }


  double calculateDistance(lat1, lon1, lat2, lon2) {
    String mesafe="";
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double uzaqliq = 12742 * asin(sqrt(a));
    return uzaqliq;
  }
  
  Future<void> _sendInfoToDatabase(bg.Location location, ModelGirisCixis modela) async {
    await userService.init();
    double uzaqliq=calculateDistance(location.coords.latitude,location.coords.longitude,double.parse(modela.marketgpsEynilik!),double.parse(modela.marketgpsEynilik!),);
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    var data = {
      "userCode": loggedUserModel.userModel!.code!,
      "userPosition": loggedUserModel.userModel!.roleId!,
      "userFullName": "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
      "latitude": location.coords.latitude,
      "longitude": location.coords.longitude,
      "locationDate": DateTime.now().toString().substring(0,18),
      "speed": location.coords.speed,
      "isOnline": true,
      "pastInputCustomerCode": modela.ckod,
      "pastInputCustomerName": modela.cariad,
      "inputCustomerDistance": uzaqliq.round(),
      "batteryLevel": location.battery.level*100
    };
    print("sending data :"+data.toString());
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

  stopBackGroundFetch() async {
    await flutterLocalNotificationsPlugin.cancel(0);
    await flutterLocalNotificationsPlugin.cancel(1);
    await flutterLocalNotificationsPlugin.cancel(2);
    await bg.BackgroundGeolocation.stop();
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void _istifadeciIcazeniBagladi(bg.ProviderChangeEvent provider) {}
}
