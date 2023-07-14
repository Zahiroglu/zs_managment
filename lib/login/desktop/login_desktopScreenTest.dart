import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/customwidgets/CustomTextFiled.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/customwidgets/loagin_animation.dart';
import 'package:zs_managment/customwidgets/simple_dialog.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/utils/dilsecimi_dropdown.dart';
import 'package:zs_managment/login/service/i_userservic.dart';
import 'package:zs_managment/login/service/models/base_responce.dart';
import 'package:zs_managment/login/service/shared_manager.dart';
import 'package:zs_managment/login/service/user_service.dart';
import 'package:zs_managment/rout/rout_controller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/thema/theme_constants.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/users_apicontroller.dart';

class LoginDesktopScreenTest extends StatefulWidget {
  const LoginDesktopScreenTest({Key? key}) : super(key: key);

  @override
  State<LoginDesktopScreenTest> createState() => _LoginDesktopScreenTestState();
}

class _LoginDesktopScreenTestState extends State<LoginDesktopScreenTest> {
  UsersApiController serverWithGet=Get.put(UsersApiController());
  late bool _isObscure = true;

  @override
  initState() {
    super.initState();
  }

  hemeListener() {
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return  Material(
        child: GetBuilder<LocalizationController>(
            builder: (localizationController) {
              return Stack(
                children: [
                  Container(
                    height:ScreenUtil().screenHeight,
                    width: ScreenUtil().screenWidth,
                    color: localizationController.isDark?Colors.black:Colors.white,
                  ),
                  Obx(() {
                    return serverWithGet.isLoading.isTrue
                        ? LoagindAnimation(isDark: localizationController.isDark)
                        : loginScreen(localizationController);
                  })

                ],
              );
            }),
      );
  }

  Container loginScreen(LocalizationController localizationController) {
    return
    Container(
      margin: EdgeInsets.symmetric(
          vertical:50.h,
          horizontal:20.w),
      padding: EdgeInsets.symmetric(vertical: 120.h,horizontal: 50.w),
      decoration: BoxDecoration(
        color: localizationController.isDark?Colors.black:Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: localizationController.isDark?Colors.white:Colors.black,width: localizationController.isDark?1:2),
          boxShadow: [
          BoxShadow(
            color:localizationController.isDark?Colors.white:Colors.blueAccent.withOpacity(0.5),
            offset: const Offset(5,5),
          blurRadius: 20,
          spreadRadius: 1
          //  spreadRadius: 2,
          ),
          BoxShadow(
            color: localizationController.isDark?Colors.white:Colors.blueAccent.withOpacity(0.5),
            offset: const Offset(-5,-5),
          blurRadius: 10
          //  spreadRadius: 2,
          )
        ]
      ),
      child: Card(
        //shadowColor:Get.isDarkMode?Colors.white:Colors.black,
        elevation: 0,
        color: localizationController.isDark?Colors.black:Colors.white,
        // margin: EdgeInsets.symmetric(
        //     vertical:
        //     ScreenUtil().screenHeight * 0.2,
        //     horizontal:
        //     ScreenUtil().screenWidth * 0.18),
        child: Padding(
          padding:  const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: widgetHeader(localizationController)), //basliq hisse ucun
              Expanded(
                  flex: 16,
                  child: widgetBody(localizationController)), //giris ve slide ucun
              Expanded(
                  flex: 2,
                  child: widgetFooter(localizationController)) //footer ucun
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
                  color: localizationController.isDark?Colors.white:Colors.black,
                  labeltext: 'welcome',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.bold,
                )),
            Row(
              children: [
                WidgetDilSecimi(
                    localizationController:
                    localizationController),
                SizedBox(width: 5.w,),
                Container(
                  alignment: Alignment.centerRight,
                  child: localizationController.isDark?IconButton(
                      onPressed: (){
                        setState(() {
                          localizationController.toggleTheme(false);
                          hemeListener();
                        });
                      }, icon: const Icon(Icons.light_mode_outlined,color: Colors.white,))
                      :IconButton(onPressed: (){
                    setState(() {
                      localizationController.toggleTheme(true);
                      hemeListener();
                    });

                  }, icon: const Icon(Icons.dark_mode_outlined,color: Colors.black,)),)
              ],
            )
          ],
        ));
  }

  Row widgetBody(LocalizationController localizationController) {
    return Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: widgetLoginPart(localizationController)),
                    VerticalDivider(
                      color: localizationController.isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                    Expanded(
                        flex: 1, child: widgetSliderPart(localizationController))
                  ],
                );
  }

  FlutterCarousel widgetSliderPart(LocalizationController localizationController) {
    return FlutterCarousel(
        items: [
          Stack(
            children: [
              Image.asset(
                "images/slidegps.png",
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: ScreenUtil().screenHeight * 0.15,
                  width:ScreenUtil().screenWidth * 0.3,
                  child: Center(
                    child: CustomText(
                        color: localizationController.isDark?Colors.white:Colors.black,
                        fontsize: 5.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        maxline: 5,
                        labeltext: "Butun iscileri nezareti ve is bolgusu"),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Image.asset(
                "images/slidemobilgps.png",
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: ScreenUtil().screenHeight * 0.15,
                  width:ScreenUtil().screenWidth * 0.3,
                  child: Center(
                    child: CustomText(
                        color: localizationController.isDark?Colors.white:Colors.black,
                        fontsize: 5.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        maxline: 5,
                        labeltext: "Genis tetbiq ve izleme imkanlari"),
                  ),
                ),
              ),
            ],
          ),
        ],
        options: CarouselOptions(
          height: double.infinity,
          aspectRatio: 16 / 9,
          viewportFraction: 1.0,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 2),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          onPageChanged: (val, responce) {},
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          pauseAutoPlayOnTouch: true,
          pauseAutoPlayOnManualNavigate: true,
          pauseAutoPlayInFiniteScroll: false,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          disableCenter: false,
          showIndicator: true,
          slideIndicator: const CircularSlideIndicator(),
        ));
  }

  Center widgetLoginPart(LocalizationController localizationController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            color: localizationController.isDark?Colors.white:Colors.black,
            labeltext: "Giris",
            fontsize: 10.sp,
          ),
          SizedBox(
            height: 30.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
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
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                child: CustomTextField(
                    obscureText: _isObscure,
                    onTopVisible: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    suffixIcon:
                    _isObscure ? Icons.visibility : Icons.visibility_off,
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
                    cllback: () {
                      setState(() {
                      });
                      _login(localizationController);
                    },
                    label: "Daxil ol".tr,
                    textColor: localizationController.isDark?Colors.white:Colors.black,
                    surfaceColor: localizationController.isDark?Colors.black:Colors.white,
                    borderColor:localizationController.isDark?Colors.white:Colors.black
                );
              })

            ],
          )
        ],
      ),
    );
  }

  Row widgetFooter(LocalizationController localizationController) {
    return Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(2.0.sp),
                      child: CustomText(
                        color: localizationController.isDark?Colors.white:Colors.black,
                        fontsize: 4.sp,
                        labeltext: 'develop'.tr,
                      ),
                    )
                  ],
                );
  }

  Future<void> _login(LocalizationController localizationController) async {
    serverWithGet.loginWithUsername( ResponsiveBuilder.isDesktop(context)
        ? 1
        : ResponsiveBuilder.isMobile(context)
        ? 2
        : 3,   localizationController.selectedIndex);
  }

}

