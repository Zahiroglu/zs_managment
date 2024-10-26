import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/backgroud_task/bacgroud_location_serviz.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carihereket.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/models/model_carikassa.dart';
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
import 'companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'language/lang_constants.dart';
import 'language/localization_controller.dart';
import 'language/utils/messages.dart';


Future<void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyArwk-LNUsz7bPN7cgKToorBC5nwd4_y4w',
  //     appId: '1:281974451758:android:b37adf32a79ddfd0f1b9bf',messagingSenderId: '281974451758',
  //     projectId: 'zscontrollsystem'));
  await Hive.initFlutter();
  Map<String, Map<String, String>> languages = await dep.init();
  //sonuncu HiveType 37-di
  Hive.registerAdapter(MotivationDataAdapter());//id-37
  Hive.registerAdapter(ModelInOutAdapter());//id-36
  Hive.registerAdapter(ModelInOutDayAdapter());//id-35
  Hive.registerAdapter(ModelMainInOutAdapter());//id-34
  Hive.registerAdapter(ModelConfigrationsAdapter());//id-33
  Hive.registerAdapter(ModelBackErrorsAdapter());//id-31
  Hive.registerAdapter(ModelUsercCurrentLocationReqeustAdapter());//id-32
  Hive.registerAdapter(ModelAnbarRaporAdapter());
  Hive.registerAdapter(LoggedUserModelAdapter());
  Hive.registerAdapter(ModelAppSettingAdapter());
  Hive.registerAdapter(ModelMapAppAdapter());
  Hive.registerAdapter(CustomMapTypeAdapter());
  Hive.registerAdapter(ModelCustuomerVisitAdapter());
  Hive.registerAdapter(CompanyModelAdapter());
  Hive.registerAdapter(ModelRegionsAdapter());
  Hive.registerAdapter(TokenModelAdapter());
  Hive.registerAdapter(ModelUserConnectionAdapter());
  Hive.registerAdapter(ModelUserPermissionsAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ModelModuleAdapter());
  Hive.registerAdapter(ModelCarilerAdapter());
  Hive.registerAdapter(ModelDownloadsAdapter());
  Hive.registerAdapter(ModelCariHereketAdapter());
  Hive.registerAdapter(ModelCariKassaAdapter());
  Hive.registerAdapter(DayAdapter());
  Hive.registerAdapter(MercDataModelAdapter());
  Hive.registerAdapter(MercCustomersDatailAdapter());
  Hive.registerAdapter(SellingDataAdapter());
  Hive.registerAdapter(UserMercAdapter());
  runApp(MyApp(languages: languages));

}


class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key,required this.languages});
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  BackgroudLocationServiz backgroudLocationServiz=BackgroudLocationServiz();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();

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

    bool isUpDestroyed=state==AppLifecycleState.detached;
    if(isUpDestroyed){
      await localGirisCixisServiz.init();
      ModelCustuomerVisit model=await localGirisCixisServiz.getGirisEdilmisMarket();
      if(model.inDate!=null) {
       // await backgroudLocationServiz.stopBackGroundFetch();
        //await backgroudLocationServiz.startBackgorundFetck(model);
      }}

    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
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


