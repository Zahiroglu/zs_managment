import 'dart:convert';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import '../../../dio_config/api_client.dart';
import '../../../helpers/dialog_helper.dart';
import '../../../routs/rout_controller.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/base_responce.dart';
import '../../login/models/logged_usermodel.dart';
import '../../login/models/user_model.dart';
import '../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:intl/intl.dart' as intl;

import 'liveTrack/model_live_track_map.dart';

class WidgetHesabatListItemsUser extends StatefulWidget {
  BuildContext context;
  ModelCariHesabatlar modelCariHesabatlar;
  String userCode;
  String roleId;
  Function onclick;

  WidgetHesabatListItemsUser(
      {required this.onclick,
      required this.modelCariHesabatlar,
      required this.context,
      required this.userCode,
      required this.roleId,
      super.key});

  @override
  State<WidgetHesabatListItemsUser> createState() =>
      _WidgetHesabatListItemsUserState();
}

class _WidgetHesabatListItemsUserState extends State<WidgetHesabatListItemsUser> {
  TextEditingController ctFistDay = TextEditingController();
  TextEditingController ctLastDay = TextEditingController();
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices userService = LocalUserServices();
  final controller = BoardDateTimeController();

  @override
  void initState() {
    if(widget.modelCariHesabatlar.needTime!){
      ctFistDay.text = DateTime.now().toString();
      ctLastDay.text = DateTime.now().toString();
    }else {
      ctFistDay.text = DateTime.now().toString().substring(0, 10);
      ctLastDay.text = DateTime.now().toString().substring(0, 10);
    }userService.init();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    ctLastDay.dispose();
    ctFistDay.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          intendByDialog();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: widget.modelCariHesabatlar.color!,
                      offset: const Offset(2, 2),
                      spreadRadius: 0.1,
                      blurRadius: 2)
                ],
                border: Border.all(
                    color: widget.modelCariHesabatlar.color!.withOpacity(0.5)),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: widget.modelCariHesabatlar.color!,
                  foregroundColor: Colors.white,
                  child: Icon(widget.modelCariHesabatlar.icon!),
                ),
                SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomText(
                        labeltext: widget.modelCariHesabatlar.label!.tr,
                        maxline: 2,
                        textAlign: TextAlign.center,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  intendByDialog() {
    if (widget.modelCariHesabatlar.needDate!) {
      if (widget.modelCariHesabatlar.needTime!) {
        Get.dialog(_widgetDateTimePicker());

      } else {
        Get.dialog(_widgetDatePicker());
      }
    } else {
      _intenReqPage();
    }
  }

  Widget _widgetDatePicker() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(widget.context).size.height * 0.3,
            horizontal: MediaQuery.of(widget.context).size.width * 0.1),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                  ctFistDay.text = DateTime.now().toString().substring(0, 10);
                  ctLastDay.text = DateTime.now().toString().substring(0, 10);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(bottom: 0),
                  child: Icon(Icons.clear),
                ),
              ),
            ),
            CustomText(
              labeltext: widget.modelCariHesabatlar.label!,
              fontsize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "firstDate".tr,
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(widget.context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker(true);
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctFistDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "lastDate".tr,
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(widget.context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker(true);
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctLastDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevetedButton(
                surfaceColor: Colors.white,
                borderColor: Colors.green,
                textColor: Colors.green,
                fontWeight: FontWeight.w700,
                icon: Icons.refresh,
                clicble: true,
                elevation: 10,
                height: 40,
                width: MediaQuery.of(widget.context).size.width * 0.4,
                cllback: () {
                  _intenReqPage();
                },
                label: "hesabatAl".tr)
          ],
        ),
      ),
    );
  }

  Widget _widgetDateTimePicker() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(widget.context).size.height * 0.3,
            horizontal: MediaQuery.of(widget.context).size.width * 0.1),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                  ctFistDay.text = DateTime.now().toString().substring(0, 10);
                  ctLastDay.text = DateTime.now().toString().substring(0, 10);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(bottom: 0),
                  child: Icon(Icons.clear),
                ),
              ),
            ),
            CustomText(
              labeltext: widget.modelCariHesabatlar.label!,
              fontsize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "firstDate".tr,
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(widget.context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () async {
                          final result = await showBoardDateTimePicker(
                            context: context,
                            pickerType: DateTimePickerType.datetime,
                          );
                          if (result != null) {
                            setState(() => ctFistDay.text = result.toString().substring(0,16));
                          }
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctFistDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "lastDate".tr,
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(widget.context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () async {
                          final result = await showBoardDateTimePicker(
                            useSafeArea: true,
                            showDragHandle: true,
                            context: context,
                            pickerType: DateTimePickerType.datetime,
                          );
                          if (result != null) {
                            setState(() => ctLastDay.text = result.toString().substring(0,16));
                          }
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctLastDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevetedButton(
                surfaceColor: Colors.white,
                borderColor: Colors.green,
                textColor: Colors.green,
                fontWeight: FontWeight.w700,
                icon: Icons.refresh,
                clicble: true,
                elevation: 10,
                height: 40,
                width: MediaQuery.of(widget.context).size.width * 0.4,
                cllback: () {
                  _intenReqPage();
                },
                label: "hesabatAl".tr)
          ],
        ),
      ),
    );
  }


  void callDatePicker(bool isFistDate) async {
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
    if (isFistDate) {
      //ctFistDay.text = "$day.$ay.${order.year}";
      ctFistDay.text = "${order.year}-$ay-$day";
    } else {
      // ctLastDay.text = "$day.$ay.${order.year}";
      ctLastDay.text = "${order.year}-$ay-$day";
    }
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

  Future<void> _intenReqPage() async {
    switch (widget.modelCariHesabatlar.key) {
      case "trhesabat":
        DialogHelper.showLoading("cmendirilir".tr);
        List<ModelMainInOut> listGirisCixis = [];
        List<UserModel> listUsers = [];
        MercDataModel modela = await getAllCustomersMerc(widget.userCode);
        listGirisCixis=await getAllGirisCixis(widget.userCode, widget.roleId);
        DialogHelper.hideLoading();
        if (modela.user != null) {
          Get.toNamed(RouteHelper.screenMercRoutDatail, arguments: [modela, listGirisCixis, listUsers]);
        } else {
          Get.dialog(ShowInfoDialog(
              messaje: "mtapilmadi".tr,
              icon: Icons.error,
              callback: () {
                Get.back();
                Get.back();
              }));
        }
        break;
        case "tzhesab":
        DialogHelper.showLoading("tzhesab".tr);
        List<ModelMainInOut> listGirisCixis=await getAllGirisCixis(widget.userCode, widget.roleId);
        DialogHelper.hideLoading();
        if (listGirisCixis.isNotEmpty) {
          Get.toNamed(RouteHelper.screenTemZiyaret, arguments: [listGirisCixis]);
        } else {
          Get.dialog(ShowInfoDialog(
              messaje: "mtapilmadi".tr,
              icon: Icons.error,
              callback: () {
                Get.back();
                Get.back();
              }));
        }
        break;
    }switch (widget.modelCariHesabatlar.key) {
      case "tizlemehesab":
        DialogHelper.showLoading(widget.modelCariHesabatlar.label!.tr);

        List<MyConnectedUsersCurrentLocationReport> listGirisCixis = [];
        listGirisCixis=await getMyConnectedUsersCurrentLocations(widget.userCode, widget.roleId);
        DialogHelper.hideLoading();
        if (listGirisCixis.isNotEmpty) {
          Get.toNamed(RouteHelper.screenLiveTrackReport,arguments: [listGirisCixis]);
        } else {
          Get.dialog(ShowInfoDialog(
              messaje: "mtapilmadi".tr,
              icon: Icons.error,
              callback: () {
                Get.back();
                Get.back();
              }));
        }
        break;
        case "terror":
          Get.toNamed(RouteHelper.screenErrorsReport,arguments: [true,ctFistDay.text.substring(0,16),ctLastDay.text.substring(0,16),widget.userCode,widget.roleId]);
    }
    //ctFistDay.clear();
    //ctLastDay.clear();
  }

  Future<MercDataModel> getAllCustomersMerc(String temKod) async {
    MercDataModel listUsers = MercDataModel();
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler = [];
    secilmisTemsilciler.add(temKod);
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(false).post(
              "${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-merch",
              data: jsonEncode(secilmisTemsilciler),
              options: Options(
                receiveTimeout: const Duration(seconds: 60),
                headers: {
                  'Lang': languageIndex,
                  'Device': dviceType,
                  'abs': '123456',
                  "Authorization": "Bearer $accesToken"
                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );
        print("responce kode :" + response.data.toString());

          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for (var i in listuser) {
              listUsers = MercDataModel.fromJson(i);
            }

        }
      } on DioException catch (e) {
      }
    }
    return listUsers;
  }

  Future<List<ModelMainInOut>> getAllGirisCixis(String temsilcikodu, String roleId) async {
    List<ModelMainInOut> listGirisCixis = [];
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    DateTime dateParse = DateTime.parse(date);
    //String ilkGun = intl.DateFormat('yyyy-MM-dd hh:mm').format(dateParse);
    String ilkGun = intl.DateFormat('yyyy-MM-dd').format(dateParse);
    //String songun = intl.DateFormat('yyyy-MM-dd hh:mm').format(now);
    String songun = intl.DateFormat('yyyy-MM-dd').format(now);
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    var data = {

        "user": [
          {
            "code": temsilcikodu,
            "role": roleId
          }
        ],
        "startDate": ilkGun,
        "endDate": songun
    };
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(false).post(
              "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-customers-by-user",
              data: data,
              options: Options(
                receiveTimeout: const Duration(seconds: 60),
                headers: {
                  'Lang': languageIndex,
                  'Device': dviceType,
                  'abs': '123456',
                  "Authorization": "Bearer $accesToken"
                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );

          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for (var i in listuser) {
              ModelMainInOut model = ModelMainInOut.fromJson(i);
              print("model :" + model.toString());
              listGirisCixis.add(model);
            }
        }
      } on DioException catch (e) {
      }
    }
    return listGirisCixis;
  }

  Future<List<MyConnectedUsersCurrentLocationReport>> getMyConnectedUsersCurrentLocations(String temsilcikodu, String roleId) async {
    List<MyConnectedUsersCurrentLocationReport> listGirisCixis = [];
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    var data = {
      "user": [
        {
          "code": widget.userCode,
          "role":widget.roleId
        }
      ],
      "startDate": ctFistDay.text.toString().substring(0,16),
      "endDate": ctLastDay.text.toString().substring(0,16)

    };
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio(false).post(
              "${loggedUserModel.baseUrl}/api/v1/InputOutput/live-tracking-by-user",
              data: data,
              options: Options(
                headers: {
                  'Lang': languageIndex,
                  'Device': dviceType,
                  'abs': '123456',
                  "Authorization": "Bearer $accesToken"
                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );

          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for (var i in listuser) {
              MyConnectedUsersCurrentLocationReport model = MyConnectedUsersCurrentLocationReport.fromJson(i);
              print("model :" + model.toString());
              listGirisCixis.add(model);
            }
        }
      } on DioException catch (e) {
      }
    }
    return listGirisCixis;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
