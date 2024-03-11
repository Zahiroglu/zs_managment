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
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import '';
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
    modelRutPerform.value=await localBaseDownloads.getRutDatail(loggedUserModel.userModel);
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
                      )))
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
                            children: [
                              CustomText(
                                labeltext: "welcome".tr,
                                fontsize: 28,
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
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            labeltext:
                                "${loggedUserModel.userModel!.name!} ${loggedUserModel.userModel!.surname!}",
                            fontsize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          CustomText(
                            labeltext:
                                "${loggedUserModel.userModel!.moduleName!} | ${loggedUserModel.userModel!.roleName!} | ${loggedUserModel.userModel!.code!}",
                            fontsize: 12,
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

  Widget getDownloadMenu(BuildContext context) {
    return screenLoading.isFalse
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        border: Border.all(color: Colors.grey, width: 0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: CustomText(
                                  labeltext: "Umumi Yenileme sayi : ${listDonwloads.length}",
                                  fontsize: 12),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 2),
                              child: CustomText(
                                labeltext: "Yenilenmeli baza sayi : ${listDonwloads.where((element) => element.musteDonwload==true).toList().length}",
                                fontsize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            iconSize: 35,
                            onPressed: () {},
                            icon: Icon(Icons.refresh))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ));
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
    return modelRutPerform.value.snSayi!=null?Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: InkWell(
        onTap: () async {
        await Get.toNamed(RouteHelper.mobileGirisCixisHesabGunluk,arguments: modelRutPerform.value);

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5,bottom: 5),
              child: CustomText(
                labeltext: "Gunluk Giris-Cixislar",
                fontWeight: FontWeight.bold,
                fontsize: 18,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widgetSimpleTextInfo("Umumi musteriler : ",modelRutPerform.value.snSayi.toString()),
                        widgetSimpleTextInfo("Cari rut : ",modelRutPerform.value.rutSayi.toString()),
                        widgetSimpleTextInfo("Duz ziyaret : ",modelRutPerform.value.duzgunZiya.toString()),
                        widgetSimpleTextInfo("Sef ziyaret : ",modelRutPerform.value.rutkenarZiya.toString()),
                        widgetSimpleTextInfo("Umumi ziyaret : ",modelRutPerform.value.listGirisCixislar!.length.toString()),
                        widgetSimpleTextInfo("Ziyaret edilmeyen : ",modelRutPerform.value.ziyaretEdilmeyen.toString()),
                        widgetSimpleTextInfo("Sn-lerde is vaxti : ",modelRutPerform.value.snlerdeQalma.toString()),
                        widgetSimpleTextInfo("Umumi is vaxti : ",modelRutPerform.value.umumiIsvaxti.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        chartWidget(),
                        CustomText(labeltext: "Ziyaret Diagrami", fontsize: 10),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ):const SizedBox();

  }

  Widget widgetSimpleTextInfo(String lable,String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 150,
            child: CustomText(labeltext: lable,fontWeight: FontWeight.w600)),
        Expanded(child: CustomText(labeltext: value)),
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

}
