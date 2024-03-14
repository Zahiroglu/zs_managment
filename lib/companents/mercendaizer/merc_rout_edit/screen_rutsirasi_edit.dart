import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_mercbaza.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_update_mercrut_order.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

class ScreenMercRutSirasiEdit extends StatefulWidget {
  List<MercCustomersDatail> listRutGunleri;
  String rutGunu;
  int rutGunuInt;
  String mercKod;

  ScreenMercRutSirasiEdit(
      {required this.listRutGunleri,
      required this.rutGunu,
      required this.rutGunuInt,
      required this.mercKod,
      super.key});

  @override
  State<ScreenMercRutSirasiEdit> createState() =>
      _ScreenMercRutSirasiEditState();
}

class _ScreenMercRutSirasiEditState extends State<ScreenMercRutSirasiEdit> {
  List<MercCustomersDatail> listRutGunleri = [];
  bool deyisiklikEdildi = false;
  bool dataLoading = true;
  bool buttonClicble = true;
  LocalUserServices userService = LocalUserServices();
  late CheckDviceType checkDviceType = CheckDviceType();

  @override
  void initState() {
    listRutGunleri = sortListByDayOrderNumber(widget.listRutGunleri);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: CustomText(labeltext: "${widget.rutGunu} ${"msirasi".tr}"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dataLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.teal,
                  ))
                : _body(listRutGunleri),
            deyisiklikEdildi
                ? Align(
                    alignment: Alignment.bottomCenter,
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
                        print("Button basoldi :true");
                        await _sendDataToBase();
                      },
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    ));
  }

  _body(List<MercCustomersDatail> listRutGunleri) {
    return SizedBox(
      height: deyisiklikEdildi
          ? MediaQuery.of(context).size.height * 0.8
          : MediaQuery.of(context).size.height * 0.85,
      child: ReorderableListView(
        shrinkWrap: false,
        padding: const EdgeInsets.all(0),
        children: listRutGunleri
            .map((e) => ListTile(
                  enabled: true,
                  contentPadding: const EdgeInsets.all(0)
                      .copyWith(left: 10, bottom: 5, right: 10),
                  splashColor: Colors.orange,
                  title: _listItem(e),
                  key: ValueKey(e.code),
                ))
            .toList(),
        onReorderEnd: (oldIndex) {},
        onReorder: (oldIndex, newIndex) {
          _changeListOrder(oldIndex, newIndex);
        },
      ),
    );
  }

  void _changeListOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      MercCustomersDatail model = listRutGunleri.elementAt(oldIndex);
      listRutGunleri.remove(model);
      listRutGunleri.insert(newIndex, model);
      changeListDayOrderByListIndex(listRutGunleri);
    });
    //listRutGunleri=sortListByDayOrderNumber(listRutGunleri);
  }

  _listItem(MercCustomersDatail e) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black,
                offset: Offset(0, 0),
                spreadRadius: 0.2,
                blurRadius: 5,
                blurStyle: BlurStyle.outer)
          ],
          color: Colors.white.withOpacity(0.5),
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0).copyWith(top: 5, left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: Center(
                          child: CustomText(
                              labeltext: (e.days
                                  .where((element) =>
                                      element.day == widget.rutGunuInt)
                                  .first
                                  .orderNumber
                                  .toString())),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CustomText(
                              labeltext: e.name.toString(),
                              maxline: 2,
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.drag_handle_outlined))
          ],
        ),
      ]),
    );
  }

  List<MercCustomersDatail> sortListByDayOrderNumber(
      List<MercCustomersDatail> listRutGunleri) {
    List<MercCustomersDatail> newList = [];
    final Map<String, MercCustomersDatail> profileMap = {};
    for (var item in listRutGunleri) {
      profileMap[item.days
          .where((element) => element.day == widget.rutGunuInt)
          .first
          .orderNumber
          .toString()] = item;
    }
    var mapEntries = profileMap.entries.toList()
      ..sort(((a, b) => a.key.compareTo(b.key)));
    profileMap
      ..clear()
      ..addEntries(mapEntries);
    for (var element in profileMap.values) {
      setState(() {
        newList.add(element);
      });
    }
    setState(() {
      dataLoading = false;
    });
    return newList;
  }

  void changeListDayOrderByListIndex(List<MercCustomersDatail> listRutGunleri) {
    for (var element in listRutGunleri) {
      element.days.firstWhere((e) => e.day == widget.rutGunuInt).orderNumber =
          listRutGunleri.indexOf(element) + 1;
    }
    setState(() {
      deyisiklikEdildi = true;
    });
  }

  Future<void> _sendDataToBase() async {
    setState(() {
      buttonClicble = false;
    });
    await _callApiServiz();
    setState(() {
      buttonClicble = true;
    });
  }

  Future<void> _callApiServiz() async {
    List<OrderCustomer> orderCusoms = [];
    for (var element in listRutGunleri) {
      orderCusoms.add(OrderCustomer(
          customerCode: element.code,
          orderNumber: element.days
              .firstWhere((e) => e.day == widget.rutGunuInt)
              .orderNumber));
    }
    await userService.init();
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    ModelUpdateMercRutOrder modelDataSent = ModelUpdateMercRutOrder(
        day: widget.rutGunuInt,
        orderCustomers: orderCusoms,
        merchCode: widget.mercKod);
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
            "${loggedUserModel.baseUrl}/api/v1/Sales/edit-merch-customer-day-order",
            data: modelDataSent.toJson(),
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
            Get.back();
          },
        ));
      }
    }
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }
}
