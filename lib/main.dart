import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_state/screen_state.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/backgroud_task/bacgroud_location_fulltime.dart';
import 'package:zs_managment/companents/backgroud_task/bacgroud_location_serviz.dart';
import 'package:zs_managment/companents/backgroud_task/backgroud_errors/local_backgroud_events.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/notifications/noty_background_track.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carihereket.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carikassa.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/dio_config/api_client_back.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/global_models/model_maptypeapp.dart';
import 'package:zs_managment/language/utils/dep.dart' as dep;
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/thema/theme_constants.dart';
import 'companents/backgroud_task/backgroud_errors/model_back_error.dart';
import 'companents/backgroud_task/backgroud_errors/model_user_current_location_reqeust.dart';
import 'companents/base_downloads/models/model_cariler.dart';
import 'companents/base_downloads/models/model_downloads.dart';
import 'companents/giris_cixis/models/model_customers_visit.dart';
import 'companents/local_bazalar/local_giriscixis.dart';
import 'companents/login/models/logged_usermodel.dart';
import 'companents/login/models/model_company.dart';
import 'companents/login/models/model_configrations.dart';
import 'companents/login/models/model_regions.dart';
import 'companents/login/models/model_token.dart';
import 'companents/login/models/model_userconnnection.dart';
import 'companents/login/models/model_userspormitions.dart';
import 'companents/login/models/user_model.dart';
import 'companents/notifications/firebase_notificatins.dart';
import 'companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'helpers/user_permitions_helper.dart';
import 'language/lang_constants.dart';
import 'language/localization_controller.dart';
import 'language/model_language.dart';
import 'language/utils/messages.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:firebase_core/firebase_core.dart';

bool isHeadlessTaskRegistered = false; // Kaydın olup olmadığını kontrol etmek için bir değişken

StreamSubscription<ScreenStateEvent>? _screenSubscription;
final Screen screena = Screen();
String telefonunEkrani="on";
bg.Location? updatedLocation = bg.Location(null);


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyArwk-LNUsz7bPN7cgKToorBC5nwd4_y4w',
          appId: '1:281974451758:android:b37adf32a79ddfd0f1b9bf',
          messagingSenderId: '281974451758',
          projectId: 'zscontrollsystem'));
  registerAdapters();
  ///FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  Map<String, Map<String, String>> languages = await dep.init();

  // Headless task yalnızca bir kez kaydedilsin
  if (!isHeadlessTaskRegistered) {
    await bg.BackgroundGeolocation.registerHeadlessTask(backgroundTaskHandler);
    isHeadlessTaskRegistered = true; // Kaydettikten sonra bayrağı güncelle
  }


  runApp(MyApp(languages: languages));
}

void registerAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(LanguageModelAdapter()); // id-2
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(LoggedUserModelAdapter()); // id-2
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(TokenModelAdapter()); // id-3
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(CompanyModelAdapter()); // id-4
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(UserModelAdapter()); // id-5
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(ModelUserConnectionAdapter()); // id-6
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(ModelUserPermissionsAdapter()); // id-7
  }
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(ModelModuleAdapter()); // id-8
  }
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(ModelRegionsAdapter()); // id-9
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(ModelAppSettingAdapter()); // id-10
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(ModelMapAppAdapter()); // id-11
  }
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(CustomMapTypeAdapter()); // id-12
  }
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(ModelCustuomerVisitAdapter()); // id-13
  }
  if (!Hive.isAdapterRegistered(22)) {
    Hive.registerAdapter(ModelAnbarRaporAdapter()); // id-22
  }
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(ModelCarilerAdapter()); // id-22
  }
  if (!Hive.isAdapterRegistered(23)) {
    Hive.registerAdapter(ModelDownloadsAdapter()); // id-23
  }
  if (!Hive.isAdapterRegistered(24)) {
    Hive.registerAdapter(ModelCariHereketAdapter()); // id-24
  }
  if (!Hive.isAdapterRegistered(25)) {
    Hive.registerAdapter(ModelCariKassaAdapter()); // id-25
  }
  if (!Hive.isAdapterRegistered(26)) {
    Hive.registerAdapter(DayAdapter()); // id-26
  }
  if (!Hive.isAdapterRegistered(27)) {
    Hive.registerAdapter(MercDataModelAdapter()); // id-27
  }
  if (!Hive.isAdapterRegistered(28)) {
    Hive.registerAdapter(MercCustomersDatailAdapter()); // id-28
  }
  if (!Hive.isAdapterRegistered(29)) {
    Hive.registerAdapter(SellingDataAdapter()); // id-29
  }
  if (!Hive.isAdapterRegistered(30)) {
    Hive.registerAdapter(UserMercAdapter()); // id-30
  }
  if (!Hive.isAdapterRegistered(31)) {
    Hive.registerAdapter(ModelBackErrorsAdapter()); // id-31
  }
  if (!Hive.isAdapterRegistered(32)) {
    Hive.registerAdapter(ModelUsercCurrentLocationReqeustAdapter()); // id-32
  }
  if (!Hive.isAdapterRegistered(33)) {
    Hive.registerAdapter(ModelConfigrationsAdapter()); // id-33
  }
  if (!Hive.isAdapterRegistered(34)) {
    Hive.registerAdapter(ModelMainInOutAdapter()); // id-34
  }
  if (!Hive.isAdapterRegistered(35)) {
    Hive.registerAdapter(ModelInOutDayAdapter()); // id-35
  }
  if (!Hive.isAdapterRegistered(36)) {
    Hive.registerAdapter(ModelInOutAdapter()); // id-36
  }
  if (!Hive.isAdapterRegistered(37)) {
    Hive.registerAdapter(MotivationDataAdapter()); // id-37
  }
}

bool isTaskRunning = false;

String  startListening(bg.Location location,FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  _screenSubscription = screena.screenStateStream.listen((ScreenStateEvent event) async {
    switch(event){
      case ScreenStateEvent.SCREEN_UNLOCKED:
        telefonunEkrani="unlock";
        break;
      case ScreenStateEvent.SCREEN_ON:
        telefonunEkrani="on";
        break;
      case ScreenStateEvent.SCREEN_OFF:
        telefonunEkrani="off";
        break;
    }
    if (telefonunEkrani == "unlock" || telefonunEkrani == "off") {
      await sendInfoLocationsToDatabase(location,flutterLocalNotificationsPlugin,telefonunEkrani);
    }
  });
  return telefonunEkrani;
  // Başqa stream-lər üçün də eyni şəkildə dinləyicilər əlavə edilə bilər
}


@pragma('vm:entry-point')
void backgroundTaskHandler(bg.HeadlessEvent event) async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
  final directory = await getApplicationDocumentsDirectory();
  if(_screenSubscription!=null){
    _screenSubscription!.cancel();
    _screenSubscription = null;
  }
  registerAdapters();
  Hive.init(directory.path);
  WidgetsFlutterBinding.ensureInitialized();
  switch (event.name) {
    case bg.Event.BOOT:
      break;
    case bg.Event.ACTIVITYCHANGE:
      break;
    case bg.Event.POWERSAVECHANGE:
      // bool enabled = headlessEvent.event;
      // print(enabled);
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile||connectivityResult != ConnectivityResult.wifi) {
        await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
        await sendErrorsToServers("Internet","Internet","mobilInternetXeta".tr,"","");
      } else {
        await flutterLocalNotificationsPlugin.cancel(1);
      }
      break;
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent eventa = event.event;
      if (eventa.status != bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
        await NotyBackgroundTrack.showBigTextNotificationAlarm(
            title: "Diqqet",
            body:
                "Gps icaze sistemine mudaxile edirsen.Duzelt Yada blok edileceksen.Tarix : ${DateTime.now()}",
            fln: flutterLocalNotificationsPlugin);
        sendErrorsToServers(
            "Block",
            "Block",
            "Gps icaze sistemine mudaxile edirsen.Duzelt Yada blok edileceksen",
            "0",
            "0");
        isTaskRunning = false;
      }
      break;
    case bg.Event.LOCATION:
      bg.Location location = event.event;
      sendLocation(location, flutterLocalNotificationsPlugin);
      break;
      case bg.Event.MOTIONCHANGE:
        try {
          bg.Location? lastLocation = await bg.BackgroundGeolocation.getCurrentPosition(
            persist: false,
            samples: 3, // 400 çox ola bilər, 1-5 istifadə etmək daha yaxşıdır
            maximumAge: 60000, // 1 dəqiqəlik köhnə məlumatı istifadə edə bilər
            timeout: 10, // Maksimum 10 saniyə gözləyəcək
          );
          sendLocation(lastLocation, flutterLocalNotificationsPlugin);
        } catch (error) {
        }
        break;
    case "heartbeat":
      try {
        bg.Location? lastLocation = await bg.BackgroundGeolocation.getCurrentPosition(
          persist: false,
          samples: 3, // 400 çox ola bilər, 1-5 istifadə etmək daha yaxşıdır
          maximumAge: 60000, // 1 dəqiqəlik köhnə məlumatı istifadə edə bilər
          timeout: 10, // Maksimum 10 saniyə gözləyəcək
        );
        sendLocation(lastLocation, flutterLocalNotificationsPlugin);
      } catch (error) {
      }
      break;
  }
  if (_screenSubscription == null) {
    startListening(updatedLocation!,flutterLocalNotificationsPlugin);
  }
}

Future<void> sendLocation(bg.Location location, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  bool isGPSEnabled = await Geolocator.isLocationServiceEnabled();
  updatedLocation=location;
  if (!isGPSEnabled) {
    await NotyBackgroundTrack.showBigTextNotificationAlarm(
        title: "Diqqet",
        body: "Mobil GPS aktivlesdirin.Eks halda girisiniz silinecel.Tarix : ${DateTime.now()}",
        fln: flutterLocalNotificationsPlugin);
    isTaskRunning = false; // Taskı bitir
    return;
  } else {
    isTaskRunning = false; // Taskı bitir
    await flutterLocalNotificationsPlugin.cancel(1);
  }
  // konum bilgilerini yoxla
  if (location.mock) {
    await sendErrorsToServers(
        "Block",
        "Block",
        "Saxta GPS məlumatı aşkarlandı ve blok edildi",
        location.coords.latitude.toString(),
        location.coords.longitude.toString());
    isTaskRunning = false; // Taskı bitir
  } else {
    await sendInfoLocationsToDatabase(location, flutterLocalNotificationsPlugin,telefonunEkrani).whenComplete(() async {
      await Future.delayed(
          const Duration(seconds: 2)); // Sorğu cavabını gözləyin
      isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.
    });
  }
}

Future<bool> checkMobileDataStatus() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.mobile&&connectivityResult != ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

Future<void> sendInfoLocationsToDatabase(bg.Location location, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, String telefonunEkrani) async {
  LocalUserServices userService = LocalUserServices();
  LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  UserPermitionsHelper userPermitionsHelper = UserPermitionsHelper();
  await userService.init();
  await localBackgroundEvents.init();
  await localGirisCixisServiz.init();
  String ent = userPermitionsHelper.getUserWorkTime(userService.getLoggedUser().userModel!.configrations!)[1].substring(0, 2);
  ModelCustuomerVisit modela = await localGirisCixisServiz.getGirisEdilmisMarket();
  double uzaqliq = 0;
  if (modela.customerCode != null) {
    uzaqliq = calculateDistanceInMeters(
      location.coords.latitude,
      location.coords.longitude,
      double.parse(modela.customerLongitude!),
      double.parse(modela.customerLatitude!),
    );
  }
  if (userPermitionsHelper.liveTrack(userService.getLoggedUser().userModel!.configrations!)) {
    stopTracking(int.parse(ent), modela);
  }
  LoggedUserModel loggedUserModel = userService.getLoggedUser();
  String accesToken = loggedUserModel.tokenModel!.accessToken!;
  ModelUsercCurrentLocationReqeust model = ModelUsercCurrentLocationReqeust(
    screenState: telefonunEkrani,
    sendingStatus: "0",
    batteryLevel: (location.battery.level * 100).roundToDouble(),
    inputCustomerDistance: uzaqliq.round(),
    isOnline: true,
    latitude: location.coords.latitude,
    longitude: location.coords.longitude,
    locationDate: DateTime.now().toString().substring(0, 18),
    pastInputCustomerCode: modela.customerCode ?? "0",
    pastInputCustomerName: modela.customerName ?? "0",
    locationHeading: location.coords.heading,
    speed: location.coords.speed,
    userFullName:
        "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
    userCode: loggedUserModel.userModel!.code!,
    userPosition: loggedUserModel.userModel!.roleId.toString(),
    locAccuracy: location.coords.accuracy,
    isMoving: location.isMoving,
  );
  try {
    final response = await ApiClientBack().dio(false).post(
          "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertUserCurrentLocationRequest",
          data: model.toJson(),
          options: Options(
            headers: {
              'Lang': "az",
              'Device': 1,
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
    if (location.coords.accuracy < 50) {
      if (uzaqliq > 1000) {
        await sendErrorsToServers(
            "Distance",
            "Uzaqlasma",
            modela.customerName ??
                "Bilinmeyen adli marketden teyin edilmis mesafeden cox uzaqdir.Cari uzqliq : ${uzaqliq.round()} m",
            location.coords.latitude.toString(),
            location.coords.longitude.toString());
      }
    }
  } on DioException {
    await localBackgroundEvents.addBackLocationToBase(model);
  }
}

void stopTracking(int endDate, ModelCustuomerVisit modela) async {
  DateTime now = DateTime.now();
  if (now.hour >= endDate) {
    if (modela.outLongitude != ""&&modela.outLongitude!=null) {
      await bg.BackgroundGeolocation.stop();
    }
  }
}

Future<void> sendErrorsToServers(String errorCode, String xetaBasliq, String xetaaciqlama, String lat, String long) async {
  LocalUserServices userService = LocalUserServices();
  LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
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
    userFullName:
        "${loggedUserModel.userModel!.name} ${loggedUserModel.userModel!.surname}",
    userPosition: loggedUserModel.userModel!.roleId,
  );
  try {
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
        BackgroudLocationServiz backgroudLocationServiz = Get.put(BackgroudLocationServiz());
        await userService.clearALLdata();
        await backgroudLocationServiz.stopBackGroundFetch();
        await backgroudLocationServiz.sistemiYenidenBaslat();
      }
    } else {
      await localBackgroundEvents.addBackErrorToBase(model);
    }
  } on DioException {
    await localBackgroundEvents.addBackErrorToBase(model);
  }
}

double calculateDistanceInMeters(
    double lat1, double lon1, double lat2, double lon2) {
  const double p = 0.017453292519943295; // Radians conversion factor
  var c = cos;
  final double a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  double distanceInKm = 12742 * asin(sqrt(a)); // Earth's diameter in kilometers
  return distanceInKm * 1000; // Convert to meters
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  LocalUserServices userService = LocalUserServices();
  UserPermitionsHelper userPermitionHelper = UserPermitionsHelper();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  FirebaseNotyficationController firebaseNotyficationController = FirebaseNotyficationController();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkIfFirstTimeOpened();
    super.initState();
  }

  Future<void> checkIfFirstTimeOpened() async {
    await localGirisCixisServiz.init();
    await userService.init();
    await firebaseNotyficationController.fireBaseMessageInit();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    if (loggedUserModel.userModel != null) {
      ModelCustuomerVisit model = await localGirisCixisServiz.getGirisEdilmisMarket();
      if (userPermitionHelper.liveTrack(loggedUserModel.userModel!.configrations!)) {
        int count= localGirisCixisServiz.getAllGirisCixisToday().length;
        if(count>0){
          checkAndStartServicesFull(model);
      }
      } else {
        if (model.userCode != null) {
          checkAndStartServices(model);
        }
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
  }

  void checkAndStartServices(ModelCustuomerVisit model) async {
    try {
      // Xidmətin statusunu yoxla
      await restartServices(model);
    } catch (e) {
    }
  }

  void checkAndStartServicesFull(ModelCustuomerVisit model) async {
    try {
      await restartServicesFull(model);
    } catch (e) {
    }
  }

  Future<void> restartServices(ModelCustuomerVisit model) async {
    try {
    //  stopAllListening();
      await Get.delete<BackgroudLocationServiz>();
      BackgroudLocationServiz backgroudLocationServiz = Get.put(BackgroudLocationServiz());
      // Xidmətləri dayandır və yenidən başlat
      await backgroudLocationServiz.stopBackGroundFetch();
      await backgroudLocationServiz.startBackgorundFetck(model);
    } catch (e) {
    }
  }

  Future<void> restartServicesFull(ModelCustuomerVisit model) async {
    try {
    //  stopAllListening();
      await Get.delete<BackgroudLocationServizFullTime>();
      BackgroudLocationServizFullTime backgroudLocationServiz = Get.put(BackgroudLocationServizFullTime());
      await backgroudLocationServiz.stopBackGroundFetch();
      await backgroudLocationServiz.startBackgorundFetckFull(model);
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        theme: Get.put(ThemaController()).isDark.value ? darkTheme : lightTheme,
        themeMode: Get.put(ThemaController()).isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: localizationController.locale,
        translations: Messages(languages: widget.languages),
        fallbackLocale: Locale(LangConstants.languages[0].languageCode,
            LangConstants.languages[0].countryCode),
        initialRoute: RouteHelper.getWellComeScreen(),
        //initialRoute: RouteHelper.getMobileMainScreen(),
        getPages: RouteHelper.routes,
        defaultTransition: Transition.topLevel,
      );
    });
  }
}
