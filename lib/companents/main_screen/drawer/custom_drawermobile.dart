import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/thema/theme_constants.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/sual_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDrawerMobile extends StatefulWidget {
  CustomDrawerMobile({
    required this.drawerMenuController,
    required this.userModel,
    required this.appversion,
    required this.closeDrawer,
    required this.data,
    required this.scaffoldkey,
    required this.initialSelected,
    Key? key,
  }) : super(key: key);

  final String appversion;
  final int initialSelected;
  final Function(int index) data;
  final Function(bool clouse) closeDrawer;
  final GlobalKey<ScaffoldState> scaffoldkey;
  DrawerMenuController drawerMenuController=Get.put(DrawerMenuController());
  LoggedUserModel userModel;

  @override
  State<CustomDrawerMobile> createState() => _CustomDrawerMobileState();
}

class _CustomDrawerMobileState extends State<CustomDrawerMobile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius:  const BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0)),
          color: colorPramary.withOpacity(0.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Expanded(
                flex: 2,
                child: widgetHeader()),
            const Divider(thickness: 3,endIndent: 5,indent: 5),
            Expanded(
              flex: 12,
              child: widget.drawerMenuController.getItemsMenu(widget.closeDrawer,false),
            ),
            // const SizedBox(
            //   height: 50,
            // )
          ],
        ),
      ),
    );
  }

  Padding widgetHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                maxRadius: 30.w,
                minRadius: 20.w,
                backgroundColor: Colors.white,
                child:  Image.asset(
                  widget.userModel.userModel!.gender.toString() == "Qadin"
                      ? "images/imagewoman.png"
                      : "images/imageman.png",
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(labeltext: "${widget.userModel.userModel!.name} ${widget.userModel.userModel!.surname} - ${widget.userModel.userModel!.code}",fontWeight: FontWeight.w700,fontsize: 14.sp,overflow: TextOverflow.ellipsis,),
                    SizedBox(width: 5.h,),
                    CustomText(labeltext: "${widget.userModel.userModel!.moduleName}",fontWeight: FontWeight.w500,fontsize: 12.sp,overflow: TextOverflow.ellipsis,),
                    CustomText(labeltext: "${widget.userModel.userModel!.roleName}",fontWeight: FontWeight.w500,fontsize: 12.sp,overflow: TextOverflow.ellipsis,),

                  ],
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

}
