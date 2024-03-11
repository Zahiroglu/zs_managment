import 'dart:convert';
import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_giriscixis.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/model_token.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/mercendaizer/data_models/model_mercbaza.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';

import '../local_bazalar/local_giriscixis.dart';
import '../local_bazalar/local_users_services.dart';
import '../local_bazalar/local_db_downloads.dart';
import 'models/model_cariler.dart';
import 'models/model_downloads.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ControllerBaseDownloads extends GetxController {
  Dio dio = Dio();
  late CheckDviceType checkDviceType = CheckDviceType();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalUserServices localUserServices = LocalUserServices();
  RxList<ModelDownloads> listDonwloads = List<ModelDownloads>.empty(growable: true).obs;
  RxList<ModelDownloads> listDownloadsFromLocalDb = List<ModelDownloads>.empty(growable: true).obs;
  RxList<ModelDownloads> listDonwloadsAll = List<ModelDownloads>.empty(growable: true).obs;
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  String soapadress = "http://193.105.123.215:9689/WebService1.asmx";
  String soaphost = "193.105.123.215";
  RxBool dataLoading = true.obs;
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  LocalBaseSatis localBaseSatis = LocalBaseSatis();
  RxBool davamEtButonuGorunsun = false.obs;
  String languageIndex = "az";

  @override
  onInit() {
    callLocalBases();
    _donloadListiniDoldur();
    super.onInit();
  }

  _donloadListiniDoldur() async {
    await localUserServices.init();
    List<ModelUserPermissions> listUsersPermitions = localUserServices.getLoggedUser().userModel!.permissions!;
    for (var element in listUsersPermitions) {
      if (element.code == "myUserRut") {
        listDonwloads.add(ModelDownloads(
            name: "Baglantilarim",
            code: "myUserRut",
            info: "Temsilci melumatlari ve hesabtalari v.s",
            lastDownDay: "",
            donloading: false,
            musteDonwload: true));
      } else if (element.code == "warehouse") {
        listDonwloads.add(ModelDownloads(
            name: "Anbar Baza",
            code: "warehouse",
            info:
                "Anbarda movcud stok melumatlari ve son qiymetler ucundur.Eyni zamanda Checklist etmek ucunde nezerde tutulub",
            lastDownDay: "",
            donloading: false,
            musteDonwload: true));
      }
      if(localUserServices.getLoggedUser().userModel!.roleId==23){
        if (element.code == "myRut") {
          listDonwloads.add(ModelDownloads(
              name: "Menim rutum",
              donloading: false,
              code: "myRut",
              info: "Rut melumatlari ve motivasiya melumatlari ucun lazimdir",
              lastDownDay: "",
              musteDonwload: true));
        }
      }else{
        if (element.code == "enter") {
          listDonwloads.add(ModelDownloads(
              name: "Cari Baza",
              donloading: false,
              code: "enter",
              info: "Satis Temsilcilerinin erazi uzre cari musteri bazasini gormesi ucun lazimdir.",
              lastDownDay: "",
              musteDonwload: true));
        }
      }
    }
  }

  Future<void> clearAllDataSatis() async {
    DialogHelper.showLoading("Melumatlar silinir...");
    await Get.delete<DrawerMenuController>();
    await localBaseSatis.clearAllData();
    DrawerMenuController controller = Get.put(DrawerMenuController());
    controller.onInit();
    controller.addPermisionsInDrawerMenu(loggedUserModel);
    DialogHelper.hideLoading();
    update();
  }

  callLocalBases() async {
    dataLoading = true.obs;
    await localBaseSatis.init();
    loggedUserModel = localUserServices.getLoggedUser();
    listDownloadsFromLocalDb.value = localBaseDownloads.getAllDownLoadBaseList();
    getMustDownloadBase(loggedUserModel.userModel!.roleId!, listDownloadsFromLocalDb);
    if (localBaseDownloads
        .checkIfUserMustDonwloadsBase(loggedUserModel.userModel!.roleId!)) {
      davamEtButonuGorunsun.value = true;
    }
    update();
  }

  getWidgetDownloads(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listDonwloads.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomText(
                        labeltext: "baseMustDownload".tr,
                        fontsize: 18,
                        color: Colors.black,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10, width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: Colors.white),
                      child: SizedBox(
                        height: listDonwloads.length * 80,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(2),
                          scrollDirection: Axis.vertical,
                          children: listDonwloads
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: itemsEndirilmeliBazalar(e, context),
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
          SizedBox(
            height: listDonwloads.isNotEmpty ? 30 : 0,
          ),
          listDownloadsFromLocalDb.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomText(
                        color: Colors.black,
                        labeltext: "baseDownloaded".tr,
                        fontsize: 18,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: Colors.green, width: 1)),
                      child: SizedBox(
                        height: listDownloadsFromLocalDb.length * 100,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.vertical,
                          children: listDownloadsFromLocalDb
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        itemsGuncellenmeliBazalar(e, context),
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(),
        ]);
  }

  Widget itemsEndirilmeliBazalar(ModelDownloads model, BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      labeltext: model.name!,
                      fontsize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  InkWell(
                      onTap: () {
                        melumatlariEndir(model, false);
                      },
                      child: const Icon(Icons.upload_rounded))
                ]),
            CustomText(
              labeltext: model.info!,
              maxline: 2,
              fontsize: 10,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  Widget itemsGuncellenmeliBazalar(ModelDownloads model, BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          labeltext: model.name!,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontsize: 14),
                      CustomText(
                          fontsize: 10,
                          labeltext:
                              "${"lastRefresh".tr}: ${model.lastDownDay!.substring(0, 10)}"),
                      model.musteDonwload == false
                          ? CustomText(
                              labeltext: model.info!,
                              maxline: 3,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey,
                              fontsize: 12,
                            )
                          : CustomText(
                              labeltext: "infoRefresh".tr,
                              maxline: 3,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.red,
                              fontsize: 12,
                            )
                    ],
                  ),
                ),
                model.donloading!
                    ? FlutterLogo()
                    : InkWell(
                        onTap: () {
                          melumatlariEndir(model, true);
                        },
                        child: const Icon(Icons.refresh))
              ],
            ),
            model.musteDonwload == false
                ? const SizedBox()
                : const Positioned(
                    bottom: 5,
                    right: 5,
                    child: Icon(
                      Icons.info,
                      color: Colors.red,
                    ))
          ],
        ),
      ),
    );
  }

  getMustDownloadBase(int roleId, List<ModelDownloads> listDownloadsFromLocalDb) {
    for (var e in listDownloadsFromLocalDb) {
      if (listDonwloads.any((element) => element.code == e.code)) {
        listDonwloads.remove(listDonwloads.where((a) => a.code == e.code).first);
      }
    }
    dataLoading = false.obs;
  }

  Future<void> melumatlariEndir(ModelDownloads model, bool guncelle) async {
    await localGirisCixisServiz.init();
    DialogHelper.showLoading("${model.name!} endirilir...");
    switch (model.code) {
      case "myUserRut":
        loggedUserModel = localUserServices.getLoggedUser();
        List<UserModel> listUser = await getAllConnectedUsers();
        await localBaseDownloads.addConnectedUsers(listUser);
        if (listUser.isNotEmpty) {
          listDonwloads.remove(model);
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          localBaseDownloads.addDownloadedBaseInfo(model);
          if (guncelle) {
            listDownloadsFromLocalDb.remove(model);
            listDownloadsFromLocalDb.add(model);
          } else {
            listDownloadsFromLocalDb.add(model);
          }
        }
        break;
      case "warehouse":
        loggedUserModel = localUserServices.getLoggedUser();
        List<ModelAnbarRapor> data = await getDataAnbar(soapadress, soaphost);
        await localBaseDownloads.addAnbarBaza(data);
        if (data.isNotEmpty) {
          listDonwloads.remove(model);
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          localBaseDownloads.addDownloadedBaseInfo(model);
          localGirisCixisServiz.clearAllGiris();
          if (guncelle) {
            listDownloadsFromLocalDb.remove(model);
            listDownloadsFromLocalDb.add(model);
          } else {
            listDownloadsFromLocalDb.add(model);
          }
        }
        break;
      case "enter":
        loggedUserModel = localUserServices.getLoggedUser();
        List<ModelCariler> data = await getAllCustomers();
        if (data.isNotEmpty) {
          listDonwloads.remove(model);
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          await localBaseDownloads.addCariBaza(data);
          localBaseDownloads.addDownloadedBaseInfo(model);
          localGirisCixisServiz.clearAllGiris();
          if (guncelle) {
            listDownloadsFromLocalDb.remove(model);
            listDownloadsFromLocalDb.add(model);
          } else {
            listDownloadsFromLocalDb.add(model);
          }
        }
        case "myRut":
          loggedUserModel = localUserServices.getLoggedUser();
          if(loggedUserModel.userModel!.roleId==23)//merc cari baza endirmek ucundur
          {
            MercDataModel data = await getAllMercCariBaza(loggedUserModel.userModel!.code!);
            if (data.user!=null) {
              listDonwloads.remove(model);
              model.lastDownDay = DateTime.now().toIso8601String();
              model.musteDonwload = false;
              localBaseDownloads.addDownloadedBaseInfo(model);
              localBaseDownloads.addCariToMercBaza(data);
              if (guncelle) {
                listDownloadsFromLocalDb.remove(model);
                listDownloadsFromLocalDb.add(model);
              } else {
                listDownloadsFromLocalDb.add(model);
              }
            }

          }

        break;
    }
    callLocalBases();
    DialogHelper.hideLoading();
    update();
  }

  Future<void> clearAllData() async {
    print("clear button basildi :true");
    listDonwloads.value = [
      ModelDownloads(
          name: "Cari Baza",
          code: "expcari",
          info:
              "Satis Temsilcilerinin erazi uzre cari musteri bazasini gormesi ucun lazimdir.",
          lastDownDay: "",
          musteDonwload: true),
      ModelDownloads(
          name: "Anbar Baza",
          code: "anbar",
          info:
              "Anbarda movcud stok melumatlari ve son qiymetler ucundur.Eyni zamanda Checklist etmek ucunde nezerde tutulub",
          lastDownDay: "",
          musteDonwload: true),
      ModelDownloads(
          name: "Umumi Merc Baza",
          code: "umumimerc",
          info:
              "Eraziniz daxilindeki Merclerin is fealiyyetini ve motivasiyasini gormek ucundur",
          lastDownDay: "",
          musteDonwload: true),
    ];
    listDownloadsFromLocalDb.clear();
    await localBaseDownloads.clearAllData();
    callLocalBases();
    update();
  }

  ///connected users service
  Future<List<UserModel>> getAllConnectedUsers() async {
    List<UserModel> listUsers = [];
    languageIndex = await getLanguageIndex();
    int dviceType = checkDviceType.getDviceType();
    loggedUserModel = localUserServices.getLoggedUser();
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
        final response = await ApiClient().dio().get(
              "${loggedUserModel.baseUrl}/api/v1/User/my-connected-users",
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
          // print("Request responce My USER INFO:" + response.data.toString());
          if (response.statusCode == 200) {
            var userlist = json.encode(response.data['result']);
            List listuser = jsonDecode(userlist);
            print("list :" + listuser.length.toString());
            for (var i in listuser) {
              listUsers.add(UserModel(
                roleName: i['roleName'],
                roleId: i['roleId'],
                code: i['code'],
                name: i['fullName'],
                gender: 0,
              ));
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

  ///Get Exp cari Baza From Serviz
  Future<List<ModelCariler>> getAllCustomers() async {
    List<ModelCariler> listUsers=[];
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel=localUserServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler=[];
    await localBaseDownloads.init();
    List<UserModel> listUsersSelected = localBaseDownloads
        .getAllConnectedUserFromLocal()
        .where((element) => element.roleId == 17)
        .toList();
    if (listUsersSelected.isEmpty) {
      secilmisTemsilciler.add(loggedUserModel.userModel!.code!);
    } else {
      for (var element in listUsersSelected) {
        secilmisTemsilciler.add(element.code!);
      }
    }

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      try {
        final response = await ApiClient().dio().post("${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-forwarders",
          data:jsonEncode(secilmisTemsilciler),
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
        print("responce kode :"+response.data.toString());
        if (response.statusCode == 404) {
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {
          if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['result']);
            print("dataModel :"+dataModel.toString());
            List listuser = jsonDecode(dataModel);
            for(var i in listuser){
              var dataCus = json.encode(i['customers']);
              var temsilciKodu=i['user']['code'];
              print("temsilciKodu :"+temsilciKodu.toString());

              List listDataCustomers = jsonDecode(dataCus);
              for(var a in listDataCustomers){
                ModelCariler model=ModelCariler.fromJson(a);
                model.forwarderCode=temsilciKodu;
                print("a custim :"+a.toString());
                listUsers.add(model);

              }
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

  ///Cari Merc Baza endirme/////////
  Future<MercDataModel> getAllMercCariBaza(String temKod) async {
    MercDataModel listUsers=MercDataModel();
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler=[];
    secilmisTemsilciler.add(temKod);
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel=localUserServices.getLoggedUser();
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
        final response = await ApiClient().dio().post("${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-merch",
          data:jsonEncode(secilmisTemsilciler),
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
        print("responce kode :"+response.data.toString());
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
            for(var i in listuser){
              listUsers=MercDataModel.fromJson(i);
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

//   Future<MercDataModel> getDataFromServerMercBaza(String temsilcikodu) async {
//     String temp = "'" + temsilcikodu + "'";
//     String audit = "";
//     String supervaizer = "";
//     String ay = "01";
//     var envelopeaUmumicariler = '''
// <?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
// xmlns:xsd="http://www.w3.org/2001/XMLSchema"
// xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
// <soap:Body>
//     <mercler xmlns="http://tempuri.org/">
//       <ay>$ay</ay>
//       <audit>$audit</audit>
//       <merc>$temp</merc>
//       <srv>$supervaizer</srv>
//     </mercler>
//   </soap:Body>
// </soap:Envelope>
// ''';
//     var url = Uri.parse(soapadress);
//     http.Response response = await http.post(url, headers: {
//       "Content-Type": "text/xml; charset=utf-8",
//       "SOAPAction": "http://tempuri.org/mercler",
//       // "Host": "85.132.97.2"
//       "Host": soaphost
//       //"Accept": "text/xml"
//     }, body: envelopeaUmumicariler);
//     var rawXmlResponse = "";
//     if (response.statusCode == 200) {
//       rawXmlResponse = response.body;
//       print(" response.body :" + response.body.toString());
//     } else {
//       Get.dialog(ShowInfoDialog(
//         messaje: "Xeta BAs Verdi",
//         icon: Icons.error,
//         callback: () {
//           DialogHelper.hideLoading();
//         },
//       ));
//     }
//     update();
//     return _parsingCarilerMerc(rawXmlResponse);
//   }
//   Future<MercDataModel> _parsingCarilerMerc(var _response) async {
//     List<ModelMercBaza> listKodrdinar = [];
//     List<MercCustomersDatail> listMercCustomers = [];
//     MercDataModel modelMercData = MercDataModel(user: null);
//     var document = xml.parse(_response);
//     Iterable<xml.XmlElement> items = document.findAllElements('Table');
//     items.map((xml.XmlElement item) {
//       var _kode = _getValue(item.findElements("merc_cari_kod"));
//       var _name = _getValue(item.findElements("cari_ad"));
//       var _rutadi = _getValue(item.findElements("merc_kod"));
//       var mercAdi = _getValue(item.findElements("merc_ad"));
//       var _audit = _getValue(item.findElements("merc_audit"));
//       var _gun1 = _getValue(item.findElements("merc_gun1"));
//       var _gun2 = _getValue(item.findElements("merc_gun2"));
//       var _gun3 = _getValue(item.findElements("merc_gun3"));
//       var _gun4 = _getValue(item.findElements("merc_gun4"));
//       var _gun5 = _getValue(item.findElements("merc_gun5"));
//       var _gun6 = _getValue(item.findElements("merc_gun6"));
//       var _gun7 = _getValue(item.findElements("merc_gun7"));
//       var _uzunluq = _getValue(item.findElements("merc_gps_uz"));
//       var _eynilik = _getValue(item.findElements("merc_gps_en"));
//       var _netsatis = _getValue(item.findElements("NET_SATIS"));
//       var _plan = _getValue(item.findElements("merc_plan"));
//       var _qaytarma = _getValue(item.findElements("ZAY_QAYTARMA"));
//       var _expkodu = _getValue(item.findElements("merc_tem_kod"));
//       var _spr = _getValue(item.findElements("merc_srv_kod"));
//       ModelMercBaza modelKordinat = ModelMercBaza(
//           supervaizer: _spr,
//           expeditor: _expkodu,
//           carikod: _kode,
//           mercadi: mercAdi,
//           gpsUzunluq: _uzunluq,
//           gpsEynilik: _eynilik,
//           audit: _audit,
//           cariad: _name,
//           gun1: _gun1,
//           gun2: _gun2,
//           gun3: _gun3,
//           gun4: _gun4,
//           gun5: _gun5,
//           gun6: _gun6,
//           gun7: _gun7,
//           netsatis: _netsatis,
//           plan: _plan,
//           qaytarma: _qaytarma,
//           rutadi: _rutadi
//       );
//       listKodrdinar.add(modelKordinat);
//       //  itemsList.add(_addResult);
//     }).toList();
//     listKodrdinar.forEach((element) {
//       List<Day>listDays=[];
//       if(element.gun1=="1"){
//         listDays.add(Day(day: 1, orderNumber: 0));
//       }
//       if(element.gun2=="1"){
//         listDays.add(Day(day: 2, orderNumber: 0));
//       }  if(element.gun3=="1"){
//         listDays.add(Day(day: 3, orderNumber: 0));
//       }  if(element.gun4=="1"){
//         listDays.add(Day(day: 4, orderNumber: 0));
//       }  if(element.gun5=="1"){
//         listDays.add(Day(day: 5, orderNumber: 0));
//       }  if(element.gun6=="1"){
//         listDays.add(Day(day: 6, orderNumber: 0));
//       }
//       listMercCustomers.add(MercCustomersDatail(
//         name: element.cariad!,
//         code: element.carikod!,
//         longitude: element.gpsUzunluq!,
//         latitude: element.gpsEynilik!,
//         district: "",
//         category: "",
//         area: "",
//         action: double.parse(element.netsatis!)>0?true:false,
//         days: listDays,
//         fullAddress: "",
//         plans: double.parse(element.plan!),
//         refund: double.parse(element.qaytarma!),
//         selling: double.parse(element.netsatis!),
//         forwarderCode: element.expeditor
//       ));
//     });
//     modelMercData=MercDataModel(totalPlans: listKodrdinar.fold(0, (sum, element) => sum!+double.parse(element.plan!)),
//         totalSelling: listKodrdinar.fold(0, (sum, element) => sum!+double.parse(element.netsatis!)),
//         totalRefund: listKodrdinar.fold(0, (sum, element) => sum!+double.parse(element.qaytarma!)),
//         code: listKodrdinar.first.rutadi!,
//         name: listKodrdinar.first.mercadi!,
//         mercCustomersDatail: listMercCustomers);
//
//     return modelMercData;
//   }

  _getValue(Iterable<xml.XmlElement> items) {
    var textValue;
    items.map((xml.XmlElement node) {
      textValue = node.text;
    }).toList();
    return textValue;
  }

  String rutDuzgunluyuYoxla(ModelCariler selectedModel) {
    String rutgun = "Sef";
    int hefteningunu = DateTime
        .now()
        .weekday;
    switch (hefteningunu) {
      case 1:
        if (selectedModel.days!.any((element) => element.day==1)) {
          rutgun = "Duz";
        }
        break;
      case 2:
        if (selectedModel.days!.any((element) => element.day==2)) {
          rutgun = "Duz";
        }
        break;
      case 3:
        if (selectedModel.days!.any((element) => element.day==3)) {
          rutgun = "Duz";
        }
        break;
      case 4:
        if (selectedModel.days!.any((element) => element.day==4)) {
          rutgun = "Duz";
        }
        break;
      case 5:
        if (selectedModel.days!.any((element) => element.day==5)) {
          rutgun = "Duz";
        }
        break;
      case 6:
        if (selectedModel.days!.any((element) => element.day==6)) {
          rutgun = "Duz";
        }
        break;
      default:
        rutgun = "Sef";
    }
    return rutgun;
  }

  ///Anbar baza downloads////
  Future getDataAnbar(String soapadress, String soaphost) async {
    DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    String ay = now.month.toString(); // ay
    String gun = now.day.toString(); // gun
    String il = now.year.toString(); // il
    String sontarix_merc = il + "/" + ay + "/" + gun;
    var envolpeAnbarqaliq = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
    <Anbar_qaliq xmlns="http://tempuri.org/">
      <tarix>$sontarix_merc</tarix>
    </Anbar_qaliq>
  </soap:Body>
</soap:Envelope>
''';
    var url = Uri.parse(soapadress);
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/Anbar_qaliq",
          // "Host": "85.132.97.2"
          "Host": soaphost
          //"Accept": "text/xml"
        },
        body: envolpeAnbarqaliq);

    var rawXmlResponse = response.body;
    return _parsingAnbar(rawXmlResponse);
  }

  Future _parsingAnbar(var _response) async {
    List<ModelAnbarRapor> list_mallar = [];
    var _document = xml.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('Table');
    items.map((xml.XmlElement item) {
      var _kode = _getValue(item.findElements("STOK_KOD"));
      var _name = _getValue(item.findElements("STOK_AD"));
      var _anaqrup = _getValue(item.findElements("ANA_GRUP"));
      var _qaliq = _getValue(item.findElements("QALIQ"));
      var _vahid = _getValue(item.findElements("VAHID_1"));
      var _qiymet = _getValue(item.findElements("SATIS_QIYMETI"));
      ModelAnbarRapor modelmal = ModelAnbarRapor(
          stokadi: _name,
          stokkod: _kode,
          qaliq: _qaliq,
          anaqrup: _anaqrup,
          satisqiymeti: _qiymet,
          vahidbir: _vahid);
      list_mallar.add(modelmal);
      //  itemsList.add(_addResult);
    }).toList();
    return list_mallar;
  }

  void syncAllInfo() async {
    await getLoggedUserInfo(loggedUserModel.tokenModel!, loggedUserModel.baseUrl!);
    _donloadListiniDoldur();
    callLocalBases();
    listDonwloadsAll.clear();
    for (var element in listDonwloads) {
      listDonwloadsAll.add(element);
    }
    for (var element in listDownloadsFromLocalDb) {
      listDonwloadsAll.add(element);
    }
    for (var element in listDonwloadsAll) {
      listDonwloads.remove(element);
      listDownloadsFromLocalDb.remove(element);
      element.donloading == true;
      listDownloadsFromLocalDb.add(element);
     await melumatlariEndir(element, true).whenComplete(() => {
       listDownloadsFromLocalDb.remove(element),
          element.donloading == false,
       listDownloadsFromLocalDb.add(element)
      });
    }
    update();
  }

  Future<void> getLoggedUserInfo(TokenModel modelToken, String baseUrl) async {
    int dviceType = checkDviceType.getDviceType();

    DialogHelper.showLoading("istMelEndirilir".tr);
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
              "$baseUrl/api/v1/User/myinfo",
              options: Options(
                headers: {
                  'Lang': languageIndex,
                  'Device': dviceType,
                  'abs': '123456',
                  "Authorization": "Bearer ${modelToken.accessToken}"
                },
                validateStatus: (_) => true,
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
              ),
            );
        if (response.statusCode == 404) {
          DialogHelper.hideLoading();
          Get.dialog(ShowInfoDialog(
            icon: Icons.error,
            messaje: "baglantierror".tr,
            callback: () {},
          ));
        } else {
          if (response.statusCode == 200) {
            DialogHelper.hideLoading();
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            UserModel modelUser = UserModel.fromJson(baseResponce.result['user']);
            CompanyModel modelCompany = CompanyModel.fromJson(baseResponce.result['company']);
            LoggedUserModel modelLogged = LoggedUserModel(
                baseUrl: baseUrl,
                isLogged: true,
                companyModel: modelCompany,
                tokenModel: modelToken,
                userModel: modelUser);
            localUserServices.init();
            localUserServices.addUserToLocalDB(modelLogged);
            DrawerMenuController controller=Get.put(DrawerMenuController());
            controller.onInit();
            controller.addPermisionsInDrawerMenu(loggedUserModel);
            update();
          } else {
            BaseResponce baseResponce = BaseResponce.fromJson(response.data);
            Get.dialog(ShowInfoDialog(
              icon: Icons.error_outline,
              messaje: baseResponce.exception!.message.toString(),
              callback: () {},
            ));
            DialogHelper.hideLoading();
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
          messaje: e.message ?? "baglantierror".tr,
          callback: () {},
        ));
        DialogHelper.hideLoading();
      }
    }
  }
}
