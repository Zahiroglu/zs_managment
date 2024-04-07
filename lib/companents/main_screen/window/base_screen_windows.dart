import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/main_screen/drawer/custom_drawer_windows.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/utils/dilsecimi_dropdown.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../../widgets/simple_info_dialog.dart';
import '../../anbar/screan_anbar_esas.dart';
import '../../base_downloads/screen_download_base.dart';
import '../../connected_users/rout_detail_users_screen.dart';
import '../../dashbourd/dashbourd_screen_mobile.dart';
import '../../giris_cixis/sceens/reklam_girisCixis/screen_giriscixis_reklamsobesi.dart';
import '../../giris_cixis/sceens/satisGirisCixis/screen_giriscixis_umumilist.dart';
import '../../giris_cixis/sceens/yeni_giriscixis_map.dart';
import '../../live_track/screen_live_track.dart';
import '../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import '../../rut_gostericileri/mercendaizer/screens/merc_routdatail_screen.dart';
import '../../satis_emeliyyatlari/sifaris_detallari/screen_sifarislerebax.dart';
import '../../setting_panel/setting_screen_mobile.dart';
import '../../tapsiriqlar/screen_tasks.dart';
import '../../users_panel/mobile/users_panel_mobile_screen.dart';
import '../../users_panel/user_panel_windows_screen.dart';
import '../drawer/model_drawerItems.dart';

class BaseScreenWindows extends StatefulWidget {
  LoggedUserModel loggedUserModel;

  BaseScreenWindows({Key? key, required this.loggedUserModel})
      : super(key: key);

  @override
  State<BaseScreenWindows> createState() => _BaseScreenWindowsState();
}

class _BaseScreenWindowsState extends State<BaseScreenWindows> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  int drawerWidget = 1;
  late LoggedUserModel modelUser = LoggedUserModel();
  ThemaController themaController = Get.put(ThemaController());
  DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  @override
  void initState() {
    modelUser = widget.loggedUserModel;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ThemaController>();
    Get.delete<DrawerMenuController>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Material(
      child:GetBuilder<LocalizationController>(builder: (localizationController) {
        return Scaffold(
          key: _key,
          body: Obx(() => Column(
            children: [
              widgetHeader(localizationController),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => widgetCustomDrawer()),
                    Expanded(child: drawerMenuController.pageView)
                  ],
                ),
              ),
              widgetFooter(),
            ],
          )),
        );
      }),
    );
  }

  ConstrainedBox widgetCustomDrawer() {
    return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                      drawerMenuController.isMenuExpended.isTrue
                          ? ScreenUtil.defaultSize.width * 0.2
                          : ScreenUtil.defaultSize.width * 0.6,
                    ),
                    child: Drawer(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      width: ScreenUtil.defaultSize.width,
                      child: CustomDrawerWindos(
                        drawerMenuController: drawerMenuController,
                        userModel: modelUser,
                        data: (va) {},
                        logout: (val) {
                          if (val) {
                            // Get.offNamed(RouteHelper.getWellComeScreen());
                            // sharedManager.cleareAllInfo();
                          }
                        },
                        scaffoldkey: _key,
                        appversion: '0.1',
                        initialSelected: 0,
                        closeDrawer: (val) {
                          _key.currentState!.closeDrawer();
                          setState(() {});
                        },
                      ),
                    ),
                  );
  }

  Widget widgetHeader(LocalizationController localizationController) {
    return modelUser.toString().isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(bottom: 1),
            alignment: Alignment.centerRight,
            height: 55,
            width: ResponsiveBuilder.mainWidh(context),
            decoration: BoxDecoration(
              color: themaController.isDark.isTrue
                  ? ThemeData.dark().canvasColor
                  : ThemeData.light().canvasColor,
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0.1,
                    blurRadius: 2,
                    offset: Offset(1.2, 0.8))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widgetSystemTitle(),
                widgetMainViewsUser(localizationController)
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

  Widget widgetMainViewsUser(LocalizationController localizationController) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 50,
        minWidth: 280
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            maxRadius: 15,
                            minRadius: 10,
                            child: Image.asset(
                              modelUser.userModel!.gender.toString() == "Qadin"
                                  ? "images/imagewoman.png"
                                  : "images/imageman.png",
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                color: themaController.isDark.isTrue
                                    ? Colors.white
                                    : Colors.black,
                                labeltext: modelUser.userModel!.name
                                        .toString()
                                        .toUpperCase() ??
                                    'Username',
                                fontsize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                  color: themaController.isDark.isTrue
                                      ? Colors.white
                                      : Colors.black,
                                  labeltext: modelUser.userModel!.roleName
                                          .toString()
                                          .toUpperCase(),
                                  fontsize: 10),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      WidgetDilSecimi(
                          localizationController: localizationController,
                          isDestop: true,
                          callBack: () {
                            drawerMenuController.changeIndexWhenLanguageChange();
                            setState(() {});
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: themaController.isDark.isTrue
                            ? IconButton(
                                onPressed: () {
                                  themaController.toggleTheme();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.light_mode_outlined,
                                  color: Colors.white,
                                ))
                            : IconButton(
                                onPressed: () {
                                  themaController.toggleTheme();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.dark_mode_outlined,
                                  color: Colors.black,
                                )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget widgetSystemTitle() {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 280,
            minHeight:50,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50))),
          ),
        ),
        SizedBox(
          width: 280,
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 10,),
              CircleAvatar(
                maxRadius: 15,
                minRadius: 10,
                child: Image.asset("images/zs2.png"),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      labeltext: AppConstands.appName,
                      fontWeight: FontWeight.bold,
                      fontsize: 14,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomText(
                        color: Colors.white,
                        labeltext: 'nezsystem',
                        fontWeight: FontWeight.bold,
                        maxline: 2,
                        fontsize: 12),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(top: BorderSide(color: Colors.black, width: 0.2))),
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(labeltext: 'developed', fontsize: 12),
          const SizedBox(
            width: 5,
          ),
          CustomText(
              labeltext: "| Version : 0.0.1", fontWeight: FontWeight.w600),
        ],
      ),
    );
  }


}
