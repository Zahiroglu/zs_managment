import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zs_managment/language/lang_constants.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/utils/messages.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:zs_managment/language/utils/dep.dart' as dep;
import 'package:get/get.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:developer' as developer;
import 'package:permission_handler/permission_handler.dart';






Future<void>  main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await dep.init();
  Permission.notification.isDenied.then((value) => {
    if(value)
      Permission.notification.request()

  });
  runZonedGuarded(() {
    runApp(MyApp(languages: languages));
  }, (dynamic error, dynamic stack) {
    developer.log("Something went wrong!", error: error, stackTrace: stack);
  });
}
class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key,required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
   getCurrentScreen().then((value) => {
     _changeWindowsSize(value)

   });
  }

  Future<double> getCurrentScreen() async {
    final windowInfo = await DesktopWindow.getWindowSize();
    return windowInfo.width;
  }

  _changeWindowsSize(double value) async {
    if (Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isFuchsia) {
      await DesktopWindow.setMinWindowSize( Size(value/2, 1000));
      await DesktopWindow.setFullScreen(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<LocalizationController>(builder: (localizationController){
      return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        themeMode: localizationController.isDark?ThemeMode.dark:ThemeMode.light,
        darkTheme: ThemeData.dark(),
        theme:localizationController.isDark?ThemeData.dark():ThemeData.light(),
      locale: localizationController.locale,
      translations: Messages(languages: widget.languages),
      fallbackLocale: Locale(LangConstants.languages[0].languageCode,
      LangConstants.languages[0].countryCode),
      initialRoute: RouteHelper.getWellComeScreen(),
      getPages: RouteHelper.routes,
      defaultTransition: Transition.topLevel,
    );
  });
  }
}


