import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';

import '../../dio_config/api_client.dart';
import '../../utils/checking_dvice_type.dart';
import '../local_bazalar/local_users_services.dart';


class BackgroudLocationServiz{
  LocalUserServices userService = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();


  startServiz(){
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
     _sendInfoToDatabase(location);
    });
    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (location.isMoving) {
              print('[onMotionChange] Device has just started MOVING ${location}');

          } else {
             print('[onMotionChange] Device has just STOPPED:  ${location}');
      }
    });
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent provider) {
         switch(provider.status) {
           case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
            _istifadeciIcazeniBagladi(provider);
             break;
          case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
             // Android & iOS
            // console.log('- Location always granted');
             break;
           case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
             // iOS only
            //console.log('- Location WhenInUse granted');
             _istifadeciIcazeniBagladi(provider);
             break;
         }
    });

    bg.BackgroundGeolocation.ready(
        bg.Config(
        notification: bg.Notification(
          channelId: "zs001",
          channelName: "zsNotall",
          title: 'ZS-CONTROL',
          text: 'System fealiyyet gosterir',
          color: '#FEDD1E',
        ),
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        //stopOnStationary: false,
        isMoving: true,
        enableHeadless: true,
        stopOnTerminate: false,
        forceReloadOnBoot: true,
        foregroundService: true,
        startOnBoot: true,
        debug: true,
        distanceFilter: 0,
        locationUpdateInterval:50000, //50 saniye edildi
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();

      }
    });
  }

  Future<void> _sendInfoToDatabase(bg.Location location) async {
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    var data ={
      "userCode": loggedUserModel.userModel!.code!,
      "userPosition":  loggedUserModel.userModel!.roleId!,
      "userFullName": "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
      "latitude": location.coords.latitude,
      "longitude":  location.coords.longitude,
      "locationDate": DateTime.now().toString()
    };
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      /// baglanti xetasi var
    } else {
      final response = await ApiClient().dio().post(
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
        print("melumat sisteme gonderildi : "+data.toString());
      }
    }
  }


  stopServiz() async {
    await bg.BackgroundGeolocation.stop();
  }
  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void _istifadeciIcazeniBagladi(bg.ProviderChangeEvent provider) {}
}