import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';


class BackgroudLocationServiz{


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

  void _sendInfoToDatabase(bg.Location location) {}

  stopServiz() async {
    await bg.BackgroundGeolocation.stop();
  }

  void _istifadeciIcazeniBagladi(bg.ProviderChangeEvent provider) {}
}