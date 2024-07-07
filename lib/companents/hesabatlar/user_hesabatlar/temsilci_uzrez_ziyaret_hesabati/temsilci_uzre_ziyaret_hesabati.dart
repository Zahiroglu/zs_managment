import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';

import '../../../../widgets/custom_responsize_textview.dart';
import '../../../../widgets/simple_info_dialog.dart';
import '../../../login/models/logged_usermodel.dart';
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

  @override
  void initState() {
    userService.init();
    if (controllerRoutDetailUser.initialized) {
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
                Expanded(flex: 8, child: _pageViewZiyaretTarixcesi()),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
        List<ModelMainInOut> listGirisCixis = [];
        MercDataModel modela = await getAllCustomersMerc(widget.listGirisCixis.first.userCode);
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
                    CustomText(
                        labeltext: model.lastExitDate.substring(
                            11, model.lastExitDate.toString().length)),
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
        if (response.statusCode == 404) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {
          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            List listuser = jsonDecode(dataModel);
            for (var i in listuser) {
              listUsers = MercDataModel.fromJson(i);
            }
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {},
            ));
          }
        }
      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response!.data);
          print(e.response!.headers);
          print(e.response!.requestOptions);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.requestOptions);
          print(e.message);
        }
        Get.dialog(ShowInfoDialog(
          icon: Icons.error_outline,
          messaje: e.message ?? "Xeta bas verdi.Adminle elaqe saxlayin",
          callback: () {},
        ));
      }
    }
    return listUsers;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

}
