import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/drawer/model_drawerItems.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/sual_dialog.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import '../drawer/selection_buttondrawer.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawerMobile extends StatefulWidget {
  CustomDrawerMobile({
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
      backgroundColor: Colors.transparent,
      body: Container(
        //argin:  EdgeInsets.only(top: widget.isMobile?0.h:50.h, bottom: widget.isMobile?0.h:50.h),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius:  const BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0)),
          border: Border.all(color: Colors.black),
          color: Colors.blue.withOpacity(0.4),
        ),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10.w, 40.h, 0, 0),
              height: 100.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(width: 5.w,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.h,),
                        CustomText(labeltext: "${widget.userModel.userModel!.username} - ${widget.userModel.userModel!.code}",fontWeight: FontWeight.w700,fontsize: 16.sp,overflow: TextOverflow.ellipsis,),
                       // CustomText(labeltext: "${widget.userModel.userModel!.departamentName} | ${widget.userModel.userModel!.roleName}",fontWeight: FontWeight.w500,fontsize: 14.sp,overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(thickness: 1),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      widgetMenuItems(),
                    ],
                  )),
            ),
            const Divider(thickness: 1),
            Expanded(flex: 1, child: widgetLogOut(context)),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Padding widgetLogOut(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          elevation: 0,
          minimumSize:  Size(100.w, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ShowSualDialog(
                    messaje: "cmeminsiz".tr,
                    callBack: (val) {
                      if(val) {
                        setState(() {
                          print("Cixis ucun Buton basildi");
                          widget.logout.call(val);
                          //Get.offNamed(RouteHelper.getWellComeScreen());
                        });
                      }
                    });
              });
        },
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.logout),
              const SizedBox(width: 5,),
               CustomText(labeltext: "cixiset".tr,fontWeight: FontWeight.w600,color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }

  Center widgetMenuItems() {
    return Center(
      child: SelectionButton(
        isExpendet: true,
        initialSelected: widget.initialSelected,
        data: [],
        onSelected: (index, value) {
          setState(() {
            widget.data.call(index);
          });
        },
      ),
    );
  }
}
