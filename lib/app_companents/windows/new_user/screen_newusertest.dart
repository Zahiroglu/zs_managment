import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/windows/new_user/newuser_statecontroller.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/customwidgets/CustomTextFiled.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/customwidgets/simple_dialog.dart';
import 'package:zs_managment/login/models/model_regions.dart';
import 'package:zs_managment/login/models/model_useracces.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:provider/provider.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';

import '../../model/model_modules.dart';
import '../../model/model_vezifeler.dart';

class ScreenNewUserTest extends StatefulWidget {
  const ScreenNewUserTest({Key? key}) : super(key: key);

  @override
  State<ScreenNewUserTest> createState() => _ScreenNewUserTestState();
}

class _ScreenNewUserTestState extends State<ScreenNewUserTest> with TickerProviderStateMixin {
  PageController controller = PageController(initialPage: 0);
  TextEditingController cttextDviceId = TextEditingController();
  TextEditingController cttextUsername = TextEditingController();
  TextEditingController cttextPassword = TextEditingController();
  TextEditingController cttextEmail = TextEditingController();
  TextEditingController cttextAdsoyad = TextEditingController();
  TextEditingController cttextTelefon = TextEditingController();
  TextEditingController cttextDogumTarix = TextEditingController();
  bool _isObscure = false;
  bool genderSelect = true;
  String selectedDate = DateTime.now().toString().substring(0, 10);
  late NewUsersStateController _stateController;
  late ScrollController scrollController;
  int selectedIndex = 0;
  bool isFullcreen = false;
  late TabController accesTabController;
  late PageController accesPageController;
  int accesGoupIndex = 0;

  changeScrenToFull() {
    setState(() {
      isFullcreen = !isFullcreen;
    });
  }

  @override
  void initState() {
    _stateController = NewUsersStateController();
    _stateController.checkIfRegionMustSelect();
    accesTabController = TabController(length: 0, vsync: this);
    accesPageController=PageController(initialPage: 0);
    controller = PageController(initialPage: 0);
    controller.addListener(() {
      controller.initialPage == selectedIndex;
    });
    scrollController =
        ScrollController(initialScrollOffset: 50.0, keepScrollOffset: true);
    scrollController.addListener(() {
      scrollController.jumpTo(double.parse(selectedIndex.toString()));
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    accesPageController.dispose();
    accesTabController.dispose();
    controller.dispose();
    cttextDviceId.dispose();
    cttextUsername.dispose();
    cttextPassword.dispose();
    cttextEmail.dispose();
    cttextAdsoyad.dispose();
    cttextTelefon.dispose();
    cttextDogumTarix.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void incrementCustomStepper() {
    if (selectedIndex != _stateController.listStepper.length) {
      setState(() {
        selectedIndex++;
        controller.jumpToPage(selectedIndex);
      });
    }
  }

  void decrementCustomStepper() {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex--;
        controller.jumpToPage(selectedIndex);
      });
    }
  }

  reLengtTabController() {
    accesTabController = TabController(length: _stateController.listAccess.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewUsersStateController(),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              border: const Border(),
              borderRadius: BorderRadius.all(
                  isFullcreen ? Radius.zero : const Radius.circular(20)),
              color: Colors.white),
          height: ResponsiveBuilder.mainHeight(context),
          width: ResponsiveBuilder.mainWidh(context),
          margin: isFullcreen
              ? null
              : EdgeInsets.symmetric(
                  vertical: ResponsiveBuilder.isTablet(context) ||
                          ResponsiveBuilder.isMobile(context)
                      ? ResponsiveBuilder.mainHeight(context) * 0.05
                      : ResponsiveBuilder.mainHeight(context) * 0.07,
                  horizontal: ResponsiveBuilder.isTablet(context) ||
                          ResponsiveBuilder.isMobile(context)
                      ? ResponsiveBuilder.mainWidh(context) * 0.05
                      : ResponsiveBuilder.mainWidh(context) * 0.2),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
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
                                  changeScrenToFull();
                                },
                                icon: Icon(isFullcreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen)),
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
                          child: CustomText(
                              labeltext: "${'newUser'.tr} FORM",
                              fontWeight: FontWeight.bold,
                              fontsize: 18,
                              color: Colors.blue),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: widgetProgressStepper(),
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
                        padding: const EdgeInsets.only(left: 15),
                        child: widgetScreenIlkinSecimler(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: widgetScreenGeneralInfo(context),
                      ),
                      widgetScreenIcazeler(),
                      widgetScreenBaglantilar(),
                    ],
                  ),
                ),
                Expanded(flex: 1, child: widgetFooter())
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox widgetFooter() {
    return SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            selectedIndex > 0
                ? SizedBox(
                    height: 35,
                    child: CustomElevetedButton(
                        elevation: 15,
                        cllback: () {
                          decrementCustomStepper();
                        },
                        label: "geri".tr,
                        surfaceColor: Colors.white,
                        borderColor: Colors.red.withOpacity(0.5)))
                : const SizedBox(),
            const SizedBox(
              width: 15,
            ),
            _stateController.canUseWindows || _stateController.canUseMobile
                ? SizedBox(
                    height: 35,
                    child: CustomElevetedButton(
                        elevation: 15,
                        cllback: () {
                          if (selectedIndex == 0) {
                            if (_stateController.canUseWindows) {
                              if (cttextPassword.text.isNotEmpty &&
                                  cttextUsername.text.isNotEmpty) {
                                if (_stateController.canUseMobile) {
                                  if (cttextDviceId.text.isNotEmpty) {
                                    incrementCustomStepper();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (c) => ShowInfoDialog(
                                            messaje: "icazecihazDialog".tr,
                                            icon: Icons.error));
                                  }
                                } else {
                                  incrementCustomStepper();
                                }
                              } else {
                                showDialog(
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (c) => ShowInfoDialog(
                                        messaje: "icazeWinwosDialog".tr,
                                        icon: Icons.error));
                              }
                            } else {
                              if (_stateController.canUseMobile) {
                                if (cttextDviceId.text.isNotEmpty) {
                                  incrementCustomStepper();
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (c) => ShowInfoDialog(
                                          messaje: "icazecihazDialog".tr,
                                          icon: Icons.error));
                                }
                              }
                            }
                          } else if (selectedIndex == 1) {
                            if (cttextAdsoyad.text.isNotEmpty &&
                                cttextTelefon.text.isNotEmpty) {
                              incrementCustomStepper();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (c) => ShowInfoDialog(
                                      messaje: "adsoyadvephoneDialog".tr,
                                      icon: Icons.error));
                            }
                          }
                        },
                        label: "ireli".tr,
                        surfaceColor: Colors.white,
                        borderColor: Colors.blueAccent.withOpacity(0.5)))
                : SizedBox(),
          ],
        ));
  }

  Scrollbar widgetProgressStepper() {
    return Scrollbar(
      trackVisibility: true,
      controller: scrollController,
      scrollbarOrientation: ScrollbarOrientation.right,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ProgressStepper(
          onClick: (pos) {
            setState(() {});
          },
          padding: 5,
          currentStep: 0,
          progressColor: Colors.blueAccent.withOpacity(0.5),
          color: Colors.red.withOpacity(0.5),
          width: 700,
          height: 25,
          stepCount: _stateController.listStepper.length,
          builder: (int index) {
            const double widthOfStep = 450.0 / 3.0;
            if (index <= selectedIndex) {
              return ProgressStepWithArrow(
                width: widthOfStep,
                defaultColor: Colors.red.withOpacity(0.5),
                progressColor: Colors.green.withOpacity(0.5),
                wasCompleted: selectedIndex >= index - 1,
                child: Center(
                  child: CustomText(
                    labeltext: _stateController.listStepper
                        .elementAt(index - 1)
                        .toString()
                        .tr,
                  ),
                ),
              );
            }
            return ProgressStepWithChevron(
              width: widthOfStep,
              defaultColor: Colors.red.withOpacity(0.5),
              progressColor: Colors.green.withOpacity(0.5),
              wasCompleted: selectedIndex >= index - 1,
              child: Center(
                child: CustomText(
                    labeltext: _stateController.listStepper
                        .elementAt(index - 1)
                        .toString()
                        .tr),
              ),
            );
          },
        ),
      ),
    );
  }

/////////////Ilkin secimler hissesi/////////////////////////
  Column widgetScreenIlkinSecimler(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              labeltext: "Ilkin secimler Penceresi",
              color: Colors.black,
              fontsize: 16,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
              labeltext: "Zehmet olmasa deqiq secin",
              color: Colors.grey,
              fontsize: 12,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 2,
              width: double.infinity,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        _stateController.regionSecilmelidir
            ? widgetRegionSec(context)
            : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            _stateController.regionSecildi
                ? widgetSobeSecimi(context)
                : const SizedBox(),
            const SizedBox(
              width: 30,
            ),
            _stateController.sobeSecildi
                ? widgetVezifeSecimi(context)
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        _stateController.vezifeSecildi
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
            : SizedBox(),
      ],
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
            width: 250,
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
                  value: _stateController.getselectedRegion,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "regionsec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: _stateController.listRegionlar
                      .map<DropdownMenuItem<ModelRegions>>(
                        (lang) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: lang,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  //background color of dropdown button
                                  borderRadius: BorderRadius.circular(
                                      5), //border raiuds of dropdown button
                                ),
                                height: 40,
                                width: 200,
                                child: Center(
                                    child: CustomText(
                                        labeltext:
                                            lang.regionAdi.toString())))),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _stateController.changeSelectedRegion(val);
                      });
                    }
                  }),
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
            width: 250,
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
                  value: _stateController.getSelectedSobe(),
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "sobesec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: _stateController.listSobeler
                      .map<DropdownMenuItem<ModelModules>>(
                        (lang) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: lang,
                            child: Container(
                                height: 40,
                                width: 200,
                                child: Center(
                                    child: CustomText(
                                        labeltext:
                                            lang.moduleName.toString())))),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _stateController.changeSelectedSobe(val);
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
        SizedBox(
            height: 30,
            width: 250,
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
                  value: _stateController.selectedVezife,
                  isExpanded: true,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "posSec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: _stateController.listVezifeler
                      .map<DropdownMenuItem<ModelVezifeler>>(
                        (lang) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: lang,
                            child: Container(
                                height: 40,
                                width: 250,
                                child: Center(
                                    child: CustomText(
                                        labeltext: lang.roleName.toString())))),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _stateController.changeSelectedVezife(val);
                        reLengtTabController();
                        // listAccess = accessController.getUsersAccesListByRole(selectedVezife!);
                      });
                    }
                  }),
            ))
      ],
    );
  }

////////////Genel melumatlar hissesi/////////////////
  Column widgetScreenGeneralInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              labeltext: "Genel Melumatlar Penceresi",
              color: Colors.black,
              fontsize: 16,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
              labeltext: "Zehmet olmasa deqiq doldurun",
              color: Colors.grey,
              fontsize: 12,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 2,
              width: double.infinity,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 120),
                    child: CustomText(labeltext: "userName".tr)),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 200, maxHeight: 45, maxWidth: 350),
                  child: CustomTextField(
                    isImportant: true,
                    icon: Icons.perm_identity,
                    obscureText: false,
                    controller: cttextAdsoyad,
                    fontsize: 14,
                    hindtext: "userName".tr,
                    inputType: TextInputType.text,
                  ),
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 120),
                    child: CustomText(labeltext: "email".tr)),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 200, maxHeight: 45, maxWidth: 350),
                  child: CustomTextField(
                    icon: Icons.email_outlined,
                    obscureText: false,
                    controller: cttextEmail,
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
                    constraints: const BoxConstraints(minWidth: 120),
                    child: CustomText(labeltext: "userPhone".tr)),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 200, maxHeight: 45, maxWidth: 350),
                  child: CustomTextField(
                    isImportant: true,
                    icon: Icons.phone_android_outlined,
                    obscureText: false,
                    controller: cttextTelefon,
                    fontsize: 14,
                    hindtext: "userPhone".tr,
                    inputType: TextInputType.phone,
                  ),
                )
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 120),
                    child: CustomText(labeltext: "birthDay".tr)),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(labeltext: selectedDate, fontsize: 16),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            callDatePicker();
                          },
                          child: Icon(Icons.date_range))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 120),
                    child: CustomText(labeltext: "userGender".tr)),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    AnimatedToggleSwitch<bool>.dual(
                      current: genderSelect,
                      first: true,
                      second: false,
                      dif: 50.0,
                      borderColor: Colors.transparent,
                      borderWidth: 5.0,
                      height: 35,
                      fittingMode: FittingMode.preventHorizontalOverlapping,
                      boxShadow: [
                        BoxShadow(
                          color: genderSelect ? Colors.blueAccent : Colors.red,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                      onChanged: (b) {
                        setState(() => genderSelect = b);
                        return Future.delayed(Duration(seconds: 0));
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
            ),
          ],
        )
      ],
    );
  }

////////////Icazeler hissesi///////////////////////
  Column widgetScreenIcazeler() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          //padding: const EdgeInsets.all(5),
          height: 40,
          width: double.infinity,
          child: TabBar(
            onTap: (index) {
              setState(() {
                accesGoupIndex = index;
                accesPageController.jumpToPage(index);
              });
            },
            isScrollable: true,
            dividerColor: Colors.grey,
            indicator: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0)),
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
            //indicatorSize: TabBarIndicatorSize.tab,
            padding: const EdgeInsets.all(2),
            controller: accesTabController,
            tabs: _stateController.listAccess
                .map((e) => Center(
                        child: Text(
                      e.groupName.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    )))
                .toList(),
          ),
        ),
        _stateController.vezifeSecildi?Expanded(
          child: PageView(
            controller: accesPageController,
            children: _stateController.listAccess.map((e) => widgetIcazelerListiByGroupName(e)).toList(),
          ),
        ):SizedBox()
      ],
    );
  }

  Widget widgetIcazelerListiByGroupName(GroupUserAcces modelqroup){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: modelqroup.listAccess!.map((e) => accessItems(e, modelqroup)).toList(),
        ),
      ),
    );
  }

  Padding accessItems(UserAccess e, GroupUserAcces modelqroup) {
    Color colors=Colors.black;
    IconData icon=Icons.block;
    switch(e.accesType){
      case AccesType.notAccess:
        icon=Icons.block;
        colors=Colors.red;
        break;
      case AccesType.hasAccess:
        icon=Icons.verified_user_outlined;
        colors=Colors.blueAccent;
        break;
      case AccesType.fullAccess:
        icon=Icons.verified_outlined;
        colors= Colors.green;
        break;
      case AccesType.readerAccess:
        icon=Icons.remove_red_eye;
        colors=Colors.amber;
        break;

      case AccesType.controlAccess:
        icon=Icons.verified_user_outlined;
        colors=Colors.blueAccent;
        // TODO: Handle this case.
        break;
    }
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: colors.withOpacity(0.5),width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: DropdownButton(
                  value: e.accesType,
                  elevation: 10,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "icazeSec".tr),
                  alignment: Alignment.center,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: AccesType.values.map<DropdownMenuItem<AccesType>>(
                        (lang) => DropdownMenuItem(
                        alignment: Alignment.center,
                        value: lang,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5), //border raiuds of dropdown button
                            ),
                            height: 40,
                            width: 200,
                            child: Center(
                                child: CustomText(
                                    labeltext:
                                    lang.name.toString().tr)))),
                  ).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      int accesIndex=modelqroup.listAccess!.indexOf(e);
                      setState(() {
                        _stateController.updateAccesList(accesGoupIndex,accesIndex,val);
                      });
                    }
                  }),
            ),
            const SizedBox(width: 10,),
            Icon(icon,color: colors,),
            const SizedBox(width: 10,),
            CustomText(labeltext: e.accesName.toString().tr),
          ],
        ),
      );
  }

  Widget widgetDviceIcaze() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
                value: _stateController.canUseMobile,
                onChanged: (val) {
                  setState(() {
                    _stateController.changeCnUseMobile(val!);
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 220),
                child: CustomText(labeltext: "mcihazicaze".tr)),
            const SizedBox(
              width: 10,
            ),
            _stateController.canUseMobile
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                        minWidth: 200, maxHeight: 45, maxWidth: 350),
                    child: Expanded(
                        child: CustomTextField(
                      isImportant: true,
                      icon: Icons.mobile_friendly,
                      obscureText: false,
                      controller: cttextDviceId,
                      fontsize: 14,
                      hindtext: "mobId".tr,
                      inputType: TextInputType.text,
                    )),
                  )
                : const SizedBox(),
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: _stateController.canUseWindows,
                onChanged: (val) {
                  setState(() {
                    _stateController.changeCnUseWindows(val!);
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 220),
                child: CustomText(labeltext: "wicazesi".tr)),
            const SizedBox(
              width: 10,
            ),
            _stateController.canUseWindows
                ? Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minWidth: 200, maxHeight: 45, maxWidth: 350),
                        child: Expanded(
                            child: CustomTextField(
                                isImportant: true,
                                obscureText: false,
                                updizayn: false,
                                icon: Icons.perm_identity,
                                controller: cttextUsername,
                                inputType: TextInputType.text,
                                hindtext: 'username'.tr,
                                fontsize: 14)),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minWidth: 200, maxHeight: 45, maxWidth: 350),
                        child: Expanded(
                            child: CustomTextField(
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
                                controller: cttextPassword,
                                inputType: TextInputType.visiblePassword,
                                hindtext: 'password'.tr,
                                fontsize: 14)),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        )
      ],
    );
  }

  /////////Baglantilar hissesi /////////////////////////
  Column widgetScreenBaglantilar() {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              labeltext: "Icazeler Penceresi",
              color: Colors.black,
              fontsize: 16,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
              labeltext: "Zehmet olmasa deqiq secin",
              color: Colors.grey,
              fontsize: 12,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 2,
              width: double.infinity,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  void callDatePicker() async {
    String day = "01";
    String ay = "01";
    var order = await getDate();
    if (order!.day.toInt() < 10) {
      day = "0${order.day}";
    } else {
      day = order.day.toString();
    }
    if (order.month.toInt() < 10) {
      ay = "0${order.month}";
    } else {
      ay = order.month.toString();
    }
    setState(() {
      selectedDate = "$day.$ay.${order.year}";
    });
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
  }
}
