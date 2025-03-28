import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zs_managment/companents/anbar/controller_anbar.dart';
import 'package:zs_managment/companents/local_bazalar/local_bazalar.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
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

import '../login/models/model_userspormitions.dart';

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
  void initState() {
    if(settingPanelController.initialized){
      settingPanelController.getCurrentLoggedUserFromLocale(UserModel());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(child:
        GetBuilder<LocalizationController>(builder: (localizationController) {
      return  Scaffold(
        body: Obx((){return NestedScrollView(
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
                      child:  settingPanelController.dataLoading.isFalse?  widgetHeaderFull(localizationController):SizedBox(),
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
          body: settingPanelController.dataLoading.isFalse? widgetSettingPart(settingPanelController.modelModule.value, themaController):Center(child: CircularProgressIndicator(color: Colors.green,),),
        );}),
      );
    }));
  }


  @override
  void dispose() {
    Get.delete<SettingPanelController>();
    super.dispose();
  }

  void _openDrawer() {
    widget.drawerMenuController.openDrawer();
    setState(() {
    });
  }

  Widget widgetHeaderFull(LocalizationController localizationController) {
    return SizedBox(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Obx(() => Column(
          children: [
            Container(
              height: 20,
            ),
            CircleAvatar(
              maxRadius: 50,
              minRadius: 50,
              backgroundColor: Colors.white,
              child: Image.asset(
                settingPanelController.modelModule.value.gender.toString() == "1"
                    ? "images/imagewoman.png"
                    : "images/imageman.png",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              labeltext: "${settingPanelController.modelModule.value.username!.toUpperCase()} ${settingPanelController.modelModule.value.surname}",
              fontWeight: FontWeight.w600,
              fontsize: 14,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              color:
              themaController.isDark.isTrue ? Colors.white : Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() => CustomText(
              labeltext:
              "${settingPanelController.modelModule.value.moduleName} | ${settingPanelController.modelModule.value.roleName}",
              fontWeight: FontWeight.w700,
              fontsize: 14,
              overflow: TextOverflow.ellipsis,
              color:
              themaController.isDark.isTrue ? Colors.white : Colors.black,
            )),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              padding: EdgeInsets.only(top: 5, bottom: 5),
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
            height: 5,
          ),
          widgetPersonalPermisions(model, themaController),
        ],
      ),
    );
  }

  Widget widgetPersonalInfo(UserModel model, ThemaController themaController) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
              const SizedBox(
                width: 10,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"region".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                  color: themaController.isDark.isTrue
                      ? Colors.white
                      : Colors.black,
                  labeltext: model.regionName.toString().toUpperCase() ?? "Bos")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.date_range),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"birthDay".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                  color: themaController.isDark.isTrue
                      ? Colors.white
                      : Colors.black,
                  labeltext:
                      model.birthdate.toString().toUpperCase() ??"")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.code),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"userCode".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                labeltext: model.code ?? "".toUpperCase() ?? "",
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.phone_android_outlined),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"userPhone".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                labeltext: model.phone.toString() ?? "",
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(Icons.email_outlined),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                color:
                    themaController.isDark.isTrue ? Colors.white : Colors.black,
                labeltext: "${"email".tr.toUpperCase()} : ",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                  color: themaController.isDark.isTrue
                      ? Colors.white
                      : Colors.black,
                  labeltext: model.email.toString() ?? "")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget widgetPersonalPermisions(UserModel model, ThemaController themaController) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
                  const SizedBox(
                    width: 5,
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
                  const SizedBox(
                    width: 5,
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
                const SizedBox(
                  width: 5,
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
    List<ModelUserPermissions> listper=[];
    listper.addAll(model.permissions!);
    listper.addAll(model.draweItems!);
    Get.to(ScreenUserPermisions(listPermisions: listper));

  }

  void baglantilarFormunaBax(UserModel model) {
    Get.to(ScreenUserConnections(listConnections:  model.connections!));

  }

  void appsettionFormunaBax(UserModel model) {
    Get.toNamed(RouteHelper.mobileMapSettingMobile);

  }

  Future<void> _sistemiYenidenBaslat() async {
    Get.delete<DrawerMenuController>();
    Get.delete<UserApiControllerMobile>();
   // Get.delete<SettingPanelController>();
    Get.delete<ControllerAnbar>();
    await localBazalar.clearLoggedUserInfo();
    await localBazalar.clearAllBaseDownloads();
    Get.offAllNamed(RouteHelper.getMobileLisanceScreen());

  }
}
