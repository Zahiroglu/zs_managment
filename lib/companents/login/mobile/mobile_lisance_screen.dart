import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/constands/app_constands.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:lottie/lottie.dart';


//import 'package:platform_device_id/platform_device_id.dart';

class ScreenRequestCheckMobile extends StatelessWidget {
  ScreenRequestCheckMobile({Key? key}) : super(key: key);

  UserApiControllerMobile apiController = Get.put(UserApiControllerMobile());

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widgetLogoHisse(context),
                const SizedBox(
                  height: 60,
                ),
                Obx(() {
                  return apiController.isLoading.isTrue
                      ? widgetAnimationYoxlanir(context)
                      : widgetMelumatTapilmadi();
                }),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Positioned(bottom: 10, right: 5, child: widgetFooter())
          ],
        ),
      ),
    ));
  }

  Align widgetFooter() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(labeltext: "develop".tr),
      ),
    );
  }

  Stack widgetAnimationYoxlanir(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset("lottie/request_checking.json",
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            fit: BoxFit.fitHeight),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                labeltext: 'yoxlanir'.tr,
                fontsize: 20,
                maxline: 2,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent.withOpacity(0.6),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding widgetMelumatTapilmadi() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.red, size: 72),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            labeltext: apiController.basVerenXeta,
            fontWeight: FontWeight.normal,
            maxline: 3,
            fontsize: 18,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          apiController.countClick.value == 3
              ? CustomElevetedButton(
                  cllback: () {
                    apiController.clouseApp();
                  },
                  label: "yenidenBaslat".tr,
                  surfaceColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                  height: 30,
                )
              : CustomElevetedButton(
                  cllback: () {
                    apiController.initPlatformState();
                    apiController.countClick++;
                  },
                  label: "tryagain".tr,
                  surfaceColor: Colors.blueAccent.withOpacity(0.5),
                  elevation: 5,
                  height: 30,
                )
        ],
      ),
    );
  }

  Column widgetDeviceIdhisse(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
                labeltext: "ID : ",
                fontsize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w700),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: apiController.dviceId.value.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height - 100,
                            right: 20,
                            left: 20),
                        backgroundColor: Colors.black.withOpacity(0.5),
                        elevation: 10,
                        duration: const Duration(seconds: 1),
                        content: Center(child: CustomText(labeltext: "copyId".tr,color: Colors.white,)),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CustomText(
                          labeltext: apiController.dviceId.value.toString(),
                          fontsize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.copy,
                        color: Colors.grey,
                      )
                    ],
                  )),
            )
          ],
        ),
        Container(
          width: 200,
          height: 0.2,
          color: Colors.blue,
        )
      ],
    );
  }

  Row widgetLogoHisse(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/zs6.png",
          height: 80,
          width: 80,
        ),
        const SizedBox(
          width: 10,
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
            const SizedBox(
              height: 2,
            ),
            CustomText(labeltext: "nezsystem".tr),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              width: 200,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => apiController.deviceIdMustvisible.isTrue
                  ? widgetDeviceIdhisse(context)
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        )
      ],
    );
  }
}
