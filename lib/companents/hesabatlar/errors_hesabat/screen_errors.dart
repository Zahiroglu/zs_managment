import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../dio_config/api_client.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/custom_responsize_textview.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../../widgets/widget_notdata_found.dart';
import '../../backgroud_task/backgroud_errors/model_back_error.dart';
import '../../giris_cixis/models/model_request_inout.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/base_responce.dart';
import '../../login/models/logged_usermodel.dart';

class ScreenErrorsReport extends StatefulWidget {
  bool mustgetAllUsers;
  DateTime startDay;
  DateTime endDay;
  String userCode;
  String userRoleId;
  List<UserRole> listUsers;


  ScreenErrorsReport(
      {required this.mustgetAllUsers,
      required this.startDay,
      required this.endDay,
      required this.userCode,
      required this.userRoleId,
        required this.listUsers,
      super.key});

  @override
  State<ScreenErrorsReport> createState() => _ScreenErrorsReportState();
}

class _ScreenErrorsReportState extends State<ScreenErrorsReport> {
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices userService = LocalUserServices();
  bool dataLoading = true;
  List<ModelBackErrors> listErrors = [];
  bool isUserMode = true;
  bool isListReseved = false;
  String startDay = "";
  String endDay = "";

  @override
  void initState() {
    getAllDatafromServer();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isUserMode = false;
                });
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                setState(() {
                  isListReseved != isListReseved;
                  listErrors = listErrors.reversed.toList();
                });
              },
              icon: Icon(Icons.sort))
        ],
        title: CustomText(
          labeltext: "errors".tr,
        ),
      ),
      body: dataLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : listErrors.isEmpty
              ? _melumatTapilmadi()
              : _body(),
    );
  }

  Future<void> getAllDatafromServer() async {
    listErrors = await getAllErrors();
    setState(() {});
  }

  Future<List<ModelBackErrors>> getAllErrors() async {
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    List<ModelBackErrors> listAllErrors = [];
    if (!widget.mustgetAllUsers) {
     widget.listUsers.add(UserRole(code: widget.userCode, role: widget.userRoleId));
    }
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
              "${loggedUserModel.baseUrl}/Hesabatlar/GetUsersErrorsByParams",
              data: widget.listUsers,
          queryParameters: {
            "startDate": widget.startDay.toIso8601String(),
            "endDate": widget.endDay.toIso8601String(),
          },
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
          List listerror = jsonDecode(dataModel);
          for (var i in listerror) {
            ModelBackErrors model = ModelBackErrors.fromJson(i);
            listAllErrors.add(model);
          }
          setState(() {
            dataLoading = false;
          });
        } else {
          setState(() {
            dataLoading = false;
          });
        }
      } on DioException catch (e) {
        setState(() {
          dataLoading = false;
        });
      }
    }
    return listAllErrors;
  }


  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Widget _melumatTapilmadi() {
    return NoDataFound(
      title: "melumattapilmadi".tr,
    );
  }

  _body() {
    return ListView.builder(
        itemCount: listErrors.length,
        itemBuilder: (c, index) {
      return listItems(listErrors.elementAt(index));
    });
  }

  Card listItems(ModelBackErrors element) {
    return Card(
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CustomText(labeltext: element.userCode.toString()+" - "+element.userFullName.toString(),fontsize: 14,fontWeight: FontWeight.bold,),
                ),
                CustomText(
                  maxline: 3,
                  labeltext: element.errName!,
                ),
                CustomText(
                  maxline: 3,
                  labeltext: element.description!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      maxline: 3,
                      labeltext: "date".tr+" : "+element.errDate.toString().substring(0,15),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
