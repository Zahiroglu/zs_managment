import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:screen_state/screen_state.dart';
import 'package:zs_managment/companents/backgroud_task/backgroud_errors/model_back_error.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/notifications/noty_background_track.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import '../../helpers/user_permitions_helper.dart';
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


class BackgroudLocationServizFullTime extends GetxController {
  LocalUserServices userService = LocalUserServices();
  LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  late CheckDviceType checkDviceType = CheckDviceType();
  Rx<double> currentLatitude = 0.0.obs;
  Rx<double> currentLongitude = 0.0.obs;
  Rx<bool> isFistTime = true.obs;
  Rx<ModelCustuomerVisit> modelVisitedInfo = ModelCustuomerVisit().obs;
  static String blok="Block";
  LocalBazalar localBazalar = LocalBazalar();
  Rx<ModelCustuomerVisit> modelgirisEdilmis = ModelCustuomerVisit().obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  RxBool hereketsizdir=false.obs;
  var selectedDate = DateTime.now().obs; // `obs` ilə `DateTime` reaktiv hala gəlir
  final Screen screena = Screen();
  final Rxn<StreamSubscription<ScreenStateEvent>> _screenSubscription = Rxn<StreamSubscription<ScreenStateEvent>>();
  RxString telefonunEkrani="on".obs;
  Rx<bg.Location?> updatedLocation = Rx<bg.Location?>(null);
  UserPermitionsHelper userPermitionsHelper=UserPermitionsHelper();

  @override
  void onClose() {
    if(_screenSubscription.value!=null){
      _screenSubscription.value!.cancel();
      _screenSubscription.value = null;
    }
    super.onClose();
  }

  String startListening(ModelCustuomerVisit modela) {
    _screenSubscription.value = screena.screenStateStream.listen((ScreenStateEvent event) async {
      switch(event){
        case ScreenStateEvent.SCREEN_UNLOCKED:
          telefonunEkrani.value="unlock";
          break;
        case ScreenStateEvent.SCREEN_ON:
          telefonunEkrani.value="on";
          break;
        case ScreenStateEvent.SCREEN_OFF:
          telefonunEkrani.value="off";
          break;
      }
      if (telefonunEkrani.value == "unlock" || telefonunEkrani.value == "off") {
        await sendInfoLocationsToDatabase(updatedLocation.value!, modela);
      }
    });
    return telefonunEkrani.value;
  }

  Future<void> startBackgorundFetckFull(ModelCustuomerVisit modela) async {
    try {
      bg.BackgroundGeolocation.onMotionChange((bg.Location location) async {
       // await NotyBackgroundTrack.showBigTextNotification(title: " Hərəkət aşkarlandı", body: location.toString(), fln: flutterLocalNotificationsPlugin);
        bg.State state = await bg.BackgroundGeolocation.state;
        if (!state.enabled) {
          await startBackgorundFetckFull(modela);
        }
        currentLatitude.value = location.coords.latitude;
        currentLongitude.value = location.coords.longitude;
        await sendInfoLocationsToDatabase(location, modela);
        selectedDate.value = DateTime.now();
      });
      bg.BackgroundGeolocation.onLocation((bg.Location location) async {
        // Əgər son yeniləmə vaxtından 30 saniyə keçibsə
        if (DateTime.now().difference(selectedDate.value).inSeconds >= 30) {
          if (location.mock) {
            // Saxta GPS məlumatını serverə göndərin
            await sendErrorsToServers(
              blok,
              blok,
              "Saxta GPS məlumatı aşkarlandı:",
              location.coords.latitude.toString(),
              location.coords.longitude.toString(),
            );
          } else {
            // Mövcud koordinatları yeniləyin
            currentLatitude.value = location.coords.latitude;
            currentLongitude.value = location.coords.longitude;
            // Məlumatı serverə göndərin
            await sendInfoLocationsToDatabase(location, modela);

            // Son yeniləmə vaxtını təyin edin
            selectedDate.value = DateTime.now();

            // UI yeniləmə
            update();
          }
        } else {
        }
      }, (bg.LocationError error) {});
      bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) async {
        //await NotyBackgroundTrack.showBigTextNotification(title: "HeartbeatEvent ise dusdu", body: event.toString(), fln: flutterLocalNotificationsPlugin);

        try {
          selectedDate.value = DateTime.now();
          bg.Location? lastLocation = await bg.BackgroundGeolocation.getCurrentPosition(
            persist: false,
            samples: 1, // 400 çox ola bilər, 1-5 istifadə etmək daha yaxşıdır
            maximumAge: 60000, // 1 dəqiqəlik köhnə məlumatı istifadə edə bilər
            timeout: 10, // Maksimum 10 saniyə gözləyəcək
          );
          if (lastLocation.mock) {
            await sendErrorsToServers( blok,blok, "Saxta GPS məlumatı aşkarlandı:",lastLocation.coords.latitude.toString(),lastLocation.coords.longitude.toString());
          }
          else {
            currentLatitude.value = lastLocation.coords.latitude;
            currentLongitude.value = lastLocation.coords.longitude;
            await sendInfoLocationsToDatabase(lastLocation,modela);
          }
          bg.State state = await bg.BackgroundGeolocation.state;
          if (!state.enabled) {
            await startBackgorundFetckFull(modela);
          }
          else {
          }
          update();
        } catch (e) {
        }

      });
      bg.BackgroundGeolocation.onAuthorization((c) {

        if (c.status != bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
          sendErrorsToServers(blok,blok, "${modela.customerName} adli marketde girisde iken Gps melumatlar sistemini deyisdiyi ucun blok edildi. Gps service - $c","","");
        }
      });
      bg.BackgroundGeolocation.onActivityChange((bg.ActivityChangeEvent event) async {
        bg.State state = await bg.BackgroundGeolocation.state;
        if (state.enabled) {
          bg.BackgroundGeolocation.changePace(true);
        } else {
          await startBackgorundFetckFull(modela);
        }
        // if (event.activity == "in_vehicle" || event.activity == "on_bicycle"|| event.activity == "on_foot") {
        //   bg.BackgroundGeolocation.changePace(true); // GPS yenilənməsini aktiv et
        // }
      });
      bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) async {
        if (!event.gps) {
          NotyBackgroundTrack.showBigTextNotificationAlarm(
            title: "GPS Bağlandı",
            body: "GPS əl ilə bağlanıb. Zəhmət olmasa yenidən aktiv edin.",
            fln: flutterLocalNotificationsPlugin,
          );
        }
        else {
          await flutterLocalNotificationsPlugin.cancel(1);
        }
      });
      bg.BackgroundGeolocation.onConnectivityChange((connection) async {
        final connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult != ConnectivityResult.mobile&&connectivityResult != ConnectivityResult.wifi) {
          await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet-Internet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
          await sendErrorsToServers("Internet","Internet", "${modela.customerName} ${"adlimarkerInternetxeta".tr}${"date".tr} : ${DateTime.now()}","","");
        } else {
          //await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxetaQalxdi".tr}${"date".tr} : ${DateTime.now()}");
          await flutterLocalNotificationsPlugin.cancel(1);
        }
      });
      await bg.BackgroundGeolocation.ready(bg.Config(
        persistMode: bg.Config.PERSIST_MODE_NONE,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10,  // 📌 0 etmə, ən az 10 metr olsun
        disableElasticity: false,  // 📌 Daha çevik işləsin
        locationUpdateInterval: 30000, // 📌 Yenilənmə intervalını qısalt
        fastestLocationUpdateInterval: 10000, // 📌 Ən sürətli yenilənmə vaxtı 5 saniyə olsun
        activityRecognitionInterval: 5000,  // 📌 Aktivlik yoxlamasını 3 saniyəyə sal
        stopOnStationary: false,
        stopTimeout: 0,
        stationaryRadius: 5, // 📌 0 etmə, az da olsa radius qoy
        enableHeadless: true,
        foregroundService: true,
        preventSuspend: true,
        stopOnTerminate: false,
        startOnBoot: true,
        pausesLocationUpdatesAutomatically: false,
        forceReloadOnBoot: true,
        forceReloadOnHeartbeat: true,
        forceReloadOnMotionChange: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        // Digər parametrlər
        heartbeatInterval: 60,
        reset: true,
        backgroundPermissionRationale: bg.PermissionRationale(
            title: "Fon lokasiya icazəsi Lazımdır",
            message: "Tətbiqin fon rejimində də işləməsi üçün icazə verməlisiniz.",
            positiveAction: "Ok",
            negativeAction: "Ləğv et"
        ),
        // Bildiriş parametrləri
        notification: bg.Notification(
          title: "ZS-CONTROL",
          text: "Sistem aktivdir",
          sticky: true,
          channelId: "zs0001",
          channelName: "ZS-CONTROL",
          priority: bg.Config.NOTIFICATION_PRIORITY_HIGH, // MAX yerinə HIGH yoxla
        ),

      )
      ).then((bg.State state) async {
        if (!state.enabled) {
          await bg.BackgroundGeolocation.start();
          bg.Location? lastLocation = await bg.BackgroundGeolocation.getCurrentPosition(
            persist: false,
            samples: 2, // 400 çox ola bilər, 1-5 istifadə etmək daha yaxşıdır
            maximumAge: 60000, // 1 dəqiqəlik köhnə məlumatı istifadə edə bilər
            timeout: 10, // Maksimum 10 saniyə gözləyəcək
          );
          await sendInfoLocationsToDatabase(lastLocation,modela);
          selectedDate.value = DateTime.now();
          startListening(modela);
        }
      });

    } catch (e) {
    }
  }

  Future<bool> stopBackGroundFetch() async {
    try {
      // 📌 Tüm bildirimleri iptal et
      await flutterLocalNotificationsPlugin.cancelAll();

      // 📌 Mevcut konumu bir kere al
      final bg.Location initialLocation = await bg.BackgroundGeolocation.getCurrentPosition(
        persist: false,
        samples: 1,
        maximumAge: 0,
        timeout: 5,
      );

      // 📌 Konumu veritabanına gönder
      await sendInfoLocationsToDatabase(initialLocation, ModelCustuomerVisit());
      selectedDate.value = DateTime.now();

      // 📌 Bütün olay dinleyicilerini kaldır
      await bg.BackgroundGeolocation.removeListeners();

      // 📌 Tüm coğrafi çitleri kaldır
      await bg.BackgroundGeolocation.removeGeofences();

      // 📌 **Önemli:** Konum güncellemelerini durdur
      await bg.BackgroundGeolocation.stop();

      // 📌 **Tamamen servisleri kapat (Ekstra güvenlik için)**
      await bg.BackgroundGeolocation.destroyLocations();  // 📌 Kaydedilmiş tüm konumları sil
      await bg.BackgroundGeolocation.stopSchedule();      // 📌 Zamanlanmış görevleri iptal et

      // 📌 Tüm arka plan dinleyicilerini kapat
      //await stopAllListening();

      // 📌 GetX ile servisi kaldır
      await Get.delete<BackgroudLocationServizFullTime>();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void stopTracking(int endDate, ModelCustuomerVisit modela) async {
    await userService.init();
    DateTime now = DateTime.now();
    if (now.hour >= endDate) {
      await stopBackGroundFetch();
      Get.delete<BackgroudLocationServizFullTime>();
    }
  }

  Future<void> sendInfoLocationsToDatabase(bg.Location location, ModelCustuomerVisit modelBirinci) async {
    updatedLocation.value=location;
    await userService.init();
    await localBackgroundEvents.init();
    await localGirisCixisServiz.init();
    ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
    String ent=userPermitionsHelper.getUserWorkTime(userService.getLoggedUser().userModel!.configrations!)[1].substring(0,2);
    double uzaqliq=0;
    if(modela.customerCode!=null){
      uzaqliq = calculateDistanceInMeters(
        location.coords.latitude,
        location.coords.longitude,
        double.parse(modela.customerLongitude!),
        double.parse(modela.customerLatitude!),
      );
    }
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    ModelUsercCurrentLocationReqeust model = ModelUsercCurrentLocationReqeust(
      screenState: telefonunEkrani.value,
      sendingStatus: "0",
      batteryLevel: (location.battery.level * 100).roundToDouble(),
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
      locAccuracy: location.coords.accuracy,
      isMoving: location.isMoving,
    );
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none){
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
          model.sendingStatus="0";
          await localBackgroundEvents.addBackLocationToBase(model);
        }
        else{
          checkUnsendedLocations();
          checkUnsendedErrors();
          if(location.coords.accuracy<50){
            if(uzaqliq>1000){
              NotyBackgroundTrack.showBigTextNotificationAlarm(
                title: "Marketden Uzaqlasirsan",
                body: "Marketden cox uzaqlasirsan.Zehmet olmasa geri don",
                fln: flutterLocalNotificationsPlugin,
              );
              await sendErrorsToServers("Distance","Uzaqlasma",  "${modela.customerName} adli marketden teyin edilmis mesafeden cox uzaqdir.Cari uzqliq : ${uzaqliq.round()} m",location.coords.latitude.toString(),location.coords.longitude.toString());
            }
          }}
      } on DioException {
        model.sendingStatus="0";
        await  localBackgroundEvents.addBackLocationToBase(model);
      }
    }else{
      model.sendingStatus="0";
      await localBackgroundEvents.addBackLocationToBase(model);
      await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet-Internet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
      await sendErrorsToServers("Internet","Internet", "${modela.customerName} ${"adlimarkerInternetxeta".tr}${"date".tr} : ${DateTime.now()}","","");
    }
    stopTracking(int.parse(ent.toString()),modela);
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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      String accesToken = loggedUserModel.tokenModel!.accessToken!;
      final response = await ApiClient().dio(false).post(
        "${loggedUserModel
            .baseUrl}/GirisCixisSystem/InsertUserCurrentLocationRequest",
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
    }else{

    }
  }

  double calculateDistanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // Radians conversion factor
    var c = cos;
    final double a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double distanceInKm = 12742 * asin(sqrt(a)); // Earth's diameter in kilometers
    return distanceInKm * 1000; // Convert to meters
  }

  ////////// back errors
  Future<void> sendErrorsToServers(String errorCode,String xetaBasliq, String xetaaciqlama,String lat,String long) async {
    LocalUserServices userService = LocalUserServices();
    LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
    LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
    // await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);
    await userService.init();
    await localBackgroundEvents.init();
    await localGirisCixisServiz.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    ModelBackErrors model = ModelBackErrors(
      userId: loggedUserModel.userModel!.id,
      deviceId: loggedUserModel.userModel!.deviceId!,
      errCode: errorCode,
      errDate: DateTime.now().toString(),
      errName: xetaBasliq,
      description: xetaaciqlama,
      locationLatitude: lat,
      locationLongitude: long,
      sendingStatus: "0",
      userCode: loggedUserModel.userModel!.code,
      userFullName: "${loggedUserModel.userModel!.name} ${loggedUserModel.userModel!.surname}",
      userPosition: loggedUserModel.userModel!.roleId,
    );
    try{
      final response = await ApiClient().dio(false).post(
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
        if (xetaBasliq == "Block") {
          await userService.clearALLdata();
          stopBackGroundFetch();
          sistemiYenidenBaslat();
        }
      }else{
        model.sendingStatus="0";
        await localBackgroundEvents.addBackErrorToBase(model);
      }}on DioException {
      model.sendingStatus="0";
      await localBackgroundEvents.addBackErrorToBase(model);
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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none){
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

  ///////// ckeck unsended visits
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

  Future<void> sistemiYenidenBaslat() async {
    Get.delete<DrawerMenuController>();
    Get.delete<UserApiControllerMobile>();
    // Get.delete<SettingPanelController>();
    Get.delete<ControllerAnbar>();
    await localBazalar.clearLoggedUserInfo();
    await localBazalar.clearAllBaseDownloads();
    Get.offAllNamed(RouteHelper.getMobileLisanceScreen());

  }


}