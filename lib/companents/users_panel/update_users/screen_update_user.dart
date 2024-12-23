import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:zs_managment/companents/login/models/model_regions.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/companents/users_panel/update_users/update_user_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';
import '../mobile/screen_changeid_password_mobile.dart';

class ScreenUpdateUser extends StatefulWidget {
  UserModel model;

  ScreenUpdateUser({required this.model, Key? key}) : super(key: key);

  @override
  State<ScreenUpdateUser> createState() => _ScreenUpdateUserState();
}

class _ScreenUpdateUserState extends State<ScreenUpdateUser>
    with TickerProviderStateMixin {
  PageController controller = PageController(initialPage: 0);
  bool _isObscure = false;
  late ScrollController scrollController;
  late TabController accesTabController;
  late PageController accesPageController;
  int accesGoupIndex = 0;
  UpdateUserController userController = Get.put(UpdateUserController());

  @override
  void initState() {
    accesTabController = TabController(length: 0, vsync: this);
    accesPageController = PageController(initialPage: 0);
    controller = PageController(initialPage: 0);
    controller.addListener(() {
      controller.initialPage == userController.selectedIndex.value;
    });
    scrollController =
        ScrollController(initialScrollOffset: 50.0, keepScrollOffset: true);
    scrollController.addListener(() {
      scrollController
          .jumpTo(double.parse(userController.selectedIndex.value.toString()));
    });
    userController.addSelecTedUser(widget.model);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    accesPageController.dispose();
    accesTabController.dispose();
    controller.dispose();
    Get.delete<UpdateUserController>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
              border: Border(),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(() => Column(
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
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
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
                            padding: const EdgeInsets.only(left: 10),
                            child: Obx(() => widgetScreenGeneralInfo(context)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child:
                                Obx(() => widgetScreenIlkinSecimler(context)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: widgetScreenBaglantilar(context),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: widgetScreenIcazeler(context)),
                        ],
                      ),
                    ),
                    Expanded(flex: 1, child: widgetFooter(context))
                  ],
                )),
          ),
        ));
  }

  SizedBox widgetFooter(BuildContext context) {
    return SizedBox(
        height: 35,
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                userController.selectedIndex.value > 0
                    ? SizedBox(
                        height: 40,
                        child: CustomElevetedButton(
                            icon: Icons.arrow_back,
                            elevation: 15,
                            cllback: () {
                              userController.decrementCustomStepper(controller);
                              setState(() {});
                            },
                            label: "geri".tr,
                            surfaceColor: Colors.white,
                            borderColor: Colors.red.withOpacity(0.5)))
                    : const SizedBox(),
                const SizedBox(
                  width: 5,
                ),
                userController.canRegisterNewUser.value
                    ? SizedBox(
                        height: 40,
                        child: CustomElevetedButton(
                          clicble: true,
                            icon: Icons.change_circle,
                            elevation: 15,
                            cllback: () {
                              userController.updateUserEndpoint();
                              setState(() {});
                            },
                            label: "deyisdir".tr,
                            surfaceColor: Colors.green,
                            borderColor: Colors.white.withOpacity(0.5)))
                    : userController.canUseNextButton.value
                        ? SizedBox(
                            height: 40,
                            child: CustomElevetedButton(
                                icon: Icons.arrow_forward,
                                elevation: 15,
                                cllback: () {
                                  userController.useNextButton(controller);
                                  setState(() {});
                                },
                                label: "ireli".tr,
                                surfaceColor: Colors.white,
                                borderColor:
                                    Colors.blueAccent.withOpacity(0.5)))
                        : SizedBox(),
              ],
            )));
  }

  ProgressStepper widgetProgressStepper(BuildContext context) {
    return ProgressStepper(
      onClick: (pos) {
        setState(() {});
      },
      padding: 5,
      currentStep: 0,
      progressColor: Colors.blueAccent.withOpacity(0.5),
      color: Colors.red.withOpacity(0.5),
      width: 55 * 4,
      height: 25,
      stepCount: userController.listStepper.length,
      builder: (int index) {
        return Obx(() => index <= userController.selectedIndex.value
            ? Obx(() => ProgressStepWithArrow(
                  width: 50,
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
                ))
            : Obx(() => ProgressStepWithChevron(
                  width: 50,
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            supHeaderMainScreens("fistSelectWindows", "fistSelectWindowsDes"),
            const SizedBox(
              height: 10,
            ),
            userController.regionSecilmelidir.isTrue
                ? widgetRegionSec(context)
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                userController.regionSecildi.isTrue
                    ? widgetSobeSecimi(context)
                    : const SizedBox(),
                const SizedBox(
                  width: 20,
                ),
                userController.sobeSecildi.isTrue
                    ? widgetVezifeSecimi(context)
                    : const SizedBox(),
              ],
            ),
            const SizedBox(
              height: 30,
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
                      const SizedBox(
                        height: 10,
                      ),
                      widgetDviceIcaze(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Column widgetRegionSec(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          labeltext: "userRegion".tr,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 30,
            width: 60,
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
              child: userController.listRegionlar.isNotEmpty
                  ? DropdownButton(
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
                                value: userController.listRegionlar.isNotEmpty
                                    ? lang
                                    : ModelRegions(),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      //background color of dropdown button
                                      borderRadius: BorderRadius.circular(
                                          5), //border raiuds of dropdown button
                                    ),
                                    height: 40,
                                    width: 40,
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
                      })
                  : SizedBox(),
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
            height: 30,
            width: 60,
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
                                height: 40,
                                width: 40,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          labeltext: "chousePosition".tr,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 5,
        ),
        Obx(() => SizedBox(
            height: 30,
            width: 50,
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
                                height: 40,
                                width: 40,
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
        userController.canUserMobilePermitions.value
            ? Row(
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
                      constraints:
                          const BoxConstraints(minWidth: 50, maxWidth: 60),
                      child: CustomText(labeltext: "mcihazicaze".tr)),
                  userController.canUseMobile.value
                      ? widget.model.deviceId!.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxHeight: 40, maxWidth: 100),
                                  child: Row(
                                    children: [
                                      CustomElevetedButton(
                                        label: "ID ${"change".tr}",
                                        cllback: () {
                                          Get.dialog(ChangePasswordAndDviceIdMobile(
                                            changeType: 1,
                                            modelUser: widget.model,
                                          ));
                                        },
                                        height: 20,
                                        //width: 40,
                                        icon: Icons.change_circle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: 80,
                                      maxHeight: 40,
                                      maxWidth: 120),
                                  child: CustomTextField(
                                    borderColor:
                                        userController.cttextDviceIdError.value
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
              )
            : const SizedBox(),
        SizedBox(
            width: MediaQuery.of(context).size.width * 2.7,
            child: const Divider(
              color: Colors.grey,
            )),
        userController.canUserWindowsPermitions.value
            ? Row(
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
                      constraints:
                          const BoxConstraints(minWidth: 50, maxWidth: 60),
                      child: CustomText(labeltext: "wicazesi".tr)),
                  userController.canUseWindows.value
                      ? widget.model.username!.isNotEmpty
                          ? Row(
                              children: [
                                CustomElevetedButton(
                                  label: "${"password".tr} ${"change".tr}",
                                  cllback: () {
                                    Get.dialog(ChangePasswordAndDviceIdMobile(
                                      changeType: 0,
                                      modelUser: widget.model,
                                    ));
                                  },
                                  height: 20,
                                  icon: Icons.change_circle,
                                )
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: 80,
                                      maxHeight: 40,
                                      maxWidth: 120),
                                  child: CustomTextField(
                                      borderColor: userController
                                              .cttextUsernameError.value
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
                                  child: userController
                                          .cttextUsernameError.value
                                      ? CustomText(
                                          labeltext:
                                              "icazeWinwosDialogUsername".tr,
                                          color: Colors.red,
                                          fontsize: 8,
                                        )
                                      : const SizedBox(),
                                ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: 80,
                                      maxHeight: 40,
                                      maxWidth: 120),
                                  child: CustomTextField(
                                      borderColor: userController
                                              .cttextPasswordError.value
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
                                  child: userController
                                          .cttextPasswordError.value
                                      ? CustomText(
                                          labeltext:
                                              "icazeWinwosDialogPassword".tr,
                                          color: Colors.red,
                                          fontsize: 8,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            )
                      : SizedBox()
                ],
              )
            : const SizedBox()
      ],
    );
  }

//////////Genel melumatlar hissesi/////////////////
  Column widgetScreenGeneralInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        supHeaderMainScreens(
            "personalInfoWindowsDes", "personalInfoWindowsDes"),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 30),
                    child: CustomText(labeltext: "userCode".tr)),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60, maxHeight: 40, maxWidth: 80),
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
                    constraints: BoxConstraints(minWidth: 30),
                    child: CustomText(labeltext: "userName".tr)),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: 60, maxHeight: 40, maxWidth: 80),
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
                    constraints: BoxConstraints(minWidth: 30),
                    child: CustomText(labeltext: "usersurname".tr)),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60, maxHeight: 40, maxWidth: 80),
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
                    constraints: BoxConstraints(minWidth: 30),
                    child: CustomText(labeltext: "email".tr)),
                SizedBox(
                  width: 5,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 60, maxHeight: 40, maxWidth: 80),
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
                    constraints: BoxConstraints(minWidth: 30),
                    child: CustomText(labeltext: "userPhone".tr)),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 60, maxHeight: 40, maxWidth: 80),
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
                    constraints: BoxConstraints(minWidth: 30),
                    child: CustomText(labeltext: "birthDay".tr)),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: CustomTextField(
                    readOnly: true,
                      align: TextAlign.center,
                      suffixIcon: Icons.date_range,
                      obscureText: false,
                      updizayn: true,
                      onTopVisible: () {
                        userController.callDatePicker();
                      },
                      // suffixIcon: Icons.date_range,
                      hasBourder: true,
                      borderColor: Colors.black,
                      containerHeight: 50,
                      controller: userController.cttextDogumTarix,
                      inputType: TextInputType.datetime,
                      hindtext: "",
                      fontsize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Obx(() => Row(
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 30),
                        child: CustomText(labeltext: "userGender".tr)),
                    SizedBox(
                      width: 5,
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
                          height: 30,
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
            height: 280,
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
                  height: 240,
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
    
    return Column(
      children: [
        userController.listUserConnections.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  supHeaderMainScreens("conWindows", "conWindowsDes"),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
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
                    width: 200, height: 200, title: "Baglanti Tapilmadi")),
      ],
    );
  }

  Widget widgetIcazelerListiByGroupName(ModelSelectUserPermitions e) {
    
    return InkWell(
      onTap: () {
        userController.changeSelectedModelSelectUserPermitions(e);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: userController.selectedModulPermitions.value == e
                ? const [
                    BoxShadow(
                        color: Colors.green,
                        offset: Offset(2, 2),
                        spreadRadius: 0.5,
                        blurRadius: 10)
                  ]
                : [],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: userController.selectedModulPermitions.value == e
                    ? Colors.green
                    : Colors.grey,
                width:
                    userController.selectedModulPermitions.value == e ? 2 : 1),
            color: Colors.white),
        child: CustomText(
          labeltext: e.name.toString(),
          fontsize: userController.selectedModulPermitions.value == e ? 16 : 14,
        ),
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
          height: 5,
        ),
        CustomText(
          labeltext: aciqlama.tr,
          color: Colors.grey,
          fontsize: 12,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          width: double.infinity,
          color: Colors.blueAccent.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget widgetBaglantiModulItems(
      ModelConnectionsTest element, BuildContext context) {
    
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
                width: 40,
                height: 35,
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
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                          child: CustomText(
                        fontsize: 16,
                        fontWeight: FontWeight.w700,
                        labeltext: element.name.toString(),
                        color: userController.selectedGroupName.value.id ==
                                element.id
                            ? Colors.white
                            : Colors.black,
                      )),
                      userController.listSelectedGroupId.contains(element.id)
                          ? const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.green,
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget widgetBaglantiItems(ModelMustConnect element, BuildContext context) {
    
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 150, minHeight: 40),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
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
                    width: 1,
                  ),
                  CustomText(labeltext: "bagsec"),
                ],
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                  child: Wrap(
                children: userController.selectedListUserConnections
                        .where((p) => p.roleId == element.connectionRoleId)
                        .map((e) => widgetSelectedUsers(e))
                        .toList() ??
                    [],
              )),
              IconButton(
                  onPressed: () {
                    userController.getConnectionMustSelect(element,true);
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
      ),
    );
  }

  Stack widgetSelectedUsers(User e) {
    
    return Stack(
      children: [
        Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, bottom: 10, top: 10, right: 25),
              child: CustomText(labeltext: e.fullName.toString()),
            )),
        Positioned(
            top: -5,
            right: -5,
            child: IconButton(
              onPressed: () {
                userController.clearDataFromSelectedUsers(e);
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ))
      ],
    );
  }

  Widget widgetItemsPermitions(ModelUserPermissions data) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          child: Row(
            children: [
              CustomText(labeltext: data.name!, fontsize: 16),
              SizedBox(
                width: 5,
              ),
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

  widgetTenzimlemeler(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          supHeaderMainScreens("confWindows", "confWindowsDes"),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  userController.userPermitionsHelper
                      .getUserWorkTime(userController.listUserConfigration)
                      .isNotEmpty
                      ? _isgunuVaxti(context)
                      : const SizedBox(),
                  const Divider(
                    height: 1,
                    color: Colors.black38,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  userController.listUserConfigration
                      .where((e) => e.configId == 2)
                      .isNotEmpty
                      ? _canliIzlemeSistemi(context)
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black38,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //userController.userPermitionsHelper.getOnlyByGirisCixis(userController.listUserConfigration)?_girisCixisSistem(context):const SizedBox(),
                  userController.listUserConfigration
                      .where((e) => e.configId == 4)
                      .isNotEmpty
                      ? _girisCixisSistem(context)
                      : SizedBox(),
                ],
              ),
            ),
          )
        ]);
  }

  _isgunuVaxti(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            fontWeight: FontWeight.w700,
            fontsize: 16,
            labeltext: userController.listUserConfigration
                .where((e) => e.configId == 1)
                .first
                .confVal
                .toUpperCase()),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: CustomTextField(
                      hasLabel: true,
                      align: TextAlign.center,
                      controller: userController.cttextIsBaslama,
                      inputType: TextInputType.text,
                      hindtext: "Ise baslama vaxti",
                      fontsize: 14),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: CustomTextField(
                      hasLabel: true,
                      align: TextAlign.center,
                      controller: userController.cttextIsBitirme,
                      inputType: TextInputType.text,
                      hindtext: "Is bitirme vaxti",
                      fontsize: 14),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            userController.userPermitionsHelper
                .daySalary(userController.listUserConfigration) !=
                -1
                ? ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: CustomTextField(
                  isImportant: true,
                  hasLabel: true,
                  align: TextAlign.center,
                  controller: userController.ctTextGunlukMaas,
                  inputType: TextInputType.text,
                  hindtext: "Gunluk ortalama maas (AZN)",
                  fontsize: 14),
            )
                : const SizedBox(),
          ],
        )
      ],
    );
  }

  _canliIzlemeSistemi(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            fontWeight: FontWeight.w700,
            fontsize: 16,
            labeltext: userController.listUserConfigration
                .where((e) => e.configId == 2)
                .first
                .confVal
                .toUpperCase()),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                        labeltext:
                        "Ancaq markete giris cixis eden zaman izlensin?"),
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                        value: userController.userPermitionsHelper.liveTrack(
                            userController.listUserConfigration) ==
                            "full",
                        onChanged: (c) {
                          if (c!) {
                            userController.listUserConfigration
                                .where((e) => e.configId == 2)
                                .first
                                .data1 = "full";
                          } else {
                            userController.listUserConfigration
                                .where((e) => e.configId == 2)
                                .first
                                .data1 = "false";
                          }
                          setState(() {});
                        }),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                        labeltext: "Ise basladiqdan bitirene kimi izlensin?"),
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                        value: userController.userPermitionsHelper.liveTrack(
                            userController.listUserConfigration) ==
                            "true",
                        onChanged: (c) {
                          if (c!) {
                            userController.listUserConfigration
                                .where((e) => e.configId == 2)
                                .first
                                .data1 = "true";
                          } else {
                            userController.listUserConfigration
                                .where((e) => e.configId == 2)
                                .first
                                .data1 = "false";
                          }
                          setState(() {});
                        }),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  _girisCixisSistem(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            fontWeight: FontWeight.w700,
            fontsize: 16,
            labeltext: userController.listUserConfigration
                .where((e) => e.configId == 4)
                .first
                .confVal
                .toUpperCase()),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        CustomText(
                            labeltext: "Giris-cixis sistemi ile islemek"),
                        const SizedBox(
                          width: 10,
                        ),
                        Checkbox(
                            value: userController.userPermitionsHelper
                                .getOnlyByGirisCixis(
                                userController.listUserConfigration),
                            onChanged: (c) {
                              userController.listUserConfigration
                                  .where((e) => e.configId == 4)
                                  .first
                                  .data1 = c.toString();
                              setState(() {});
                            }),
                      ],
                    ),
                    const SizedBox(width: 20,),
                    userController.userPermitionsHelper
                        .getOnlyByGirisCixis(
                        userController.listUserConfigration)?ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250,maxHeight: 50),
                      child: CustomTextField(
                          hasLabel: true,
                          align: TextAlign.center,
                          controller: userController.ctTextGirisMesafesi,
                          inputType: TextInputType.text,
                          hindtext: "Giris mesafesi (m-le)",
                          fontsize: 14),
                    ):const SizedBox()
                  ],
                ),
                userController.listUserConfigration
                    .where((e) => e.configId == 5)
                    .isNotEmpty
                    ? Row(
                  children: [
                    CustomText(labeltext: "Ancaq rut gunu ile islesin"),
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                        value: userController.userPermitionsHelper
                            .getOnlyByRutDay(
                            userController.listUserConfigration),
                        onChanged: (c) {
                          userController.listUserConfigration
                              .where((e) => e.configId == 5)
                              .first
                              .data1 = c.toString();
                          setState(() {});
                        }),
                  ],
                )
                    : const SizedBox(),
                userController.listUserConfigration
                    .where((e) => e.configId == 6)
                    .isNotEmpty
                    ? Row(
                  children: [
                    CustomText(
                        labeltext: "Ancaq rut gun ve sirasi ile islesin"),
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                        value: userController.userPermitionsHelper
                            .onlyByRutOrderNumber(
                            userController.listUserConfigration),
                        onChanged: (c) {
                          userController.listUserConfigration
                              .where((e) => e.configId == 6)
                              .first
                              .data1 = c.toString();
                          setState(() {});
                        }),
                  ],
                )
                    : const SizedBox(),
              ],
            ),
          ],
        )
      ],
    );
  }

}
