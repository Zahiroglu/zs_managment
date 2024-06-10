import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/controller_mercpref.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/model_merc_customers_edit.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/merc_rout_edit/dialog_select_expeditor.dart';
import 'package:zs_managment/companents/users_panel/new_user_create/new_user_controller.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/dialog_select_simpleuser_select.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenMercCariEdit extends StatefulWidget {
  ControllerMercPref controllerMercPref;

  // MercCustomersDatail modelMerc;
  // List<UserModel> listUsers;
  // String mercKod;
  // String mercAd;

  ScreenMercCariEdit(
      {required this.controllerMercPref,super.key});

  @override
  State<ScreenMercCariEdit> createState() => _ScreenMercCariEditState();
}

class _ScreenMercCariEditState extends State<ScreenMercCariEdit> {
  List<User> listUsers = [];
  String selectedMercKod = "";
  String selectedMercAd = "";
  late MercCustomersDatail modelMerc;
  bool rutGunuBir = false;
  bool rutGunuIki = false;
  bool rutGunuUc = false;
  bool rutGunuDort = false;
  bool rutGunuBes = false;
  bool rutGunuAlti = false;
  TextEditingController ctNewPlan = TextEditingController();
  bool buttonClicble = true;
  LocalUserServices userService = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();
  List<SellingData> selectedSellingDatas=[];
  List<Day> selectedDays=[];
  ExeptionHandler exeptionHandler=ExeptionHandler();

  @override
  void initState() {
    for (var element in widget.controllerMercPref.listUsers.value) {
      listUsers.add(User(
        code: element.code,
        roleId: element.roleId,
        roleName: element.roleName,
        fullName: element.name,
        isSelected: element.code == widget.controllerMercPref.selectedMercBaza.value.user!.code,
      ));
    }
    modelMerc =widget.controllerMercPref.selectedCustomers.value;
    rutGunuBir = modelMerc.days!.any((element) => element.day == 1);
    rutGunuIki = modelMerc.days!.any((element) => element.day == 2);
    rutGunuUc = modelMerc.days!.any((element) => element.day == 3);
    rutGunuDort = modelMerc.days!.any((element) => element.day == 4);
    rutGunuBes = modelMerc.days!.any((element) => element.day == 5);
    rutGunuAlti = modelMerc.days!.any((element) => element.day == 6);
    selectedMercKod =widget.controllerMercPref.selectedMercBaza.value.user!.code;
    selectedMercAd =widget.controllerMercPref.selectedMercBaza.value.user!.name;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    ctNewPlan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: widget.controllerMercPref.selectedMercBaza.value.user!.name),
      ),
      body: _body(context),
    )));
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _infoMerc(context),
          _infoPlan(context),
          widget.controllerMercPref.loggedUserModel.userModel!.permissions!.any((element) => element.id==29)?widgetRutGunleri(context):SizedBox(),
  Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CustomElevetedButton(
                clicble: buttonClicble,
                width: MediaQuery.of(context).size.width / 2,
                height: 40,
                elevation: 10,
                borderColor: Colors.green,
                surfaceColor: Colors.white,
                textColor: Colors.green,
                fontWeight: FontWeight.bold,
                label: "change".tr,
                cllback: () async {
                  await _sendDataToBase();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoMerc(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(DialogSimpleUserSelect(
          selectedUserCode: widget.controllerMercPref.selectedMercBaza.value.user!.code,
          getSelectedUse: (selectedUser) {
            setState(() {
              selectedMercKod = selectedUser.code!;
              selectedMercAd = selectedUser.name!;
            });
          },
          listUsers:  widget.controllerMercPref.listUsers,
          vezifeAdi: "mercler".tr,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0).copyWith(left: 10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                  child: CustomText(
                    labeltext: "mercBaglanti".tr,
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                  margin: const EdgeInsets.all(10).copyWith(top: 5),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(2, 2),
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 2)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(labeltext: "${"rutKod".tr} : "),
                          CustomText(
                            labeltext: selectedMercKod,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"merc".tr} : "),
                          CustomText(
                            labeltext: selectedMercAd,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: 5,
                right: -0,
                child: IconButton(
                  iconSize: 32,
                  onPressed: () {
                    Get.dialog(DialogSimpleUserSelect(
                        selectedUserCode: selectedMercKod,
                        getSelectedUse: (selectedUser) {
                          setState(() {
                            selectedMercKod = selectedUser.code!;
                            selectedMercAd = selectedUser.name!;
                          });
                        },
                        listUsers:  widget.controllerMercPref.listUsers,
                        vezifeAdi: "mercler".tr));
                  },
                  icon: const Icon(
                    Icons.change_circle,
                    color: Colors.green,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _infoPlan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0)
          .copyWith(left: 10, top: 10, bottom: 5, right: 10),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0).copyWith(left: 10),
                child: CustomText(
                  labeltext: "plan".tr,
                  fontsize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey)),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.grey.withOpacity(0.3)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0)
                            .copyWith(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(labeltext: "plan".tr + " : "),
                                CustomText(
                                    labeltext: modelMerc.totalPlan.toString())
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(labeltext: "satis".tr + " : "),
                                CustomText(
                                    labeltext:
                                        modelMerc.totalSelling.toString())
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(labeltext: "zaymal".tr + " : "),
                                CustomText(
                                    labeltext: modelMerc.totalRefund.toString())
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: modelMerc.sellingDatas!.length * 110,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: modelMerc.sellingDatas!.length,
                          itemBuilder: (c, index) {
                            return widgetSatisDetal(
                                modelMerc.sellingDatas!.elementAt(index));
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  widgetSatisDetal(SellingData element) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    CustomText(
                        labeltext: "${"expeditor".tr} : ",
                        fontWeight: FontWeight.w700),
                    CustomText(labeltext: element.forwarderCode),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"plan".tr} : ",
                                      fontsize: 14,
                                      fontWeight: FontWeight.w700),
                                  CustomText(
                                      labeltext:
                                          "${element.plans} ${"manatSimbol".tr}",
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"satis".tr} : ",
                                      fontsize: 14,
                                      fontWeight: FontWeight.w700),
                                  CustomText(
                                      labeltext:
                                          "${element.selling} ${"manatSimbol".tr}",
                                      fontsize: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"zaymal".tr} : ",
                                      fontsize: 14,
                                      fontWeight: FontWeight.w700),
                                  CustomText(
                                      labeltext:
                                          "${element.refund} ${"manatSimbol".tr}",
                                      fontsize: 14),
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
            ),
            widget.controllerMercPref.loggedUserModel.userModel!.permissions!.any((element) => element.id==31)? Positioned(
                top: 0,
                right: 0,
                height: 50,
                child: CustomElevetedButton(
                  label: "planDeyis".tr,
                  cllback: () {

                    _editPlanDialogAc(element);
                  },
                  elevation: 5,
                  icon: Icons.edit,
                )):SizedBox()
          ],
        ),
      ),
    );
  }

  Widget widgetRutGunleri(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(left: 0, bottom: 5),
            child: CustomText(
                labeltext: "rutmelumat",
                fontsize: 16,
                fontWeight: FontWeight.w700),
          ),
          DecoratedBox(
            decoration:
                BoxDecoration(color: Colors.grey.shade200, boxShadow: const [
              BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 2)
            ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(0.0).copyWith(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                CustomText(labeltext: "gun1".tr),
                                Checkbox(
                                    value: rutGunuBir ? true : false,
                                    onChanged: (value) {
                                      setState(() {
                                        rutGunuBir = value!;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(labeltext: "gun2".tr),
                                Checkbox(
                                    value: rutGunuIki,
                                    onChanged: (v) {
                                      setState(() {
                                        rutGunuIki = v!;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(labeltext: "gun3".tr),
                                Checkbox(
                                    value: rutGunuUc,
                                    onChanged: (v) {
                                      setState(() {
                                        rutGunuUc = v!;
                                      });
                                    }),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                CustomText(labeltext: "gun4".tr),
                                Checkbox(
                                    value: rutGunuDort,
                                    onChanged: (v) {
                                      setState(() {
                                        rutGunuDort = v!;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(labeltext: "gun5".tr),
                                Checkbox(
                                    value: rutGunuBes,
                                    onChanged: (v) {
                                      setState(() {
                                        rutGunuBes = v!;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(labeltext: "gun6".tr),
                                Checkbox(
                                    value: rutGunuAlti,
                                    onChanged: (v) {
                                      setState(() {
                                        rutGunuAlti = v!;
                                      });
                                    }),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _editPlanDialogAc(SellingData element) {
    Get.dialog(dialogEditPlan(element),barrierDismissible: true);
  }

  Widget dialogEditPlan(SellingData element) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.35),
        // margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    labeltext: "planDeyisme",
                    textAlign: TextAlign.center,
                    fontsize: 18,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: CustomTextField(
                        controller: ctNewPlan,
                        fontsize: 14,
                        hindtext: "yeniPlan".tr,
                        inputType: TextInputType.number,
                        align: TextAlign.center,
                        isImportant: true,
                        obscureText: false),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: CustomElevetedButton(
                          height: 35,
                          width: 120,
                          elevation: 10,
                          fontWeight: FontWeight.w800,
                          borderColor: Colors.black,
                          surfaceColor: Colors.teal,
                          textColor: Colors.white,
                          cllback: () {
                            if(ctNewPlan.text.isNotEmpty){
                            _btnPlandeyis(element);
                            }else{
                              Fluttertoast.showToast(msg: "yeniPlanError".tr,gravity: ToastGravity.TOP,backgroundColor: Colors.red);
                            }
                          },
                          label:"tesdiqle".tr),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                    onTap: (){
                      ctNewPlan.clear();
                      Get.back();
                    },
                    child: Icon(Icons.clear,color: Colors.red,)))
          ],
        ),
      ),
    );
  }

  void _btnPlandeyis(SellingData element) {
    SellingData newPlan=element;
    newPlan.plans=double.parse(ctNewPlan.text);
    modelMerc.sellingDatas!.remove(element);
    modelMerc.sellingDatas!.insert(0,newPlan);
    modelMerc.totalPlan=modelMerc.sellingDatas!.fold(0.0, (sum, e) => sum!+e.plans);
    ctNewPlan.clear();
    setState(() {});
    Get.back();
  }

  Future<void> _sendDataToBase() async {
    if(modelMerc.sellingDatas!.length>1&&widget.controllerMercPref.selectedMercBaza.value.user!.code!=selectedMercKod){
      Get.dialog(DialogSelectExpeditor(sellingDatas:modelMerc.sellingDatas!,getDataBack: (listSelectedExp){
        selectedSellingDatas=listSelectedExp;
        Get.back();
        _callApiServiz();
      },));

    }else {
      selectedSellingDatas.add(modelMerc.sellingDatas!.first);
      setState(() {
        buttonClicble = false;
      });
      await _callApiServiz();
      setState(() {
        buttonClicble = true;
      });
    }}

  Future<void> _callApiServiz() async {
    if(rutGunuBir){
      selectedDays.add(Day(day: 1, orderNumber: 0));
    }if(rutGunuIki){
      selectedDays.add(Day(day: 2, orderNumber: 0));
    }if(rutGunuUc){
      selectedDays.add(Day(day: 3, orderNumber: 0));
    }if(rutGunuDort){
      selectedDays.add(Day(day: 4, orderNumber: 0));
    }if(rutGunuBes){
      selectedDays.add(Day(day: 5, orderNumber: 0));
    }if(rutGunuAlti){
      selectedDays.add(Day(day: 6, orderNumber: 0));
    }
    List<String> lisexpeditorlar=[];
    List<Plan> listPlanlar=[];
    for (var element in selectedSellingDatas) {
      lisexpeditorlar.add(element.forwarderCode);
      listPlanlar.add(Plan(forwarderCode: element.forwarderCode, plan: element.plans));
    }
    ChangeMerch changeMerch=ChangeMerch(
      newMerchCode: selectedMercKod,
      forwarderCodes: lisexpeditorlar
    );
    ModelUpdateMercCustomers modelUpdateMercCustomers=ModelUpdateMercCustomers(
      merchCode:  widget.controllerMercPref.selectedMercBaza.value.user!.code,
      days: selectedDays,
      changeMerch: changeMerch,
      customerCode: modelMerc.code!,
      plans:listPlanlar
    );
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    DialogHelper.showLoading("mDeyisdirilir".tr, false);
    String languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      DialogHelper.hideLoading();
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {
          Get.back();
        },
      ));
    } else {
      final response = await ApiClient().dio().put(
        "${loggedUserModel.baseUrl}/api/v1/Sales/edit-merch-customer",
        data: modelUpdateMercCustomers.toJson(),
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
        Get.dialog(ShowInfoDialog(
          color: Colors.teal,
          icon: Icons.verified,
          messaje: response.data["result"],
          callback: () {
            widget.controllerMercPref.updateData(modelUpdateMercCustomers,listPlanlar.length==widget.controllerMercPref.selectedCustomers.value.sellingDatas!.length,selectedSellingDatas);
            if(listPlanlar.length==widget.controllerMercPref.selectedCustomers.value.sellingDatas!.length){
              Get.back();
              Get.back();
              Get.back(result: "OK");
            }else{
              Get.back();
              Get.back(result: "OK");
            }
          },
        ));
      }else{
        exeptionHandler.handleExeption(response);

      }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }


}
