import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/local_bazalar/local_bazalar.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_apicontroller_web_windows.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/setting_panel/screen_user_connections.dart';
import 'package:zs_managment/companents/setting_panel/screen_user_permisions.dart';
import 'package:zs_managment/companents/setting_panel/setting_panel_controller.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/utils/dilsecimi_dropdown.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/thema/thema_controller.dart';
import 'package:zs_managment/thema/theme_constants.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zs_managment/widgets/custom_switch.dart';

class SettingScreenMobile extends StatefulWidget {
  DrawerMenuController drawerMenuController;
   SettingScreenMobile({required this.drawerMenuController,super.key});

  @override
  State<SettingScreenMobile> createState() => _SettingScreenMobileState();
}

class _SettingScreenMobileState extends State<SettingScreenMobile> {
  SettingPanelController settingPanelController = Get.put(SettingPanelController());
  ThemaController themaController = Get.put(ThemaController());
  var _scrollControllerNested;
  LocalBazalar localBazalar = LocalBazalar();


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(child:
        GetBuilder<LocalizationController>(builder: (localizationController) {
      return  Scaffold(
        body: NestedScrollView(
          controller: _scrollControllerNested,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverSafeArea(
                sliver: SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: false,
                  expandedHeight: 300,
                  pinned: true,
                  floating: false,
                  stretch: true,
                  actions: [],
                  title: const SizedBox(),
                  leading: IconButton(
                    icon: const Icon(Icons.menu),onPressed:_openDrawer,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.blurBackground],
                    background:  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration:  BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                offset: const Offset(2,2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal
                            )
                          ],
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                      ),
                      child:  widgetHeaderFull(localizationController),
                    ),
                    collapseMode: CollapseMode.values[0],
                    centerTitle: true,
                  ),
                  // bottom: PreferredSize(
                  //     preferredSize: const Size.fromHeight(70),
                  //     child: ColoredBox(
                  //       color: Colors.white,
                  //       child:  contoller.widgetHesabatlar(context),
                  //     )),
                ),
              )
            ];
          },
          body:  widgetSettingPart(settingPanelController.modelModule.value, themaController),
        ),
      );
      return Scaffold(
          body: Obx(() => Column(
            children: [
              widgetHeaderFull(localizationController),
              widgetSettingPart(settingPanelController.modelModule.value, themaController),
            ],
          )));
    }));
  }
  void _openDrawer() {
    widget.drawerMenuController.openDrawer();
    setState(() {
    });
  }
  Widget widgetHeaderFull(LocalizationController localizationController) {
    return SizedBox(
      child: Container(
        height: ScreenUtil.defaultSize.height * 0.38,
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Obx(() => Column(
          children: [
            Container(
              height: 20.h,
            ),
            CircleAvatar(
              maxRadius: 50.w,
              minRadius: 50.w,
              backgroundColor: Colors.white,
              child: Image.asset(
                settingPanelController.modelModule.value.gender.toString() == "1"
                    ? "images/imagewoman.png"
                    : "images/imageman.png",
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomText(
              labeltext: "${settingPanelController.modelModule.value.username!} ${settingPanelController.modelModule.value.surname}",
              fontWeight: FontWeight.w600,
              fontsize: 14,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              color:
              themaController.isDark.isTrue ? Colors.white : Colors.black,
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(() => CustomText(
              labeltext:
              "${settingPanelController.modelModule.value.moduleName} | ${settingPanelController.modelModule.value.roleName}",
              fontWeight: FontWeight.w700,
              fontsize: 14.sp,
              overflow: TextOverflow.ellipsis,
              color:
              themaController.isDark.isTrue ? Colors.white : Colors.black,
            )),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 30.w, right: 30.w),
              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            labeltext: "theme".tr,
                            color: themaController.isDark.isTrue
                                ? Colors.white
                                : Colors.black),
                        Obx(() => InkWell(
                          onTap: () {
                            themaController.toggleTheme();
                            setState(() {});
                          },
                          child: Icon(themaController.isDark.isTrue
                              ? Icons.light_mode
                              : Icons.dark_mode_outlined),
                        )),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            labeltext: "dil".tr,
                            color: themaController.isDark.isTrue
                                ? Colors.white
                                : Colors.black),
                        WidgetDilSecimi(
                          callBack: (){
                            setState(() {
                            });
                          },
                          isDestop: false,
                          localizationController: localizationController,
                        )
                      ],
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget widgetSettingPart(UserModel model, ThemaController themaController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          widgetPersonalInfo(model, themaController),
          SizedBox(
            height: 5.h,
          ),
          widgetPersonalPermisions(model, themaController),
        ],
      ),
    );
  }

  Widget widgetPersonalInfo(UserModel model, ThemaController themaController) {
    return Container(
      width: ScreenUtil.defaultSize.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.01)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              color:
                  themaController.isDark.isTrue ? Colors.white : Colors.black,
              labeltext: "haqqinda".tr.toUpperCase(),
              fontWeight: FontWeight.w700,
              fontsize: 14),
          Divider(
            thickness: 1.5,
            color: colorPramary.withOpacity(0.4),
          ),
          Row(
            children: [
              const Icon(Icons.place_outlined),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"region".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                  color: themaController.isDark.isTrue
                      ? Colors.white
                      : Colors.black,
                  labeltext: model.regionName.toString().toUpperCase() ?? "Bos")
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              const Icon(Icons.date_range),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"birthDay".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                  color: themaController.isDark.isTrue
                      ? Colors.white
                      : Colors.black,
                  labeltext:
                      model.birthdate.toString().toUpperCase() ??"")
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              const Icon(Icons.code),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"userCode".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                labeltext: model.code ?? "".toUpperCase() ?? "",
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              const Icon(Icons.phone_android_outlined),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"userPhone".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                labeltext: model.phone.toString() ?? "",
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              const Icon(Icons.email_outlined),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"email".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                  color: themaController.isDark.isTrue
                      ? Colors.white
                      : Colors.black,
                  labeltext: model.email.toString() ?? "")
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  Widget widgetPersonalPermisions(UserModel model, ThemaController themaController) {
    return Container(
      width: ScreenUtil.defaultSize.width,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              color:
                  themaController.isDark.isTrue ? Colors.white : Colors.black,
              labeltext: "diger".tr.toUpperCase(),
              fontWeight: FontWeight.w700,
              fontsize: 14),
          Divider(
            thickness: 1.5,
            color: colorPramary.withOpacity(0.4),
          ),
          widgetDigerItems("icazeler",const Icon(Icons.verified_user_outlined,color: Colors.green,),
              const Icon(Icons.arrow_forward_ios_outlined,color: Colors.green,),model,themaController,(){
                icazelerFormunaBax(model);
              }),
          const SizedBox(height: 5,),
          widgetDigerItems("connections",const Icon(Icons.connect_without_contact,color: Colors.blue,),
              const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),model,themaController,(){
            baglantilarFormunaBax(model);
              }),
          const SizedBox(height: 5,),
          widgetDigerItems("appsettings",const Icon(Icons.app_settings_alt,color: Colors.black45,),
              const Icon(Icons.arrow_forward_ios_outlined,color: Colors.black45,),model,themaController,(){
                appsettionFormunaBax(model);
              }),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  CustomText(
                    color: Colors.red,
                    labeltext: "cixiset".tr.toUpperCase(),
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                _sistemiYenidenBaslat();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.refresh_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  CustomText(
                    color: Colors.blue,
                    labeltext: "sistemyenidenBaslat".tr.toUpperCase(),
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding widgetDigerItems(String label,Icon iconsufix,Icon iconPerefix,UserModel model, ThemaController themaController,Function callBack) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 2),
          child: InkWell(
            onTap: () {
             callBack();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconsufix,
                SizedBox(
                  width: 5.w,
                ),
                CustomText(
                    color: themaController.isDark.isTrue
                        ? Colors.white
                        : Colors.black,
                    labeltext: label.tr,
                    fontWeight: FontWeight.w500,
                    fontsize: 16),
                const Spacer(),
                iconPerefix,
              ],
            ),
          ),
        );
  }

  void icazelerFormunaBax(UserModel model) {
    print(model.permissions.toString());
    Get.to(ScreenUserPermisions(listPermisions: model.permissions!));

  }

  void baglantilarFormunaBax(UserModel model) {
    Get.to(ScreenUserConnections(listConnections:  model.connections!));

  }

  void appsettionFormunaBax(UserModel model) {
    Get.toNamed(RouteHelper.mobileMapSettingMobile);

  }

  Future<void> _sistemiYenidenBaslat() async {
    Get.delete<DrawerMenuController>();
    Get.delete<UsersApiController>();
    Get.delete<UserApiControllerMobile>();
    Get.delete<SettingPanelController>();
    Get.delete<ControllerAnbar>();
    await localBazalar.clearLoggedUserInfo();
    await localBazalar.clearAllBaseDownloads();
    Get.offAllNamed(RouteHelper.getMobileLisanceScreen());

  }
}
