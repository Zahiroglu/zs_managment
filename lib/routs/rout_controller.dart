import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/screen_anbarrapor.dart';
import 'package:zs_managment/companents/base_downloads/screen_download_base_firstScreen.dart';
import 'package:zs_managment/companents/connected_users/exp_rout_datail/edit_screens/dart_edit_musteri_dayail.dart';
import 'package:zs_managment/companents/connected_users/exp_rout_datail/rout_screens/screen_users_rout_perform.dart';
import 'package:zs_managment/companents/connected_users/exp_rout_datail/rout_screens/screen_users_rout_perform_map.dart';
import 'package:zs_managment/companents/connected_users/exp_rout_datail/screen_rutsirasi_edit_exp.dart';
import 'package:zs_managment/companents/giris_cixis/companents/screen_musteridetail.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_cesid_hesabati/screen_cari_cesid_hesabati.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_cesid_hesabati/screen_cari_cesid_hesabati_mal.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_hesabati/screen_cari_hereket.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/satis_hesabati/screen_faktura.dart';
import 'package:zs_managment/companents/hesabatlar/giriscixis_hesabat/screen_gunlukgiris_cixis.dart';
import 'package:zs_managment/companents/login/splashandwelcome/welcome_screen.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/main_screen/window/base_screen_windows.dart';
import 'package:zs_managment/companents/mercendaizer/screens/info_mercmusteri_datail.dart';
import 'package:zs_managment/companents/mercendaizer/screens/merc_adina_dukan_atmaq.dart';
import 'package:zs_managment/companents/mercendaizer/merc_rout_edit/merc_cari_edit.dart';
import 'package:zs_managment/companents/mercendaizer/merc_rout_edit/screen_rutsirasi_edit.dart';
import 'package:zs_managment/companents/mercendaizer/screens/merc_routdatail_screen.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/giris_cixis_zamani/screen_sifariselave_et.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/giris_cixis_zamani/screen_sifarisler.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/screen_ziyaret_giriscixislar_exp.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '../companents/base_downloads/screen_download_base.dart';
import '../companents/setting_panel/screen_maps_setting.dart';
import '../companents/giris_cixis/companents/screen_searchMusteri.dart';
import '../companents/login/desktop/login_desktop_screen.dart';
import '../companents/login/mobile/login_mobile_first_screen.dart';
import '../companents/login/mobile/mobile_lisance_screen.dart';
import '../companents/main_screen/mobile/base_screen_mobile.dart';
import '../companents/ziyaret_tarixcesi/screen_ziyaret_giriscixislar_merc.dart';

class RouteHelper {
  /////////////////constants
  static const String wellcome = '/wellcome_screen';
  static const String mobileLisanceScreen = '/mobile_lisance';
  static const String mobileLoginFistScreen = '/mobileLoginFistScreen';
  static const String windosLoginScreen = '/windosLoginScreen';
  static const String mobileMainScreen = '/mobileMainScreen';
  static const String mobileGirisCixisHesabGunluk = '/mobileGirisCixisHesabGunluk';
  static const String bazaDownloadMobile = '/bazaDownloadMobile';
  static const String windosMainScreen = '/windosMainScreen';
  static const String mobileSearchMusteriMobile = '/mobileSearchMusteriMobile';
  static const String mobileMapSettingMobile = '/mobileMapSettingMobile';
  static const String mobileScreenMusteriDetail = '/mobileScreenMusteriDetail';
  static const String cariZiyaretHesabatlari = '/cariZiyaretHesabatlari';
  static const String cariSatisHesabati = '/cariSatisHesabati';
  static const String fackturaHesabati = '/fackturaHesabati';
  static const String cariMuqavilelerHesabati = '/cariMuqavilelerHesabati';
  static const String cariTaninanMallarHesabati = '/cariTaninanMallarHesabati';
  static const String cariQaytarmaRaporu = '/cariQaytarmaRaporu';
  static const String cariSatilanCesidRaporu = '/cariSatilanCesidRaporu';
  static const String cariSatilanCesidRaporuMal = '/cariSatilanCesidRaporuMal';
  static const String anbarCesidlerSehfesi = '/anbarCesidlerSehfesi';
  static const String screenSatis = '/screenSatis';
  static const String screenSifarisElaveEt = '/screenSifarisElaveEt';
  static const String screenExpRoutDetail = '/screenExpRoutDetail';
  static const String screenExpRoutDetailMap = '/screenExpRoutDetailmap';
  static const String screenEditMusteriDetailScreen = '/screenEditMusteriDetailScreen';
  static const String screenMercRoutDatail = '/screenMercRoutDatail';
  static const String screenZiyaretGirisCixis = '/screenZiyaretGirisCixis';
  static const String screenZiyaretGirisCixisExp = '/screenZiyaretGirisCixisExp';
  static const String screenMercMusteriDetail = '/screenMercMusteriDetail';
  static const String screenEditMercMusteri = '/screenEditMercMusteri';
  static const String screenMercRutSiraEdit = '/screenMercRutSiraEdit';
  static const String screenExpRutSiraEdit = '/screenExpRutSiraEdit';
  static const String screenMercAdinaMusteriAt = '/screenMercAdinaMusteriAt';
  /////////////////getLinks
  static String getWellComeScreen() => wellcome;
  static String getMobileLisanceScreen() => mobileLisanceScreen;
  static String getLoginMobileFirstScreen() => mobileLoginFistScreen;
  static String getWindosLoginScreen() => windosLoginScreen;
  static String getMobileMainScreen() => mobileMainScreen;
  static String getbazaDownloadMobile() => bazaDownloadMobile;
  static String getWindosMainScreen() => windosMainScreen;
  static String getwidgetSearchMusteriMobile() => mobileSearchMusteriMobile;
  static String getwidgetMapSettingScreenMobile() => mobileMapSettingMobile;
  static String getwidgetScreenMusteriDetail() => mobileScreenMusteriDetail;
  static String getMobileGirisCixisHesabGunluk() => mobileGirisCixisHesabGunluk;
  static String getCariZiyaretHesabatlari() => cariZiyaretHesabatlari;
  static String getCariSatisHesabati() => cariSatisHesabati;
  static String getfackturaHesabati() => fackturaHesabati;
  static String getCariMuqavilelerHesabati() => cariMuqavilelerHesabati;
  static String getCariTaninanMallarHesabati() => cariTaninanMallarHesabati;
  static String getCariQaytarmaRaporu() => cariQaytarmaRaporu;
  static String getCariSatilanCesidRaporu() => cariSatilanCesidRaporu;
  static String getCariSatilanCesidRaporuMal() => cariSatilanCesidRaporuMal;
  static String getAnbarCesidlerSehfesi() => anbarCesidlerSehfesi;
  static String getScreenSatis() => screenSatis;
  static String getScreenSifarisElaveEt() => screenSifarisElaveEt;
  static String getScreenExpRoutDetail() => screenExpRoutDetail;
  static String getscreenExpRoutDetailMapl() => screenExpRoutDetailMap;
  static String getscreenEditMusteriDetailScreen() => screenEditMusteriDetailScreen;
  static String getScreenMercRoutDatail() => screenMercRoutDatail;
  static String getScreenZiyaretGirisCixis() => screenZiyaretGirisCixis;
  static String getScreenZiyaretGirisCixisExp() => screenZiyaretGirisCixisExp;
  static String getScreenMercMusteriDetail() => screenMercMusteriDetail;
  static String getScreenEditMercMusteri() => screenEditMercMusteri;
  static String getScreenMercRutSiraEdit() => screenMercRutSiraEdit;
  static String getScreenExpRutSiraEdit() => screenExpRutSiraEdit;
  static String getScreenMercAdinaMusteriAt() => screenMercAdinaMusteriAt;

  static List<GetPage> routes = [
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariSatilanCesidRaporu, page: () {
      return   ScreenCariCesidHesabati(tarixIlk: Get.arguments[0],tarixSon: Get.arguments[1],cariKod: Get.arguments[2],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariSatilanCesidRaporuMal, page: () {
      return   ScreenCariCesidHesabatiMal(listCesidler: Get.arguments[0],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariQaytarmaRaporu, page: () {
      return   Center(child: CustomText(labeltext: "cariQaytarmaRaporu"),);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariTaninanMallarHesabati, page: () {
      return   Center(child: CustomText(labeltext: "cariTaninanMallarHesabati"),);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariZiyaretHesabatlari, page: () {
      return   Center(child: CustomText(labeltext: "cariZiyaretHesabatlari"),);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariMuqavilelerHesabati, page: () {
      return   Center(child: CustomText(labeltext: "cariMuqavilelerHesabati"),);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: cariSatisHesabati, page: () {
      return   ScreenCariHereket(tarixIlk: Get.arguments[0],tarixSon: Get.arguments[1],cariKod: Get.arguments[2],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: fackturaHesabati, page: () {
      return   ScreenFaktura(recNom: Get.arguments[0],senedTipi: Get.arguments[1],);
      return  Container();
    }),
    GetPage(name: wellcome, page: () {
      return const WellCameScreen();
      return  Container();
    }),
    GetPage(
        name: mobileLisanceScreen,
        page: () {
      return  ScreenRequestCheckMobile();
      return  Container();
    }),
    GetPage(name: mobileLoginFistScreen, page: () {
      return const LoginMobileFirstScreen();
      return  Container();
    }),
    GetPage(name: windosLoginScreen, page: () {
      return const LoginDesktopScreen();
      return  Container();
    }),
    GetPage(name: mobileMainScreen, page: () {
      return  const MainScreenMobile();
     // return  const MainScreenMobileYeni();
      return  Container();
    }),
    GetPage(name: windosMainScreen, page: () {
      return  BaseScreenWindows(loggedUserModel: Get.arguments,);
      return  Container();
    }),
    GetPage(
        transition: Transition.downToUp,
        transitionDuration: const Duration(seconds: 1),
        name: mobileSearchMusteriMobile, page: () {
      return  ScreenSearchMusteri(listCariler: Get.arguments,);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 600),
        name: mobileMapSettingMobile, page: () {
      return  const ScreenMapsSetting();
      return  Container();
    }),
    GetPage(
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 600),
        name: mobileScreenMusteriDetail, page: () {
      return   ScreenMusteriDetail(modelCariler: Get.arguments[0],availableMap: Get.arguments[1],);
      return  Container();
    }),
    GetPage(
        name: bazaDownloadMobile, page: () {
      return   FirstScreenBaseDownloads(fromFirstScreen: true);
      return  Container();
    }),
    GetPage(
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500),
        name: mobileGirisCixisHesabGunluk, page: () {
      return   ScreenGunlukGirisCixis(model: Get.arguments,);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: anbarCesidlerSehfesi, page: () {
      return   ScreanAnbarRapor(listMehsullar:Get.arguments[0],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenSatis, page: () {
      return   ScreenSifarisler(modelCari: Get.arguments[0],satisTipi: Get.arguments[1],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenSifarisElaveEt, page: () {
      return   ScreenSifarisElaveEt(controllerSatis: Get.arguments);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenExpRoutDetail, page: () {
      return   ScreenExpRoutPerform(controllerRoutDetailUser: Get.arguments[0],userModel: Get.arguments[1], listUsers:Get.arguments[2],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenExpRoutDetailMap, page: () {
      return   ScreenUserRoutPerformMap(controllerRoutDetailUser: Get.arguments);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenEditMusteriDetailScreen, page: () {
      return   EditMusteriDetailScreen(controllerRoutDetailUser: Get.arguments[0], routname: Get.arguments[1],cariModel: Get.arguments[2],);
      return  Container();
    }),
    GetPage(
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenMercRoutDatail, page: () {
      return   ScreenMercRoutDatail(modelMercBaza: Get.arguments[0],listGirisCixis: Get.arguments[1],listUsers: Get.arguments[2],isMenumRutum: false,drawerMenuController: DrawerMenuController(),);
      return  Container();
    }),
    GetPage(
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenMercMusteriDetail, page: () {
      return   ScreenMercMusteriDetail(modelMerc: Get.arguments[0],listGirisCixis: Get.arguments[1],listUsers: Get.arguments[2],userMerc: Get.arguments[3],);
      return  Container();
    }),
    GetPage(
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenZiyaretGirisCixis, page: () {
      return   ScreenZiyaretGirisCixis(modelGunlukGirisCixis: Get.arguments[0],adSoyad: Get.arguments[1],modelCariler: Get.arguments[2],);
      return  Container();
    }),
    GetPage(
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenZiyaretGirisCixisExp, page: () {
      return   ScreenZiyaretGirisCixisExp(modelGunlukGirisCixis: Get.arguments[0],adSoyad: Get.arguments[1],modelCariler: Get.arguments[2],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenEditMercMusteri, page: () {
      return   ScreenMercCariEdit(modelMerc: Get.arguments[0],listUsers: Get.arguments[1],mercKod: Get.arguments[2],mercAd: Get.arguments[3],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenMercRutSiraEdit, page: () {
      return   ScreenMercRutSirasiEdit(listRutGunleri: Get.arguments[0],rutGunu: Get.arguments[1],rutGunuInt: Get.arguments[2],mercKod: Get.arguments[3],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenExpRutSiraEdit, page: () {
      return   ScreenExpRutSirasiEdit(listRutGunleri: Get.arguments[0],rutGunu: Get.arguments[1],);
      return  Container();
    }),
    GetPage(
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        name: screenMercAdinaMusteriAt, page: () {
      return   ScreenMercAdinaMusteriEalveEtme(modelCari:  Get.arguments[0],listUsers: Get.arguments[1],availableMap: Get.arguments[2],);
      return  Container();
    }),
  ];
}