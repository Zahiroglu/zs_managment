import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/companents/anbar/model_anbarrapor.dart';
import 'package:zs_managment/companents/giris_cixis/models/model_request_inout.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_satis.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import 'package:zs_managment/dio_config/api_client.dart';
import 'package:zs_managment/helpers/dialog_helper.dart';
import 'package:zs_managment/helpers/exeption_handler.dart';
import 'package:zs_managment/helpers/user_permitions_helper.dart';
import 'package:zs_managment/utils/checking_dvice_type.dart';
import 'package:zs_managment/widgets/custom_eleveted_button.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/simple_info_dialog.dart';
import 'package:intl/intl.dart' as intl;
import '../../constands/app_constands.dart';
import '../../global_models/custom_enummaptype.dart';
import '../../global_models/model_appsetting.dart';
import '../../global_models/model_maptypeapp.dart';
import '../../routs/rout_controller.dart';
import '../local_bazalar/local_app_setting.dart';
import '../local_bazalar/local_giriscixis.dart';
import '../local_bazalar/local_users_services.dart';
import '../local_bazalar/local_db_downloads.dart';
import '../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import '../setting_panel/screen_maps_setting.dart';
import 'models/model_cariler.dart';
import 'models/model_downloads.dart';

class ControllerBaseDownloadsFirstTime extends GetxController {
  Dio dio = Dio();
  late CheckDviceType checkDviceType = CheckDviceType();
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalUserServices localUserServices = LocalUserServices();
  RxList<ModelDownloads> listDonwloads = List<ModelDownloads>.empty(growable: true).obs;
  RxList<ModelDownloads> listDownloadsFromLocalDb = List<ModelDownloads>.empty(growable: true).obs;
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  RxBool dataLoading = true.obs;
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  LocalBaseSatis localBaseSatis = LocalBaseSatis();
  RxBool davamEtButonuGorunsun = false.obs;
  String languageIndex = "az";
  ExeptionHandler exeptionHandler = ExeptionHandler();
  RxBool ifUserMustLocateAllWordDay = false.obs;
  ModelAppSetting modelsetting = ModelAppSetting(
      mapsetting: null, girisCixisType: "", userStartWork: false);
  List<AvailableMap> listApps = [];
  late AvailableMap selectedApp = AvailableMap(
      mapName: MapType.google.name.tr,
      mapType: MapType.google,
      icon: const Icon(Icons.map).toString());
  LocalAppSetting localAppSetting = LocalAppSetting();
  RxString giriscixisScreenType = "".obs;
  RxBool userStartWork = false.obs;
  late Rx<ModelGirisCixisScreenType> selectedModelGirisCixis = ModelGirisCixisScreenType().obs;
  late Rx<ModelAppSetting> modelAppSetting = ModelAppSetting().obs;
  List<ModelGirisCixisScreenType> listGirisCixisType = [
    ModelGirisCixisScreenType(
        name: "map",
        icon: const Icon(
          Icons.map,
          color: Colors.green,
        ),
        kod: "map"),
    ModelGirisCixisScreenType(
        name: "list", icon: const Icon(Icons.list_alt), kod: "list")
  ];
  UserPermitionsHelper userPermitionSercis = UserPermitionsHelper();

  @override
  onInit() async {
    _donloadListiniDoldur();
    getAPPlist();
    super.onInit();
  }

  getAPPlist() async {
    listApps = await MapLauncher.installedMaps;
    await localAppSetting.init();
    ModelAppSetting modelAppSetting = await localAppSetting.getAvaibleMap();
    modelsetting = modelAppSetting;
    if (modelAppSetting.mapsetting != null) {
      ModelMapApp modelMapApp = modelAppSetting.mapsetting!;
      CustomMapType? customMapType = modelMapApp.mapType;
      MapType mapType = MapType.values[customMapType!.index];
      if (modelMapApp.name == "null") {
        selectedApp = listApps.first;
      } else {
        selectedApp = AvailableMap(
            mapName: modelMapApp.name!,
            mapType: mapType,
            icon: modelMapApp.icon!);
      }
    }
    if (modelAppSetting.girisCixisType != null) {
      giriscixisScreenType.value = modelAppSetting.girisCixisType!;
    } else {
      giriscixisScreenType.value = "map";
    }
    if (modelAppSetting.userStartWork != null) {
      userStartWork.value = modelAppSetting.userStartWork!;
    } else {
      userStartWork.value = false;
    }
    if (giriscixisScreenType.isNotEmpty) {
      selectedModelGirisCixis.value = listGirisCixisType
          .where((element) => element.kod == giriscixisScreenType.value)
          .first;
    } else {
      selectedModelGirisCixis.value = listGirisCixisType.first;
    }
    update();
  }

  Future<void> saveChangedSettingtoDb(bool istrue) async {
    modelsetting.userStartWork = istrue;
    await localAppSetting.addSelectedMyTypeToLocalDB(modelsetting);
    Get.offNamed(RouteHelper.mobileMainScreen);
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
    await localBaseDownloads.init();
    await localGirisCixisServiz.init();
    await localBaseSatis.init();
    await localBaseSatis.init();
    modelsetting = await localAppSetting.getAvaibleMap();
    loggedUserModel = localUserServices.getLoggedUser();
    ifUserMustLocateAllWordDay.value == loggedUserModel.userModel!.permissions!.any((element) => element.code == "liveAllDay");
    listDownloadsFromLocalDb.value = await localBaseDownloads.getAllDownLoadBaseList();
    getMustDownloadBase(loggedUserModel.userModel!.roleId!, listDownloadsFromLocalDb);
    intentScreen();
    update();
  }

  Future<void> _donloadListiniDoldur() async {
    listDonwloads.clear();
    int sayList = 0;
    await localUserServices.init();
    List<ModelUserPermissions> listUsersPermitions =
    localUserServices.getLoggedUser().userModel!.permissions!.where((e)=>e.category==2).toList();
    sayList = sayList + 1;
    for (var element in listUsersPermitions) {
      listDonwloads.add(ModelDownloads(
          name: element.name,
          code: element.code,
          info: element.valName,
          lastDownDay: "",
          donloading: false,
          musteDonwload: true));
    }
    await callLocalBases();
    update();
  }

  getWidgetDownloads(BuildContext context) {
    return Obx(() => listDonwloads.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  children: listDonwloads
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: itemsGuncellenmeliBazalar(e, context),
                          ))
                      .toList(),
                ),
              ),
              davamEtButonuGorunsun.isFalse
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: CustomElevetedButton(
                                cllback: () async {
                                  await saveChangedSettingtoDb(false);
                                },
                                label: "goAhead".tr,
                                height: 40,
                                icon: Icons.info,
                                surfaceColor: Colors.white,
                                textColor: Colors.orangeAccent,
                                borderColor: Colors.orangeAccent,
                                elevation: 10,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: CustomElevetedButton(
                                cllback: () async {
                                  await saveChangedSettingtoDb(true);
                                },
                                textColor: Colors.green,
                                icon: Icons.work_history,
                                label: "startWork".tr,
                                height: 40,
                                surfaceColor: Colors.white,
                                borderColor: Colors.green,
                                elevation: 10,
                              ),
                            ),
                          ],
                        ),
                      ))
            ],
          )
        : const SizedBox());
  }

  Widget itemsGuncellenmeliBazalar(ModelDownloads model, BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 5),
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
                          fontsize: 16),
                      model.donloading!
                          ?CustomText(labeltext: "loading".tr,color: Colors.red,): model.lastDownDay!.length > 1
                          ? Row(
                        children: [
                          CustomText(
                              color: model.musteDonwload == true
                                  ? Colors.red
                                  : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontsize: 12,
                              labeltext:
                              "${"lastRefresh".tr}: ${model.lastDownDay!.substring(0, 10)}"),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              color: model.musteDonwload == true
                                  ? Colors.red
                                  : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontsize: 12,
                              labeltext:
                              "( ${model.lastDownDay!.substring(11, 16)} )"),
                        ],
                      )
                          : const SizedBox(),
                      CustomText(
                        labeltext: model.info!,
                        maxline: 3,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                        fontsize: 12,
                      ),
                      model.musteDonwload == true
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            size: 12,
                            Icons.info,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: CustomText(
                              labeltext: "infoRefresh".tr,
                              maxline: 3,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.red,
                              fontsize: 12,
                            ),
                          ),
                        ],
                      )
                          : const SizedBox()
                    ],
                  ),
                ),
                model.donloading!
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.blue,))
                    : InkWell(
                    onTap: () {
                      melumatlariEndir(model, true);
                    },
                    child: const Icon(Icons.refresh))
              ],
            ),
          ],
        ),
      ),
    );
  }

  getMustDownloadBase(int roleId, List<ModelDownloads> listDownloadsFromLocalDb) {
    for (var e in listDownloadsFromLocalDb) {
      if (listDonwloads.any((element) => element.code == e.code)) {
        listDonwloads.remove(listDonwloads.where((a) => a.code == e.code).first);
        listDonwloads.add(e);
      }
    }
    dataLoading = false.obs;
  }

  Future<void> melumatlariEndir(ModelDownloads model, bool guncelle) async {
    switch (model.code) {
      case "myConnectedUsers":
        await localGirisCixisServiz.init();
        await localBaseDownloads.init();
        updateElementDownloading(model,true);
        loggedUserModel = localUserServices.getLoggedUser();
        List<UserModel> listUser = await getAllConnectedUsers();
        model.lastDownDay = DateTime.now().toIso8601String();
        model.musteDonwload = false;
        localBaseDownloads.addDownloadedBaseInfo(model);
          await localBaseDownloads.addConnectedUsers(listUser);
          updateElementDownloading(model,false);
        break;
      case "downanbar":
        await localGirisCixisServiz.init();
        updateElementDownloading(model,true);
        loggedUserModel = localUserServices.getLoggedUser();
        List<ModelAnbarRapor> data = await getDataAnbar();
        await localBaseDownloads.addAnbarBaza(data);
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          localBaseDownloads.addDownloadedBaseInfo(model);
        updateElementDownloading(model,false);

        break;
      case "enterScreen":
        loggedUserModel = localUserServices.getLoggedUser();
        updateElementDownloading(model,true);
        List<MercDataModel> data = [];
        await getAllGirisCixis(loggedUserModel.userModel!.code!,
              loggedUserModel.userModel!.roleId.toString())
              .whenComplete(() async {
            data = await getAllMercCariBazaMotivasiya();
          });
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          localBaseDownloads.addDownloadedBaseInfo(model);
          localBaseDownloads.addAllToMercBase(data);
        updateElementDownloading(model,false);

      case "myRut":
        await localGirisCixisServiz.init();
        loggedUserModel = localUserServices.getLoggedUser();
        break;
      case "donwEnterMerc":
        await localGirisCixisServiz.init();
        updateElementDownloading(model,true);
        List<MercDataModel> data = await getAllMercCariBazaMotivasiya();
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          localBaseDownloads.addDownloadedBaseInfo(model);
          localBaseDownloads.addAllToMercBase(data);
          updateElementDownloading(model,false);

        break;
      case "donwSingleMercBaza":
        await localGirisCixisServiz.init();
        updateElementDownloading(model,true);
        List<MercDataModel> data = await getSingleMercCariBazaMotivasiya();
          model.lastDownDay = DateTime.now().toIso8601String();
          model.musteDonwload = false;
          localBaseDownloads.addDownloadedBaseInfo(model);
          localBaseDownloads.addAllToMercBase(data);
        updateElementDownloading(model,false);

        break;
    }
    intentScreen();
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
      try{
        final response = await ApiClient().dio(false).get(
          AppConstands.baseUrlsMain+"/UserControl/GetUsersWithConnectedMe",
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
          var userlist = json.encode(response.data['Result']);
          List listuser = jsonDecode(userlist);
          for (var i in listuser) {
            listUsers.add(UserModel(
              id: i['Id'],
              roleName: i['RoleName'],
              roleId: i['RoleId'],
              code: i['Code'],
              name: i['Name'],
              gender: 0,
            ));
          }
        }
      }catch(ex){
      print(ex);
      }}
    return listUsers;
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  ///Get Exp cari Baza From Serviz
  Future<List<ModelCariler>> getAllCustomers() async {
    List<ModelCariler> listUsers = [];
    int dviceType = checkDviceType.getDviceType();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    String accesToken = loggedUserModel.tokenModel!.accessToken!;
    languageIndex = await getLanguageIndex();
    List<String> secilmisTemsilciler = [];
    await localBaseDownloads.init();
    List<UserModel> listUsersSelected =
        localBaseDownloads.getAllConnectedUserFromLocal();
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
      final response = await ApiClient().dio(false).post(
            "${loggedUserModel.baseUrl}/api/v1/Sales/customers-by-forwarders",
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

      if (response.statusCode == 200) {
        var dataModel = json.encode(response.data['result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          var dataCus = json.encode(i['customers']);
          var temsilciKodu = i['user']['code'];

          List listDataCustomers = jsonDecode(dataCus);
          for (var a in listDataCustomers) {
            ModelCariler model = ModelCariler.fromJson(a);
            model.forwarderCode = temsilciKodu;
            listUsers.add(model);
          }
        }
      }
    }
    return listUsers;
  }

  ///Cari Merc Baza endirme/////////
  Future<List<MercDataModel>> getAllMercCariBazaMotivasiya() async {
    List<MercDataModel> listUsers = [];
    languageIndex = await getLanguageIndex();
    await localBaseDownloads.init();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    DateTime dateTime=DateTime.now();
    var data=
    {
      "usersConnectedMe": true,
      "companyId": loggedUserModel.userModel!.companyId,
      "regionCode": loggedUserModel.userModel!.regionCode,
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
      if (response.statusCode == 200) {
        List<UserModel> listConnectedMercs =[];
        var dataModel = json.encode(response.data['Result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          listUsers.add(MercDataModel.fromJson(i));
          listConnectedMercs.add(UserModel(
              roleName: MercDataModel.fromJson(i).user!.roleName,
              roleId: MercDataModel.fromJson(i).user!.roleId,
              name: MercDataModel.fromJson(i).user!.name,
              code: MercDataModel.fromJson(i).user!.code,
              gender: 0));

        }
        await localBaseDownloads.addConnectedUsers(listConnectedMercs);
      }else{

      }
    }
    return listUsers;
  }

  Future<List<MercDataModel>> getSingleMercCariBazaMotivasiya() async {
    List<MercDataModel> listUsers = [];
    languageIndex = await getLanguageIndex();
    await localBaseDownloads.init();
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    DateTime dateTime=DateTime.now();
    var data=
    {
      "code":loggedUserModel.userModel!.code,
      "companyId": loggedUserModel.userModel!.companyId,
      "roleId": loggedUserModel.userModel!.roleId,
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
      if (response.statusCode == 200) {
        var dataModel = json.encode(response.data['Result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          listUsers.add(MercDataModel.fromJson(i));
        }
      }
    }
    return listUsers;
  }

  String rutDuzgunluyuYoxla(ModelCariler selectedModel) {
    String rutgun = "Sef";
    int hefteningunu = DateTime.now().weekday;
    switch (hefteningunu) {
      case 1:
        if (selectedModel.days!.any((element) => element.day == 1)) {
          rutgun = "Duz";
        }
        break;
      case 2:
        if (selectedModel.days!.any((element) => element.day == 2)) {
          rutgun = "Duz";
        }
        break;
      case 3:
        if (selectedModel.days!.any((element) => element.day == 3)) {
          rutgun = "Duz";
        }
        break;
      case 4:
        if (selectedModel.days!.any((element) => element.day == 4)) {
          rutgun = "Duz";
        }
        break;
      case 5:
        if (selectedModel.days!.any((element) => element.day == 5)) {
          rutgun = "Duz";
        }
        break;
      case 6:
        if (selectedModel.days!.any((element) => element.day == 6)) {
          rutgun = "Duz";
        }
        break;
      default:
        rutgun = "Sef";
    }
    return rutgun;
  }

  ///Anbar baza downloads////
  Future<List<ModelAnbarRapor>> getDataAnbar() async {
    List<ModelAnbarRapor> listProducts = [];
    languageIndex = await getLanguageIndex();
    var data = {"date": DateTime.now().toString().substring(0, 9)};
    int dviceType = checkDviceType.getDviceType();
    await localUserServices.init();
    String accesToken = await localUserServices.getLoggedToken();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(ShowInfoDialog(
        icon: Icons.network_locked_outlined,
        messaje: "internetError".tr,
        callback: () {},
      ));
    } else {
      final response = await ApiClient().dio(false).post(
        "${loggedUserModel.baseUrl}/Anbar/GetAnbarBaze",
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

      if (response.statusCode == 200) {
        var dataModel = json.encode(response.data['Result']);
        List listuser = jsonDecode(dataModel);
        for (var i in listuser) {
          listProducts.add(ModelAnbarRapor.fromJson(i));
        }
      }
    }
    return listProducts;
  }

  void syncAllInfo() async {
    await localUserServices.init();
    loggedUserModel = localUserServices.getLoggedUser();
    for (var element in listDonwloads) {
      await melumatlariEndir(element, true);
    }
    intentScreen();
    update();
  }

  Future<List<ModelMainInOut>> getAllGirisCixis(String temsilcikodu, String roleId) async {
    List<ModelMainInOut> listUsers = [];
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    DateTime dateParse = DateTime.parse(date);
    String ilkGun = intl.DateFormat('yyyy/MM/dd').format(dateParse);
    String songun = intl.DateFormat('yyyy/MM/dd').format(now);
    LoggedUserModel loggedUserModel = localUserServices.getLoggedUser();
    ModelRequestInOut model = ModelRequestInOut(
      listConfs: [],
        userRole: [UserRole(code: temsilcikodu, role: roleId)],
        endDate: songun,
        startDate: ilkGun);
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
              "${loggedUserModel.baseUrl}/api/v1/InputOutput/in-out-customers-by-user",
              data: model.toJson(),
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
          var dataModel = json.encode(response.data['result']);
          List listuser = jsonDecode(dataModel);
          await localGirisCixisServiz.clearAllGirisServer();
          for (var i in listuser) {
            ModelMainInOut model = ModelMainInOut.fromJson(i);
            await localGirisCixisServiz.addSelectedGirisCixisDBServer(model);
            listUsers.add(model);
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
    return listUsers;
  }

  void intentScreen() {
    if (listDonwloads.any((e) => e.musteDonwload == true)) {
      davamEtButonuGorunsun.value = false;
    } else {
      if (modelsetting.userStartWork == true) {
        Get.offNamed(RouteHelper.mobileMainScreen);
      }
      else {
        davamEtButonuGorunsun.value = true;
      }
    }
  }

  void updateElementDownloading(ModelDownloads model, bool isdownloading) {
    model.donloading=isdownloading;
    listDonwloads[listDonwloads.indexWhere((e) => e.code == model.code)] = model;
   update;
  }
}
