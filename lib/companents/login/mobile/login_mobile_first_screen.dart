import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../local_bazalar/local_users_services.dart';
import '../../notifications/firebase_notificatins.dart';

class LoginMobileFirstScreen extends StatefulWidget {
  const LoginMobileFirstScreen({Key? key}) : super(key: key);

  @override
  State<LoginMobileFirstScreen> createState() => _LoginMobileFirstScreenState();
}

class _LoginMobileFirstScreenState extends State<LoginMobileFirstScreen> {
  List<SliderModel> mySLides = [];
  int slideIndex = 0;
  late PageController controller;
  LocalUserServices userLocalService=LocalUserServices();
  FirebaseNotyficationController firebaseNotyficationController=FirebaseNotyficationController();

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    userLocalService.init();
    mySLides = getSlides();
    controller = PageController(initialPage: slideIndex);
    controller.addListener(() => _changeIndex());
    firebaseNotyficationController.reguestForFirebaseNoty();
    firebaseNotyficationController.fireBaseMessageInit();
  }

  _changeIndex() {
    setState(() {
      slideIndex == controller.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: ScreenUtil().screenHeight - 80,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        slideIndex = index;
                      });
                    },
                    children: <Widget>[
                      SlideTile(
                        imagePath: mySLides[0].getImageAssetPath()!,
                        title: mySLides[0].getTitle()!,
                        desc: mySLides[0].getDesc()!,
                      ),
                      SlideTile(
                        imagePath: mySLides[1].getImageAssetPath()!,
                        title: mySLides[1].getTitle()!,
                        desc: mySLides[1].getDesc()!,
                      ),
                      SlideTile(
                        imagePath: mySLides[2].getImageAssetPath()!,
                        title: mySLides[2].getTitle()!,
                        desc: mySLides[2].getDesc()!,
                      ),
                      SlideTile(
                        imagePath: mySLides[3].getImageAssetPath()!,
                        title: mySLides[3].getTitle()!,
                        desc: mySLides[3].getDesc()!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: slideIndex == mySLides.length - 1
              ? Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 16.w, horizontal: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Spacer(),
                      const Spacer(),
                      Row(
                        children: [
                          for (int i = 0; i < mySLides.length; i++)
                            i == slideIndex
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false),
                        ],
                      ),
                      const Spacer(),
                      CustomElevetedButton(
                          cllback: () async {
                            Get.offNamed(RouteHelper.mobileLisanceScreen);
                            await userLocalService.addValueForAppFistTimeOpen(true);
                          },
                          label: "giris".tr,
                          surfaceColor: Colors.blueAccent.withOpacity(0.3),
                          width: 200.w,
                          height: 20.h,
                          elevation: 6),
                    ],
                  ),
                )
              : Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomElevetedButton(
                          cllback: () {
                            controller.animateToPage(mySLides.length - 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.linear);
                          },
                          label: "scipe".tr,
                          surfaceColor: Colors.blue.withOpacity(0.3),
                          width: 20.w,
                          height: 20.h,
                          elevation: 10),
                      Row(
                        children: [
                          for (int i = 0; i < mySLides.length; i++)
                            i == slideIndex
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false),
                        ],
                      ),
                      CustomElevetedButton(
                          cllback: () {
                            controller.animateToPage(slideIndex + 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.linear);
                          },
                          label: "next".tr,
                          surfaceColor: Colors.green.withOpacity(0.3),
                          width: 100.w,
                          height: 20.h,
                          elevation: 10),
                    ],
                  ),
                )),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Lottie.asset(imagePath,height: ScreenUtil().screenHeight/2.5,filterQuality: FilterQuality.medium,fit: BoxFit.fill),
            SizedBox(
              height: 40.h,
            ),
            CustomText(
                color: Colors.blueAccent.withOpacity(0.8),
                labeltext: title,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
                fontsize: 24.sp,
                latteSpacer: 0.1,
                maxline: 2),
            SizedBox(height: 20.h,),
            CustomText(
                labeltext: desc,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
                fontsize: 20.sp,
                maxline: 5),
          ],
        ),
      ),
    );
  }
}

class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title;
  }

  String? getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = SliderModel();

  //1
  sliderModel.setTitle("Genis Hesabatlar");
  sliderModel.setDesc(
      "Programda size uygun istenilen hesabatlara baxa analiz ede bilersiniz.");
  sliderModel.setImageAssetPath("lottie/lottie_hesabat.json");
  slides.add(sliderModel);
  sliderModel = SliderModel();

  //2
  sliderModel.setDesc("Rahat ve deqiq gunluk marsurutun nizamlanmasi");
  sliderModel.setTitle("Marsurut tenzimleyici");
  sliderModel.setImageAssetPath("lottie/map_navigation.json");
  slides.add(sliderModel);
  sliderModel = SliderModel();

  //3
  sliderModel
      .setDesc("Bir cihazin size yaratdigi ustunluklere inana bilmeyeceksiniz");
  sliderModel.setTitle("Mobil Ustunluk");
  sliderModel.setImageAssetPath("lottie/mobile_use.json");
  slides.add(sliderModel);
  sliderModel = SliderModel();
  //4
  sliderModel.setDesc("Mobil cihazla ve Kompyuterle nezaret imkani");
  sliderModel.setTitle("Kompyuter uygunlasma");
  sliderModel.setImageAssetPath("lottie/lottie_mobilendcom.json");
  slides.add(sliderModel);
  sliderModel = SliderModel();

  return slides;
}
