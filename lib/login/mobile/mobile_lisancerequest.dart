import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/login/service/models/base_responce.dart';
import '../../customwidgets/loagin_animation.dart';
import '../../customwidgets/simple_dialog.dart';
import '../../language/localization_controller.dart';
import '../../main.dart';
import '../service/users_apicontroller.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenRequestCheck extends StatefulWidget {
  const ScreenRequestCheck({Key? key}) : super(key: key);

  @override
  State<ScreenRequestCheck> createState() => _ScreenRequestCheckState();
}

class _ScreenRequestCheckState extends State<ScreenRequestCheck> {
  UsersApiController apiController = Get.put(UsersApiController());
  String dviceId = "";
  bool deviceIdMustvisible=false;
  BaseResponce responce = BaseResponce();
  int countClick = 0;

  checkDviceLisance(String s) async {
    responce = await apiController.LoginWithMobileDviceId(1, 1, s);
    if(responce.exception!.code=="006"){
      setState(() {
        dviceId=s;
        deviceIdMustvisible=true;
      });
    }

  }

  Future<void> initPlatformState() async {
    deviceIdMustvisible=false;
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;

    setState(() {
      if (deviceId!.isNotEmpty) {
        print("Device bos deyil");
        checkDviceLisance(deviceId);
      } else {
        Get.dialog(ShowInfoDialog(
          messaje: "Xeta bas verdi",
          icon: Icons.error_outline,
          callback: () {
            initPlatformState();
          },
        ));
      }
    });
  }

  @override
  void initState() {
    initPlatformState();
    //initPlatformStateA();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GetBuilder<LocalizationController>(builder: (accc) {
      return Material(
          child: SizedBox(
        height: ScreenUtil().screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80.h,
                  ),
                  widgetLogoHisse(),
                  SizedBox(
                    height: 50.h,
                  ),
                  Obx(() {
                    return apiController.isLoading.isTrue
                        ? widgetAnimationYoxlanir()
                        : widgetMelumatTapilmadi();
                  })
                ],
              ),
            ),
            widgetFooter()
          ],
        ),
      ));
    });
  }

  Align widgetFooter() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: CustomText(labeltext: "develop".tr),
      ),
    );
  }

  Stack widgetAnimationYoxlanir() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset("lottie/request_checking.json",
            height: ScreenUtil().screenHeight / 3,
            width: double.infinity,
            fit: BoxFit.fitHeight),
        Positioned(
          bottom: ScreenUtil().screenHeight / 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                labeltext: 'yoxlanir'.tr,
                fontsize: 20.sp,
                maxline: 2,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent.withOpacity(0.6),
              ),
              SizedBox(
                width: 5.w,
              ),
              Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  size: 12.sp,
                  color: Colors.blueAccent.withOpacity(0.6),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding widgetMelumatTapilmadi() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 25.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.red, size: 72.sp),
          SizedBox(
            height: 10.h,
          ),
          CustomText(
            labeltext: responce.exception!.message.toString(),
            fontWeight: FontWeight.w700,
            maxline: 3,
            fontsize: 18.sp,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          countClick == 3
              ? CustomElevetedButton(
                  cllback: () {
                    Get.reset(clearRouteBindings: true);
                    SystemNavigator.pop();
                  },
                  label: "yenidenBaslat".tr,
                  surfaceColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                  height: 20.h,
                )
              : CustomElevetedButton(
                  cllback: () {
                    initPlatformState();
                    countClick++;
                  },
                  label: "tryagain".tr,
                  surfaceColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                  height: 20.h,
                )
        ],
      ),
    );
  }

  Column widgetDeviceIdhisse() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
                labeltext: "ID : ", fontsize: 16.sp,color: Colors.blue,fontWeight: FontWeight.w700),
            SizedBox(
              height: 5.h,
            ),
            CustomText(labeltext: dviceId.toString(), fontsize: 16.sp,color: Colors.blue,fontWeight: FontWeight.w600),
          ],
        ),
        Container(
          width: 180.w,
          height: 0.2,
          color: Colors.blue,
        )
      ],
    );
  }

  Row widgetLogoHisse() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/zs6.png",
          height: 80.h,
          width: 80.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                labeltext: AppConstands.appName,
                fontsize: 20.sp,
                latteSpacer: 0.2,
                fontWeight: FontWeight.w800),
            SizedBox(
              height: 2.h,
            ),
            CustomText(labeltext: "nezsystem".tr),
            SizedBox(
              height: 5.h,
            ),
            Container(
              height: 1,
              width: 200.w,
              color: Colors.black,
            ),
            SizedBox(
              height: 10.h,
            ),
            deviceIdMustvisible? widgetDeviceIdhisse():const SizedBox(),
            SizedBox(
              height: 5.h,
            ),
          ],
        )
      ],
    );
  }
}
