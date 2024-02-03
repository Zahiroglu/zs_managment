import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      //color: Colors.transparent,
      child: Scaffold(
        key: _key,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Get.isDarkMode?Colors.white:Colors.black,
          elevation: 0.0,
        ),
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
      ),
    );
  }

  Future<void> initAllValues() async {
    await userServices.init();
    setState(() {
      melumatYuklendi=true;
    });
  }
}
