import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/thema/theme_constants.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDrawerWindos extends StatefulWidget {
  CustomDrawerWindos({
    required this.drawerMenuController,
    required this.userModel,
    required this.appversion,
    required this.closeDrawer,
    required this.data,
    required this.scaffoldkey,
    required this.logout,
    required this.initialSelected,
    Key? key,
  }) : super(key: key);

  final String appversion;
  final int initialSelected;
  final Function(bool) logout;
  final Function(int index) data;
  final Function(bool clouse) closeDrawer;
  final GlobalKey<ScaffoldState> scaffoldkey;
  DrawerMenuController drawerMenuController=Get.put(DrawerMenuController());
  LoggedUserModel userModel;

  @override
  State<CustomDrawerWindos> createState() => _CustomDrawerWindosState();
}

class _CustomDrawerWindosState extends State<CustomDrawerWindos> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
   // Get.delete<DrawerMenuController>();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20.h,bottom: 20.h),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius:  const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: colorPramary.withOpacity(0.4),
          ),
          padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
          child: widget.drawerMenuController.getItemsMenu(widget.closeDrawer,true,widget.scaffoldkey),
        )
      ),
    );
  }


}
