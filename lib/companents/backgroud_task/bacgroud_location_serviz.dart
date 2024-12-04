import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/backgroud_task/backgroud_errors/model_back_error.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/notifications/noty_background_track.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import '../../routs/rout_controller.dart';
import '../../utils/checking_dvice_type.dart';
import '../anbar/controller_anbar.dart';
import '../giris_cixis/models/model_customers_visit.dart';
import '../giris_cixis/models/model_request_giriscixis.dart';
import '../local_bazalar/local_bazalar.dart';
import '../local_bazalar/local_users_services.dart';
import '../login/services/api_services/users_controller_mobile.dart';
import '../main_screen/controller/drawer_menu_controller.dart';
import 'backgroud_errors/local_backgroud_events.dart';
import 'backgroud_errors/model_user_current_location_reqeust.dart';

class BackgroudLocationServiz extends GetxController {
  LocalUserServices userService = LocalUserServices();
  LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  late CheckDviceType checkDviceType = CheckDviceType();
  Rx<double> currentLatitude = 0.0.obs;
  Rx<double> currentLongitude = 0.0.obs;
  Rx<bool> isFistTime = true.obs;
  Rx<DateTime> cureentTime = DateTime.now().obs;
  Rx<ModelCustuomerVisit> modelVisitedInfo = ModelCustuomerVisit().obs;
  static String blok="Block";
  LocalBazalar localBazalar = LocalBazalar();
  Rx<ModelCustuomerVisit> modelgirisEdilmis = ModelCustuomerVisit().obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  RxBool hasConnection=true.obs;

  startBackgorundFetckoLD() async {
    await localGirisCixisServiz.init();
    ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      if (location.mock) {
        sendErrorsToServers(blok, modela.customerCode.toString() + "adlimarkerBlockMock".tr);
      } else {
        if (isFistTime.isTrue) {
          isFistTime.value = false;
          cureentTime.value = DateTime.now();
          currentLatitude.value = location.coords.latitude;
          currentLongitude.value = location.coords.longitude;
          await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);
         // await sendInfoLocationsToDatabase(location, modela);
        }
        else {
          if (await checkIfTimeGretherThanOneMinute(cureentTime.value, DateTime.now())) {
            isFistTime.value = false;
            cureentTime.value = DateTime.now();
            currentLatitude.value = location.coords.latitude;
            currentLongitude.value = location.coords.longitude;
            await NotyBackgroundTrack.showBigTextNotification(
                title: "Diqqet",
                body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}",
                fln: flutterLocalNotificationsPlugin);
           // await sendInfoLocationsToDatabase(location, modela);
            await checkUnsendedErrors();
          }
        }
      }
      update();
    });
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (location.isMoving) {
      } else {
      }
    });
    bg.BackgroundGeolocation.onConnectivityChange((connection) async {
      hasConnection.value=connection.connected;
      if (!connection.connected) {
        await localGirisCixisServiz.init();
        ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
        await NotyBackgroundTrack.showBigTextNotificationUpdate(title: "Diqqet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
       // await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxeta".tr}${"date".tr} : ${DateTime.now()}");
      } else {
        //await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxetaQalxdi".tr}${"date".tr} : ${DateTime.now()}");
        await flutterLocalNotificationsPlugin.cancel(1);
      }
    });
    bg.BackgroundGeolocation.onAuthorization((c) {
      // if (c == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED) {
      //   print("GPS icazəsi rədd edildi.");
      // } else
      if (c != bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
        sendErrorsToServers(blok, "${modela.customerCode}marketde girisde iken Gps melumatlar sistemini deyisdiyi ucun blok edildi. Gps service - $c");
      }
    });
    bg.BackgroundGeolocation.onGeofencesChange((geo){
    });
    bg.BackgroundGeolocation.onActivityChange((a) {
    });
    bg.BackgroundGeolocation.onSchedule((s){

    });
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      if (!event.gps) {
        NotyBackgroundTrack.showBigTextNotification(
          title: "GPS Bağlandı",
          body: "GPS əl ilə bağlanıb. Zəhmət olmasa yenidən aktiv edin.",
          fln: flutterLocalNotificationsPlugin,
        );
      } else {
        // GPS aktivdir.
      }
    });
    bg.BackgroundGeolocation.ready(bg.Config(
      notification: bg.Notification(
        sticky: true,
        channelId: "zs001",
        channelName: "zsNotall",
        title: 'ZS-CONTROL - Sistem aktivdir',
        text: "Adli markete giris edilib.",
        color: '#FEDD1E',
      ),
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH, // Yüksək dəqiqliklə mövqeyi izləyir.
      distanceFilter: 0, // Hərəkət etməsə də yeniləmə olacaq.
      locationUpdateInterval: 60000, // Hər 1 dəqiqədən bir mövqe göndər.
      stopOnTerminate: false, // Tətbiq tam bağlansa belə xidməti dayandırma.
      startOnBoot: true, // Cihaz yenidən başladıldıqda avtomatik başlat.
      foregroundService: true, // Xidmət ön planda işləyəcək.
      enableHeadless: true, // Proqram arxa planda belə işləsin.
      showsBackgroundLocationIndicator: true, // Arxa planda mövqe izləmə göstəricisi.
      preventSuspend: true, // Cihazın yuxuya keçməsinin qarşısını al.
      debug: false,
      logLevel: bg.Config. LOG_LEVEL_VERBOSE,
      heartbeatInterval: 60, // 60 saniyədə bir heartbeat hadisəsi.
    )).then((bg.State state) {
      // Xidmət aktiv deyilsə, onu başlat.
      if (!state.enabled) {
        NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin); // Bildiriş xidməti.
        bg.BackgroundGeolocation.start(); // Xidməti başlat.
      }
    });


  }

  startBackgorundFetck2() async {
    await userService.init();
    await localBackgroundEvents.init();
    await localGirisCixisServiz.init();
    ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
    // bg.BackgroundGeolocation.onLocation((bg.Location location) async {
    //
    //   if (location.mock) {
    //     sendErrorsToServers(blok, modela.customerCode.toString() + "adlimarkerBlockMock".tr);
    //   } else {
    //       isFistTime.value = false;
    //       cureentTime.value = DateTime.now();
    //       currentLatitude.value = location.coords.latitude;
    //       currentLongitude.value = location.coords.longitude;
    //       await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);
    //       await sendInfoLocationsToDatabase(location);
    //
    //   }
    //   update();
    // });

    // Handle location heartbeat events
    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) async {
      try {
        print("Heartbeat event triggered: ${event.location}");

        final bg.Location location = event.location!;
        if (location.mock) {
          // Send error to the server if mock location is detected
          await sendErrorsToServers(
            blok,
            "${modela.customerCode} - Mock location detected during heartbeat.",
          );
        } else {
          // Update values for the current location
          isFistTime.value = false;
          cureentTime.value = DateTime.now();
          currentLatitude.value = location.coords.latitude;
          currentLongitude.value = location.coords.longitude;

          // Show a notification for the location change
          await NotyBackgroundTrack.showBigTextNotification(
            title: "Diqqət",
            body: "GPS məlumat dəyişdi: Latitude ${location.coords.latitude}, Longitude ${location.coords.longitude}",
            fln: flutterLocalNotificationsPlugin,
          );

          // Send updated location info to the database
          await sendInfoLocationsToDatabase(location);
        }

        update(); // Notify listeners about the state change
      } catch (e) {
        print("Error handling onHeartbeat event: $e");
      }
    });
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (location.isMoving) {
      } else {
      }
    });
    bg.BackgroundGeolocation.onConnectivityChange((connection) async {
      hasConnection.value=connection.connected;
      if (!connection.connected) {
        await localGirisCixisServiz.init();
        ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
        await NotyBackgroundTrack.showBigTextNotificationUpdate(title: "Diqqet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
       // await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxeta".tr}${"date".tr} : ${DateTime.now()}");
      } else {
        //await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxetaQalxdi".tr}${"date".tr} : ${DateTime.now()}");
        await flutterLocalNotificationsPlugin.cancel(1);
      }
    });
    bg.BackgroundGeolocation.onAuthorization((c) {
      // if (c == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED) {
      //   print("GPS icazəsi rədd edildi.");
      // } else
      if (c != bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
        sendErrorsToServers(blok, "Gps melumatlar sistemini deyisdiyi ucun blok edildi. Gps service - $c");
      }
    });
    bg.BackgroundGeolocation.onGeofencesChange((geo){
    });
    bg.BackgroundGeolocation.onActivityChange((a) {
    });
    bg.BackgroundGeolocation.onSchedule((s){

    });
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      if (!event.gps) {
        NotyBackgroundTrack.showBigTextNotification(
          title: "GPS Bağlandı",
          body: "GPS əl ilə bağlanıb. Zəhmət olmasa yenidən aktiv edin.",
          fln: flutterLocalNotificationsPlugin,
        );
      } else {
        // GPS aktivdir.
      }
    });
    bg.BackgroundGeolocation.onNotificationAction((String action) {
      if (action == 'dismiss') {
        print("Bildiriş bağlandı və ya istifadəçi tərəfindən silindi.");
        // Xidməti yenidən başladın və ya bildirişi bərpa edin.
        bg.BackgroundGeolocation.start();
      }
    });
    await bg.BackgroundGeolocation.ready(bg.Config(
      notification: bg.Notification(
          title: "Tracking",
          text: "Background location is being tracked."
      ),
      // notification: bg.Notification(
      //   sticky: true,
      //   channelId: "zs001",
      //   channelName: "zsNotall",
      //   title: 'ZS-CONTROL - Sistem aktivdir',
      //   text: modela.customerName.toString()+"Adli markete giris edilib.",
      //   color: '#FEDD1E',
      //   priority: bg.Config.NOTIFICATION_PRIORITY_HIGH, // Bildiriş prioriteti
      //   actions: ['Silmə Bloklanıb'], // Əlavə hərəkət düymələri
      // ),
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH, // Yüksək dəqiqliklə mövqeyi izləyir.
      stopOnTerminate: false, // Tətbiq tam bağlansa belə xidməti dayandırma.
      startOnBoot: true, // Cihaz yenidən başladıldıqda avtomatik başlat.
      foregroundService: true, // Xidmət ön planda işləyəcək.
      enableHeadless: true, // Proqram arxa planda belə işləsin.

      preventSuspend: true, // Cihazın yuxuya keçməsinin qarşısını al.
      debug: true,
      distanceFilter: 0,
      disableStopDetection: true,
      pausesLocationUpdatesAutomatically: false,
      logLevel: bg.Config. LOG_LEVEL_VERBOSE,
      allowIdenticalLocations: false, // Eyni koordinatları qəbul et
      heartbeatInterval: 30, // 30 saniyədə bir heartbeat hadisəsi.
     // activityRecognitionInterval: 1
    )).then((bg.State state) async {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start(); // Xidməti başlat.
        NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin); // Bildiriş xidməti.
        await NotyBackgroundTrack.showUncleanbleNotification(
          id: 1,
          title: "ZS-CONTROL",
          body: modela.customerName.toString() + "adli markete giris etdiniz.Sistemi baglamayin!",
          fln: flutterLocalNotificationsPlugin,
        );
      }
    });


  }

  startBackgorundFetck() async {
    try {
      // Servisləri başlat
      await userService.init();
      await localBackgroundEvents.init();
      await localGirisCixisServiz.init();
      bg.BackgroundGeolocation.onEnabledChange((bool enabled) {
        if (!enabled) {
          print("BackgroundGeolocation stopped. Re-adding listeners.");
          startBackgorundFetck(); // Listener'ları tekrar ekle
        }
      });
      // BackgroundGeolocation üçün dinləyicilər
      bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) async {
        try {
          final bg.Location? initialLocation = await bg.BackgroundGeolocation.getCurrentPosition(
            persist: true,
            samples: 1,
            maximumAge: 0,
            timeout: 30,
          );
          if (initialLocation!.mock) {
            await sendErrorsToServers(
                blok, "Saxta GPS məlumatı aşkarlandı: ${initialLocation.coords}");
          } else {
            print("Yer məlumatı yeniləndi: ${initialLocation.coords.latitude}, ${initialLocation.coords.longitude}");
            cureentTime.value = DateTime.now();
            currentLatitude.value = initialLocation.coords.latitude;
            currentLongitude.value = initialLocation.coords.longitude;
            await sendInfoLocationsToDatabase(initialLocation);
          }
        } catch (e) {
          print("Heartbeat xətası: $e");
        }
      });

      // BackgroundGeolocation konfiqurasiyası
      await bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH, // Yüksək dəqiqlik
        distanceFilter: 0, // Dəyişiklikdən asılı olmayaraq məlumat topla
        //locationUpdateInterval: 10000, // 30 saniyədə bir yeniləmə
       // fastestLocationUpdateInterval: 10000, // Ən sürətli yeniləmə
        heartbeatInterval: 10, // 30 saniyədə bir heartbeat
        stopOnTerminate: false, // Proqram bağlansa belə dayanmasın
        startOnBoot: true, // Cihaz yenidən başladıqda aktiv olsun
        preventSuspend: true, // Cihaz yuxuya getməsin
        foregroundService: true, // Xidmət arxa planda işləyərkən aktiv olsun
        debug: true, // Debug logları aktiv edin
        enableHeadless: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE, // Təfərrüatlı loglar
        notification: bg.Notification(
          title: "ZS-CONTROL Aktivdir",
          text: "Fon rejimində izlənir.",
          sticky: true, // Bildiriş bağlanmasın
          channelId: "zs0001", // Unikal kanal ID
          channelName: "zs-controll", // Kanal adı
         // priority: bg.Config.NOTIFICATION_PRIORITY_MAX, // Yüksək prioritet
        ),
      )).then((bg.State state) async {
        if (!state.enabled) {
          await bg.BackgroundGeolocation.start();
        }
      });
      // Başlanğıc yer məlumatını dərhal götür
      final bg.Location? initialLocation = await bg.BackgroundGeolocation.getCurrentPosition(
        persist: true,
        samples: 1,
        maximumAge: 0,
        timeout: 30,
      );
      if (initialLocation != null) {
        print("Başlanğıc yer məlumatı: ${initialLocation.coords .latitude}, ${initialLocation.coords.longitude}");
        await sendInfoLocationsToDatabase(initialLocation);
      } } catch (e) {
      print("startBackgroundFetch xətası: $e");
    }
  }

  Future<void> stopBackGroundFetch() async {
    try {
      // Bütün bildirişləri ləğv edin
      await flutterLocalNotificationsPlugin.cancelAll();
      // Arxa plan izləmə xidmətini dayandırın
      bg.BackgroundGeolocation.removeListeners(); // Dinləyiciləri silin
      await bg.BackgroundGeolocation.stop();
    } catch (e) {
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Future<void> sendInfoLocationsToDatabase(bg.Location location) async {
    await userService.init();
    await localBackgroundEvents.init();
    await localGirisCixisServiz.init();
    await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);

    ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
    double uzaqliq=0;
    if(modela.customerCode!=null){
      uzaqliq = calculateDistance(
      location.coords.latitude,
      location.coords.longitude,
      double.parse(modela.customerLatitude!),
      double.parse(modela.customerLongitude!),
    );
    }
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    ModelUsercCurrentLocationReqeust model = ModelUsercCurrentLocationReqeust(
      sendingStatus: "0",
      batteryLevel: location.battery.level * 100,
      inputCustomerDistance: uzaqliq.round(),
      isOnline: true,
      latitude:  location.coords.latitude,
      longitude: location.coords.longitude,
      locationDate: DateTime.now().toString().substring(0, 18),
      pastInputCustomerCode: modela.customerCode??"0",
      pastInputCustomerName: modela.customerName??"0",
      locationHeading: location.coords.heading,
      speed: location.coords.speed,
      userFullName:"${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
      userCode: loggedUserModel.userModel!.code!,
      userPosition: loggedUserModel.userModel!.roleId.toString(),
    );
    if(hasConnection.isTrue){
      try{
        final response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertUserCurrentLocationRequest",
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
        if (response.statusCode != 200) {
          await localBackgroundEvents.addBackLocationToBase(model);
        }
      } on DioException catch (e) {
        await  localBackgroundEvents.addBackLocationToBase(model);
      }
    }else{
      await localBackgroundEvents.addBackLocationToBase(model);
    }

  }

  Future<void> checkUnsendedLocations() async {
    await localBackgroundEvents.init();
    int unsendedCount = localBackgroundEvents.getAllUnSendedLocations().length;
    if (unsendedCount > 0) {
      await sendInfoUnsendedLocationsToDatabase(localBackgroundEvents.getAllUnSendedLocations().first);
    }
  }

  Future<void> sendInfoUnsendedLocationsToDatabase(ModelUsercCurrentLocationReqeust model) async {
    await userService.init();
    await localBackgroundEvents.init();

    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    if(hasConnection.isTrue){
        final response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertUserCurrentLocationRequest",
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
        if (response.statusCode == 200) {
          await localBackgroundEvents.deleteItemLocation(model);
          checkUnsendedLocations();
        }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double uzaqliq = 12742 * asin(sqrt(a));
    return uzaqliq;
  }

  ////////// back errors
  Future<void> sendErrorsToServers(String xetaBasliq, String xetaaciqlama) async {
    await userService.init();
    await localBackgroundEvents.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    ModelBackErrors model = ModelBackErrors(
      userId: loggedUserModel.userModel!.id,
      deviceId: dviceType.toString(),
      errCode: xetaBasliq,
      errDate: DateTime.now().toString(),
      errName: xetaaciqlama,
      description: xetaaciqlama,
      locationLatitude: currentLatitude.toString(),
      locationLongitude: currentLongitude.toString(),
      sendingStatus: "0",
      userCode: loggedUserModel.userModel!.code,
      userFullName: "${loggedUserModel.userModel!.name} ${loggedUserModel.userModel!.surname}",
      userPosition: loggedUserModel.userModel!.roleId,
    );
    if(hasConnection.isTrue){
    final response = await ApiClient().dio(false).post(
      "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertNewBackError",
      data: model.toJson(),
      options: Options(
        headers: {
          'Lang': languageIndex,
          'Device': dviceType,
          'SMR': '12345',
          "Authorization": "Bearer $accesToken"
        },
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      if (xetaBasliq == "Block") {
        stopBackGroundFetch();
        _sistemiYenidenBaslat();
      }
    }else{
      localBackgroundEvents.addBackErrorToBase(model);
    }}else{
      localBackgroundEvents.addBackErrorToBase(model);
    }
  }

  Future<void> checkUnsendedErrors() async {
    await localBackgroundEvents.init();
    int unsendedCount = localBackgroundEvents.getAllUnSendedBckError().length;
    if (unsendedCount > 0) {
      await sendErrorsToServersUnsended(localBackgroundEvents.getAllUnSendedBckError().first);
    } else {
      await checkUnsendedLocations();
    }
  }

  Future<void> sendErrorsToServersUnsended(ModelBackErrors unsendedModel) async {
    await userService.init();
    await localBackgroundEvents.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    if(hasConnection.isTrue){
    final response = await ApiClient().dio(false).post(
      "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertNewBackError",
      data: unsendedModel.toJson(),
      options: Options(
        headers: {
          'Lang': languageIndex,
          'Device': dviceType,
          'SMR': '12345',
          "Authorization": "Bearer $accesToken"
        },
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    if (response.statusCode == 200) {
      localBackgroundEvents.deleteItemErrors(unsendedModel);
     // await checkUnsendedErrors();
    }
    }else{
      await checkUnsendedLocations();
    }
  }

  Future<bool> checkIfTimeGretherThanOneMinute(DateTime value, DateTime dateTime) async {
    int differennce = dateTime
        .difference(value)
        .inSeconds;
    if (differennce >= 59) {
      return true;
    } else {
      return false;
    }
  }

  // ckeck unsended Visits
  Future<void> checkUnsededAllVisits() async {
    await localGirisCixisServiz.init();
    int countUnsended = localGirisCixisServiz
        .getAllUnSendedGirisCixis()
        .length;
    if (countUnsended > 0) {
      ModelCustuomerVisit model = localGirisCixisServiz
          .getAllUnSendedGirisCixis()
          .first;
      _callsendAllUnsendedVisitsPoinsEnter(model);
    }
  }

  Future<void> _callsendAllUnsendedVisitsPoinsEnter(ModelCustuomerVisit modelvisit) async {
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelRequestGirisCixis model = ModelRequestGirisCixis();
    if (modelvisit.operationType == "in") {
      model = ModelRequestGirisCixis(
          userPosition: modelvisit.userPosition.toString(),
          customerCode: modelvisit.customerCode.toString(),
          note: "",
          operationLatitude: modelvisit.inLatitude.toString(),
          operationLongitude: modelvisit.inLongitude.toString(),
          operationDate: modelvisit.inDate.toString(),
          operationType: "In",
          userCode: modelvisit.userCode.toString());
    } else {
      model = ModelRequestGirisCixis(
          userPosition: modelvisit.userPosition.toString(),
          customerCode: modelvisit.customerCode.toString(),
          note: modelvisit.outNote.toString(),
          operationLatitude: modelvisit.outLatitude.toString(),
          operationLongitude: modelvisit.outLongitude.toString(),
          operationType: "Out",
          operationDate: modelvisit.outDate.toString(),
          userCode: modelvisit.userCode.toString());
    }
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final response = await ApiClient().dio(false).post(
      "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertUserCurrentLocationRequest",
      data: model.toJson(),
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
    // 404
    if (response.statusCode == 200) {
      modelvisit.gonderilme = "1";
      await localGirisCixisServiz.updateSelectedValue(modelvisit);
      int countUnsended = localGirisCixisServiz
          .getAllUnSendedGirisCixis()
          .length;
      if (countUnsended > 0) {
        ModelCustuomerVisit model = localGirisCixisServiz
            .getAllUnSendedGirisCixis()
            .first;
        await _callsendAllUnsendedVisitsPoinsEnter(model);
      }
    }
  }

  Future<void> _sistemiYenidenBaslat() async {
    Get.delete<DrawerMenuController>();
    Get.delete<UserApiControllerMobile>();
    // Get.delete<SettingPanelController>();
    Get.delete<ControllerAnbar>();
    await localBazalar.clearLoggedUserInfo();
    await localBazalar.clearAllBaseDownloads();
    Get.offAllNamed(RouteHelper.getMobileLisanceScreen());

  }

}
