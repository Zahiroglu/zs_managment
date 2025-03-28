import 'dart:convert';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/model_cari_hesabatlar.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import '../../../constands/app_constands.dart';
import '../../../dio_config/api_client.dart';
import '../../../helpers/dialog_helper.dart';
import '../../../routs/rout_controller.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/logged_usermodel.dart';
import '../../login/models/user_model.dart';
import '../../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';

import '../../ziyaret_tarixcesi/model_requestreport_giriscixis.dart';
import '../../ziyaret_tarixcesi/simple_user_request.dart';
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
  DateTime dateFirst=DateTime.now();
  DateTime dateLast=DateTime.now();
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
                color:Get.isDarkMode?Colors.black: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: widget.modelCariHesabatlar.color!,
                      offset: const Offset(3, 3),
                      spreadRadius: 0.5,
                      blurRadius: 5)
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
                  child: const Icon(Icons.clear),
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
                          callDatePicker(false);
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
                  child: const Icon(Icons.clear),
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
      dateFirst=order;
      ctFistDay.text = "${order.year}-$ay-$day";
    } else {
      // ctLastDay.text = "$day.$ay.${order.year}";
      dateLast=order;
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
        Get.back();
        DialogHelper.showLoading("cmendirilir".tr);
        List<ModelMainInOut> listGirisCixis = await getUsersInfo(true);
        List<UserModel> listUsers = [];
        MercDataModel modela = await getAllCustomersMerc(widget.userCode);
        Get.toNamed(RouteHelper.screenMercRoutDatail, arguments: [modela, listGirisCixis, listUsers]);
              break;
        case "tzhesab":
          Get.back();
          DialogHelper.showLoading("tzhesab".tr);
        List<ModelMainInOut> listGirisCixis=await getUsersInfo(false);
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
      case "tizlemehesab":
        Get.back();
        var dif= dateLast.difference(dateFirst).inDays;
        if(dif<=1){
        Get.toNamed(RouteHelper.screenLiveTrackReport,arguments: [widget.roleId,widget.userCode,ctFistDay.text,ctLastDay.text]);
        }else{
          Get.dialog(ShowInfoDialog(
              messaje: "ziyaretHaciqlama".tr,
              icon: Icons.running_with_errors_sharp,
              callback: () {
              }));

        }
        break;
      case "terror":
        Get.back();
        Get.toNamed(RouteHelper.screenErrorsReport,arguments: [true,ctFistDay.text.substring(0,16),ctLastDay.text.substring(0,16),widget.userCode,widget.roleId]);
      break;
    }

  }


  Future<MercDataModel> getAllCustomersMerc(String temKod) async {
    List<MercDataModel> listUsers = [];
    List<UserModel> listConnectedUsers = [];
    languageIndex = await getLanguageIndex();
    LoggedUserModel loggedUserModel =  userService.getLoggedUser();
    DateTime dateTime=DateTime.now();
    var data=
    {
      "code": temKod,
      "roleId": widget.roleId,
      "companyId": loggedUserModel.userModel!.companyId,
      "il": dateTime.year,
      "ay": dateTime.month

    };
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      var response = await ApiClient().dio(false).post(
        "${loggedUserModel.baseUrl}/MercSystem/getAllMercRout",
        data: data,
        options: Options(
          headers: {
            'Lang': languageIndex,
            'Device': dviceType,
            'smr': '12345',
            "Authorization": "Bearer $accesToken"
          },
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        var dataModel = json.encode(response.data['Result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          listUsers.add(MercDataModel.fromJson(i));
          listConnectedUsers.add(UserModel(
            roleName: "Mercendaizer",
            roleId: 23,
            code: MercDataModel.fromJson(i).user!.code,
            name: MercDataModel.fromJson(i).user!.name,
            gender: 0,
          ));
        }
      }
    }
    return listUsers.first;
  }

  Future<List<ModelMainInOut>> getUsersInfo(bool needMounth) async {
    late List<SimpleUserModel>? listUsers = [];
    List<ModelMainInOut> listGirisCixis=[];
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    int compId=loggedUserModel.userModel!.companyId!;
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    var data={
      "code": widget.userCode,
      "roleId": widget.roleId,
      "companyId": loggedUserModel.userModel!.companyId!
    };

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
          "${AppConstands.baseUrlsMain}/Admin/GetSimpleUsersInfoByFilterParams",
          data: data,
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        if (response.statusCode == 200) {
          var userlist = json.encode(response.data['Result']);
          List list = jsonDecode(userlist);
          for(var i in list){
            UserModel model=UserModel.fromJson(i);
            listUsers.add(SimpleUserModel(
                code: model.code,
                permissions: model.permissions,
                name: model.name,
                surname:model.surname,
                phone: model.phone,
                roleId: model.roleId,
                roleName: model.roleName,
                moduleName: model.moduleName,
                moduleId: model.moduleId,
                configrations: model.configrations,
                email: model.email
            ));
          }
          listGirisCixis= await getAllGirisCixis(listUsers,needMounth);
        }
      } on DioException {
      }
    }
    return listGirisCixis;
  }

  Future<List<ModelMainInOut>> getAllGirisCixis(List<SimpleUserModel> listUsers, bool needMounth) async {
    List<ModelMainInOut> listGirisCixis=[];
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    String endTimeS=DateTime.now().toString().substring(0,7)+"-01 23:59";
    GirisCixisRequest model = GirisCixisRequest(
        rollar: listUsers,
        endDate:ctLastDay.text+" 23:59",
        userCode: widget.userCode,
        startDate: needMounth?endTimeS:"${ctLastDay.text}00:01");
    print("Model tarixleri : ${model.startDate} - ${model.endDate}");
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
          "${loggedUserModel
              .baseUrl}/Hesabatlar/GetGirisCixisByParmsReport",
          data: model.toJson(),
          options: Options(
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Lang': languageIndex,
              'Device': dviceType,
              'smr': '12345',
              "Authorization": "Bearer $accesToken"
            },
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        if (response.statusCode == 200) {
          var dataModel = json.encode(response.data['Result']);
          List listuser = jsonDecode(dataModel);
          for (var i in listuser) {
            ModelMainInOut model = ModelMainInOut.fromJson(i);
            listGirisCixis.add(model);
          }
        }
      } on DioException {
      }
    }
    return listGirisCixis;
  }


  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
