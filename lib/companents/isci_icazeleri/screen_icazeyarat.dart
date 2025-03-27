import 'dart:convert';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/isci_icazeleri/ModelIcazeRequest.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

import '../../dio_config/api_client.dart';
import '../../helpers/exeption_handler.dart';
import '../../utils/checking_dvice_type.dart';
import '../../widgets/custom_text_field.dart';
import '../local_bazalar/local_users_services.dart';
import '../login/models/logged_usermodel.dart';
import 'ModelIcazeType.dart';
import 'package:get/get.dart';

class ScreenIcazeYrat extends StatefulWidget {
  final int illikGunLimiti;
  final int ayliqSaatLimiti;
  final Function(int) callBack;
 const ScreenIcazeYrat({required this.illikGunLimiti,required this.ayliqSaatLimiti,required this.callBack,super.key});

  @override
  State<ScreenIcazeYrat> createState() => _ScreenIcazeYratState();
}

class _ScreenIcazeYratState extends State<ScreenIcazeYrat> {
  LocalUserServices userServices = LocalUserServices();
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler = ExeptionHandler();
  bool dataLoading = true;
  List<Modelicazetype> listIcazeType = [];
  Modelicazetype selectedIcazeType = Modelicazetype();
  TextEditingController ctFistDay = TextEditingController();
  TextEditingController ctFistSaat = TextEditingController();
  TextEditingController ctLastDay = TextEditingController();
  TextEditingController ctLastSaat = TextEditingController();
  TextEditingController ctQeyd = TextEditingController();
  DateTime startDateTime = DateTime.now();
  DateTime endtDateTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endtTime = DateTime.now();
  String secilenVaxtQeyd="";

    @override
  void initState() {
    getAllIcazeType();
    // TODO: implement initState
    super.initState();
    ctFistDay.text = DateTime.now().toString().substring(0, 10);
    ctLastDay.text = DateTime.now().toString().substring(0, 10);
    ctFistSaat.text = DateTime.now().toString().substring(10, 16);
    ctLastSaat.text = DateTime.now().toString().substring(10, 16);
    startTime = DateTime.now();
    endtTime = DateTime.now().add(const Duration(minutes: 10));
    gunlukZamaniHesabla();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            labeltext: "Icaze yarat",
          ),
        ),
        body: dataLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : listIcazeType.isNotEmpty
                ? _body(context)
                : NoDataFound(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width * 0.6,
                    title: "melumatTapilmadi".tr,
                    mustReloud: true,
                    callBack: () {
                      getAllIcazeType();
                    },
                  ),
      ),
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: widgetIcazeTipiniSec(),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(labeltext: "Vaxt araligi secin",fontWeight: FontWeight.bold,),
                        secilenVaxtQeyd.isNotEmpty?CustomText(labeltext:"$secilenVaxtQeyd secildi",
                          fontWeight: FontWeight.w700,color: Colors.blueAccent,):const SizedBox(),
                      ],
                    ),
                  ),
                  selectedIcazeType.icazeId == 4
                      ? _widgetDateTimePicker()
                      : _widgetDatePicker(),
                    selectedIcazeType.icazeId==4?const SizedBox():secilenVaxtQeyd.isNotEmpty?Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const Icon(Icons.info_rounded,color: Colors.red,),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: CustomText(
                                maxline: 2,
                                labeltext: "Icazeniz tesdiqlense ${endtDateTime.add(const Duration(days: 1)).toString().substring(0,10)} tarixinde isde olmalisiniz!"),
                          ),
                        ],
                      ),
                    // ignore: prefer_const_constructors
                    ):SizedBox()
                ],),
              ),
            ),
          ),
          secilenVaxtQeyd.isNotEmpty?Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                    child: CustomText(labeltext: "Icaze sebebini qeyd edin",fontWeight: FontWeight.bold,fontsize: 16,),
                  ),
                  CustomTextField(
                      maxLines: 10,
                      containerHeight: 100,
                      isImportant: true,
                      controller: ctQeyd, inputType: TextInputType.text, hindtext: "Sebeb elave edin",
                      fontsize: 18)
                ],
              ),
            ),
          ):const SizedBox(),
          const SizedBox(height: 20,),
          secilenVaxtQeyd.isNotEmpty?Align(
            alignment: Alignment.bottomCenter,
            child:
            CustomElevetedButton(
              icon: Icons.arrow_circle_right_outlined,
              borderColor: Colors.green,
              textColor: Colors.green,
              textsize: 16,
              fontWeight: FontWeight.bold,
              elevation: 10,
              iconLeft: false,
              width: MediaQuery.of(context).size.width/2,
              label: "Icazeni tesdiqle",
              cllback: (){
                icazeniTesdiqle();
              },
            ),):const SizedBox()
        ],
      ),
    );
  }

  widgetIcazeTipiniSec() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.green.withOpacity(0.5),
                        child: const Icon(
                          size: 18,
                          Icons.task,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      labeltext: "icazeTipiSec".tr,
                      fontsize: 16,
                      maxline: 2,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 5,
                child: DropdownButton<Modelicazetype>(
                  value: selectedIcazeType,
                  elevation: 16,
                  padding: const EdgeInsets.all(0),
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: const SizedBox(),
                  onChanged: (Modelicazetype? value) {
                    setState(() {
                      if(selectedIcazeType.icazeId!=value!.icazeId){
                        selectedIcazeType = value;
                        secilenVaxtQeyd="";
                        if(value.icazeId==4){
                          ctFistDay.text = DateTime.now().toString().substring(0, 10);
                          ctLastDay.text = DateTime.now().toString().substring(0, 10);
                          ctFistSaat.text = DateTime.now().toString().substring(10, 16);
                          ctLastSaat.text = DateTime.now().add(const Duration(minutes: 10)).toString().substring(10, 16);
                          startTime = DateTime.now();
                          endtTime = DateTime.now().add(const Duration(
                              minutes: 10));
                          endtDateTime = endtDateTime.add(const Duration(
                              days: 1));
                        }
                        else {
                          ctFistDay.text = DateTime.now().toString().substring(0, 10);
                          ctLastDay.text = DateTime.now().add(const Duration(days: 1)).toString().substring(0, 10);
                          ctFistSaat.text = DateTime.now().toString().substring(10, 16);
                          ctLastSaat.text = DateTime.now().toString().substring(10, 16);
                          startTime = DateTime.now();
                          endtTime = DateTime.now().add(const Duration(
                              minutes: 10));
                          endtDateTime = endtDateTime.add(const Duration(
                              days: 1));
                        }
                      }

                    });
                  },
                  items: listIcazeType.map<DropdownMenuItem<Modelicazetype>>(
                      (Modelicazetype value) {
                    return DropdownMenuItem<Modelicazetype>(
                        value: value,
                        child: CustomText(
                          labeltext: value.icazeAdi!,
                          maxline: 2,
                        ));
                  }).toList(),
                ),
              )
            ],
          )),
    );
  }

  Widget _widgetDateTimePicker() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: CustomText(labeltext: "Tarix sec : ",
                        fontsize: 16,
                        fontWeight: FontWeight.w400)),
                Expanded(
                  flex: 5,
                  child: CustomTextField(
                      align: TextAlign.center,
                      suffixIcon: Icons.date_range,
                      obscureText: false,
                      updizayn: true,
                      onTopVisible: () async {
                        final result = await showBoardDateTimePicker(
                          minimumDate: DateTime.now(),
                          radius: 50,
                          useSafeArea: false,
                          enableDrag: false,
                          context: context,
                          pickerType: DateTimePickerType.date,
                        );
                        if (result != null) {
                          setState(() {
                          ctFistDay.text = result.toString().substring(0, 10);
                          ctLastDay.text = result.toString().substring(0, 10);
                          endtDateTime = result;
                          if(result.toString().substring(0, 10)!=DateTime.now().toString().substring(0, 10)){
                            startTime=DateTime.now().add(const Duration(days: -1));
                            endtTime=DateTime.now().add(const Duration(days: -1));
                          }else{
                            startTime=DateTime.now();
                            endtTime=DateTime.now().add(const Duration(minutes: 10));
                          }
                          });
                        }
                      },
                      // suffixIcon: Icons.date_range,
                      hasBourder: true,
                      borderColor: Colors.black,
                      containerHeight: 45,
                      controller: ctFistDay,
                      inputType: TextInputType.datetime,
                      hindtext: "",
                      fontsize: 14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: CustomText(
                      labeltext: "startDate".tr,
                      fontsize: 16,
                      fontWeight: FontWeight.w400),
                ),
                Expanded(
                    flex: 5,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.timelapse,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () async {
                          final result = await showBoardDateTimePicker(
                            minimumDate:startTime,
                            radius: 50,
                            useSafeArea: false,
                            enableDrag: false,
                            context: context,
                            pickerType: DateTimePickerType.time,
                          );
                          if (result != null) {
                            setState(() { ctFistSaat.text = result.toString().substring(10, 16);
                            endtTime=result;
                            });
                          }
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 45,
                        controller: ctFistSaat,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomText(
                      labeltext: "endDate".tr,
                      fontsize: 16,
                      fontWeight: FontWeight.w400),
                ),
                Expanded(
                    flex:5,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.timelapse,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () async {
                          final result = await showBoardDateTimePicker(
                            initialDate: endtTime.add(const Duration(minutes: 10)),
                            minimumDate: endtTime.add(const Duration(minutes: 10)),
                            radius: 50,
                            useSafeArea: false,
                            enableDrag: false,
                            context: context,
                            pickerType: DateTimePickerType.time,
                          );
                          if (result != null) {
                            setState(() => ctLastSaat.text = result.toString().substring(10, 16));
                            gunlukSaatHesabla();
                          }
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 45,
                        controller: ctLastSaat,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _widgetDatePicker() {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 15, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: CustomText(
                      labeltext: "startDate".tr,
                      fontsize: 16,
                      fontWeight: FontWeight.w400),
                ),
                Expanded(
                    flex: 4,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () async {
                          final result = await showBoardDateTimePicker(
                            minimumDate: DateTime.now(),
                            radius: 50,
                            useSafeArea: false,
                            enableDrag: false,
                            context: context,
                            pickerType: DateTimePickerType.date,
                          );
                          if (result != null) {
                            setState(() {
                              ctFistDay.text = result.toString().substring(0, 10);
                              ctLastDay.text = result.toString().substring(0, 10);
                              endtDateTime = result;
                            });
                          }
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 45,
                        controller: ctFistDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 15, top: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomText(
                      labeltext: "endDate".tr,
                      fontsize: 16,
                      fontWeight: FontWeight.w400),
                ),
                Expanded(
                    flex: 4,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () async {
                          final result = await showBoardDateTimePicker(
                            minimumDate: endtDateTime,
                            initialDate: endtDateTime,
                            radius: 50,
                            useSafeArea: false,
                            enableDrag: false,
                            context: context,
                            pickerType: DateTimePickerType.date,
                          );
                          if (result != null) {
                            {
                              setState(() {
                                ctLastDay.text = result.toString().substring(0, 10);
                                gunlukZamaniHesabla();
                              });
                            }
                          }
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 45,
                        controller: ctLastDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAllIcazeType() async {
    setState(() {
      dataLoading = true;
      listIcazeType.clear();
    });
    await userServices.init();
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
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
              "${loggedUserModel.baseUrl}/Icaze/getAllIcazeTypes?simpleCanUse=true",
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
            Modelicazetype model = Modelicazetype.fromJson(i);
            listIcazeType.add(model);
          }
          if (!listIcazeType.contains(selectedIcazeType)) {
            selectedIcazeType =
                (listIcazeType.isNotEmpty ? listIcazeType.first : null)!;
          }
        } else {
          exeptionHandler.handleExeption(response);
        }
      } on DioException catch (e) {
        if (e.response != null) {
        } else {
          // Something happened in setting up or sending the request that triggered an Error
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }
    setState(() {
      dataLoading = false;
    });
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void gunlukZamaniHesabla() {
    String startDate = "${ctFistDay.text} 00:01";
    String endDate = "${ctLastDay.text} 00:01";
    // String formatından DateTime formatına çevirmək
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    // İki tarix arasındakı fərqi hesablamaq
    int differenceInDays = (end.add(const Duration(days: 1))).difference(start).inDays;
    secilenVaxtQeyd="$differenceInDays ${"day".tr}";
  }

  void gunlukSaatHesabla() {
    // Tarix və saatları birləşdirərək string şəklində alırıq
    String startDate = ctFistDay.text + ctFistSaat.text;
    String endDate = ctLastDay.text + ctLastSaat.text;

    // String formatından DateTime formatına çevirmək
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    // İki tarix arasındakı fərqi hesablamaq
    int differenceInMinutes = end.difference(start).inMinutes;

    // Saat və dəqiqə şəklinə çevirmək
    int hours = differenceInMinutes ~/ 60; // Tam saatları tapırıq
    int minutes = differenceInMinutes % 60; // Qalan dəqiqələri tapırıq

    // Şərtə əsasən nəticəni formatlaşdırmaq
    if (hours > 0) {
      secilenVaxtQeyd = "$hours saat $minutes dəqiqə";
    } else {
      secilenVaxtQeyd = "$minutes dəqiqə";
    }
    }

  Future<void> icazeniTesdiqle() async {
      if(ctQeyd.text.isNotEmpty){
        await userServices.init();
        DateTime start = DateTime.parse("${ctFistDay.text} 00:01");
        DateTime end = DateTime.parse( "${ctLastDay.text} 23:59");
        if(selectedIcazeType.icazeId==4){
          String startDate = ctFistDay.text + ctFistSaat.text;
          String endDate = ctLastDay.text + ctLastSaat.text;
           start = DateTime.parse(startDate);
           end = DateTime.parse(endDate);
        }
        LoggedUserModel loggedUserModel=userServices.getLoggedUser();
        ModelIcazeRequest model =ModelIcazeRequest(
            userId: loggedUserModel.userModel!.id!,
            userCode: loggedUserModel.userModel!.code!,
            userRoleId: loggedUserModel.userModel!.roleId!,
            userRoleName: loggedUserModel.userModel!.roleName!,
            userNameAndSurname: "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
            icazeTypeId: selectedIcazeType.icazeId!,
            icazeStartDate: start,
            icazeEndDate: end,
            icazeQeyd: ctQeyd.text,
        );
        await callReqestAddIcaze(model);
      }else{
        Get.dialog(ShowInfoDialog(messaje: "Qeyd melumatlarini tam doldur", icon: Icons.error, callback: (){}));
      }

  }

  Future<void> callReqestAddIcaze(ModelIcazeRequest model) async {
    DialogHelper.showLoading("Melumatlar daxil edilir",false);
    await userServices.init();
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try{
        final response = await ApiClient().dio(false).post(
          "${loggedUserModel.baseUrl}/Icaze/addNewIcazeByUser?illikLimit=${widget.illikGunLimiti}&ayliqLimit=${widget.ayliqSaatLimiti}",
          data: model.toJson(),
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
          Get.dialog(ShowInfoDialog(messaje: response.data['Result'], icon: Icons.verified_sharp, callback: (){
            widget.callBack(200);
            Get.back();
          }));
        }else{
        }
      }catch(e){
        DialogHelper.hideLoading();
      }
    }
  }

  void funFlutterToast(String s, bool isSucces) {
    Fluttertoast.showToast(
        msg: s.tr,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: isSucces ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
