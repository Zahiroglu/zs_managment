import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';


class BackgroudLocationServiz{

  /// Receive events from BackgroundGeolocation in Headless state.
  @pragma('vm:entry-point')
  void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
    switch (headlessEvent.name) {
      case bg.Event.BOOT:
        bg.State state = await bg.BackgroundGeolocation.state;
        print("📬 didDeviceReboot: ${state.didDeviceReboot}");
        break;
      case bg.Event.TERMINATE:
        bg.State state = await bg.BackgroundGeolocation.state;
        if (state.stopOnTerminate!) {
          // Don't request getCurrentPosition when stopOnTerminate: true
          return;
        }
        try {
          bg.Location location =
          await bg.BackgroundGeolocation.getCurrentPosition(
              samples: 1,
              extras: {
                "event": "terminate",
                "headless": true
              }
          );
          print("[getCurrentPosition] Headless: $location");
        } catch (error) {
          print("[getCurrentPosition] Headless ERROR: $error");
        }

        break;
      case bg.Event.HEARTBEAT:
        try {
          bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
              samples: 2,
              timeout: 10,
              extras: {
                "event": "heartbeat",
                "headless": true
              }
          );

          print('[getCurrentPosition] Headless: $location');
        } catch (error) {
          print('[getCurrentPosition] Headless ERROR: $error');
        }
        break;
      case bg.Event.LOCATION:
        bg.Location location = headlessEvent.event;
        print(location);
        break;
      case bg.Event.MOTIONCHANGE:
        bg.Location location = headlessEvent.event;
        print(location);
        break;
      case bg.Event.GEOFENCE:
        bg.GeofenceEvent geofenceEvent = headlessEvent.event;
        print(geofenceEvent);
        break;
      case bg.Event.GEOFENCESCHANGE:
        bg.GeofencesChangeEvent event = headlessEvent.event;
        print(event);
        break;
      case bg.Event.SCHEDULE:
        bg.State state = headlessEvent.event;
        print(state);
        break;
      case bg.Event.ACTIVITYCHANGE:
        bg.ActivityChangeEvent event = headlessEvent.event;
        print(event);
        break;
      case bg.Event.HTTP:
        bg.HttpEvent response = headlessEvent.event;
        print(response);
        break;
      case bg.Event.POWERSAVECHANGE:
        bool enabled = headlessEvent.event;
        print(enabled);
        break;
      case bg.Event.CONNECTIVITYCHANGE:
        bg.ConnectivityChangeEvent event = headlessEvent.event;
        print(event);
        break;
      case bg.Event.ENABLEDCHANGE:
        bool enabled = headlessEvent.event;
        print(enabled);
        break;
      // case bg.Event.AUTHORIZATION:
      //   bg.AuthorizationEvent event = headlessEvent.event;
      //   print(event);
      //   bg.BackgroundGeolocation.setConfig(
      //       bg.Config(url: "${ENV.TRACKER_HOST}/api/locations"));
      //   break;
    }
  }
  /// Receive events from BackgroundFetch in Headless state.
  @pragma('vm:entry-point')
  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;

    // Is this a background_fetch timeout event?  If so, simply #finish and bail-out.
    if (task.timeout) {
      print("[BackgroundFetch] HeadlessTask TIMEOUT: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }

    print("[BackgroundFetch] HeadlessTask: $taskId");

    try {
      var location = await bg.BackgroundGeolocation.getCurrentPosition(
          samples: 2,
          extras: {
            "event": "background-fetch",
            "headless": true
          }
      );
      print("[location] $location");
    } catch(error) {
      print("[location] ERROR: $error");
    }

    BackgroundFetch.finish(taskId);
  }


  // startServiz(){
  //   bg.BackgroundGeolocation.onLocation((bg.Location location) {
  //     print('[location] - $location');
  //    _sendInfoToDatabase(location);
  //   });
  //   // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
  //   bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
  //     if (location.isMoving) {
  //             print('[onMotionChange] Device has just started MOVING ${location}');
  //         } else {
  //            print('[onMotionChange] Device has just STOPPED:  ${location}');
  //     }
  //   });
  //
  //   // Fired whenever the state of location-services changes.  Always fired at boot
  //   bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent provider) {
  //        switch(provider.status) {
  //          case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
  //           _istifadeciIcazeniBagladi(provider);
  //            break;
  //         case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
  //            // Android & iOS
  //           // console.log('- Location always granted');
  //            break;
  //          case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
  //            // iOS only
  //           //console.log('- Location WhenInUse granted');
  //            _istifadeciIcazeniBagladi(provider);
  //            break;
  //        }
  //   });
  //
  //   ////
  //   // 2.  Configure the plugin
  //   //
  //   bg.BackgroundGeolocation.ready(
  //       bg.Config(
  //       notification: bg.Notification(
  //         channelId: "zs001",
  //         channelName: "zsNotall",
  //         title: 'ZS-CONTROL',
  //         text: 'System fealiyyet gosterir',
  //         color: '#FEDD1E',
  //       ),
  //
  //       desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
  //       //stopOnStationary: false,
  //       isMoving: true,
  //       enableHeadless: true,
  //       stopOnTerminate: false,
  //       forceReloadOnBoot: true,
  //       foregroundService: true,
  //       startOnBoot: true,
  //       debug: true,
  //       distanceFilter: 0,
  //       locationUpdateInterval:50000, //50 saniye edildi
  //       logLevel: bg.Config.LOG_LEVEL_VERBOSE
  //   )).then((bg.State state) {
  //     if (!state.enabled) {
  //       bg.BackgroundGeolocation.start();
  //
  //     }
  //   });
  // }
  startServiz(){
    bg.BackgroundGeolocation.registerHeadlessTask(
        backgroundGeolocationHeadlessTask);
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

    /// Register BackgroundFetch headless-task.
   // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  void _sendInfoToDatabase(bg.Location location) {}

  stopServiz() async {
    await bg.BackgroundGeolocation.stop();
  }

  void _istifadeciIcazeniBagladi(bg.ProviderChangeEvent provider) {}
}