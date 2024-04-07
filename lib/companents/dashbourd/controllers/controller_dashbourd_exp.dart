import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/dashbourd/models/model_rut_perform.dart';
import 'package:zs_managment/companents/local_bazalar/local_giriscixis.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/umumi_widgetler/widget_rut_performans.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '';
import '../../../global_models/model_appsetting.dart';
import '../../../widgets/custom_eleveted_button.dart';
import '../../local_bazalar/local_app_setting.dart';
import '../../local_bazalar/local_db_downloads.dart';
import '../../base_downloads/models/model_downloads.dart';
import '../../giris_cixis/models/model_giriscixis.dart';
import '../../local_bazalar/local_users_services.dart';

class ControllerDashBorudExp extends GetxController {
  LocalUserServices userServices = LocalUserServices();
  RxBool screenLoading = true.obs;
  LoggedUserModel loggedUserModel = LoggedUserModel();
  LocalGirisCixisServiz localGirisCixisServiz = LocalGirisCixisServiz();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();
  ModelGirisCixis modelLastGiris = ModelGirisCixis();
  List<ModelDownloads> listDonwloads=[];
  List<ModelGirisCixis> listGirisCixislar=[];
  Rx<ModelRutPerform> modelRutPerform=ModelRutPerform().obs;
  RxList<ModelUserPermissions> listPermitions=List<ModelUserPermissions>.empty(growable: true).obs;
  LocalAppSetting localAppSetting = LocalAppSetting();
  ModelAppSetting modelAppSetting = ModelAppSetting(mapsetting: null, girisCixisType: "map",userStartWork: false);
  @override
  onInit() {
    initializeBazalar();
    super.onInit();
  }

  initializeBazalar() async {
    await localBaseDownloads.init();
    await userServices.init();
    await localGirisCixisServiz.init();
    loggedUserModel = userServices.getLoggedUser();
    listPermitions.value = loggedUserModel
        .userModel!.permissions!
        .where((element) => element.category == 1)
        .toList();
    getInfoAboudEnter();
    getInfoAboutDownloads();
    getAllGunlukGirisCixis();
    getRutPerformToday();
    screenLoading = false.obs;
    update();
  }

  Future<void> getInfoAboudEnter() async {
    await localGirisCixisServiz.init();
    modelLastGiris = await localGirisCixisServiz.getGirisEdilmisMarket();
  }

  Future<void> getInfoAboutDownloads() async{
    listDonwloads= localBaseDownloads.getAllDownLoadBaseList();
    update();
  }

  Future<void> getAllGunlukGirisCixis() async{
    listGirisCixislar=await localGirisCixisServiz.getAllGirisCixis();
    update();
  }

  Future<void> getRutPerformToday() async{
    modelRutPerform.value=await localBaseDownloads.getRutDatail(true,"");
    update();
  }

  Widget widgetInfoEnter(BuildContext context) {
    return modelLastGiris.girisvaxt!=null?Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5,bottom: 5),
            child: CustomText(
              labeltext: "Sonuncu giris emeliyyati",
              fontWeight: FontWeight.bold,
              fontsize: 18,
            ),
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey,width: .5),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontWeight: FontWeight.bold,
                      labeltext: modelLastGiris.cariad!,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        CustomText(
                          labeltext: "Giris saati : ",
                          color: Colors.grey,
                        ),
                        CustomText(
                          labeltext:
                              modelLastGiris.girisvaxt!.substring(0, 19),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    modelLastGiris.cixisvaxt == "0"
                        ? Row(
                            children: [
                              CustomText(
                                labeltext: "Qalma vaxti :",
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(labeltext: "Cixis edilmeyib..."),
                            ],
                          )
                        : Row(
                            children: [
                              CustomText(labeltext: "Cixis saati : "),
                              CustomText(
                                  labeltext:
                                      "${modelLastGiris.cixisvaxt!.substring(0, 19)}"),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    modelLastGiris.cixisvaxt == "0"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CustomText(labeltext: "Cixis etmeyi unutmayin"),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  right: 10,
                  child: DecoratedBox(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(1,1),
                            blurStyle: BlurStyle.outer,
                            blurRadius: 1,
                            spreadRadius: 1
                          )
                        ],
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                          fontsize: 12,
                          labeltext: getTimeNow(modelLastGiris.girisvaxt!,
                              modelLastGiris.cixisvaxt),
                          color: Colors.blueAccent,
                        ),
                      ))),
            ],
          ),
        ],
      ),
    ):SizedBox();
  }

  Widget getUserInfoField(BuildContext context) {
    ScreenUtil.init(context);
    return screenLoading.isFalse
        ? Padding(
            padding: const EdgeInsets.only(left: 20, top: 35),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                labeltext: "welcome".tr,
                                fontsize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.5),
                                  border: Border.all(
                                      color: Colors.black, width: 0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                height: 25,
                                width: 90,
                                child: Center(
                                    child: CustomText(
                                        color: Colors.white,
                                        labeltext: DateTime.now()
                                            .toIso8601String()
                                            .substring(0, 10))),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            labeltext:
                                "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
                            fontsize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          CustomText(
                            labeltext:
                                "${loggedUserModel.userModel!.moduleName!} | ${loggedUserModel.userModel!.roleName!} | ${loggedUserModel.userModel!.code!}",
                            fontsize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          )
                        ],
                      ),
                    )),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
  }


  Widget widgetHesabatlar(BuildContext context) {
    return screenLoading.isFalse
        ?listPermitions.isNotEmpty? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: CustomText(
                            color: Colors.black,
                            fontsize: 18,
                            labeltext:
                                "Menular ( ${loggedUserModel.userModel!.permissions!.where((element) => element.category == 1).toList().length} )"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listPermitions
                          .map((e) => widgetItemsForMenular(e))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ):SizedBox()
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ));

  }

  Widget widgetItemsForMenular(ModelUserPermissions model) {
    int indexitem = loggedUserModel.userModel!.permissions!.indexOf(model);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                //border: Border.all(color: Colors.black,width: 0.1),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      blurStyle: BlurStyle.outer)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    IconData(model.icon!, fontFamily: 'MaterialIcons'),
                    color: Colors.primaries[indexitem],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    labeltext: model.name!,
                    fontsize: 14,
                    maxline: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetGunlukGirisCixislar(BuildContext context){
    return Column(
      children: [
        WidgetRutPerformans(modelRutPerform: modelRutPerform.value,),
      ],
    );

  }


  Widget chartWidget(){
    final List<ChartData> chartData = [
      ChartData("Rut gunu", modelRutPerform.value.rutSayi!-modelRutPerform.value.duzgunZiya!,Colors.red),
      ChartData('Ziyaret', modelRutPerform.value.duzgunZiya!,Colors.green),
    ];
    return SimpleChart(listCharts: chartData,height: 120,width: 150,);
  }

  getTimeNow(String? girisvaxt, String? cixisvaxt) {
    DateTime girisVaxt = DateTime.parse(girisvaxt!);
    DateTime cixisVaxt = DateTime.now();
    if (cixisvaxt != "0") {
      cixisVaxt = DateTime.parse(cixisvaxt!);
    }
    Duration diff = girisVaxt.difference(cixisVaxt);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) {
      return "$hours saat $minutes deq";
    } else {
      return "$minutes deq";
    }
  }

  Future<void> stopTodayWork() async {
    await localAppSetting.init();
    modelAppSetting = await localAppSetting.getAvaibleMap();
    modelAppSetting.userStartWork=false;
    localAppSetting.addSelectedMyTypeToLocalDB(modelAppSetting);
    Get.offAllNamed(RouteHelper.bazaDownloadMobile);
  }

}
