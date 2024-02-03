import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:multiselect/multiselect.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:provider/provider.dart';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_regions.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_dialog/dialog_select_user_connections.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/models/model_roles.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/loagin_animation.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

class ScreenNewUser extends StatefulWidget {
  Function() refreshCall;
  ScreenNewUser({required this.refreshCall,Key? key}) : super(key: key);

  @override
  State<ScreenNewUser> createState() => _ScreenNewUserState();
}

class _ScreenNewUserState extends State<ScreenNewUser>
    with TickerProviderStateMixin {
  PageController controller = PageController(initialPage: 0);
  bool _isObscure = false;
  late ScrollController scrollController;
  late TabController accesTabController;
  late PageController accesPageController;
  int accesGoupIndex = 0;
  NewUserController userController = Get.put(NewUserController());

  @override
  void initState() {
    accesTabController = TabController(length: 0, vsync: this);
    accesPageController = PageController(initialPage: 0);
    controller = PageController(initialPage: 0);
    controller.addListener(() {
      controller.initialPage == userController.selectedIndex.value;
    });
    scrollController = ScrollController(initialScrollOffset: 50.0, keepScrollOffset: true);
    scrollController.addListener(() {
      scrollController.jumpTo(double.parse(userController.selectedIndex.value.toString()));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    accesPageController.dispose();
    accesTabController.dispose();
    controller.dispose();
    Get.delete<NewUserController>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
              border: Border(),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white),
          height: ScreenUtil.defaultSize.height,
          width: ScreenUtil.defaultSize.width,
          margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 50.w),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:Obx(() =>  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric( horizontal: 5.w),
                          child: CustomText(
                              labeltext: "${'newUser'.tr} FORM",
                              fontWeight: FontWeight.bold,
                              fontsize: 18,
                              color: Colors.blue),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          child: widgetProgressStepper(context),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 10,
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child:
                        Obx(() => widgetScreenGeneralInfo(context)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child:
                        Obx(() => widgetScreenIlkinSecimler(context)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: widgetScreenBaglantilar(context),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: widgetScreenIcazeler(context)),
                    ],
                  ),
                ),
                Expanded(flex: 1, child:widgetFooter(context))
              ],
            )),
          ),
        ));
  }

  SizedBox widgetFooter(BuildContext context) {
    ScreenUtil.init(context);
    return SizedBox(
        height: 35.h,
        child:Obx(() =>  Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            userController.selectedIndex.value > 0
                ? SizedBox(
                height: 40.h,
                child: CustomElevetedButton(
                    icon: Icons.arrow_back,
                    elevation: 15,
                    cllback: () {
                      userController.decrementCustomStepper(controller);
                      setState(() {
                      });
                    },
                    label: "geri".tr,
                    surfaceColor: Colors.white,
                    borderColor: Colors.red.withOpacity(0.5)))
                : const SizedBox(),
            SizedBox(
              width: 5.w,
            ),
            userController.canRegisterNewUser.value?SizedBox(
                height: 40.h,
                child: CustomElevetedButton(
                    icon: Icons.add_circle_outline_sharp,
                    elevation: 15,
                    cllback: () async {
                      bool val=await userController.registerUserEndpoint();
                      if(val){
                        widget.refreshCall.call();
                        Get.back();
                      }
                    },
                    label: "qeydiyyat".tr,
                    surfaceColor: Colors.white,
                    textColor: Colors.green,
                    borderColor: Colors.green)):
           userController.canUseNextButton.value?SizedBox(
                height: 40.h,
                child: CustomElevetedButton(
                    icon: Icons.arrow_forward,
                    elevation: 15,
                    cllback: () {
                      userController.useNextButton(controller);
                      setState(() {
                      });
                    },
                    label: "ireli".tr,
                    surfaceColor: Colors.white,
                    borderColor: Colors.blueAccent.withOpacity(0.5))):SizedBox(),
          ],
        )));
  }

  ProgressStepper widgetProgressStepper(BuildContext context) {
    ScreenUtil.init(context);
    return ProgressStepper(
      onClick: (pos) {
        setState(() {});
      },
      padding: 5.w,
      currentStep: 0,
      progressColor: Colors.blueAccent.withOpacity(0.5),
      color: Colors.red.withOpacity(0.5),
      width: 55.w*4,
      height: 25.h,
      stepCount: userController.listStepper.length,
      builder: (int index) {
        return Obx(() => index <= userController.selectedIndex.value?
        Obx(() => ProgressStepWithArrow(
          width: 50.w,
          defaultColor: Colors.red.withOpacity(0.5),
          progressColor: Colors.green.withOpacity(0.5),
          wasCompleted: userController.selectedIndex.value >= index - 1,
          child: Center(
            child: CustomText(
              labeltext: userController.listStepper
                  .elementAt(index - 1)
                  .toString()
                  .tr,
            ),
          ),
        )):
        Obx(() =>  ProgressStepWithChevron(
          width: 50.w,
          defaultColor: Colors.red.withOpacity(0.5),
          progressColor: Colors.green.withOpacity(0.5),
          wasCompleted: userController.selectedIndex.value >= index - 1,
          child: Center(
            child: CustomText(
                labeltext: userController.listStepper
                    .elementAt(index - 1)
                    .toString()
                    .tr),
          ),
        )));
      },
    );
  }

/////////////Ilkin secimler hissesi/////////////////////////
  SingleChildScrollView widgetScreenIlkinSecimler(BuildContext context) {
    ScreenUtil.init(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            supHeaderMainScreens("fistSelectWindows", "fistSelectWindowsDes"),
            SizedBox(
              height: 10.h,
            ),
            userController.regionSecilmelidir.isTrue
                ? widgetRegionSec(context)
                : const SizedBox(),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                userController.regionSecildi.isTrue
                    ? widgetSobeSecimi(context)
                    : const SizedBox(),
                SizedBox(
                  width: 20.w,
                ),
                userController.sobeSecildi.isTrue
                    ? widgetVezifeSecimi(context)
                    : const SizedBox(),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            userController.vezifeSecildi.isTrue
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: "Cihaz icazeleri",
                        fontWeight: FontWeight.w800,
                        fontsize: 18,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      widgetDviceIcaze(),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  )
                : SizedBox(height: 0.h),
          ],
        ),
      ),
    );
  }

  Column widgetRegionSec(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          labeltext: "userRegion".tr,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
            height: 30.h,
            width: 60.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  //background color of dropdown button
                  border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.5), width: 1),
                  //border of dropdown button
                  borderRadius: BorderRadius.circular(5),
                  //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[
                    //apply shadow on Dropdown button
                    BoxShadow(
                        spreadRadius: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.57),
                        //shadow for button
                        blurRadius: 2)
                    //blur radius of shadow
                  ]),
              child:userController.listRegionlar.isNotEmpty? DropdownButton(
                  value: userController.selectedRegion.value,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "regionsec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: userController.listRegionlar
                      .map<DropdownMenuItem<ModelRegions>>(
                        (lang) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: userController.listRegionlar.isNotEmpty?lang:ModelRegions(),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  //background color of dropdown button
                                  borderRadius: BorderRadius.circular(
                                      5), //border raiuds of dropdown button
                                ),
                                height: 40.h,
                                width: 40.w,
                                child: Center(
                                    child: CustomText(
                                        labeltext: lang.name.toString())))),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        userController.changeSelectedRegion(val);
                      });
                    }
                  }):SizedBox(),
            ))
      ],
    );
  }

  Column widgetSobeSecimi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          labeltext: "chouseDepartment".tr,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 30.h,
            width: 60.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  //background color of dropdown button
                  border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.5), width: 1),
                  //border of dropdown button
                  borderRadius: BorderRadius.circular(5),
                  //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[
                    //apply shadow on Dropdown button
                    BoxShadow(
                        spreadRadius: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.57),
                        //shadow for button
                        blurRadius: 2)
                    //blur radius of shadow
                  ]),
              child: DropdownButton(
                  value: userController.selectedSobe.value,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "sobesec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: userController.listSobeler
                      .map<DropdownMenuItem<ModelUserRolesTest>>(
                        (lang) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: lang,
                            child: SizedBox(
                                height: 40.h,
                                width: 40.w,
                                child: Center(
                                    child: CustomText(labeltext: lang.name!)))),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        userController.changeSelectedSobe(val);
                      });
                    }
                  }),
            ))
      ],
    );
  }

  Column widgetVezifeSecimi(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          labeltext: "chousePosition".tr,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 5.h,
        ),
        Obx(() => SizedBox(
            height: 30.h,
            width: 50.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  //background color of dropdown button
                  border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.5), width: 1),
                  //border of dropdown button
                  borderRadius: BorderRadius.circular(5),
                  //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[
                    //apply shadow on Dropdown button
                    BoxShadow(
                        spreadRadius: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.57),
                        //shadow for button
                        blurRadius: 2)
                    //blur radius of shadow
                  ]),
              child: DropdownButton(
                  value: userController.selectedVezife.value,
                  isExpanded: true,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "posSec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: userController.listVezifeler
                      .map<DropdownMenuItem<Role>>(
                        (lang) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: lang,
                            child: SizedBox(
                                height: 40.h,
                                width: 40.w,
                                child: Center(
                                    child: CustomText(
                                        labeltext: lang.name.toString())))),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        userController.changeSelectedVezife(val);
                      });
                    }
                  }),
            )))
      ],
    );
  }

  Widget widgetDviceIcaze() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userController.canUserMobilePermitions.value?Row(
          children: [
            Checkbox(
                value: userController.canUseMobile.value,
                onChanged: (val) {
                  setState(() {
                    userController.changeCnUseMobile(val!);
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 50.w, maxWidth: 60.w),
                child: CustomText(labeltext: "mcihazicaze".tr)),
            userController.canUseMobile.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: 80.w, maxHeight: 40.h, maxWidth: 120.w),
                        child: CustomTextField(
                          borderColor: userController.cttextDviceIdError.value
                              ? Colors.red
                              : Colors.grey,
                          isImportant: true,
                          icon: Icons.mobile_friendly,
                          obscureText: false,
                          controller: userController.cttextDviceId,
                          fontsize: 14,
                          hindtext: "mobId".tr,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: userController.cttextDviceIdError.value
                            ? CustomText(
                                labeltext: "mobId".tr,
                                color: Colors.red,
                                fontsize: 8,
                              )
                            : const SizedBox(),
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ):SizedBox(),
        SizedBox(
            width: ScreenUtil.defaultSize.width * 2.7,
            child: const Divider(
              color: Colors.grey,
            )),
        userController.canUserWindowsPermitions.value?Row(
          children: [
            Checkbox(
                value: userController.canUseWindows.value,
                onChanged: (val) {
                  setState(() {
                    userController.changeCnUseWindows(val!);
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 50.w, maxWidth: 60.w),
                child: CustomText(labeltext: "wicazesi".tr)),
            userController.canUseWindows.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: 80.w, maxHeight: 40.h, maxWidth: 120.w),
                        child: CustomTextField(
                            borderColor:
                                userController.cttextUsernameError.value
                                    ? Colors.red
                                    : Colors.grey,
                            isImportant: true,
                            obscureText: false,
                            updizayn: false,
                            icon: Icons.perm_identity,
                            controller: userController.cttextUsername,
                            inputType: TextInputType.text,
                            hindtext: 'username'.tr,
                            fontsize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: userController.cttextUsernameError.value
                            ? CustomText(
                                labeltext: "icazeWinwosDialogUsername".tr,
                                color: Colors.red,
                                fontsize: 8,
                              )
                            : const SizedBox(),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: 80.w, maxHeight: 40.h, maxWidth: 120.w),
                        child: CustomTextField(
                            borderColor:
                                userController.cttextPasswordError.value
                                    ? Colors.red
                                    : Colors.grey,
                            isImportant: true,
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
                            controller: userController.cttextPassword,
                            inputType: TextInputType.visiblePassword,
                            hindtext: 'password'.tr,
                            fontsize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: userController.cttextPasswordError.value
                            ? CustomText(
                                labeltext: "icazeWinwosDialogPassword".tr,
                                color: Colors.red,
                                fontsize: 8,
                              )
                            : const SizedBox(),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ):SizedBox()
      ],
    );
  }

//////////Genel melumatlar hissesi/////////////////
  Column widgetScreenGeneralInfo(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        supHeaderMainScreens(
            "personalInfoWindowsDes", "personalInfoWindowsDes"),
        SizedBox(
          height: 10.h,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 30.w),
                    child: CustomText(labeltext: "userCode".tr)),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60.w, maxHeight: 40.h, maxWidth: 80.w),
                      child: CustomTextField(
                        borderColor: userController.cttextCodeError.value
                            ? Colors.red
                            : Colors.grey,
                        isImportant: true,
                        icon: Icons.perm_identity,
                        obscureText: false,
                        controller: userController.cttextCode,
                        fontsize: 14,
                        hindtext: "userCode".tr,
                        inputType: TextInputType.text,
                      ),
                    ),
                    userController.cttextCodeError.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userController.cttextCodeError.value
                                ? CustomText(
                                    labeltext: "userCode".tr,
                                    color: Colors.red,
                                    fontsize: 8,
                                  )
                                : const SizedBox(),
                          )
                        : SizedBox()
                  ],
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 30.w),
                    child: CustomText(labeltext: "userName".tr)),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60.w, maxHeight: 40.h, maxWidth: 80.w),
                      child: CustomTextField(
                        borderColor: userController.cttextAdError.value
                            ? Colors.red
                            : Colors.grey,
                        isImportant: true,
                        icon: Icons.perm_identity,
                        obscureText: false,
                        controller: userController.cttextAd,
                        fontsize: 14,
                        hindtext: "userName".tr,
                        inputType: TextInputType.text,
                      ),
                    ),
                    userController.cttextAdError.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userController.cttextAdError.value
                                ? CustomText(
                                    labeltext: "adsoyaderrorText".tr,
                                    color: Colors.red,
                                    fontsize: 8,
                                  )
                                : const SizedBox(),
                          )
                        : SizedBox()
                  ],
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 30.w),
                    child: CustomText(labeltext: "usersurname".tr)),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60.w, maxHeight: 40.h, maxWidth: 80.w),
                      child: CustomTextField(
                        borderColor: userController.cttextSoyadError.value
                            ? Colors.red
                            : Colors.grey,
                        isImportant: true,
                        icon: Icons.perm_identity,
                        obscureText: false,
                        controller: userController.cttextSoyad,
                        fontsize: 14,
                        hindtext: "usersurname".tr,
                        inputType: TextInputType.text,
                      ),
                    ),
                    userController.cttextSoyadError.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userController.cttextSoyadError.value
                                ? CustomText(
                                    labeltext: "adsoyaderrorText".tr,
                                    color: Colors.red,
                                    fontsize: 8,
                                  )
                                : const SizedBox(),
                          )
                        : SizedBox()
                  ],
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 30.w),
                    child: CustomText(labeltext: "email".tr)),
                SizedBox(
                  width: 5.w,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 60.w, maxHeight: 40.h, maxWidth: 80.w),
                  child: CustomTextField(
                    icon: Icons.email_outlined,
                    obscureText: false,
                    controller: userController.cttextEmail,
                    fontsize: 14,
                    hindtext: "email".tr,
                    inputType: TextInputType.emailAddress,
                  ),
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 30.w),
                    child: CustomText(labeltext: "userPhone".tr)),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60.w, maxHeight: 40.h, maxWidth: 80.w),
                      child: CustomTextField(
                        borderColor: userController.cttextTelefonError.value
                            ? Colors.red
                            : Colors.grey,
                        isImportant: true,
                        icon: Icons.phone_android_outlined,
                        obscureText: false,
                        controller: userController.cttextTelefon,
                        fontsize: 14,
                        hindtext: "userPhone".tr,
                        inputType: TextInputType.phone,
                      ),
                    ),
                    userController.cttextTelefonError.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userController.cttextTelefonError.value
                                ? CustomText(
                                    labeltext: "telefonErrorText".tr,
                                    color: Colors.red,
                                    fontsize: 8,
                                  )
                                : const SizedBox(),
                          )
                        : SizedBox()
                  ],
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 30.w),
                    child: CustomText(labeltext: "birthDay".tr)),
                SizedBox(
                  width: 5.w,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: CustomTextField(
                    align: TextAlign.center,
                    suffixIcon:Icons.date_range ,
                      obscureText: false,
                      updizayn: true,
                      onTopVisible: (){
                        userController.callDatePicker();
                      },
                     // suffixIcon: Icons.date_range,
                      hasBourder: true,
                      borderColor: Colors.black,
                      containerHeight: 50,
                      controller: userController.cttextDogumTarix,
                      inputType: TextInputType.datetime, hindtext: "", fontsize: 14),
                ),

              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(() => Row(
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 30.w),
                        child: CustomText(labeltext: "userGender".tr)),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      children: [
                        AnimatedToggleSwitch<bool>.dual(
                          current: userController.genderSelect.value,
                          first: true,
                          second: false,
                          dif: 50.0,
                          borderColor: Colors.transparent,
                          borderWidth: 0.5,
                          height: 30.h,
                          fittingMode: FittingMode.preventHorizontalOverlapping,
                          boxShadow: [
                            BoxShadow(
                              color: userController.genderSelect.value
                                  ? Colors.blueAccent
                                  : Colors.red,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                          onChanged: (val) {
                            userController.changeSelectedGender(val);
                            return Future.delayed(const Duration(seconds: 0));
                          },
                          colorBuilder: (b) =>
                              b ? Colors.transparent : Colors.transparent,
                          iconBuilder: (value) => value
                              ? Icon(Icons.man_2_outlined,
                                  color: Colors.blueAccent.withOpacity(0.8))
                              : Icon(
                                  Icons.woman_2_outlined,
                                  color: Colors.red.withOpacity(0.8),
                                ),
                          textBuilder: (value) => value
                              ? Center(
                                  child: CustomText(
                                  labeltext: 'Kisi',
                                  fontsize: 16,
                                  fontWeight: FontWeight.w800,
                                ))
                              : Center(
                                  child: CustomText(
                                  labeltext: "Qadin",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w800,
                                )),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        )
      ],
    );
  }

////////Icazeler hissesi///////////////////////
  Column widgetScreenIcazeler(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          supHeaderMainScreens("perWindows", "perWindowsDes"),
          Row(
            children: userController.listModelSelectUserPermitions
                .map((e) => widgetIcazelerListiByGroupName(e))
                .toList(),
          ),
          SizedBox(
            height: 280.h,
            child: Column(
              children: [
                SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(labeltext: "Secilen :"),
                            CustomText(labeltext: userController.selectedPermitions.length.toString()+"/"+userController.selectedPermitions.where((p) => p.val==1).length.toString())
                            ,const SizedBox(width: 5,)
                            ,Checkbox(
                                splashRadius: 5,
                                value: userController.selectedPermitions.where((p) => p.val==1).length==userController.selectedPermitions.length,
                                onChanged: (val) {
                                  if (val!) {
                                    userController.channgePermitionbyModule(true,userController.selectedModulPermitions.value);
                                  } else {
                                    userController.channgePermitionbyModule(false,userController.selectedModulPermitions.value);
                                  }
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  height: 240.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: userController.selectedPermitions
                          .map((data) => widgetItemsPermitions(data))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  ///Baglantilar hissesi /////////////////////////
  Column widgetScreenBaglantilar(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      children: [
        userController.listUserConnections.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            supHeaderMainScreens("conWindows", "conWindowsDes"),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 50.h,
              child: Row(
                children: userController.listGroupNameConnection
                    .map((element) =>
                    widgetBaglantiModulItems(element, context))
                    .toList(),
              ),
            ),
            Obx(() => Column(
              children: userController.listUserConnections
                  .map((element) =>
                  widgetBaglantiItems(element, context))
                  .toList(),
            ))
          ],
        )
            : Center(
            child: NoDataFound(
                width: 200.w, height: 200.h, title: "Baglanti Tapilmadi")),
      ],
    );
  }


  Widget widgetIcazelerListiByGroupName(ModelSelectUserPermitions e) {
    return InkWell(
      onTap: (){
        userController.changeSelectedModelSelectUserPermitions(e);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: userController.selectedModulPermitions.value==e?const [
            BoxShadow(
              color: Colors.green,
              offset: Offset(2,2),
              spreadRadius: 0.5,
              blurRadius: 10
            )
          ]:[],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: userController.selectedModulPermitions.value==e?Colors.green:Colors.grey,width:  userController.selectedModulPermitions.value==e?2:1),
          color: Colors.white
        ),
        child: CustomText(labeltext: e.name.toString(),fontsize:  userController.selectedModulPermitions.value==e?16:14,),
      ),
    );
  }

  Widget supHeaderMainScreens(String basliq, String aciqlama) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          labeltext: basliq.tr,
          color: Colors.black,
          fontsize: 16,
        ),
        SizedBox(
          height: 5.h,
        ),
        CustomText(
          labeltext: aciqlama.tr,
          color: Colors.grey,
          fontsize: 12,
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 2.h,
          width: double.infinity,
          color: Colors.blueAccent.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget widgetBaglantiModulItems(ModelConnectionsTest element, BuildContext context) {
    ScreenUtil.init(context);
    return InkWell(
      onTap: () {
        userController.changeSelectedGroupConnected(element);
        setState(() {});
      },
      child: Obx(() => Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                width: 40.w,
                height: 35.h,
                decoration: BoxDecoration(
                    color:
                        userController.selectedGroupName.value.id == element.id
                            ? Colors.green
                            : Colors.white,
                    border: Border.all(
                        color: userController.selectedGroupName.value.id ==
                                element.id
                            ? Colors.white
                            : Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    boxShadow:
                        userController.selectedGroupName.value.id == element.id
                            ? [
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(2, 2))
                              ]
                            : []),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10,),
                      Center(
                          child: CustomText(
                        fontsize: 16,
                        fontWeight: FontWeight.w700,
                        labeltext: element.name.toString(),
                        color:
                            userController.selectedGroupName.value.id == element.id
                                ? Colors.white
                                : Colors.black,
                      )),
                      userController.listSelectedGroupId.contains(element.id)?const Icon(Icons.check,size: 20,color: Colors.green,):SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget widgetBaglantiItems(ModelMustConnect element, BuildContext context) {
    ScreenUtil.init(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 150.w,
            minHeight: 40.h
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12)
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(labeltext: element.connectionRoleName.toString()),
                  SizedBox(
                    width: 1.w,
                  ),
                  CustomText(labeltext: "bagsec"),
                ],
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(child: Wrap(children: userController.selectedListUserConnections.where((p) =>p.roleId==element.connectionRoleId).map((e) => widgetSelectedUsers(e)).toList()??[],)),
              IconButton(onPressed: () {
                userController.getConnectionMustSelect(element);
              }, icon: const Icon(Icons.add))
            ],
          ),
        ),
      ),
    );
  }

  Stack widgetSelectedUsers(User e){
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10,right: 25),
              child: CustomText(labeltext: e.fullName.toString()),
            )),
        Positioned(
            top: -5,
            right: -5,
            child: IconButton(onPressed: (){
              userController.clearDataFromSelectedUsers(e);
            },icon: const Icon(Icons.clear,color: Colors.red,),))
      ],
    );
  }

  Widget widgetItemsPermitions(ModelUserPermissions data) {
    return Obx(() => Container(
      padding:const EdgeInsets.all(5) ,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CustomText(labeltext: data.name!,fontsize: 16),
          SizedBox(width: 5.w,),
          Checkbox(
              splashRadius: 5,
              value: userController.listModelSelectUserPermitions.where((a) => a.id==userController.selectedModulPermitions.value.id)
                  .first.permissions!.where((p) => p.id == data.id)
                  .first
                  .val ==
                  1,
              onChanged: (val) {
                if (val!) {
                  userController.channgePermitionType(data, true,userController.selectedModulPermitions.value);
                } else {
                  userController.channgePermitionType(data, false,userController.selectedModulPermitions.value);
                }
                setState(() {});
              })
        ],
      ),
    ));
  }
}
