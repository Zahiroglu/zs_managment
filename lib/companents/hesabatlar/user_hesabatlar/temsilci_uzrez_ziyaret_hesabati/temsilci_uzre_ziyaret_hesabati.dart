import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';

import '../../../../widgets/custom_responsize_textview.dart';
import '../../../../widgets/simple_info_dialog.dart';
import '../../../login/models/logged_usermodel.dart';
import '../../../login/models/user_model.dart';
import 'controller_user_ziyaret.dart';

class TemsilciUzreZiyaretHesabati extends StatefulWidget {
  List<ModelMainInOut> listGirisCixis;

  TemsilciUzreZiyaretHesabati({required this.listGirisCixis, super.key});

  @override
  State<TemsilciUzreZiyaretHesabati> createState() =>
      _TemsilciUzreZiyaretHesabatiState();
}

class _TemsilciUzreZiyaretHesabatiState extends State<TemsilciUzreZiyaretHesabati> {
  ControllerUserZiyaret controllerRoutDetailUser = Get.put(ControllerUserZiyaret());
  late CheckDviceType checkDviceType = CheckDviceType();
  String languageIndex = "az";
  LocalUserServices userService = LocalUserServices();
  MercDataModel modela=MercDataModel();
  @override
  void initState() {
    userService.init();
    if (controllerRoutDetailUser.initialized) {
      getAllDataFromBaza();
      controllerRoutDetailUser.getAllUsers(widget.listGirisCixis);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          labeltext: "ayliqZiyaretHes".tr,
          fontWeight: FontWeight.w600,
          fontsize: 16,
        ),
      ),
      body: controllerRoutDetailUser.dataLoading.isFalse
          ? Column(
              children: [
                Expanded(flex: 1, child: infoZiyaretTarixcesi()),
                Expanded(flex: 7, child: _pageViewZiyaretTarixcesi()),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            )),
    );
  }

  Widget infoZiyaretTarixcesi() {
    return Column(
      children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              Card(

                margin: const EdgeInsets.all(5).copyWith(top: 0,left: 10,right: 10),
                elevation: 5,
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"isgunleri".tr} : ",fontWeight: FontWeight.bold,),
                          CustomText(labeltext:
                                  "${controllerRoutDetailUser.listGunlukGirisCixislar.length} ${"gun".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"ziyaretSayi".tr} : ",fontWeight: FontWeight.bold,),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.listGunlukGirisCixislar.fold(0, (sum, element) => sum + element.visitedCount)} ${"market".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"umumiIssaati".tr} : ",fontWeight: FontWeight.bold,),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.totalIsSaati} "),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _pageViewZiyaretTarixcesi() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listGunlukGirisCixislar.length,
        itemBuilder: (con, index) {
          return itemZiyaretGunluk(controllerRoutDetailUser
              .listGunlukGirisCixislar
              .elementAt(index));
        });
  }

  Widget itemZiyaretGunluk(ModelInOutDay model) {
    return InkWell(
      onTap: () async {
        DialogHelper.showLoading("cmendirilir".tr);
        DialogHelper.hideLoading();
        if (modela.user != null) {
          Get.toNamed(RouteHelper.screenZiyaretGirisCixis,arguments: [model,widget.listGirisCixis.first.userFullName,modela.mercCustomersDatail]);
        } else {
          Get.dialog(ShowInfoDialog(
              messaje: "mtapilmadi".tr,
              icon: Icons.error,
              callback: () {
                Get.back();
                Get.back();
              }));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0).copyWith(left: 10, right: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1),
                    spreadRadius: 0.1,
                    blurRadius: 2)
              ],
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(5.0).copyWith(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  labeltext: model.day,
                  fontsize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  height: 2,
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    CustomText(
                        labeltext: "${"ziyaretSayi".tr} : ",
                        fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.visitedCount.toString()),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                        labeltext: "${"isBaslama".tr} : ",
                        fontWeight: FontWeight.w600),
                    CustomText(
                        labeltext: model.firstEnterDate.substring(
                            11, model.firstEnterDate.toString().length)),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                        labeltext: "${"isbitme".tr} : ",
                        fontWeight: FontWeight.w600),
              model.lastExitDate!='null'? CustomText(
                        labeltext: model.lastExitDate.substring(
                            11, model.lastExitDate.toString().length)):SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                labeltext: "${"marketlerdeISvaxti".tr} : ",
                              ),
                              CustomText(labeltext: model.workTimeInCustomer),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                labeltext: "${"erazideIsVaxti".tr} : ",
                              ),
                              CustomText(
                                labeltext: model.workTimeInArea,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
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
      "roleId": widget.listGirisCixis.first.userPosition,
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
      print("respince : "+response.toString());
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

  Future<void> getAllDataFromBaza() async {
    modela = await getAllCustomersMerc(widget.listGirisCixis.first.userCode);
    setState(() {});
  }

}
