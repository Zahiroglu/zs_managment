import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_customers_visit.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/cari_ziyaret_hesabati/widget_giriscixis_item.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';

import '../../../dio_config/api_client.dart';
import '../../../utils/checking_dvice_type.dart';
import '../../../widgets/simple_info_dialog.dart';
import '../../../widgets/widget_notdata_found.dart';
import '../../backgroud_task/backgroud_errors/model_back_error.dart';
import '../../local_bazalar/local_users_services.dart';
import '../../login/models/base_responce.dart';
import '../../login/models/logged_usermodel.dart';
import '../../main_screen/controller/drawer_menu_controller.dart';

class WrongEntriesRepors extends StatefulWidget {
  DrawerMenuController drawerMenuController;

  WrongEntriesRepors({required this.drawerMenuController, super.key});

  @override
  State<WrongEntriesRepors> createState() => _WrongEntriesReporsState();
}

class _WrongEntriesReporsState extends State<WrongEntriesRepors> {
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices userService = LocalUserServices();
  bool dataLoading = true;
  List<ModelCustuomerVisit> listErrors = [];

  @override
  void initState() {
    getAllDatafromServer();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getAllDatafromServer() async {
    listErrors = await getAllErrors();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: CustomText(
          labeltext: "wronEntries".tr,
        ),
        leading: IconButton(
          onPressed: () {
            widget.drawerMenuController.openDrawer();
          },
          icon: Icon(Icons.menu),
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
    ));
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
          return WidgetGirisCixisItem(
            element: listErrors.elementAt(index),
            canDelete: true,
            deleted: (val) {
              if (val) {
                deleteItems(listErrors.elementAt(index));
              }
            },
          );
        });
  }

  Future<List<ModelCustuomerVisit>> getAllErrors() async {
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    List<ModelCustuomerVisit> listAllErrors = [];
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
        final response = await ApiClient().dio().get(
              "${loggedUserModel.baseUrl}/api/v1/InputOutput/my-connected-users-open-enters",
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
          List listerror = jsonDecode(dataModel);
          for (var i in listerror) {
            ModelCustuomerVisit model = ModelCustuomerVisit.fromJson(i);
            model.inDate!.add(Duration(days: 1));
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

  Future<void> deleteItems(ModelCustuomerVisit model) async {
    DialogHelper.showLoading("msilinir".tr);
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    var data = {
      "userCode": model.userCode,
      "userPosition": model.userPosition,
      "customerCode": model.customerCode
    };
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          DialogHelper.hideLoading();
        },
      ));
    } else {
      try {
        final response = await ApiClient().dio().delete(
              "${loggedUserModel.baseUrl}/api/v1/InputOutput/delete-input-by-user",
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
          DialogHelper.hideLoading();
          var dataModel = json.encode(response.data['result']);
          Get.dialog(ShowInfoDialog(
            icon: Icons.verified,
            callback: () {
              listErrors.removeWhere((element) => element.userCode == model.userCode);
              setState(() {});
            },
            messaje: dataModel.toString(),
            color: Colors.green,
          ));
        }
        DialogHelper.hideLoading();
      } on DioException catch (e) {
        setState(() {
          DialogHelper.hideLoading();
          dataLoading = false;
        });
      }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
