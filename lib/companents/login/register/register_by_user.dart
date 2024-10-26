import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../../constands/app_constands.dart';
import '../../../dio_config/api_client.dart';
import '../../../dio_config/custim_interceptor.dart';
import '../../../helpers/dialog_helper.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../users_panel/new_user_create/new_user_controller.dart';
import '../models/model_regions.dart';
import '../register/model_lisance.dart';
import 'model_register_byuser.dart';
import 'package:get/get.dart';

class ScreenRegisterByUser extends StatefulWidget {
  LicenseModel model;
  String deviceId;
   ScreenRegisterByUser({required this.model,required this.deviceId,super.key});

  @override
  State<ScreenRegisterByUser> createState() => _ScreenRegisterByUserState();
}

class _ScreenRegisterByUserState extends State<ScreenRegisterByUser> {
  Dio dio = Dio();
  ModelRegions? selectedRegion;
  TextEditingController cttextEmail = TextEditingController();
  TextEditingController cttextAd = TextEditingController();
  bool cttextAdError = false;
  TextEditingController cttextSoyad = TextEditingController();
  bool cttextSoyadError = false;
  TextEditingController cttextTelefon = TextEditingController();
  bool cttextTelefonError = false;
  TextEditingController cttextDogumTarix = TextEditingController();
  String selectedDate = DateTime.now().toString().substring(0, 10);
  bool genderSelect = true;
  late CheckDviceType checkDviceType = CheckDviceType();

  @override
  void initState() {
   // selectedRegion=widget.model.listRegionlar.first;
    print("regionlar :"+widget.model.listRegionlar.length.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(

        centerTitle: false,
        title: CustomText(labeltext: "Ferdi qeydiyyat",),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0).copyWith(top: 5,right: 15),
                    child: CustomText(
                        maxline: 4,
                        fontWeight: FontWeight.w600,
                        fontsize: 14,
                        labeltext: widget.model.lisMessaje),
                  ),
                  const Positioned(
                      top: 5,
                      right: 0,
                      child: Icon(Icons.info,color: Colors.orange,))
                ],
              ),
            ),
            Expanded(
              flex: 20,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgetRegionSec(context),
                    selectedRegion!=null?widgetScreenGeneralInfo(context):const SizedBox()
                  ],
                ),
              ),
            ),
            selectedRegion!=null?Align(
              child: CustomElevetedButton(
                surfaceColor: Colors.green,
                borderColor: Colors.white,
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
                textsize: 18,
                height: 40,
                width: MediaQuery.of(context).size.width,
                label: "Tesdiqle",
                cllback: (){
                  register();
                },
              ),
            ):const SizedBox()
          ],
        ),
      ),
    );
  }

  Column widgetRegionSec(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
          labeltext: "userRegion".tr,
          fontsize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width*0.9,
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
              child:  DropdownButton(
                  value: selectedRegion,
                  elevation: 0,
                  icon: const Icon(Icons.expand_more_outlined),
                  underline: const SizedBox(),
                  hint: CustomText(labeltext: "regionsec".tr),
                  alignment: Alignment.center,
                  isDense: false,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  items: widget.model.listRegionlar
                      .map<DropdownMenuItem<ModelRegions>>((region) => DropdownMenuItem(
                      alignment: Alignment.center,
                      value: region,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black26),
                            //background color of dropdown button
                            borderRadius: BorderRadius.circular(5), //border raiuds of dropdown button
                          ),
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Center(
                              child: CustomText(
                                  labeltext: region.name??"Bilinmeyen region")))),
                  ).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        changeSelectedRegion(val);
                      });
                    }
                  }),
            ))
      ],
    );
  }

  SingleChildScrollView widgetScreenGeneralInfo(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 30,left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(labeltext: "Genel melumatlar",fontsize: 18,fontWeight: FontWeight.bold,),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints( maxHeight: 60,),
                          child: CustomTextField(
                            borderColor: cttextAdError
                                ? Colors.red
                                : Colors.grey,
                            isImportant: true,
                            icon: Icons.perm_identity,
                            obscureText: false,
                            controller: cttextAd,
                            fontsize: 14,
                            hindtext: "userName".tr,
                            inputType: TextInputType.text,
                          ),
                        ),
                        cttextAdError
                            ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: cttextAdError
                              ? CustomText(
                            labeltext: "aderrorText".tr,
                            color: Colors.red,
                            fontsize: 8,
                          )
                              : const SizedBox(),
                        )
                            : const SizedBox()
                      ],
                    ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints( maxHeight: 60,),
                          child: CustomTextField(
                            borderColor: cttextSoyadError
                                ? Colors.red
                                : Colors.grey,
                            isImportant: true,
                            icon: Icons.perm_identity,
                            obscureText: false,
                            controller: cttextSoyad,
                            fontsize: 14,
                            hindtext: "usersurname".tr,
                            inputType: TextInputType.text,
                          ),
                        ),
                        cttextSoyadError
                            ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: cttextSoyadError
                              ? CustomText(
                            labeltext: "soyaderrorText".tr,
                            color: Colors.red,
                            fontsize: 8,
                          )
                              : const SizedBox(),
                        )
                            : const SizedBox()
                      ],
                    ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints( maxHeight: 60,),
                          child: CustomTextField(
                            borderColor: cttextTelefonError
                                ? Colors.red
                                : Colors.grey,
                            isImportant: true,
                            icon: Icons.phone_android_outlined,
                            obscureText: false,
                            controller: cttextTelefon,
                            fontsize: 14,
                            hindtext: "userPhone".tr,
                            inputType: TextInputType.phone,
                          ),
                        ),
                        cttextTelefonError
                            ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: cttextTelefonError
                              ? CustomText(
                            labeltext: "telefonErrorText".tr,
                            color: Colors.red,
                            fontsize: 8,
                          )
                              : const SizedBox(),
                        )
                            : const SizedBox()
                      ],
                    ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints( maxHeight: 60,minHeight: 60),
                      child: CustomTextField(
                        containerHeight: 40,
                        icon: Icons.email_outlined,
                        obscureText: false,
                        controller: cttextEmail,
                        fontsize: 14,
                        hindtext: "email".tr,
                        inputType: TextInputType.emailAddress,
                      ),
                    ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child:  ConstrainedBox(
                    constraints: const BoxConstraints( maxHeight: 60,minHeight: 60),
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker();
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 40,
                        controller: cttextDogumTarix,
                        inputType: TextInputType.datetime,
                        hindtext: "birthDay".tr,
                        fontsize: 14),
                  ),)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [

                Expanded(
                    flex: 8,
                    child:  Row(
                      children: [
                        AnimatedToggleSwitch<bool>.dual(
                          current: genderSelect,
                          first: true,
                          second: false,
                          dif: 50.0,
                          borderColor: Colors.transparent,
                          borderWidth: 0.5,
                          height: 40,
                          fittingMode: FittingMode.preventHorizontalOverlapping,
                          boxShadow: [
                            BoxShadow(
                              color: genderSelect
                                  ? Colors.blueAccent
                                  : Colors.red,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                          onChanged: (val) {
                            changeSelectedGender(val);
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
                    ))
              ],
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  void changeSelectedRegion(ModelRegions val) {
    setState(() {
      selectedRegion=val;
    });
  }

  void callDatePickerFirst() async {
    String day = "01";
    String ay = "01";
    var order = DateTime.now();
    if (order.day.toInt() < 10) {
      day = "0${order.day}";
    } else {
      day = order.day.toString();
    }
    if (order.month.toInt() < 10) {
      ay = "0${order.month}";
    } else {
      ay = order.month.toString();
    }
    selectedDate = "$day.$ay.${order.year}";
    cttextDogumTarix.text = "$day.$ay.${order.year}";
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
    selectedDate = "$day.$ay.${order.year}";
    cttextDogumTarix.text = "$day.$ay.${order.year}";
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
  }

  void changeSelectedGender(bool val) {
    setState(() {
      genderSelect=val;
    });
  }

  Future<void> register() async {
    if (cttextAd.text.isNotEmpty) {
      cttextAdError = false;
    }
    else {
      cttextAdError = true;
    }
    if (cttextSoyad.text.isNotEmpty) {
      cttextSoyadError = false;
    }
    else {
      cttextSoyadError = true;
    }
    if (cttextTelefon.text.isNotEmpty) {
      cttextTelefonError = false;
    }
    else {
      cttextTelefonError = true;
    }

    setState(() {});
    if (cttextAd.text.isNotEmpty &&
        cttextSoyad.text.isNotEmpty &&
        cttextTelefon.text.isNotEmpty) {
     await  registerUserEndpoint();
    }
  }

  Future<bool> registerUserEndpoint() async {
    bool succes=false;
    DialogHelper.showLoading("yoxlanir".tr,false);
    ModelRegisterByUser registerData = ModelRegisterByUser(
        name: cttextAd.text,
        defaultPermitions: widget.model.listPerIds,
        code: widget.model.lisUserCode,
        companyId:  widget.model.lisCompanyId,
        moduleId:  widget.model.lisModuleId,
        roleId:  widget.model.lisRoleId,
        usernameLogin: false,
        surname: cttextSoyad.text,
        phone: cttextTelefon.text.toString().removeAllWhitespace,
        gender: genderSelect,
        regionId: selectedRegion!.id,
        email: cttextEmail.text,
        deviceLogin: true,
        deviceId: widget.deviceId,
        birthdate: cttextDogumTarix.text.trim(),
        folloginService: "true"
    );
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      final response = await dio.post(
        AppConstands.baseUrlsMain+"/Admin/RegisterByUser",
        data: registerData.toJson(),
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      print("sending data  "+registerData.toString());
      print("responce status "+response.statusCode.toString());
      print("responce data "+response.data.toString());
      if (response.statusCode == 200) {
        Get.back();
        Get.dialog(ShowInfoDialog(
            icon: Icons.network_locked_outlined,
            messaje: response.data['Result'].toString(),
            callback: () {
              Get.back();
              Get.offAllNamed(RouteHelper.mobileLisanceScreen);
            },
          ));
      }else{
        Get.back();
        if(response.data['Exception'] != null) {
          succes=false;
          ModelExceptions model = ModelExceptions.fromJson(response.data['Exception']);
          Get.dialog(ShowInfoDialog(
            color: Colors.red,
            icon: Icons.perm_identity,
            messaje: model.message!=null?model.message!:model.code!.toString(),
            callback: () {
              Get.back();
            },
          ));

        }else{
          Get.dialog(ShowInfoDialog(
            color: Colors.red,
            icon: Icons.error,
            messaje: "error".tr,
            callback: () {
              Get.back();
            },
          ));

        }
      }
    }

    return succes;
  }
  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

}
