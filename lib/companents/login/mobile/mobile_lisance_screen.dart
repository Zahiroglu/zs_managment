import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/services/api_services/users_apicontroller_web_windows.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:lottie/lottie.dart';
//import 'package:platform_device_id/platform_device_id.dart';
import 'package:android_id/android_id.dart';

class ScreenRequestCheckMobile extends StatelessWidget {
   ScreenRequestCheckMobile({Key? key}) : super(key: key);

  UserApiControllerMobile apiController = Get.put(UserApiControllerMobile());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
      return Material(
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widgetLogoHisse(),
                    SizedBox(
                      height: 60.h,
                    ),
                    Obx(() {
                      return apiController.isLoading.isTrue
                          ? widgetAnimationYoxlanir(context)
                          : widgetMelumatTapilmadi();
                    }),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
                Positioned(
                    bottom: 10.h,
                    right: 5.w,
                    child: widgetFooter())
              ],
            ),
          ));
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

  Stack widgetAnimationYoxlanir(BuildContext context) {
    ScreenUtil.init(context);
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

            ],
          ),
        )
      ],
    );
  }

  Padding widgetMelumatTapilmadi() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.red, size: 72.spMin),
          SizedBox(
            height: 10.h,
          ),
          CustomText(
            labeltext: apiController.basVerenXeta,
            fontWeight: FontWeight.normal,
            maxline: 3,
            fontsize: 18.spMin,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          apiController.countClick.value == 3
              ? CustomElevetedButton(
                  cllback: () {
                  apiController.clouseApp();

                  },
                  label: "yenidenBaslat".tr,
                  surfaceColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                  height: 30.h,
                )
              : CustomElevetedButton(
                  cllback: () {
                    apiController.initPlatformState();
                    apiController.countClick++;
                  },
                  label: "tryagain".tr,
                  surfaceColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                  height: 30.h,
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
            CustomText(labeltext: "ID : ", fontsize: 16,color: Colors.blue,fontWeight: FontWeight.w700),
            SizedBox(height: 5.h,),
            Obx(() =>CustomText(labeltext: apiController.dviceId.value.toString(), fontsize: 16,color: Colors.blue,fontWeight: FontWeight.w600),)
          ],
        ),
        Container(width: 200.w, height: 0.2, color: Colors.blue,)
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
                fontsize: 20,
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
            Obx(() => apiController.deviceIdMustvisible.isTrue? widgetDeviceIdhisse():const SizedBox(),),
            SizedBox(
              height: 5.h,
            ),
          ],
        )
      ],
    );
  }
}
