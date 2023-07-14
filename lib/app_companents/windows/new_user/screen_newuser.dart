import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/model/model_modules.dart';
import 'package:zs_managment/app_companents/windows/admin_usercontrol/controller/useraccesController.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/customwidgets/CustomTextFiled.dart';
import 'package:zs_managment/customwidgets/customElevetedButton.dart';
import 'package:zs_managment/login/models/model_regions.dart';
import 'package:zs_managment/login/models/model_useracces.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

import '../../model/model_vezifeler.dart';

class ScreenNewUser extends StatefulWidget {
  const ScreenNewUser({Key? key}) : super(key: key);

  @override
  State<ScreenNewUser> createState() => _ScreenNewUserState();
}

class _ScreenNewUserState extends State<ScreenNewUser>
    with SingleTickerProviderStateMixin {
  List<String> listStepper = [
    'Ilkin secimler',
    "Genele Melumatlar",
    "Icazeler",
    "Baglantilar",
  ];
 // List<String> listInfoUsers = UserModel().getListUserInfoDetail();
  List<ModelModules> listSobeler = ModelModules().getAktivModules();
  List<ModelRegions> listRegionlar = ModelRegions().listRegions();
  List<ModelVezifeler> listVezifeler = [];
  int selectedIndex = 0;
  late ModelModules? selectedSobe;
  late ModelVezifeler? selectedVezife;
  late ModelRegions? selectedRegion;
  bool ilkinMelumatlarSecildi = false;
  bool regionSecilmelidir = true;
  bool regionSecildi = false;
  bool sobeSecildi = false;
  bool veifeSecildi = false;
  bool canUseMobile = false;
  bool canUseWindows = false;
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
  UserAccessController accessController = UserAccessController();
  List<UserAccess> listAccess = [];

  @override
  void initState() {
    selectedSobe = null;
    selectedVezife = null;
    selectedRegion = null;
    if (listRegionlar.length == 1) {
      regionSecilmelidir = false;
      selectedRegion = listRegionlar.first;
      regionSecildi = true;
    }
    controller = PageController(initialPage: 0);
    controller.addListener(() {
      controller.initialPage == selectedIndex;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
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

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _incrementCustomStepper() {
    setState(() {
      if (selectedIndex != listStepper.length) {
        selectedIndex++;
        controller.jumpToPage(selectedIndex);
      }
    });
  }

  void _decrementCustomStepper() {
    setState(() {
      if (selectedIndex != 0) {
        selectedIndex--;
        controller.jumpToPage(selectedIndex);
      }
    });
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
        height: ResponsiveBuilder.mainHeight(context),
        width: ResponsiveBuilder.mainWidh(context),
        margin: EdgeInsets.symmetric(
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
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    selectedIndex = selectedIndex - 1;
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                  )),
                              const SizedBox(
                                width: 2,
                              ),
                              CustomText(
                                  labeltext: 'goback'.tr,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
                          _decrementCustomStepper();
                        },
                        label: "Geri",
                        surfaceColor: Colors.white,
                        borderColor: Colors.red.withOpacity(0.5)))
                : const SizedBox(),
            const SizedBox(
              width: 15,
            ),
            veifeSecildi
                ? SizedBox(
                    height: 35,
                    child: CustomElevetedButton(
                        elevation: 15,
                        cllback: () {
                          _incrementCustomStepper();
                        },
                        label: "Ireli",
                        surfaceColor: Colors.white,
                        borderColor: Colors.blueAccent.withOpacity(0.5)))
                : SizedBox(),
          ],
        ));
  }

  SingleChildScrollView widgetProgressStepper() {
    return SingleChildScrollView(
      child: ProgressStepper(
        onClick: (pos){
          setState(() {
            selectedIndex=pos;
          });
        },
        padding: 5,
        currentStep: 0,
        progressColor: Colors.blueAccent.withOpacity(0.5),
        color: Colors.red.withOpacity(0.5),
        width: 700,
        height: 25,
        stepCount: listStepper.length,
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
                  labeltext: listStepper.elementAt(index - 1).toString().tr,
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
                  labeltext: listStepper.elementAt(index - 1).toString().tr),
            ),
          );
        },
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
        regionSecilmelidir ? widgetRegionSec(context) : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            regionSecildi ? widgetSobeSecimi(context) : const SizedBox(),
            const SizedBox(
              width: 30,
            ),
            sobeSecildi ? widgetVezifeSecimi(context) : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
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
                  value: selectedRegion,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "sobesec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: listRegionlar
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
                        selectedRegion = val;
                        regionSecildi = true;
                      });
                    } else {
                      setState(() {
                        regionSecildi = false;
                        selectedRegion = null;
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
                  value: selectedSobe,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "sobesec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: listSobeler
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
                        sobeSecildi = true;
                        selectedSobe = val;
                        fullVezifelerListi(val);
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
                  value: selectedVezife,
                  isExpanded: true,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "posSec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: listVezifeler
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
                        veifeSecildi = true;
                        selectedVezife = val;
                        // listAccess = accessController
                        //     .getUsersAccesListByRole(selectedVezife!);
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
    return Column();
    // int sayaktivicaze =
    //     listAccess.where((e) => e.hasAcces == true).toList().length;
    // return Column(
    //   children: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         CustomText(
    //           labeltext: "Icazeler Penceresi",
    //           color: Colors.black,
    //           fontsize: 16,
    //         ),
    //         const SizedBox(
    //           height: 5,
    //         ),
    //         CustomText(
    //           labeltext: "Zehmet olmasa deqiq secin",
    //           color: Colors.grey,
    //           fontsize: 12,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Container(
    //           height: 2,
    //           width: double.infinity,
    //           color: Colors.blueAccent.withOpacity(0.5),
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //       ],
    //     ),
    //     widgetDviceIcaze(),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [
    //         CustomText(
    //           labeltext: "digerIcazeler".tr,
    //           color: Colors.blueAccent.withOpacity(0.5),
    //           fontsize: 24,
    //           fontWeight: FontWeight.bold,
    //         ),
    //         SizedBox(
    //           width: 10,
    //         ),
    //         CustomText(
    //           labeltext:
    //               "${"umumiIcazesayi".tr} : ${listAccess.length} ${"aktivIcazelersayi".tr} : $sayaktivicaze",
    //           color: Colors.grey.withOpacity(0.5),
    //           fontsize: 12,
    //           fontWeight: FontWeight.normal,
    //         ),
    //       ],
    //     ),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     Expanded(
    //       child: ListView.builder(
    //           itemCount: listAccess.length,
    //           itemBuilder: (context, index) {
    //             return Row(
    //               children: [
    //                 Checkbox(
    //                     value: listAccess.elementAt(index).hasAcces,
    //                     onChanged: (val) {
    //                       setState(() {
    //                         listAccess.elementAt(index).hasAcces = val;
    //                       });
    //                     }),
    //                 SizedBox(
    //                   width: 10,
    //                 ),
    //                 CustomText(
    //                     labeltext: listAccess
    //                         .elementAt(index)
    //                         .accesName
    //                         .toString()
    //                         .tr),
    //               ],
    //             );
    //           }),
    //     )
    //   ],
    // );
  }

  Widget widgetDviceIcaze() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(labeltext: "mcihazicaze".tr),
            const SizedBox(
              width: 10,
            ),
            Checkbox(
                value: canUseMobile,
                onChanged: (val) {
                  setState(() {
                    canUseMobile = val!;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            canUseMobile
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                        minWidth: 200, maxHeight: 45, maxWidth: 350),
                    child: Expanded(
                        child: CustomTextField(
                      icon: Icons.mobile_friendly,
                      obscureText: false,
                      controller: cttextDviceId,
                      fontsize: 14,
                      hindtext: "Mobil id daxil et",
                      inputType: TextInputType.text,
                    )),
                  )
                : const SizedBox(),
          ],
        ),
        Row(
          children: [
            CustomText(labeltext: "mcihazicaze".tr),
            const SizedBox(
              width: 10,
            ),
            Checkbox(
                value: canUseWindows,
                onChanged: (val) {
                  setState(() {
                    canUseWindows = val!;
                  });
                }),
            const SizedBox(
              width: 10,
            ),
            canUseWindows
                ? Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minWidth: 200, maxHeight: 45, maxWidth: 350),
                        child: Expanded(
                            child: CustomTextField(
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
      children: [Text("Baglantilar")],
    );
  }

  InkWell widgetListItemInfo(String value, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          changeIndex(selectedIndex);
        });
      },
    );
  }

  void fullVezifelerListi(ModelModules val) {
    selectedVezife = null;
    veifeSecildi = false;
    listVezifeler = val.listVezifeler!;
    print("Secilen vezifeler :${listVezifeler.length}");
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
