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



  Future<void> startBackgorundFetck(ModelCustuomerVisit modela) async {
    try {
      // Servisləri başlat
      await userService.init();
      await localBackgroundEvents.init();
      await localGirisCixisServiz.init();
      bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) async {
        try {
          final bg.Location? initialLocation = await bg.BackgroundGeolocation.getCurrentPosition(
            persist: false,
            samples: 400,
            maximumAge: 0,
            timeout: 30,
          );
          if (initialLocation!.mock) {
            await sendErrorsToServers( blok, "Samir :Saxta GPS məlumatı aşkarlandı: ${initialLocation.coords}");
          } else {
            cureentTime.value = DateTime.now();
            currentLatitude.value = initialLocation.coords.latitude;
            currentLongitude.value = initialLocation.coords.longitude;
            await sendInfoLocationsToDatabase(initialLocation);
          }
        } catch (e) {
          print("Samir :Heartbeat xətası: $e");
        }
      });
      bg.BackgroundGeolocation.onActivityChange((a) {
        print("Samir activity deyisdi" +a.toString());
      });
      bg.BackgroundGeolocation.onAuthorization((c) {
        // if (c == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED) {
        //   print("GPS icazəsi rədd edildi.");
        // } else
        if (c != bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
          sendErrorsToServers(blok, "${modela.customerCode}marketde girisde iken Gps melumatlar sistemini deyisdiyi ucun blok edildi. Gps service - $c");
        }
      });
      bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) async {
        if (!event.gps) {
          NotyBackgroundTrack.showBigTextNotificationAlarm(
            title: "GPS Bağlandı",
            body: "GPS əl ilə bağlanıb. Zəhmət olmasa yenidən aktiv edin.",
            fln: flutterLocalNotificationsPlugin,
          );
        } else {
          await flutterLocalNotificationsPlugin.cancel(1);
        }
      });
      bg.BackgroundGeolocation.onConnectivityChange((connection) async {
        hasConnection.value=connection.connected;
        if (!connection.connected) {
          await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
           await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxeta".tr}${"date".tr} : ${DateTime.now()}");
        } else {
          //await sendErrorsToServers("Internet", "${modela.customerName} ${"adlimarkerInternetxetaQalxdi".tr}${"date".tr} : ${DateTime.now()}");
          await flutterLocalNotificationsPlugin.cancel(1);
        }
      });
        bg.BackgroundGeolocation.addGeofence(bg.Geofence(
            identifier: modela.customerName!,   // Geofence üçün unikal ad
            radius: 500,            // Radius (metr)
            latitude: double.parse(modela.customerLatitude!),      // Coğrafi enlik (məsələn, Bakının mərkəzi)
            longitude:  double.parse(modela.customerLongitude!),     // Coğrafi uzunluq
            notifyOnEntry: true,    // Daxil olduqda xəbərdar et
            notifyOnExit: true,     // Çıxdıqda xəbərdar et
            notifyOnDwell: false,    // Geofence daxilində müəyyən müddət qaldıqda xəbərdar et
            ///loiteringDelay: 30000   // Dwell üçün gecikmə (milisaniyə ilə)
        )).then((bool success) {
          if (success) {
            print("Geofence əlavə edildi!");
          }
        }).catchError((error) {
          print("Geofence əlavə edilərkən xəta baş verdi: $error");
        });
      await bg.BackgroundGeolocation.ready(bg.Config(
        persistMode: bg.Config.PERSIST_MODE_NONE,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 0,
        locationUpdateInterval: 60000, // Yer məlumatlarını hər 30 saniyədən bir yenilə
        fastestLocationUpdateInterval: 60000, // Ən sürətli yeniləmə 30 saniyə
        heartbeatInterval: 60, // 60 saniyədə bir heartbeat
        stopOnTerminate: false,
        startOnBoot: true,
        preventSuspend: true,
        foregroundService: true,
        debug: false,
        enableHeadless: true,
        notification: bg.Notification(
          title: "ZS-CONTROL Aktivdir",
          text: "Fon rejimində izlənir.",
          sticky: true, // Bildiriş sabitdir
          channelId: "zs0001",
          channelName: "zs-controll",
          strings: {
            "myCustomElement": "My Custom Element Text"
          },
          priority: bg.Config.NOTIFICATION_PRIORITY_MAX, // Yüksək prioritet
        ),
      )).then((bg.State state) async {
        if (!state.enabled) {
          await bg.BackgroundGeolocation.start();
        }
      });
      // Başlanğıc yer məlumatını dərhal götür
      final bg.Location? initialLocation = await bg.BackgroundGeolocation.getCurrentPosition(
        persist: false,
        samples: 2,
        maximumAge: 0,
        timeout: 5,
      );
      if (initialLocation != null) {
        await sendInfoLocationsToDatabase(initialLocation);
      } } catch (e) {
      print("Samir : startBackgroundFetch xətası: $e");
    }
  }

  Future<bool> stopBackGroundFetch() async {
    try {
      // Bütün bildirişləri ləğv edin
      await flutterLocalNotificationsPlugin.cancelAll();

      // Dinləyiciləri silin
      await bg.BackgroundGeolocation.removeListeners();
      await bg.BackgroundGeolocation.removeGeofences();
      await bg.BackgroundGeolocation.stop();
      print("stopBackGroundFetch dayandi");
      return true;
        } catch (e) {
      print("stopBackGroundFetch xeta : " + e.toString());
      return false;
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
        await stopBackGroundFetch();
        await sistemiYenidenBaslat();
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
