import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
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
import 'package:zs_managment/utils/checking_dvice_type.dart';
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
import 'companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'language/lang_constants.dart';
import 'language/localization_controller.dart';
import 'language/model_language.dart';
import 'language/utils/messages.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;


Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyArwk-LNUsz7bPN7cgKToorBC5nwd4_y4w',
  //     appId: '1:281974451758:android:b37adf32a79ddfd0f1b9bf',messagingSenderId: '281974451758',
  //     projectId: 'zscontrollsystem'));
  await Hive.initFlutter();
  registerAdapters();
  Map<String, Map<String, String>> languages = await dep.init();
  await bg.BackgroundGeolocation.registerHeadlessTask(backgroundGeolocationHeadlessTask);
  runApp(MyApp(languages: languages));

}

void registerAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(LanguageModelAdapter()); // id-2
  }if (!Hive.isAdapterRegistered(2)) {
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
bool mobilInternetOff = false;

@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
  if (isTaskRunning) return;
  isTaskRunning = true;
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final directory = await getApplicationDocumentsDirectory();
    registerAdapters();
    Hive.init(directory.path);
  switch (headlessEvent.name) {
    case bg.Event.BOOT:
      bg.State state = await bg.BackgroundGeolocation.state;
      print("📬 didDeviceReboot: ${state.didDeviceReboot}");
      break;
    case bg.Event.HEARTBEAT:
      try {
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
          persist: false,
            samples: 1,
            timeout: 10,
            extras: {
              "event": "heartbeat",
              "headless": true
            }
        );
        if (location.mock) {
          await sendErrorsToServers("Block", "Saxta GPS məlumatı aşkarlandı ve blok edildi",location.coords.latitude.toString(),location.coords.longitude.toString());
        } else {
          print("Samir : Real location: ${location.coords.latitude}, ${location.coords.longitude}");
          await sendInfoLocationsToDatabase(location).whenComplete(() async {
            await Future.delayed(const Duration(seconds: 2)); // Sorğu cavabını gözləyin
            isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.
          });
        }
        print('[getCurrentPosition] Headless: $location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print(location);
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      if (geofenceEvent.action == 'ENTER') {
        print("Geofence-ə daxil oldunuz: ${geofenceEvent.identifier}");
      } else if (geofenceEvent.action == 'EXIT') {
        print("Geofence-dən çıxdınız: ${geofenceEvent.identifier}");
      }
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print(state);
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print(event);
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
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent event = headlessEvent.event;
      if(event.status!=bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS){
        await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet", body: "Gps icaze sistemine mudaxile edirsen.Duzelt Yada blok edileceksen.Tarix : ${DateTime.now()}", fln: flutterLocalNotificationsPlugin);

      }
      print(event);

      break;
  }}catch (e) {
    print("Samir : Error in background task: $e");
    isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.

  } finally {
    isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.
  }
}

void backgroundTaskHandler(bg.HeadlessEvent event) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await NotyBackgroundTrack.initialize(flutterLocalNotificationsPlugin);
  if (isTaskRunning) return;
  isTaskRunning = true;
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final directory = await getApplicationDocumentsDirectory();
    registerAdapters();
    Hive.init(directory.path);
    final bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
      persist: false,
      samples: 1,
      maximumAge: 0, // Həmişə yeni məlumat əldə et
      timeout: 30, // Məlumat üçün maksimum gözləmə müddəti
    );
    //sebekeni yoxla
    bool hasInternet=await checkMobileDataStatus();
    if(!hasInternet){
      await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet", body: "Mobil Interneti tecili acin yoxsa sirkete melumat gonderilcek.Tarix : ${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
      await sendErrorsToServers("Internet", "Mobil interneti el ile baglamisdir",location.coords.latitude.toString(),location.coords.longitude.toString());
      mobilInternetOff = true; // Taskı bitir
      isTaskRunning = false; // Taskı bitir
      return;
    }else{
      mobilInternetOff = false; // Taskı bitir
      await flutterLocalNotificationsPlugin.cancel(1);
    }
    // GPS statusunu yoxla
    bool isGPSEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isGPSEnabled) {
      print("Samir: GPS deaktivdir. Zəhmət olmasa aktivləşdirin.");
      await NotyBackgroundTrack.showBigTextNotificationAlarm(title: "Diqqet", body: "Mobil GPS aktivlesdirin.Eks halda girisiniz silinecel.Tarix : ${DateTime.now()}", fln: flutterLocalNotificationsPlugin);
      isTaskRunning = false; // Taskı bitir
      return;
    }else{
      await flutterLocalNotificationsPlugin.cancel(1);
    }
    // konum bilgilerini yoxla
    if (location.mock) {
      await sendErrorsToServers("Block", "Saxta GPS məlumatı aşkarlandı ve blok edildi",location.coords.latitude.toString(),location.coords.longitude.toString());
    } else {
      print("Samir : Real location: ${location.coords.latitude}, ${location.coords.longitude}");
      await sendInfoLocationsToDatabase(location).whenComplete(() async {
        await Future.delayed(const Duration(seconds: 2)); // Sorğu cavabını gözləyin
        isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.
      });
    }
  } catch (e) {
    print("Samir : Error in background task: $e");
    isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.

  } finally {
    isTaskRunning = false; // Task tamamlandı, flaqı sıfırla.
  }
}


Future<bool> checkMobileDataStatus() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile) {
    print("Mobil data aktivdir.");
    return true;
  } else {
    print("Heç bir şəbəkə bağlantısı yoxdur.");
    return false;
  }
}

Future<void> sendInfoLocationsToDatabase(bg.Location location) async {
 // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  LocalUserServices userService = LocalUserServices();
  LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
 // await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);
  await userService.init();
  await localBackgroundEvents.init();
  await localGirisCixisServiz.init();
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
    try{
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
    } on DioException catch (e) {
      await  localBackgroundEvents.addBackLocationToBase(model);
    }

}

Future<void> sendErrorsToServers(String xetaBasliq, String xetaaciqlama,String lat,String long) async {
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
    errCode: xetaBasliq,
    errDate: DateTime.now().toString(),
    errName: xetaaciqlama,
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
        BackgroudLocationServiz backgroudLocationServiz=Get.put(BackgroudLocationServiz());
        await userService.clearALLdata();
        backgroudLocationServiz.startBackgorundFetck();
      }
    }else{
     await localBackgroundEvents.addBackErrorToBase(model);
    }}on DioException catch (e) {
    await localBackgroundEvents.addBackErrorToBase(model);
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


class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key,required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  final BackgroudLocationServiz backgroudLocationServiz = Get.put(BackgroudLocationServiz());

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
    print("Samir : program yeniden acildi");
    await localGirisCixisServiz.init();
    ModelCustuomerVisit model = await localGirisCixisServiz.getGirisEdilmisMarket();
    if (model.userCode != null) {
      print("Samir : istifadeci girisdedir");

      checkAndStartServices();
    }else{
      print("Samir : istifadeci girisde deyil");

    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.resumed) {
    //   // Tətbiq yenidən açıldıqda background xidmətini aktiv et
    //   print("Tətbiq yenidən açıldı");
    //    checkAndStartServices();
    // }
  }


  void checkAndStartServices() async {
    try {
      // Xidmətin statusunu yoxla
      bg.State state = await bg.BackgroundGeolocation.state;
      await restartServices();
    } catch (e) {
      print("Samir : Xidmətlərin yoxlanması və işə salınması zamanı xəta baş verdi: $e");
    }
  }

  Future<void> restartServices() async {
    try {
      BackgroudLocationServiz backgroudLocationServiz=Get.put(BackgroudLocationServiz());
      // Xidmətləri dayandır və yenidən başlat
      await backgroudLocationServiz.stopBackGroundFetch();
      print("Samir : BackgroundGeolocation xidməti dayandırıldı.");
      await backgroudLocationServiz.startBackgorundFetck();
      print("Samir : BackgroundGeolocation xidməti işə düşdü.");
    } catch (e) {
      print("Samir : Xidmətlər yenidən başlatıla bilmədi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<LocalizationController>(builder: (localizationController){
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        theme: Get.put(ThemaController()).isDark.value
            ? darkTheme
            : lightTheme,
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


