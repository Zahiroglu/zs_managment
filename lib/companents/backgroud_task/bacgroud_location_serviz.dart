import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import '../login/services/api_services/users_apicontroller_web_windows.dart';
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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  startBackgorundFetck() {
    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      //print('[location] - $location');
      await localGirisCixisServiz.init();
      ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
      if (location.mock) {
        sendErrorsToServers(blok, modela.customerCode.toString() + "adlimarkerBlockMock".tr);
      } else {
        if (isFistTime.isTrue) {
          isFistTime.value = false;
          cureentTime.value = DateTime.now();
          currentLatitude.value = location.coords.latitude;
          currentLongitude.value = location.coords.longitude;
          await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);
          await sendInfoLocationsToDatabase(location, modela);
        }
        else {
          if (await checkIfTimeGretherThanOneMinute(
              cureentTime.value, DateTime.now())) {
            isFistTime.value = false;
            cureentTime.value = DateTime.now();
            currentLatitude.value = location.coords.latitude;
            currentLongitude.value = location.coords.longitude;
            await NotyBackgroundTrack.showBigTextNotification(
                title: "Diqqet",
                body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}",
                fln: flutterLocalNotificationsPlugin);
            await sendInfoLocationsToDatabase(location, modela);
            await checkUnsendedErrors();
          }
        }
      }
      update();
    });
    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (location.isMoving) {
      } else {
      }
    });
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent provider) async {
      switch (provider.status) {
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
          await NotyBackgroundTrack.showBigTextNotificationUpdate(
              id: 2,
              title: "Xeberdarliq",
              body:
              "Gps xidmetine mudaxile etdiyiniz ucun bloklandiniz.Tarix:${DateTime.now()}",
              fln: flutterLocalNotificationsPlugin);
          //await sendErrorsToServers("Xeberdarliq","Gps xidmetine mudaxile etdiyiniz ucun bloklandiniz.Tarix:"+DateTime.now().toString());
          break;
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
        // Android & iOS
        // console.log('- Location always granted');
          break;
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
          await NotyBackgroundTrack.showBigTextNotificationUpdate(
              id: 2,
              title: "Xeberdarliq",
              body: "Gps xidmetine mudaxile etdiyiniz ucun bloklandiniz.Tarix:${DateTime
                  .now()}",
              fln: flutterLocalNotificationsPlugin);
          // iOS only
          //console.log('- Location WhenInUse granted');
          //  await sendErrorsToServers("Xeberdarliq","Gps xidmetine mudaxile etdiyiniz ucun bloklandiniz.Tarix:"+DateTime.now().toString());
          break;
      }
    });
    bg.BackgroundGeolocation.onConnectivityChange((connection) async {
      if (!connection.connected) {
        await localGirisCixisServiz.init();
        ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
        await NotyBackgroundTrack.showBigTextNotificationUpdate(title: "Diqqet",
            body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}",
            fln: flutterLocalNotificationsPlugin);
        await sendErrorsToServers("Internet", "${modela.customerName}${"adlimarkerInternetxeta".tr}${"date".tr} : ${DateTime.now()}");
      } else {
        await flutterLocalNotificationsPlugin.cancel(1);
      }
    });
    bg.BackgroundGeolocation.onEnabledChange((bool isEnabled) {
    });

    bg.BackgroundGeolocation.ready(bg.Config(
        notification: bg.Notification(
          sticky: true,
          channelId: "zs001",
          channelName: "zsNotall",
          title: 'ZS-CONTROL-Sistem aktivdir',
          text: "${modelVisitedInfo.value.customerName} adli markete giris edilib.",
          color: '#FEDD1E',
        ),
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        // stopOnStationary: false,
        isMoving: true,
        enableHeadless: true,
        stopOnTerminate: false,
        forceReloadOnBoot: true,
        foregroundService: true,
        startOnBoot: true,
        debug: false,
        forceReloadOnSchedule: true,
        distanceFilter: 0,
        //locationUpdateInterval: 50000,//50 saniye
        locationUpdateInterval: 20000,
        //20 saniye
        maxRecordsToPersist: 1,
        backgroundPermissionRationale: PermissionRationale(
            title: "Allow {applicationName} to access to this device's location in the background?",
            message: "This app collects location data to enable tracking even when the app is closed or not in use. Please enable {backgroundPermissionOptionLabel} location permission",
            positiveAction: "Change to {backgroundPermissionOptionLabel}",
            negativeAction: "Cancel"),
        locationAuthorizationAlert: {
          'titleWhenNotEnabled': 'Yo, location-services not enabled',
          'titleWhenOff': 'Yo, location-services OFF',
          'instructions': 'You must enable "Always" in location-services, buddy',
          'cancelButton': 'Cancel',
          'settingsButton': 'Settings'
        },
        logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
        bg.BackgroundGeolocation.start();
      }
    });
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

  Future<void> sendInfoLocationsToDatabase(bg.Location location, ModelCustuomerVisit modela) async {
    await userService.init();
    await localBackgroundEvents.init();
    await localGirisCixisServiz.init();
    ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
    double uzaqliq = calculateDistance(
      location.coords.latitude,
      location.coords.longitude,
      double.parse(modela.customerLatitude!),
      double.parse(modela.customerLongitude!),
    );
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    ModelUsercCurrentLocationReqeust model = ModelUsercCurrentLocationReqeust(
      sendingStatus: "0",
      batteryLevel: location.battery.level * 100,
      inputCustomerDistance: uzaqliq.round(),
      isOnline: true,
      latitude: location.coords.latitude,
      longitude: location.coords.longitude,
      locationDate: DateTime.now().toString().substring(0, 18),
      pastInputCustomerCode: modela.customerCode,
      pastInputCustomerName: modela.customerName,
      speed: location.coords.speed,
      userFullName:
      "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!
          .surname!}",
      userCode: loggedUserModel.userModel!.code!,
      userPosition: loggedUserModel.userModel!.roleId.toString(),
    );
    localBackgroundEvents.addBackLocationToBase(model);
    final response = await ApiClient().dio(isLiveTrack: true).post(
      "${loggedUserModel.baseUrl}/api/v1/InputOutput/add-user-location",
      data: model.toJson(),
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
      model.sendingStatus = "1";
      await localBackgroundEvents.updateSelectedLocationValue(model);
    }
  }

  Future<void> checkUnsendedLocations() async {
    await localBackgroundEvents.init();
    int unsendedCount = localBackgroundEvents
        .getAllUnSendedLocations()
        .length;
    if (unsendedCount > 0) {
      await sendInfoUnsendedLocationsToDatabase(
          localBackgroundEvents
              .getAllUnSendedLocations()
              .first);
    } else {
      await checkUnsededAllVisits();
    }
  }

  Future<void> sendInfoUnsendedLocationsToDatabase(ModelUsercCurrentLocationReqeust model) async {
    await userService.init();
    await localBackgroundEvents.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final response = await ApiClient().dio(isLiveTrack: true).post(
      "${loggedUserModel.baseUrl}/api/v1/InputOutput/add-user-location",
      data: model.toJson(),
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
      model.sendingStatus = "1";
      await localBackgroundEvents.updateSelectedLocationValue(model);
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
    String time=DateTime.now().toString().substring(0,16);
    ModelBackErrors model = ModelBackErrors(
      deviceId: dviceType.toString(),
      errCode: xetaBasliq,
      errDate: time,
      errName: "",
      description: xetaaciqlama,
      locationLatitude: currentLatitude.toString(),
      locationLongitude: currentLongitude.toString(),
      sendingStatus: "0",
      userCode: loggedUserModel.userModel!.code,
      userFullName: "${loggedUserModel.userModel!.name} ${loggedUserModel.userModel!.surname}",
      userPosition: loggedUserModel.userModel!.roleId,
    );
    localBackgroundEvents.addBackErrorToBase(model);
    final response = await ApiClient().dio(isLiveTrack: true).post(
      "${loggedUserModel.baseUrl}/api/v1/User/add-user-error",
      data: model.toJson(),
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
      model.sendingStatus = "1";
      await localBackgroundEvents.updateSelectedValue(model);
      if (xetaBasliq == "Block") {
        stopBackGroundFetch();
        _sistemiYenidenBaslat();
      }
    }
  }

  Future<void> checkUnsendedErrors() async {
    await localBackgroundEvents.init();
    int unsendedCount = localBackgroundEvents
        .getAllUnSendedBckError()
        .length;
    if (unsendedCount > 0) {
      await sendErrorsToServersUnsended(localBackgroundEvents
          .getAllUnSendedBckError()
          .first);
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
    final response = await ApiClient().dio(isLiveTrack: true).post(
      "${loggedUserModel.baseUrl}/api/v1/User/add-user-error",
      data: unsendedModel.toJson(),
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
      unsendedModel.sendingStatus = "1";
      localBackgroundEvents.updateSelectedValue(unsendedModel);
      await checkUnsendedErrors();
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
    final response = await ApiClient().dio(isLiveTrack: true).post(
      "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-to-customer",
      data: model.toJson(),
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
    Get.delete<UsersApiController>();
    Get.delete<UserApiControllerMobile>();
    // Get.delete<SettingPanelController>();
    Get.delete<ControllerAnbar>();
    await localBazalar.clearLoggedUserInfo();
    await localBazalar.clearAllBaseDownloads();
    Get.offAllNamed(RouteHelper.getMobileLisanceScreen());

  }
}
