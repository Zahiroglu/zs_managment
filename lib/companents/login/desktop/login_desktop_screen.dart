import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/login/mobile/login_mobile_first_screen.dart';
import 'package:zs_managment/companents/login/services/api_services/users_apicontroller_web_windows.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/utils/dilsecimi_dropdown.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';

class LoginDesktopScreen extends StatefulWidget {
  const LoginDesktopScreen({Key? key}) : super(key: key);

  @override
  State<LoginDesktopScreen> createState() => _LoginDesktopScreenState();
}

class _LoginDesktopScreenState extends State<LoginDesktopScreen> {
  UsersApiController serverWithGet = Get.put(UsersApiController());
  ThemaController themaController = Get.put(ThemaController());
  late bool _isObscure = true;
  int slideIndex = 0;
  late Timer _timer;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (slideIndex < 2) {
        slideIndex++;
      } else {
        slideIndex = 0;
      }

      controller.animateToPage(
        slideIndex,
        duration: const Duration(seconds: 4),
        curve: Curves.easeIn,
      );
    });
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      child:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return Stack(
          children: [
            Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              color:
                  themaController.isDark.isTrue ? Colors.black : Colors.white,
            ),
            Obx(() {
              return serverWithGet.isLoading.isTrue
                  ? LoagindAnimation(isDark: themaController.isDark.isTrue,icon: "lottie/loadinganima.json",textData: "Giris Yoxlanir",)
                  : loginScreen(localizationController);
            }),
          ],
        );
      }),
    );
  }

  Container loginScreen(LocalizationController localizationController) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 120.h, horizontal: 50.w),
      decoration: BoxDecoration(
          color: themaController.isDark.isTrue ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
              color:
                  themaController.isDark.isTrue ? Colors.white : Colors.black,
              width: themaController.isDark.isTrue ? 1 : 2),
          boxShadow: [
            BoxShadow(
                color: themaController.isDark.isTrue
                    ? Colors.white
                    : Colors.blueAccent.withOpacity(0.5),
                offset: const Offset(5, 5),
                blurRadius: 20,
                spreadRadius: 1
                //  spreadRadius: 2,
                ),
            BoxShadow(
                color: themaController.isDark.isTrue
                    ? Colors.white
                    : Colors.blueAccent.withOpacity(0.5),
                offset: const Offset(-5, -5),
                blurRadius: 10
                //  spreadRadius: 2,
                )
          ]),
      child: Card(
        //shadowColor:Get.isDarkMode?Colors.white:Colors.black,
        elevation: 0,
        color: themaController.isDark.isTrue ? Colors.black : Colors.white,
        // margin: EdgeInsets.symmetric(
        //     vertical:
        //     ScreenUtil().screenHeight * 0.2,
        //     horizontal:
        //     ScreenUtil().screenWidth * 0.18),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(flex: 2, child: widgetHeader(localizationController)),
              //basliq hisse ucun
              Expanded(flex: 16, child: widgetBody(localizationController)),
              //giris ve slide ucun
              Expanded(flex: 2, child: widgetFooter(localizationController))
              //footer ucun
            ],
          ),
        ),
      ),
    );
  }

  Center widgetHeader(LocalizationController localizationController) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Center(
            child: CustomText(
          color: themaController.isDark.isTrue ? Colors.white : Colors.black,
          labeltext: 'welcome',
          fontsize: 12.sp,
          fontWeight: FontWeight.bold,
        )),
        Row(
          children: [
            WidgetDilSecimi(
              isLoginScreen: true,
              callBack: (){
                setState(() {
                });
              },
              isDestop: true, localizationController: localizationController),
            SizedBox(
              width: 5.w,
            ),
            Obx(() => Container(
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
                            setState(() {
                              //localizationController.toggleTheme(true);
                              themaController.toggleTheme();
                            });
                          },
                          icon: const Icon(
                            Icons.dark_mode_outlined,
                            color: Colors.black,
                          )),
                )),
          ],
        )
      ],
    ));
  }

  Row widgetBody(LocalizationController localizationController) {
    return Row(
      children: [
        Expanded(flex: 1, child: widgetLoginPart(localizationController)),
        VerticalDivider(
          color: themaController.isDark.isTrue ? Colors.white : Colors.black,
        ),
        Expanded(
          flex: 1,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTileWindos(

                imagePath: getSlides()[0].getImageAssetPath()!,
                title: getSlides()[0].getTitle()!,
                desc: getSlides()[0].getDesc()!,
                themaController: themaController,
              ),
              SlideTileWindos(
                imagePath: getSlides()[1].getImageAssetPath()!,
                title: getSlides()[1].getTitle()!,
                desc: getSlides()[1].getDesc()!,
                themaController: themaController,
              ),
              SlideTileWindos(
                imagePath: getSlides()[2].getImageAssetPath()!,
                title: getSlides()[2].getTitle()!,
                desc: getSlides()[2].getDesc()!,
                themaController: themaController,
              ),
              SlideTileWindos(
                imagePath: getSlides()[3].getImageAssetPath()!,
                title: getSlides()[3].getTitle()!,
                desc: getSlides()[3].getDesc()!,
                themaController: themaController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Center widgetLoginPart(LocalizationController localizationController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            color: themaController.isDark.isTrue ? Colors.white : Colors.black,
            labeltext: "Giris",
            fontsize: 10.sp,
          ),
          SizedBox(
            height: 30.h,
          ),
          Flexible(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomTextField(
                        obscureText: false,
                        updizayn: false,
                        icon: Icons.perm_identity,
                        controller: serverWithGet.ctUsername,
                        inputType: TextInputType.text,
                        hindtext: 'username'.tr,
                        fontsize: 4.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomTextField(
                        obscureText: _isObscure,
                        onTopVisible: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        suffixIcon: _isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        updizayn: false,
                        icon: Icons.lock,
                        controller: serverWithGet.ctPassword,
                        inputType: TextInputType.visiblePassword,
                        hindtext: 'password'.tr,
                        fontsize: 4.sp),
                  ),
                  Obx(() {
                    return serverWithGet.isLoading.isTrue
                        ? const SizedBox()
                        : CustomElevetedButton(
                      height: 30.h,
                            cllback: () {
                              setState(() {});
                              _login();
                            },
                            label: "daxilOl".tr,
                            textColor: themaController.isDark.isTrue
                                ? Colors.white
                                : Colors.black,
                            surfaceColor: themaController.isDark.isTrue
                                ? Colors.black
                                : Colors.white,
                            borderColor: themaController.isDark.isTrue
                                ? Colors.white
                                : Colors.black);
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row widgetFooter(LocalizationController localizationController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(2.0.sp),
          child: CustomText(
            color: themaController.isDark.isTrue ? Colors.white : Colors.black,
            fontsize: 4.sp,
            labeltext: 'develop'.tr,
          ),
        )
      ],
    );
  }

  Future<void> _login() async {
    serverWithGet.getCompanyUrlByDivaceId();
   // serverWithGet.loginWithUsername();
  }
}

class SlideTileWindos extends StatelessWidget {
  String imagePath, title, desc;
  ThemaController themaController;

  SlideTileWindos(
      {super.key,
        required this.themaController,
      required this.imagePath,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Lottie.asset(
                imagePath,
                height: ScreenUtil().screenHeight * 0.25,
                filterQuality: FilterQuality.medium,
                fit: BoxFit.fill),
            SizedBox(
              height: 5.h,
            ),
            CustomText(
                color: Colors.blueAccent.withOpacity(0.8),
                labeltext: title,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
                fontsize: 14,
                latteSpacer: 0.1,
                maxline: 2),
            SizedBox(
              height: 10.h,
            ),
            CustomText(
              color: themaController.isDark.isTrue?Colors.white:Colors.black,
                labeltext: desc,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
                fontsize: 12,
                maxline: 5),
          ],
        ),
      ),
    ));
  }
}
