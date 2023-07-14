import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/mobile/screens/screen_dashbourdmobile.dart';
import 'package:zs_managment/app_companents/mobile/screens/users_screen.dart';
import 'package:zs_managment/app_companents/windows/custom_drawer.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:get/get.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../drawer_screencontroller.dart';
import 'custom_drawermobile.dart';
import '../windows/base_screenwindows.dart';

class BaseScreenMobile extends StatefulWidget {
  LoggedUserModel loggedUserModel;
   BaseScreenMobile({required this.loggedUserModel,Key? key}) : super(key: key);

  @override
  State<BaseScreenMobile> createState() => _BaseScreenMobileState();
}

class _BaseScreenMobileState extends State<BaseScreenMobile> {
  DrawerScreenController pageController=Get.put(DrawerScreenController());
  late SharedManager sharedManager = SharedManager();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  // late var pageView;
  // int drawerIndex=-1;


  @override
  void initState() {
    sharedManager.init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
        child: Scaffold(drawerEnableOpenDragGesture: false,
      key: _key,
      drawer: Obx(
        () => Drawer(
          elevation: 20,
          width: ScreenUtil().screenWidth*0.7,
          child: CustomDrawerMobile(
            userModel: widget.loggedUserModel,
            data: (va) {
              pageController.changeIndex(va);
              // changeIndex(va);
              _key.currentState!.closeDrawer();
            },
            logout: (val) {
              if (val) {
                Get.offNamed(RouteHelper.getWellComeScreen());
                sharedManager.cleareAllInfo();
              }
            },
            scaffoldkey: _key,
            appversion: '0.1',
            initialSelected: pageController.drawerIndex.toInt(),
            closeDrawer: (val) {},
          ),
        ),
      ),
      body:Padding(
        padding:  EdgeInsets.symmetric(vertical: 30.h,horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  _key.currentState?.openDrawer();
                }, icon: Icon(Icons.menu),color: Colors.black,)
              ],
            ),
            Expanded(child: pageController.getCurrentPage())
          ],
        ),
      )
    ));
  }

  // void changeIndex(int drawerIndexdata) {
  //   if (drawerIndexdata == 0) {
  //     setState(() {
  //       pageView=const ScreenDashBourdMobile();
  //     });
  //   } else if (drawerIndexdata ==1) {
  //     setState(() {
  //       pageView=const UsersScreenMobile();
  //     });
  //   }else if(drawerIndexdata==2){
  //     setState(() {
  //     });
  //
  //   }
  //
  // }

}
