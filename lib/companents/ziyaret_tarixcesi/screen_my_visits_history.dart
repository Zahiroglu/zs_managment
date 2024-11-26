import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_notdata_found.dart';

import '../../dio_config/api_client.dart';
import '../../helpers/exeption_handler.dart';
import '../../routs/rout_controller.dart';
import '../../utils/checking_dvice_type.dart';
import '../../widgets/custom_eleveted_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loagin_animation.dart';
import '../../widgets/simple_info_dialog.dart';
import '../giris_cixis/models/model_request_inout.dart';
import '../local_bazalar/local_db_downloads.dart';
import '../local_bazalar/local_giriscixis.dart';
import '../local_bazalar/local_users_services.dart';
import '../login/models/logged_usermodel.dart';
import '../main_screen/controller/drawer_menu_controller.dart';
import '../rut_gostericileri/mercendaizer/connected_users/model_main_inout.dart';
import '../rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:intl/intl.dart' as intl;

class ScreenMyVisitHistory extends StatefulWidget {
  DrawerMenuController drawerMenuController;
  List<ModelMainInOut> listGirisCixis;
   ScreenMyVisitHistory({super.key,required this.listGirisCixis,required this.drawerMenuController});

  @override
  State<ScreenMyVisitHistory> createState() => _ScreenMyVisitHistoryState();
}

class _ScreenMyVisitHistoryState extends State<ScreenMyVisitHistory> {
  LocalUserServices userServices = LocalUserServices();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  String languageIndex = "az";
  late CheckDviceType checkDviceType = CheckDviceType();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  List<ModelMainInOut> listGirisCixis=[];
  ExeptionHandler exeptionHandler = ExeptionHandler();
  bool dataLoading=true;
  TextEditingController ctFistDay = TextEditingController();
  TextEditingController ctLastDay = TextEditingController();
  @override
  void initState() {
    getAllGirisCixis("","");
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1,0,1).toString();
    DateTime dateParse = DateTime.parse(date);
    String ilkGun = intl.DateFormat('yyyy/MM/dd').format(dateParse);
    String songun = intl.DateFormat('yyyy/MM/dd').format(now);
    ctFistDay.text=ilkGun;
    ctLastDay.text=songun;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: CustomText(
          labeltext: "Ziyaretler tarixcesi".tr,
        ),
        leading: IconButton(
          onPressed: () {
            widget.drawerMenuController.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [IconButton(onPressed: (){
          Get.dialog(_widgetDatePicker(context));
        }, icon: const Icon(Icons.calendar_month))],
      ),
      body:dataLoading?Center(child: LoagindAnimation(isDark: Get.isDarkMode,textData: "melumatyuklenir".tr,icon: "lottie/loagin_animation.json"),): _bodu(context),
    );
  }

  _bodu(BuildContext context) {
    return listGirisCixis.isNotEmpty?Column(
      children: [
        Expanded(
            flex: 2,
            child: infoZiyaretTarixcesi()),
        Expanded(
            flex: 9,
            child: _pageViewZiyaretTarixcesi()),
      ],
    ):Center(child: NoDataFound(title: "mtapilmadi".tr,height: 250,width: 250,),);
  }

  Widget infoZiyaretTarixcesi() {
    return Column(
      children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              Container(margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 0, bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    // boxShadow:  const [
                    //   BoxShadow(
                    //       color: Colors.grey,
                    //       offset: Offset(0, 0),
                    //       spreadRadius: 0.1,
                    //       blurRadius: 20)
                    // ],
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    //borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: "ayliqZiyaretHes".tr,
                        fontWeight: FontWeight.w600,
                        fontsize: 16,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"isgunleri".tr} : "),
                          CustomText(
                              labeltext: "${listGirisCixis.first.modelInOutDays.length} ${"gun".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"ziyaretSayi".tr} : "),
                          CustomText(
                              labeltext:
                              "${listGirisCixis.first.modelInOutDays.fold(0, (sum, element) => sum + element.visitedCount)} ${"market".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"umumiIssaati".tr} : "),
                          CustomText(
                              labeltext:
                              "${listGirisCixis.first.modelInOutDays.first.workTimeInCustomer} "),
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
        itemCount: listGirisCixis.first.modelInOutDays.length,
        itemBuilder: (con, index) {
          return itemZiyaretGunluk(
              listGirisCixis.first.modelInOutDays.elementAt(index));
        });
  }

  Widget itemZiyaretGunluk(ModelInOutDay model) {
    return InkWell(
      onTap: () async {
        userServices.init();
        localBaseDownloads.init();
        List<MercDataModel> list=await localBaseDownloads.getAllMercDatailByCode(userServices.getLoggedUser().userModel!.code!);
        Get.toNamed(RouteHelper.screenZiyaretGirisCixis,arguments: [model,"${userServices.getLoggedUser().userModel!.name} ${userServices.getLoggedUser().userModel!.surname!}",list.first.mercCustomersDatail]);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0).copyWith(left: 10,right: 10),
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
                CustomText(labeltext: model.day,fontsize: 18,fontWeight: FontWeight.w700,),
                const SizedBox(height: 2,),
                const Divider(height: 1,color: Colors.black,),
                const SizedBox(height: 2,),
                Row(
                  children: [
                    CustomText(labeltext: "${"ziyaretSayi".tr} : ",fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.visitedCount.toString()),
                  ],
                ),
                Row(
                  children: [
                    CustomText(labeltext: "${"isBaslama".tr} : ",fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.firstEnterDate.substring(11,model.firstEnterDate.toString().length)),
                  ],
                ),
                Row(
                  children: [
                    CustomText(labeltext: "${"isbitme".tr} : ",fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.lastExitDate.substring(11,model.lastExitDate.toString().length)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.blue, width: 0.5),
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

  Future<void> getAllGirisCixis(String firtDate,String lastDate) async {
   setState(() {
     dataLoading=true;
     listGirisCixis.clear();
   });
    await localGirisCixisServiz.init();
    await userServices.init();
    await localBaseDownloads.init();
    List<ModelMainInOut> listUsers = [];
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1,0,1).toString();
    DateTime dateParse = DateTime.parse(date);
    String ilkGun = intl.DateFormat('yyyy/MM/dd').format(dateParse);
    if(firtDate.isNotEmpty){
      ilkGun=firtDate;
    }
    String songun = intl.DateFormat('yyyy/MM/dd').format(now);
    if(lastDate.isNotEmpty){
      songun=lastDate;
    }
    LoggedUserModel loggedUserModel = userServices.getLoggedUser();
    ModelRequestInOut model = ModelRequestInOut(
        userRole: [UserRole(code: loggedUserModel.userModel!.code!, role: loggedUserModel.userModel!.roleId.toString())],
        endDate: songun+" 23:59",
        startDate: ilkGun+" 00:01");
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
          "${loggedUserModel.baseUrl}/GirisCixisSystem/GetUserDataByRoleAndDate",
          data: model.toJson(),
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
          var dataModel = json.encode(response.data['Result']);
          List listuser = jsonDecode(dataModel);
          await localGirisCixisServiz.clearAllGirisServer();
          for (var i in listuser) {
            ModelMainInOut model = ModelMainInOut.fromJson(i);
            await localGirisCixisServiz.addSelectedGirisCixisDBServer(model);
            listGirisCixis.add(model);
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
    setState(() {
      dataLoading=false;
    });
  }

  Future<String> getLanguageIndex() async {
    return await Hive.box("myLanguage").get("langCode") ?? "az";
  }

  Widget _widgetDatePicker(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.3,
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                  ctFistDay.text = DateTime.now().toString().substring(0, 10);
                  ctLastDay.text = DateTime.now().toString().substring(0, 10);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(bottom: 0),
                  child: Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "Ilkin tarix",
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker(true);
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctFistDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15),
              child: Row(
                children: [
                  CustomText(
                      labeltext: "Son tarix",
                      fontsize: 18,
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: CustomTextField(
                        align: TextAlign.center,
                        suffixIcon: Icons.date_range,
                        obscureText: false,
                        updizayn: true,
                        onTopVisible: () {
                          callDatePicker(false);
                        },
                        // suffixIcon: Icons.date_range,
                        hasBourder: true,
                        borderColor: Colors.black,
                        containerHeight: 50,
                        controller: ctLastDay,
                        inputType: TextInputType.datetime,
                        hindtext: "",
                        fontsize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevetedButton(
                surfaceColor: Colors.white,
                borderColor: Colors.green,
                textColor: Colors.green,
                fontWeight: FontWeight.w700,
                icon: Icons.refresh,
                clicble: true,
                elevation: 10,
                height: 40,
                width: MediaQuery.of(context).size.width * 0.4,
                cllback: () async {
                 await  getAllGirisCixis(ctFistDay.text,ctLastDay.text);
                },
                label: "Hesabat al")
          ],
        ),
      ),
    );
  }

  void callDatePicker(bool isFistDate) async {

    var order = await getDate();

    if (isFistDate) {
      //ctFistDay.text = "$day.$ay.${order.year}";
      ctFistDay.text = intl.DateFormat('yyyy/MM/dd').format(order!);

    } else {
      // ctLastDay.text = "$day.$ay.${order.year}"
      ctLastDay.text =  intl.DateFormat('yyyy/MM/dd').format(order!);

    }
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
  }
  
}