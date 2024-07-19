import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as getx;
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/screan_anbar_esas.dart';
import 'package:zs_managment/companents/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/connected_users/rout_detail_users_screen.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/screen_giriscixis_reklamsobesi.dart';
import 'package:zs_managment/companents/live_track/screen_live_track.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/dashbourd/dashbourd_screen_mobile.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/yeni_giriscixis_map.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/services/api_services/users_apicontroller_web_windows.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/drawer/model_drawerItems.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/screens/merc_routdatail_screen.dart';
import 'package:zs_managment/companents/satis_emeliyyatlari/sifaris_detallari/screen_sifarislerebax.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/setting_panel/setting_panel_controller.dart';
import 'package:zs_managment/companents/setting_panel/setting_screen_mobile.dart';
import 'package:zs_managment/companents/users_panel/user_panel_windows_screen.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';
import '../../base_downloads/screen_download_base.dart';
import '../../hesabatlar/wrong_entries/screen_wrongEntries.dart';
import '../../local_bazalar/local_bazalar.dart';
import '../../tapsiriqlar/screen_tasks.dart';
import '../../users_panel/mobile/users_panel_mobile_screen.dart';

class DrawerMenuController extends getx.GetxController {
  getx.RxList<SelectionButtonData> drawerMenus = List<SelectionButtonData>.empty(growable: true).obs;
  getx.RxInt selectedIndex = 0.obs;
  getSelectedIndex() => selectedIndex;
 // Widget getCurrentPage() => pageView;
  LocalUserServices userServices = LocalUserServices();
  getx.RxBool drawerCloused = true.obs;
  getx.RxBool isMenuExpended = true.obs;
  getx.RxBool aktivateHover = true.obs;
  CheckDviceType checkDviceType = CheckDviceType();
  int dviceType = 0;
  LocalAppSetting localAppSetting = LocalAppSetting();
  ModelAppSetting modelAppSetting = ModelAppSetting(mapsetting: null, girisCixisType: "map",userStartWork: false);
  LocalBazalar localBazalar = LocalBazalar();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  LocalBaseSatis localBaseSatis=LocalBaseSatis();
  LocalGirisCixisServiz localGirisCixisServiz=LocalGirisCixisServiz();
  late Rx<ModelSatisEmeliyyati> modelSatisEmeliyyat = ModelSatisEmeliyyati().obs;
  GlobalKey<ScaffoldState> keyScaff = GlobalKey(); // Create a key
  dynamic pageView =  SizedBox();


  @override
  void onInit() {
    initAllValues();
    pageView = DashborudScreenMobile(drawerMenuController: this);
    super.onInit();
  }

  void clousDrawer(){
    keyScaff.currentState!.closeDrawer();
    update();
  }

  void openDrawer(){
    keyScaff.currentState!.openDrawer();
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initKeyForScafold(GlobalKey<ScaffoldState> key) {
    keyScaff=key;
    update();
  }

  Future<List<SelectionButtonData>> addPermisionsInDrawerMenu(LoggedUserModel loggedUser) async {
    dviceType = checkDviceType.getDviceType();
    drawerMenus.clear();
    drawerMenus.forEach((element) {
      print("Drawr :"+element.label.toString());

    });
    SelectionButtonData dashboard = SelectionButtonData(
        icon: Icons.dashboard,
        label: "dashboard",
        activeIcon: Icons.dashboard_outlined,
        totalNotif: 0,
        statickField: false,
        isSelected: false,
        codename: "dashboard");
    SelectionButtonData buttondownloads = SelectionButtonData(
        icon: Icons.upcoming,
        label: "yuklemeler",
        activeIcon: Icons.upcoming_outlined,
        totalNotif: 0,
        statickField: false,
        isSelected: false,
        codename: "down");
    SelectionButtonData buttonstaticAboudAs = SelectionButtonData(
        icon: Icons.info_outline,
        label: "haqqimizda",
        activeIcon: Icons.info,
        totalNotif: 0,
        statickField: true,
        isSelected: false,
        codename: "about");
    SelectionButtonData buttonstaticPrivansyPolisy = SelectionButtonData(
        icon: Icons.lock_person_outlined,
        label: "privancypolicy",
        activeIcon: Icons.lock_person,
        totalNotif: 0,
        statickField: true,
        isSelected: false,
        codename: "privance");
    SelectionButtonData buttonstaticProfileSetting = SelectionButtonData(
        icon: Icons.settings_applications_outlined,
        label: "setting",
        activeIcon: Icons.settings_applications,
        totalNotif: 0,
        statickField: true,
        isSelected: false,
        codename: "setting");
    SelectionButtonData buttonLogOut = SelectionButtonData(
        icon: Icons.logout,
        label: "cixiset",
        activeIcon: Icons.logout,
        totalNotif: 0,
        statickField: true,
        isSelected: false,
        codename: "logout");
    drawerMenus.insert(0,dashboard);
    drawerMenus.add(buttonstaticProfileSetting);
    drawerMenus.insert(1,buttondownloads);
    if(checkIfTodayHasSales()){
      SelectionButtonData buttonSatis = SelectionButtonData(
          icon: Icons.payments,
          label: "Sifarisler",
          activeIcon: Icons.payments_sharp,
          totalNotif: (modelSatisEmeliyyat.value.listSatis!.length+modelSatisEmeliyyat.value.listIade!.length+modelSatisEmeliyyat.value.listKassa!.length).toInt(),
          statickField: false,
          isSelected: false,
          codename: "sellDetal");
      drawerMenus.insert(2,buttonSatis);
    }
    if (loggedUser.userModel != null) {
      for (var element in loggedUser.userModel!.draweItems!) {
        print("Drawer items :"+element.code.toString());
        IconData icon = IconData(element.icon!, fontFamily: 'MaterialIcons');
        IconData iconSelected = IconData(element.selectIcon!, fontFamily: 'MaterialIcons');
        SelectionButtonData buttonData = SelectionButtonData(
            icon: icon,
            label: element.name,
            activeIcon: iconSelected,
            totalNotif: 0,
            statickField: false,
            isSelected: false,
            codename: element.code);
        drawerMenus.add(buttonData);
      }
    }
    SelectionButtonData gunlukIseBasla = SelectionButtonData(
        icon: Icons.work,
        label: "startWork",
        activeIcon: Icons.work_history,
        totalNotif: 0,
        statickField: false,
        isSelected: false,
        codename: "startWork");
    SelectionButtonData gunlukIsiSonlandir = SelectionButtonData(
        icon: Icons.stop_circle_outlined,
        label: "stopWork",
        activeIcon: Icons.stop_circle_outlined,
        totalNotif: 0,
        statickField: false,
        isSelected: false,
        codename: "startWork");
    //drawerMenus.add(buttonUsers);
    drawerMenus.add(buttonstaticAboudAs);
    drawerMenus.add(buttonstaticPrivansyPolisy);
    drawerMenus.add(buttonLogOut);
    update();
    return drawerMenus;
  }

  changeExpendedOrNot() {
    dviceType = checkDviceType.getDviceType();
    if (dviceType == 3 || dviceType == 2) {
      if (aktivateHover.isTrue) {
        isMenuExpended.value = true;
      } else {
        isMenuExpended.value = false;
      }
      update();
    }
  }

  changeHover() {
    aktivateHover.toggle();
    if (!aktivateHover.value) {
      isMenuExpended.value = false;
    } else {
      isMenuExpended.value = true;
    }
    update();
  }

  Widget getItemsMenu(Function(bool clouse) closeDrawer, bool isDesk, GlobalKey<ScaffoldState> scaffoldkey) {
    keyScaff=scaffoldkey;
    if (!isDesk) {
      isMenuExpended = false.obs;
    }
    return MouseRegion(
      onEnter: (onEnter) => onClickEnter(true),
      onExit: (onExit) => onClickExit(true),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDesk
              ? Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                changeHover();
                              },
                              icon: const Icon(Icons.menu)),
                          isMenuExpended.isTrue
                              ? const SizedBox()
                              : const SizedBox(
                                  width: 10,
                                ),
                          isMenuExpended.isTrue
                              ? const SizedBox()
                              : CustomText(
                                  labeltext: "menular".tr,
                                  fontsize: 18,
                                  fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          isMenuExpended.isTrue
              ? const Divider(
                  height: 3,
                  color: Colors.grey,
                )
              : const SizedBox(),
          Expanded(
            flex: dviceType == 3 || dviceType == 2 ? 14 : 10,
            child: SingleChildScrollView(
              child: getx.Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drawerMenus
                        .where((element) => element.statickField == false)
                        .map((model) => InkWell(
                              onTap: () {
                                changeExpendedOrNot();
                                changeSelectedIndex(drawerMenus.indexOf(model), model, isDesk);
                                closeDrawer.call(true);
                                scaffoldkey.currentState!.closeDrawer();
                              },
                              child: getx.Obx(() => itemsDrawer(model)),
                            ))
                        .toList(),
                  )),
            ),
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
          ),
          Expanded(
            flex: dviceType == 3 || dviceType == 2 ? 5 : 5,
            child: SingleChildScrollView(
              child: getx.Obx(() => Column(
                    children: drawerMenus
                        .where((element) => element.statickField == true)
                        .map((model) => InkWell(
                              onTap: () {
                                changeExpendedOrNot();
                                changeSelectedIndex(drawerMenus.indexOf(model), model, isDesk);
                                closeDrawer.call(true);
                              },
                              child: getx.Obx(() => itemsDrawer(model)),
                            ))
                        .toList(),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer itemsDrawer(SelectionButtonData model) {
    return AnimatedContainer(
      padding: selectedIndex.value == drawerMenus.indexOf(model)
          ? const EdgeInsets.all(1)
          : const EdgeInsets.all(0),
      margin: const EdgeInsets.only(left: 5, top: 5),
      decoration: model.codename == "logout"
          ? const BoxDecoration()
          : BoxDecoration(
              borderRadius: selectedIndex.value == drawerMenus.indexOf(model)
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))
                  : null,
              color: selectedIndex.value == drawerMenus.indexOf(model)
                  ? Colors.blue.withOpacity(0.5)
                  : Colors.transparent,
              border: selectedIndex.value == drawerMenus.indexOf(model)
                  ? Border.all(color: Colors.black26, width: 0.2)
                  : null,
              shape: BoxShape.rectangle,
              boxShadow: selectedIndex.value == drawerMenus.indexOf(model)
                  ? [
                      BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          offset: const Offset(-2, 2),
                          blurRadius: 20,
                          spreadRadius: 1,
                        blurStyle: BlurStyle.outer
                      )
                    ]
                  : []),
      transformAlignment: Alignment.centerRight,
      duration: model.codename == "logout"
          ? const Duration(milliseconds: 1)
          : const Duration(milliseconds: 500),
      curve: Curves.linear,
      child: Padding(
        padding: model.statickField==true?const EdgeInsets.all(10.0).copyWith(bottom: 5,top: 5):const EdgeInsets.all(10.0).copyWith(top: 7,bottom: 7),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                isMenuExpended.isTrue
                    ? Tooltip(
                        waitDuration: const Duration(milliseconds: 100),
                        message: model.label!,
                        child: Icon(
                          size:
                              selectedIndex.value == drawerMenus.indexOf(model)
                                  ? 28
                                  : 24,
                          selectedIndex.value == drawerMenus.indexOf(model)
                              ? model.activeIcon
                              : model.icon,
                          color: model.codename == "logout"
                              ? Colors.red
                              : selectedIndex.value ==
                                      drawerMenus.indexOf(model)
                                  ? getx.Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black
                                  : getx.Get.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                        ),
                      )
                    : Icon(
                        size: selectedIndex.value == drawerMenus.indexOf(model)
                            ? 28
                            : 24,
                        selectedIndex.value == drawerMenus.indexOf(model)
                            ? model.activeIcon
                            : model.icon,
                        color: model.codename == "logout"
                            ? Colors.red
                            : selectedIndex.value == drawerMenus.indexOf(model)
                                ? getx.Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black
                                : getx.Get.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                      ),
                isMenuExpended.isTrue
                    ? const SizedBox()
                    : const SizedBox(
                        width: 5,
                      ),
                isMenuExpended.isTrue
                    ? const SizedBox()
                    : CustomText(
                        labeltext: model.label!,
                        color: model.codename == "logout"
                            ? Colors.red
                            : getx.Get.isDarkMode
                                ? Colors.white
                                : Colors.black,
                        fontsize:
                            selectedIndex.value == drawerMenus.indexOf(model)
                                ? 18
                                : 16,
                        fontWeight:
                            selectedIndex.value == drawerMenus.indexOf(model)
                                ? FontWeight.normal
                                : FontWeight.normal,
                      ),
                const Spacer(),
                isMenuExpended.isTrue
                    ? const SizedBox()
                    : model.totalNotif==0?SizedBox():DecoratedBox(
                  decoration: const BoxDecoration(
                    //color: Colors.grey.withOpacity(0.5),
                    shape: BoxShape.circle,

                  ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CustomText(
                            labeltext:model.totalNotif.toString(),
                            color: Colors.blue,
                            fontsize:
                                selectedIndex.value == drawerMenus.indexOf(model)
                                    ? 20
                                    : 18,
                            fontWeight:FontWeight.bold
                          ),
                      ),
                    ),
                SizedBox(width: 10,),
              ],
            ),
            model.statickField==true?SizedBox(height: 5,):SizedBox(),
          ],
        ),
      ),
    );
  }

  void changeIndexWhenLanguageChange() {
    if (drawerMenus.elementAt(selectedIndex.value).codename == "users") {
      pageView =  DashborudScreenMobile(drawerMenuController: this);
      changeSelectedIndex(selectedIndex.value, drawerMenus.elementAt(selectedIndex.value), true);
    }
  }

  changeSelectedIndex(int index, SelectionButtonData model, bool desktop) {
    selectedIndex.value = index;
    changeIndex(index, model, desktop);
    update();
  }


  bool checkIfTodayHasSales(){
    modelSatisEmeliyyat.value=localBaseSatis.getTodaySatisEmeliyyatlari();
    return modelSatisEmeliyyat.value.listKassa!.isNotEmpty|| modelSatisEmeliyyat.value.listIade!.isNotEmpty|| modelSatisEmeliyyat.value.listSatis!.isNotEmpty;
  }

  void logOut() {
    getx.Get.dialog(ShowSualDialog(
        messaje: "cixisucun".tr,
        callBack: (val) async {
          getx.Get.delete<DrawerMenuController>();
          getx.Get.delete<UsersApiController>();
          getx.Get.delete<UserApiControllerMobile>();
          getx.Get.delete<SettingPanelController>();
          getx.Get.delete<ControllerAnbar>();
          localBazalar.deleteAllBases();
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }));
  }

  onClickEnter(bool bool) {
    if (aktivateHover.value) {
      isMenuExpended.value = false;
    }
  }

  onClickExit(bool bool) {
    if (aktivateHover.value) {
      isMenuExpended.value = true;
    }
  }

  Future<void> initAllValues() async {
    await userServices.init();
    await localAppSetting.init();
    await localBaseDownloads.init();
    await localBaseSatis.init();
    addPermisionsInDrawerMenu(userServices.getLoggedUser());
    update();
  }

  Future<void> changeIndex(int drawerIndexdata, SelectionButtonData model, bool desktop) async {
    switch (model.codename) {
      case "dashboard":
        pageView = DashborudScreenMobile(drawerMenuController: this);
        break;
      case "warehouse":
        if(localBaseDownloads.getIfAnbarBaseDownloaded()){
          pageView =  AnbarRaporEsas(drawerMenuController: this,);
        }else{
          Get.dialog(ShowInfoDialog(
              messaje: "Anbar bazasi bosdur.Zehmet olmasa yenileyin",
              icon: Icons.mobiledata_off,
              callback: () {
                changeIndex(1,SelectionButtonData(
                    icon: Icons.upcoming,
                    label: "dovnloads",
                    activeIcon: Icons.upcoming_outlined,
                    totalNotif: 0,
                    statickField: false,
                    isSelected: false,
                    codename: "down"),desktop);
                update();
              }));
        }
        break;
      case "down":
        pageView = ScreenBaseDownloads(fromFirstScreen: false,drawerMenuController: this,
        );
        break;
      case "userController":
        if (desktop) {
          pageView = const UserPanelWindosScreen();
        } else {
          pageView =  UsersPanelScreenMobile(drawerMenuController: this,);
        }
        break;
      case "setting":
        pageView =  SettingScreenMobile(drawerMenuController: this,);
      case "enter":
       await localAppSetting.init();
       modelAppSetting = await localAppSetting.getAvaibleMap();
       if(modelAppSetting.userStartWork==true) {
         if (localBaseDownloads.getIfCariBaseDownloaded(userServices.getLoggedUser().userModel!.moduleId!)) {
           if (modelAppSetting.girisCixisType == "map") {
             pageView = const YeniGirisCixisMap();
           } else {
             pageView = ScreenGirisCixisReklam(drawerMenuController: this,);
           }
         } else {
           Get.dialog(ShowInfoDialog(
               messaje: "baseEmptyCari".tr,
               icon: Icons.mobiledata_off,
               callback: () {
                 Get.back();
                 update();
               }));
         }
       }else{
         Get.dialog(ShowInfoDialog(
             messaje: "infoErrorStartWork".tr,
             icon: Icons.work_history,
             color: Colors.red,
             callback: () {
               Get.back();
               update();
             }));

       }break;
      case "sellDetal":
        pageView= ScreenSifarislereBax(drawerMenuController: this,);
        break;
      case "myConnectedRutMerch":
        pageView= RoutDetailScreenUsers(drawerMenuController: this,);
        break;
      case "myRut":
        if(userServices.getLoggedUser().userModel!.roleId==23) {
          await localGirisCixisServiz.init();
          List<MercDataModel> model=await localBaseDownloads.getAllMercDatailByCode(userServices.getLoggedUser().userModel!.code!);
          List<ModelMainInOut> listGirisCixis= localGirisCixisServiz.getAllGirisCixisServer();
          pageView = ScreenMercRoutDatail(listGirisCixis: listGirisCixis,listUsers: [],modelMercBaza: model.first,isMenumRutum: true,drawerMenuController: this,);
        }break;
      case "logout":
        logOut();
        break;
      case "liveTrack":
        pageView= ScreenLiveTrack(drawerMenuController: this,);
        break;
      case "task":
        pageView= ScreenTask(drawerMenuController: this,);
        break;
        case "wrongEntries":
        pageView= WrongEntriesRepors(drawerMenuController: this,);
        break;
    }
    selectedIndex.value = drawerIndexdata;
update();  }

}
