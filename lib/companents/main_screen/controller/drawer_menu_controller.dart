import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as getx;
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/anbar/screan_anbar_esas.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/screen_giriscixis_reklamsobesi.dart';
import 'package:zs_managment/companents/live_track/screen_live_track.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/dashbourd/dashbourd_screen_mobile.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/yeni_giriscixis_map.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
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
import 'package:zs_managment/companents/users_panel/user_panel_screen.dart';
import 'package:zs_managment/global_models/model_appsetting.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';
import '../../base_downloads/screen_download_base.dart';
import '../../hesabatlar/wrong_entries/screen_wrongEntries.dart';
import '../../local_bazalar/local_bazalar.dart';
import '../../rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import '../../rut_gostericileri/mercendaizer/connected_users/screen_mymerch_screen.dart';
import '../../tapsiriqlar/screen_tasks.dart';
import '../../users_panel/mobile/users_panel_mobile_screen.dart';
import '../../ziyaret_tarixcesi/screen_my_visits_history.dart';

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
  getx.RxBool showSublist = false.obs;
  getx.RxBool subMenuSelected = false.obs;
  getx.RxInt selecteSubMenudIndex = 0.obs;


  @override
  void onInit() {
    initAllValues();
    pageView = DashborudScreenMobile(drawerMenuController: this);
    super.onInit();
  }

  void initKeyForScafold(GlobalKey<ScaffoldState> key) {
    keyScaff=key;
    update();
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

  List<SelectionButtonData> addPermisionsInDrawerMenu(LoggedUserModel loggedUser) {
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
    SelectionButtonData myVisits = SelectionButtonData(
        icon: Icons.access_time,
        label: "myVizits",
        activeIcon: Icons.access_time_filled_outlined,
        totalNotif: 0,
        statickField: false,
        isSelected: false,
        codename: "myVizits");
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
    drawerMenus.add(buttonstaticAboudAs);
    drawerMenus.add(buttonstaticPrivansyPolisy);
    drawerMenus.add(buttonLogOut);
    drawerMenus.insert(1,buttondownloads);
    drawerMenus.insert(2,myVisits);
    if(checkIfTodayHasSales()) {
      SelectionButtonData buttonSatis = SelectionButtonData(
          icon: Icons.payments,
          label: "Sifarisler",
          activeIcon: Icons.payments_sharp,
          totalNotif: (modelSatisEmeliyyat.value.listSatis!.length +
              modelSatisEmeliyyat.value.listIade!.length +
              modelSatisEmeliyyat.value.listKassa!.length).toInt(),
          statickField: false,
          isSelected: false,
          codename: "sellDetal");
      drawerMenus.insert(2, buttonSatis);
    }
    if (loggedUser.userModel != null) {
      for (var element in loggedUser.userModel!.draweItems!.where((e)=>e.isSubMenu==false)) {
        List<SelectionButtonData> listSubmenues=[];
        loggedUser.userModel!.draweItems!.where((e)=>e.mainPerId==element.id).forEach((a){
          IconData icon = IconData(element.icon!, fontFamily: 'MaterialIcons');
          IconData iconSelected = IconData(element.selectIcon!, fontFamily: 'MaterialIcons');
          SelectionButtonData buttonDataSub = SelectionButtonData(
              icon: icon,
              label: a.name,
              activeIcon: iconSelected,
              totalNotif: 0,
              statickField: false,
              isSelected: false,
              codename: a.code,
              listSubmenues: []
          );
          listSubmenues.add(buttonDataSub);
        });
        IconData icon = IconData(element.icon!, fontFamily: 'MaterialIcons');
        IconData iconSelected = IconData(element.selectIcon!, fontFamily: 'MaterialIcons');
        SelectionButtonData buttonData = SelectionButtonData(
            icon: icon,
            label: element.name,
            activeIcon: iconSelected,
            totalNotif: 0,
            statickField: false,
            isSelected: false,
            codename: element.code,
            listSubmenues:listSubmenues
        );
        drawerMenus.add(buttonData);
      }
    }

    update();
    return drawerMenus;
  }

    bool checkIfTodayHasSales(){
     // modelSatisEmeliyyat.value=localBaseSatis.getTodaySatisEmeliyyatlari();
     // return modelSatisEmeliyyat.value.listKassa!.isNotEmpty|| modelSatisEmeliyyat.value.listIade!.isNotEmpty|| modelSatisEmeliyyat.value.listSatis!.isNotEmpty;
  return false;
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
                    .map((model) =>getx.Obx(() => itemsDrawer(closeDrawer, isDesk,scaffoldkey,model),
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

                  },
                  child: getx.Obx(() => itemsDrawer(closeDrawer, isDesk,scaffoldkey,model)),
                ))
                    .toList(),
              )),
            ),
          ),
        ],
      ),
    );
  }

  InkWell itemsDrawer(Function(bool clouse) closeDrawer, bool isDesk,GlobalKey<ScaffoldState> scaffoldkey,SelectionButtonData model) {
    return InkWell(
      onTap: (){
        if(model.listSubmenues==null||model.listSubmenues!.isEmpty){
          changeExpendedOrNot();
          changeSelectedIndex(drawerMenus.indexOf(model), model, isDesk);
          closeDrawer.call(true);
          scaffoldkey.currentState!.closeDrawer();
          subMenuSelected.value=false;
          selecteSubMenudIndex.value=-1;
          update();
        }else{
          if(selectedIndex.value!=drawerMenus.indexOf(model)){
            selecteSubMenudIndex.value=-1;
          }
          selectedIndex.value=drawerMenus.indexOf(model);
          if(showSublist.isTrue){
            if(selectedIndex.value!=drawerMenus.indexOf(model)){
              showSublist.value=false;
            }
          }else{
            showSublist.value=true;
          }
          // changeSelectedIndex(drawerMenus.indexOf(model), model, isDesk);
          update();
        }
      },
      child: AnimatedContainer(
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
          padding: const EdgeInsets.all(10.0).copyWith(right: 0),
          child: Column(
            children: <Widget>[
              getx.Obx(()=>Row(
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
                  model.listSubmenues!=null?isMenuExpended.isTrue
                      ? const SizedBox()
                      : model.listSubmenues!.isEmpty?const SizedBox(): DecoratedBox(
                    decoration: BoxDecoration(
                      //color: Colors.grey.withOpacity(0.5),
                      shape: BoxShape.circle,

                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child:showSublist.isTrue? Icon(Icons.expand):Icon(Icons.expand_less),
                    ),
                  ):const SizedBox(),
                  const SizedBox(width: 10,),
                ],
              )),
              selectedIndex.value == drawerMenus.indexOf(model)?model.listSubmenues!=null?isMenuExpended.isTrue
                  ? const SizedBox():showSublist.isTrue?ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.listSubmenues!.length,
                  itemBuilder: (con,index){
                    return getx.Obx(() => itemsSubDrawer(closeDrawer, isDesk,scaffoldkey,model.listSubmenues!.elementAt(index),index,drawerMenus.indexOf(model)));
                  }):const SizedBox():const SizedBox():const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  InkWell itemsSubDrawer(Function(bool clouse) closeDrawer, bool isDesk,GlobalKey<ScaffoldState> scaffoldkey,
      SelectionButtonData model,int subIndex,int modelIndex) {
    return InkWell(
      onTap: (){
        showSublist.value=false;
        selecteSubMenudIndex.value=subIndex;
        selectedIndex.value=modelIndex;
        subMenuSelected.value=true;
        changeExpendedOrNot();
        changeSelectedIndex(modelIndex, model, isDesk);
        closeDrawer.call(true);
      },
      child: AnimatedContainer(
        padding: selecteSubMenudIndex.value == subIndex
            ? const EdgeInsets.all(1)
            : const EdgeInsets.all(0),
        margin: const EdgeInsets.only(left: 5, top: 10),
        decoration:  BoxDecoration(
            borderRadius:  selecteSubMenudIndex.value == subIndex
                ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20))
                : null,
            color:  selecteSubMenudIndex.value == subIndex
                ? Colors.blue.withOpacity(0.5)
                : Colors.transparent,
            border:  selecteSubMenudIndex.value == subIndex
                ? Border.all(color: Colors.black26, width: 0.2)
                : null,
            shape: BoxShape.rectangle,
            boxShadow: selecteSubMenudIndex.value == subIndex
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
        child: Padding(
          padding: const EdgeInsets.all(10.0).copyWith(bottom: 5,left: 15),
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
                      selecteSubMenudIndex.value == subIndex
                          ? 20
                          : 18,
                      selecteSubMenudIndex.value == subIndex
                          ? model.activeIcon
                          : model.icon,
                      color:  selecteSubMenudIndex.value == subIndex
                          ? getx.Get.isDarkMode
                          ? Colors.white
                          : Colors.black
                          : getx.Get.isDarkMode
                          ? Colors.black
                          : Colors.white,
                    ),
                  )
                      : Icon(
                    size:  selecteSubMenudIndex.value == subIndex
                        ? 20
                        : 18,
                    selecteSubMenudIndex.value == subIndex
                        ? model.activeIcon
                        : model.icon,
                    color: selecteSubMenudIndex.value == subIndex
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
                    color: getx.Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontsize:
                    selecteSubMenudIndex.value == subIndex
                        ? 16
                        : 14,
                    fontWeight:
                    selecteSubMenudIndex.value == subIndex
                        ? FontWeight.normal
                        : FontWeight.normal,
                  ),
                  const Spacer(),
                  isMenuExpended.isTrue
                      ? const SizedBox()
                      : model.totalNotif==0?const SizedBox():DecoratedBox(
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
                          selecteSubMenudIndex.value == subIndex
                              ? 18
                              : 16,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    changeIndex(index,model, desktop);
    update();
  }

  onClickEnter(bool bool) {
    if (aktivateHover.value) {
      isMenuExpended.value = false;
      if(subMenuSelected.isTrue){
        showSublist.value=true;
      }else{
        showSublist.value=false;
      }
    }
    update();
  }

  onClickExit(bool bool) {
    if (aktivateHover.value) {
      isMenuExpended.value = true;
      if(subMenuSelected.isFalse){
        showSublist.value=false;
      }else{
        showSublist.value=true;

      }
    }
    update();
  }

  Future<void> initAllValues() async {
    await userServices.init();
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
      case "userscontrol":
        if (desktop) {
          pageView = const UserPanelScreen();
        } else {
          pageView =  UsersPanelScreenMobile(drawerMenuController: this,);
        }
        break;
      case "setting":
        pageView =  SettingScreenMobile(drawerMenuController: this,);
      case "enterScreen":
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
      case "mechSystem":
        pageView= ScreenMyMerchSystem(drawerMenuController: this,);
        break;
      case "merchMyRout":
          await localGirisCixisServiz.init();
          List<MercDataModel> model=await localBaseDownloads.getAllMercDatailByCode(userServices.getLoggedUser().userModel!.code!);
          List<ModelMainInOut> listGirisCixis= localGirisCixisServiz.getAllGirisCixisServer();
          if(model.isNotEmpty) {
            pageView = ScreenMercRoutDatail(listGirisCixis: listGirisCixis,
              listUsers: [],
              modelMercBaza: model.first,
              isMenumRutum: true,
              drawerMenuController: this,);
          }else{
            Get.dialog(ShowInfoDialog(
                messaje: "baseEmptyCari".tr,
                icon: Icons.mobiledata_off,
                callback: () {
                  Get.back();
                  update();
                }));
          } break;
      case "logout":
      //  logOut();
        break;
      case "liveTrackScreen":
        pageView= ScreenLiveTrack(drawerMenuController: this,);
        break;
      case "task":
        pageView= ScreenTask(drawerMenuController: this,);
        break;
        case "wrongEntries":
        pageView= WrongEntriesRepors(drawerMenuController: this,);
        break;
      case "myVizits":
        List<ModelMainInOut> listGirisCixis= localGirisCixisServiz.getAllGirisCixisServer();
        pageView= ScreenMyVisitHistory(listGirisCixis: listGirisCixis,drawerMenuController: this,);
        break;
    }
    selectedIndex.value = drawerIndexdata;
update();
  }

}
