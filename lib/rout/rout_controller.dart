import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zs_managment/app_companents/windows/base_screenwindows.dart';
import 'package:zs_managment/login/desktop/login_desktopScreenTest.dart';
import 'package:zs_managment/login/mobile/login_mobileScreen.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/service/models/user_bindings.dart';
import 'package:zs_managment/login/wellcame_screen.dart';

import '../app_companents/mobile/base_screenMobile.dart';
import '../login/mobile/mobile_lisancerequest.dart';

class RouteHelper {
  static const String wellcome = '/wellcome_screen';
  static const String loginMobile='/loginMobile';
  static const String loginWindows='/loginWindows';
  static const String mainScreenWidows='/mainScreenWidows';
  static const String mainScreenMobile='/mainScreenMobile';
  static const String mobileCheckLisance='/mobileScreenCheckLisance';
  static String getWellComeScreen() => wellcome;
  static String getLoginMobile()=>loginMobile;
  static String getLoginWindows()=>loginWindows;
  static String getmainScreenWidows()=>mainScreenWidows;
  static String getmainScreenMobile()=>mainScreenMobile;
  static String getmobileCheckLisance()=>mobileCheckLisance;

  static List<GetPage> routes = [

    GetPage(name: wellcome, page: () {
      return const WellCameScreen();
      return  Container();
    }),
    GetPage(name:loginMobile, page:(){
      return  const LoginMobileScreen();
    }),
    GetPage(
        binding: UserBindings(),
        name:loginWindows, page:(){
      //return  LoginDesktopScreen();
      return  const LoginDesktopScreenTest();
    }),
    GetPage(
        binding: UserBindings(),
        name:mainScreenWidows, page:(){
      return   BaseScreen(userModel: Get.arguments,);
    }),
    GetPage(name:mainScreenMobile, page:(){
      return   BaseScreenMobile(loggedUserModel: Get.arguments,);
    }),
    GetPage(name:mobileCheckLisance, page:(){
      return  const ScreenRequestCheck();
    }),
  ];
}