import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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


Future<void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyArwk-LNUsz7bPN7cgKToorBC5nwd4_y4w',
  //     appId: '1:281974451758:android:b37adf32a79ddfd0f1b9bf',messagingSenderId: '281974451758',
  //     projectId: 'zscontrollsystem'));
  await Hive.initFlutter();
  registerAdapters();
  Map<String, Map<String, String>> languages = await dep.init();
  await bg.BackgroundGeolocation.registerHeadlessTask(backgroundTaskHandler);
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

void backgroundTaskHandler(bg.HeadlessEvent event) async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  registerAdapters();
  Hive.init(directory.path); // Yolu avtomatik olaraq təyin edir
  final bg.Location location = await bg.BackgroundGeolocation
      .getCurrentPosition(
    persist: true,
    samples: 1,
  );
  if (location.mock) {
    print("Mock location detected: ${location.coords}");
    // Saxta yer məlumatlarını serverə göndərin
  } else {
    print("Real location: ${location.coords.latitude}, ${location.coords
        .longitude}");
    // Doğru yer məlumatını serverə göndərin
    await sendInfoLocationsToDatabase(location);
  }
}
  // Yer Hadisəsi
  // if (event.event is bg.Location) {
  //   final bg.Location location = event.event as bg.Location;
  //   if (location.mock) {
  //     print("Mock location detected: ${location.coords}");
  //     // Saxta yer məlumatlarını serverə göndərin
  //   } else {
  //     print("Real location: ${location.coords.latitude}, ${location.coords.longitude}");
  //     // Doğru yer məlumatını serverə göndərin
  //     await sendInfoLocationsToDatabase(location);
  //   }
  // }

  // // Heartbeat Hadisəsi
  // else if (event.event is bg.HeartbeatEvent) {
  //   print("[HeadlessTask] Heartbeat event received");
  //   try {
  //     final bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
  //       persist: true,
  //       samples: 1,
  //     );
  //     if (location.mock) {
  //       print("Mock location detected: ${location.coords}");
  //       // Saxta yer məlumatlarını serverə göndərin
  //     } else {
  //       print("Real location: ${location.coords.latitude}, ${location.coords.longitude}");
  //       // Doğru yer məlumatını serverə göndərin
  //       await sendInfoLocationsToDatabase(location);
  //     }
  //   } catch (e) {
  //     print("[HeadlessTask] Error fetching location: $e");
  //   }
  // }
  //
  // // Naməlum Hadisə
  // else {
  //   print("[HeadlessTask] Unknown event type received: ${event.name}");
  // }




Future<void> sendInfoLocationsToDatabase(bg.Location location) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  LocalUserServices userService = LocalUserServices();
  LocalBackgroundEvents localBackgroundEvents = LocalBackgroundEvents();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();  await userService.init();
  late CheckDviceType checkDviceType = CheckDviceType();
  await NotyBackgroundTrack.showBigTextNotification(title: "Diqqet", body: "Konum Deyisdi Gps :${location.coords.latitude},${location.coords.longitude}", fln: flutterLocalNotificationsPlugin);
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
  //LanguageModel languageIndex = await getLanguageIndex();
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
    try{
      final response = await ApiClient().dio(false).post(
        "${loggedUserModel.baseUrl}/GirisCixisSystem/InsertUserCurrentLocationRequest",
        data: model.toJson(),
        options: Options(
          headers: {
            'Lang': "az",
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

}

Future<LanguageModel> getLanguageIndex() async {

  final LocalizationController localizationController = Get.put(LocalizationController(Hive.box('myLanguage')));

  return await localizationController.getlastLanguage();
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      print("Program arxa panele kecdi");
      // Burada background location servisini başlatmaq
      await localGirisCixisServiz.init();
      ModelCustuomerVisit model=await localGirisCixisServiz.getGirisEdilmisMarket();
      if(model.userCode== null){
      await bg.BackgroundGeolocation.stop();
      await bg.BackgroundGeolocation.start();
      print("serviz yeniden basladildi");
      }
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


