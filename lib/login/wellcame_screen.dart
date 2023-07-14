import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/login/mobile/login_mobileScreen.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/models/login_desktopmodel.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WellCameScreen extends StatefulWidget {
  const WellCameScreen({Key? key}) : super(key: key);

  @override
  State<WellCameScreen> createState() => _WellCameScreenState();
}

class _WellCameScreenState extends State<WellCameScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late Timer timer;
  late SharedManager sharedManager = SharedManager();
  late LoggedUserModel modelUser = LoggedUserModel();
  bool isLoading = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setLastThema();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    timer = Timer(const Duration(seconds: 3), () {
      getUser();
    });
  }

  setLastThema() async {
    await sharedManager.init();
    bool? val = await sharedManager.getSavedThema();
    if (val != null) {
      if (val == true) {
        Get.changeTheme(ThemeData.dark());
      } else {
        Get.changeTheme(ThemeData.light());
      }
    }
  }

  getUser() async {
    await sharedManager.init();
    modelUser = await sharedManager.getLoggedUser();
    if (modelUser.isLogged == null || modelUser.isLogged == false) {
      if (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isFuchsia) {
        Get.offNamed(RouteHelper.getLoginWindows());
      } else {
        sharedManager.checkIsFistTimeOpen().then((value) => {
              if (value == true)
                {Get.offNamed(RouteHelper.getmobileCheckLisance())}
              else
                {Get.offNamed(RouteHelper.getLoginMobile())}
            });
      }
    } else {
      if (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isFuchsia) {
        Get.offNamed(RouteHelper.getmainScreenWidows(),arguments: modelUser);
      } else {
        sharedManager.checkIsFistTimeOpen().then((value) => {
          if (value == true)
            {Get.offNamed(RouteHelper.getmainScreenMobile(),arguments: modelUser)}
          else
            {Get.offNamed(RouteHelper.getLoginMobile())}
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: Center(
                child: Image.asset(
              "images/zs6.png",
              width: 200.w,
              height: 200.h,
            )),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(labeltext: 'welcome', fontsize: 18.sp, maxline: 2),
              SizedBox(
                width: 5.w,
              ),
              Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  size: 8.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
