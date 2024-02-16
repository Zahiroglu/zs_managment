import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/main_screen/drawer/custom_drawer_windows.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';

import '../drawer/custom_drawermobile.dart';

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({ super.key});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  ThemaController themaController=ThemaController();
  DrawerMenuController drawerMenuController=Get.put(DrawerMenuController());
  LocalUserServices userServices=LocalUserServices();
  bool melumatYuklendi=false;


  @override
  void initState() {
    initAllValues();
    initKeyToController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: melumatYuklendi?Scaffold(
          key: _key,
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   //  backgroundColor: Colors.transparent,
          //   backgroundColor:drawerMenuController.selectedIndex.value==0?Colors.transparent:Get.isDarkMode?Colors.black.withOpacity(0.2):Colors.white.withOpacity(0.2),
          //   foregroundColor: Get.isDarkMode?Colors.white:Colors.black,
          //   elevation: 0.0,
          // ),
          drawer: melumatYuklendi?Drawer(
            backgroundColor: Colors.transparent,
            width: ScreenUtil.defaultSize.width*0.8,
            child: CustomDrawerMobile(
              drawerMenuController: drawerMenuController,
              userModel: userServices.getLoggedUser(),
              data: (va) {
              },
              scaffoldkey: _key,
              appversion: '0.1',
              initialSelected: 0,
              closeDrawer: (val) {
                _key.currentState!.closeDrawer();
                setState(() {
                });
              },
            ),
          ):const Drawer(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: drawerMenuController.getCurrentPage())
              ],
            ),
          ),
        ):LoagindAnimation(isDark: Get.isDarkMode,textData: "melumatyuklenir".tr,icon: "lottie/loagin_animation.json"),
      ),
    );

  }

  Future<void> initAllValues() async {
    await userServices.init();
    melumatYuklendi=true;
    setState(() {
    });
  }

  ConstrainedBox widgetCustomDrawer() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
        drawerMenuController.isMenuExpended.isTrue
            ? ScreenUtil.defaultSize.width * 0.0
            : ScreenUtil.defaultSize.width * 0.6,
      ),
      child: Drawer(
        elevation: 0,
        backgroundColor: Colors.transparent,
        width: ScreenUtil.defaultSize.width,
        child: CustomDrawerWindos(
          drawerMenuController: drawerMenuController,
          userModel: userServices.getLoggedUser(),
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

  Widget widgetHeader() {
    return drawerMenuController.userServices.getLoggedUser().toString().isNotEmpty
        ? Container(
      margin: const EdgeInsets.only(bottom: 1),
      alignment: Alignment.centerRight,
      height: 55,
      width: MediaQuery.of(context).size.width*0.7,
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
          widgetMainViewsUser()
        ],
      ),
    )
        : const CircularProgressIndicator();
  }

  Widget widgetMainViewsUser() {
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
                    drawerMenuController.userServices.getLoggedUser().userModel!.gender.toString() == "Qadin"
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
                      labeltext: drawerMenuController.userServices.getLoggedUser().userModel!.name
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
                        labeltext: drawerMenuController.userServices.getLoggedUser().userModel!.roleName
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

  void initKeyToController() {
    if(drawerMenuController.initialized){
      drawerMenuController.initKeyForScafold(_key);
    }
  }
}
