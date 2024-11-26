import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as intl;
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/base_downloads/models/model_downloads.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_inout.dart';
import 'package:zs_managment/companents/giris_cixis/sceens/reklam_girisCixis/controller_giriscixis_reklam.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/login/models/base_responce.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_app_setting.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/helpers/user_permitions_helper.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/custom_text_field.dart';
//import 'package:zs_managment/widgets/custom_text_field.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../../../login/models/user_model.dart';
import 'model_main_inout.dart';

class ControllerMyMerchSystem extends GetxController {
  LocalUserServices userService = LocalUserServices();
  LocalAppSetting appSetting = LocalAppSetting();
  LocalBaseDownloads localBaseDownloads=LocalBaseDownloads();
  late Rx<AvailableMap> availableMap = AvailableMap(
      mapName: CustomMapType.google.name,
      mapType: MapType.google,
      icon:
      'packages/map_launcher/assets/icons/${CustomMapType.google}.svg').obs;
  RxList<MercDataModel> listMercler = List<MercDataModel>.empty(growable: true).obs;
  RxList<MercDataModel> listFilteredMerc= List<MercDataModel>.empty(growable: true).obs;
  RxList<ModelMainInOut> listGirisCixis = List<ModelMainInOut>.empty(growable: true).obs;
  RxBool dataLoading = true.obs;
  TextEditingController ctTemsilciKodu = TextEditingController();
  RxBool routDataLoading = true.obs;
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  ExeptionHandler exeptionHandler=ExeptionHandler();
  RxList<MercCustomersDatail> listMercBaza = List<MercCustomersDatail>.empty(growable: true).obs;
  RxList<UserModel> listUsers = List<UserModel>.empty(growable: true).obs;
  UserPermitionsHelper userPermitionSercis = UserPermitionsHelper();
  RxString sonYenilenme="".obs;

  @override
  void onInit() {
    getMercRutDetail();
    super.onInit();
  }

  getMercRutDetail() async {
    listMercler.clear();
    listFilteredMerc.clear();
    listUsers.clear();
    listMercBaza.clear();
    dataLoading.value=true;
    listMercler.value=await localBaseDownloads.getAllMercDatail();
    listFilteredMerc.value=await localBaseDownloads.getAllMercDatail();
    sonYenilenme.value=localBaseDownloads.getLastUpdatedFieldDate("donwEnterMerc");
    for (var e in listMercler) {
      for (var a in e.mercCustomersDatail!) {
        listMercBaza.add(a);
      }
      listUsers.add(UserModel(
          roleName: e.user!.roleName,
          roleId: e.user!.roleId,
          name: e.user!.name,
          code: e.user!.code,
          gender: 0));
    }
    await localBaseDownloads.addConnectedUsers(listUsers);
    dataLoading.value=false;
    update();
  }

  @override
  void dispose() {
    Get.delete<ControllerMyMerchSystem>;
    super.dispose();
  }

  String prettify(double d) {
    return d.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  void createDialogTogetExpCode(BuildContext context) {
    Get.dialog(_widgetDialogExpCode(context), barrierDismissible: false);
  }

  Widget _widgetDialogExpCode(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery
                  .of(context)
                  .size
                  .height * 0.34,
              horizontal: MediaQuery
                  .of(context)
                  .size
                  .width * 0.1),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            labeltext: "Temsilci secimi",
                            fontsize: 18,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.all(8.0).copyWith(left: 20, right: 20),
                      child: CustomTextField(
                          obscureText: false,
                          updizayn: true,
                          align: TextAlign.center,
                          controller: ctTemsilciKodu,
                          inputType: TextInputType.text,
                          hindtext: "temsilciSec".tr,
                          fontsize: 14),
                    ),
                    CustomElevetedButton(
                      cllback: () async {
                        Get.back();
                        List<ModelCariler> listCariler=await getAllExpCustomers(ctTemsilciKodu.text);
                        if(listCariler.isEmpty){
                          Get.dialog(ShowInfoDialog(messaje: "melumatTapilmadi".tr, icon: Icons.error, callback: (){
                            Get.back();
                          }));
                        }else{
                          Get.toNamed(RouteHelper.screenExpRoutDetail,arguments: [this,ctTemsilciKodu.text,listCariler]);
                        }
                        ctTemsilciKodu.clear();
                      },
                      label: "tesdiqle".tr,
                      fontWeight: FontWeight.w700,
                      borderColor: Colors.grey,
                      elevation: 5,
                      height: 30,
                      width: 200,
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                      ctTemsilciKodu.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  ///Cari Baza endirme/////////
  Future<List<ModelCariler>> getAllExpCustomers(String temKod) async {
    List<ModelCariler> listUsers=[];
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler=[];
    secilmisTemsilciler.add(temKod);
    DialogHelper.showLoading("cmendirilir".tr);
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel=userService.getLoggedUser();
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
        final response = await ApiClient().dio(false).post("${loggedUserModel.baseUrl}/MercSystem/GetAllExpCariCariler?expCode="+temKod,
          data:jsonEncode(secilmisTemsilciler),
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
        print("response :"+response.toString());

        if (response.statusCode == 200) {
            var dataModel = json.encode(response.data['Result']);
            List listuser = jsonDecode(dataModel);
            for(var a in listuser){
              ModelCariler model=ModelCariler.fromJson(a);
              model.forwarderCode=model.forwarderCode;
              listUsers.add(model);

            }


        } else {
            exeptionHandler.handleExeption(response);
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
    DialogHelper.hideLoading();
    return listUsers;
  }
  ///Get MercBaza
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

////giris cixis

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  void changeSearchValue(String ckarakter) {
    listFilteredMerc.clear();
    if(ckarakter.isEmpty){
     listMercler.forEach((e){
       listFilteredMerc.add(e);
     });
    }else{
      listFilteredMerc.value= listMercler.where((e)=>e.user!.code.toUpperCase().contains(ckarakter.toUpperCase())||
          e.user!.name.toUpperCase().contains(ckarakter.toUpperCase())
      ).toList();
    }
    update();
  }

  void changeDateSelect(BuildContext context) {
    showMonthPicker(context,
        onSelected: (month, year) async {
          List<MercDataModel> data=await getAllMercCariBazaMotivasiya(month,year);
          if(data.isNotEmpty){
            ModelDownloads model= ModelDownloads(
                name: "currentBase".tr,
                donloading: false,
                code: "enter",
                info: "currentBaseExplain".tr,
                lastDownDay: DateTime.now().toIso8601String(),
                musteDonwload: false);
            await localBaseDownloads.addDownloadedBaseInfo(model);
           await localBaseDownloads.addAllToMercBase(data);
           await getMercRutDetail();
          }
        },
        initialSelectedMonth: DateTime.now().month,
        initialSelectedYear: DateTime.now().year,
        firstEnabledMonth: 12,
        lastEnabledMonth: DateTime.now().month,
        firstYear: 2015,
        lastYear: DateTime.now().year,
        selectButtonText: 'OK',
        cancelButtonText: 'Cancel',
        highlightColor: Colors.blue,
        textColor: Colors.white,
        contentBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white
    );
  }


  Future<List<MercDataModel>> getAllMercCariBazaMotivasiya(int month, int year) async {
    List<MercDataModel> listUsers = [];
    List<UserModel> listConnectedUsers = [];
    languageIndex = await getLanguageIndex();
    DialogHelper.showLoading("cmendirilir",true);
    await localBaseDownloads.init();
    List<ModelDownloads> listDonloads = await localBaseDownloads.getAllDownLoadBaseList();
    ModelDownloads modelDonwload=listDonloads.where((e)=>e.code=="donwEnterMerc").first;
    LoggedUserModel loggedUserModel = userService.getLoggedUser();
    var data=
    {
      //"roleId": 2,
      "companyId": loggedUserModel.userModel!.companyId,
      //"regionCode": loggedUserModel.userModel!.regionCode,
      "il": year,
      "ay": month,
      "usersConnectedMe":true

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
            roleName: MercDataModel.fromJson(i).user!.roleName,
            roleId:  MercDataModel.fromJson(i).user!.roleId,
            code: MercDataModel.fromJson(i).user!.code,
            name: MercDataModel.fromJson(i).user!.name,
            gender: 0,
          ));
        }
        modelDonwload.lastDownDay = DateTime.now().toIso8601String();
        sonYenilenme.value=DateTime.now().toIso8601String();
        modelDonwload.musteDonwload = false;
        localBaseDownloads.addDownloadedBaseInfo(modelDonwload);
      }
    }
    DialogHelper.hideLoading();
    return listUsers;
  }

  Future<void> getCurrentdata() async {
    int month=DateTime.now().month;
    int year=DateTime.now().year;
    List<MercDataModel> data=await getAllMercCariBazaMotivasiya(month,year);
    if(data.isNotEmpty){
      ModelDownloads model= ModelDownloads(
          name: "currentBase".tr,
          donloading: false,
          code: "enter",
          info: "currentBaseExplain".tr,
          lastDownDay: DateTime.now().toIso8601String(),
          musteDonwload: false);
      await localBaseDownloads.addDownloadedBaseInfo(model);
      await localBaseDownloads.addAllToMercBase(data);
      await getMercRutDetail();
    }
  }

}
