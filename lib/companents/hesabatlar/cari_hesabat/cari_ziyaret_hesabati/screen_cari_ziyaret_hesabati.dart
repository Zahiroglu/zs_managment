import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/cari_ziyaret_hesabati/screen_ziyaretler_detay.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/cari_ziyaret_hesabati/widget_giriscixis_item.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

import '../../../../dio_config/api_client.dart';
import '../../../../utils/checking_dvice_type.dart';
import '../../../../widgets/simple_info_dialog.dart';
import '../../../connected_users/model_main_inout.dart';
import '../../../local_bazalar/local_users_services.dart';
import '../../../login/models/base_responce.dart';
import '../../../login/models/logged_usermodel.dart';
import '../../../giris_cixis/models/model_customers_visit.dart';

class ScreenCariZiyaretHesabat extends StatefulWidget {
  String tarixIlk;
  String tarixSon;
  String cariKod;
  String cariAd;

  ScreenCariZiyaretHesabat(
      {required this.tarixIlk,
      required this.tarixSon,
      required this.cariKod,
      required this.cariAd,
      super.key});

  @override
  State<ScreenCariZiyaretHesabat> createState() =>
      _ScreenCariZiyaretHesabatState();
}

class _ScreenCariZiyaretHesabatState extends State<ScreenCariZiyaretHesabat> {
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalUserServices userService = LocalUserServices();
  bool dataLoading = true;
  List<ModelCustuomerVisit> listGirisCixis = [];
  List<User> listUsers = [];
  bool isUserMode = true;
  bool isListReseved=false;

  @override
  void initState() {
    userService.init();
    getAllGirisCixisByCustomers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          isUserMode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isUserMode = false;
                    });
                  },
                  icon: Icon(Icons.view_list))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isUserMode = true;
                    });
                  },
                  icon: Icon(Icons.supervised_user_circle_outlined)),
          isUserMode==false?IconButton(onPressed: (){
            setState(() {
              isListReseved!=isListReseved;
              listGirisCixis=listGirisCixis.reversed.toList();
            });
          }, icon: Icon(Icons.sort)):SizedBox()
        ],
        title: CustomText(
          labeltext: widget.cariAd,
        ),
      ),
      body: dataLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : listGirisCixis.isEmpty
              ? _melumatTapilmadi()
              : _body(),
    );
  }

  Future<List<ModelCustuomerVisit>> getAllGirisCixisByCustomers() async {
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    var data = {
      "code": widget.cariKod.toString(),
      "startDate": widget.tarixIlk.toString(),
      "endDate": widget.tarixSon.toString()
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
        final response = await ApiClient().dio().post(
              "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-by-customers",
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
              ModelCustuomerVisit model = ModelCustuomerVisit.fromJson(i);
              listGirisCixis.add(model);
              User users = User(
                  code: model.userCode,
                  fullName: model.userFullName,
                  roleName: model.userPosition.toString());
              if (!listUsers.any((e) => e.fullName == users.fullName)) {
                listUsers.add(users);
              }
            }
            setState(() {
              dataLoading = false;
            });
          } else {
            setState(() {
              dataLoading = false;
            });
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {},
            ));
          }
        }
      } on DioException catch (e) {
        setState(() {
          dataLoading = false;
        });
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
          messaje: e.message ?? "baglantierror".tr,
          callback: () {},
        ));
      }
    }
    return listGirisCixis;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Widget _melumatTapilmadi() {
    return NoDataFound(
      title: "melumattapilmadi".tr,
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: isUserMode
              ? ListView.builder(
                  itemCount: listUsers.length,
                  itemBuilder: (c, index) {
                    return itemsUserInfo(listUsers.elementAt(index));
                  })
              : ListView.builder(
                  itemCount: listGirisCixis.length,
                  itemBuilder: (c, index) {
                    return WidgetGirisCixisItem(
                        element: listGirisCixis.elementAt(index));
                  }),
        )
      ],
    );
  }

  Widget itemsUserInfo(User element) {
    print("Element last visit:"+isListReseved.toString()+" olanda =");
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.cariZiyaretDetay, arguments: [
          element,
          listGirisCixis
              .where((e) => e.userFullName == element.fullName)
              .toList()
        ]);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            shadowColor: Colors.grey,
            elevation: 5,
            color: Colors.white,
            margin: EdgeInsets.all(5),
            child: Padding(
                padding: EdgeInsets.all(5).copyWith(top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          labeltext: element.code!,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          labeltext: element.fullName!,
                          fontWeight: FontWeight.bold,
                          fontsize: 16,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomText(
                                labeltext: "ziyaretSayi".tr + " : ",
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                labeltext: listGirisCixis
                                    .where((e) =>
                                        e.userFullName == element.fullName)
                                    .toList()
                                    .length
                                    .toString(),
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                labeltext: "sonuncuZiyaret".tr + " : ",
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                labeltext:isListReseved?listGirisCixis.where((e) => e.userFullName == element.fullName).toList().first.inDate.toString().substring(0, 16):listGirisCixis.where((e) => e.userFullName == element.fullName).toList().last.inDate.toString().substring(0, 16),
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                labeltext: "marketdeISvaxti".tr + " : ",
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                labeltext: circulateSnlerdeQalmaVaxti(
                                    listGirisCixis
                                        .where((e) =>
                                            e.userFullName == element.fullName)
                                        .toList()),
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CustomText(
                    labeltext: element.roleName!,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  String circulateSnlerdeQalmaVaxti(List<ModelCustuomerVisit> allGirisCixis) {
    String vaxt = "";
    Duration umumiVaxtDeqiqe = const Duration();
    for (var element in allGirisCixis) {
      umumiVaxtDeqiqe = umumiVaxtDeqiqe +
          getTimeDifferenceFromNow(DateTime.parse(element.inDate.toString()),
              DateTime.parse(element.outDate.toString()));
    }
    int hours = umumiVaxtDeqiqe.inHours % 24;
    int minutes = umumiVaxtDeqiqe.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  Duration getTimeDifferenceFromNow(DateTime girisvaxt, DateTime cixisVaxt) {
    Duration difference = cixisVaxt.difference(girisvaxt);
    return difference;
  }
}
