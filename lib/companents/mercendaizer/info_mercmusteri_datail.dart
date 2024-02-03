import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/companents/umumi_widgetler/cari_hesabat/marketuzre_hesabatlar.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenMercMusteriDetail extends StatefulWidget {
  ModelMercBaza modelMerc;
  List<ModelGirisCixis> listGirisCixis;
  List<UserModel> listUsers;

  ScreenMercMusteriDetail({required this.modelMerc, required this.listGirisCixis,required this.listUsers, super.key});

  @override
  State<ScreenMercMusteriDetail> createState() =>
      _ScreenMercMusteriDetailState();
}

class _ScreenMercMusteriDetailState extends State<ScreenMercMusteriDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          labeltext: widget.modelMerc.cariad!,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widgetSatisInfo(context),
            widgetInfoHesabatlar(context),
            widget.listGirisCixis.isEmpty ? SizedBox() : widgetZiyaretler(context)
          ],
        ),
      ),
    )));
  }

  widgetSatisInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0).copyWith(top: 0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(top: 7,right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  //height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.all(0.0).copyWith(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0)
                                  .copyWith(top: 10, left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        labeltext: "${"plan".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CustomText(
                                          labeltext:
                                              "${widget.modelMerc.plan} ${"manatSimbol".tr}",
                                          fontsize: 16),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        labeltext: "${"satis".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CustomText(
                                          labeltext:
                                              "${prettify(double.parse(widget.modelMerc.netsatis!).round() * 1)}${"manatSimbol".tr}",
                                          fontsize: 16),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        labeltext: "${"zaymal".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CustomText(
                                          labeltext:
                                              widget.modelMerc.qaytarma.toString() +
                                                  "${"manatSimbol".tr}",
                                          fontsize: 16),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.black,
                                    width: 180,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        labeltext: "${"ziyaretSayi".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CustomText(
                                          labeltext:
                                              widget.listGirisCixis.length.toString(),
                                          fontsize: 16),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        labeltext: "${"time".tr} : ",
                                        fontsize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CustomText(
                                          labeltext: curculateTimeDistanceForVisit(
                                              widget.listGirisCixis),
                                          fontsize: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            chartWidget(widget.modelMerc),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0).copyWith(left: 2,bottom: 2),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: _infoMarketRout(widget.modelMerc),
                              )),
                          ),
                          const SizedBox(width: 10,),
                          Center(child:CustomText(textAlign: TextAlign.center,labeltext: "Exp : ${widget.modelMerc.expeditor!}"))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: -8,
              right: -5,
              child: IconButton.filled(onPressed:_editMercCari, icon: const Icon(Icons.edit_note,),padding: const EdgeInsets.all(0),constraints: BoxConstraints(maxHeight: 50,minHeight: 30,maxWidth: 50,minWidth: 30),))
        ],
      ),
    );
  }

  widgetInfoHesabatlar(BuildContext context){
      return WidgetCarihesabatlar(cad:widget.modelMerc.cariad! , ckod: widget.modelMerc.carikod!, height: 100);
  }

  Widget _infoMarketRout(ModelMercBaza element) {
    int valuMore = 0;
    if (element.gun1.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun2.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun3.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun4.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun5.toString() == "1") {
      valuMore = valuMore + 1;
    }
    if (element.gun6.toString() == "1") {
      valuMore = valuMore + 1;
    }
    return SizedBox(
      height: valuMore > 4 ? 60 : 28,
      width: MediaQuery.of(context).size.width*0.70,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          element.gun1.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun1".tr)
              : const SizedBox(),
          element.gun2.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun2".tr)
              : const SizedBox(),
          element.gun3.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun3".tr)
              : const SizedBox(),
          element.gun4.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun4".tr)
              : const SizedBox(),
          element.gun5.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun5".tr)
              : const SizedBox(),
          element.gun6.toString() == "1"
              ? WidgetRutGunu(rutGunu: "gun6".tr)
              : const SizedBox(),
          element.gun7.toString() == "1"
              ? WidgetRutGunu(rutGunu: "bagli".tr)
              : const SizedBox(),
        ],
      ),
    );
  }

  String curculateTimeDistanceForVisit(List<ModelGirisCixis> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
      difference = difference +
          DateTime.parse(element.cixisTarix)
              .difference(DateTime.parse(element.girisTarix));
    }
    hours = hours + difference.inHours % 24;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  Widget chartWidget(ModelMercBaza element) {
    bool satiskecib = double.parse(element.netsatis!).round() >
        double.parse(element.plan!).round();
    final List<ChartData> chartData = [
      ChartData(
          "plan".tr, double.parse(element.netsatis!).round(), Colors.green),
      ChartData(
          'satis'.tr,
          satiskecib
              ? 0
              : double.parse(element.plan!).round() -
                  double.parse(element.netsatis!).round(),
          Colors.red),
    ];
    return SimpleChart(listCharts: chartData, height: 135, width: 150);
    return !satiskecib
        ? SimpleChart(listCharts: chartData, height: 60, width: 60)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified,
                color: Colors.green,
              ),
              element.plan == "0"
                  ? const SizedBox()
                  : CustomText(
                      labeltext:
                          "${prettify(double.parse(element.netsatis!).round() / double.parse(element.plan!) * 100)} %",
                      fontsize: 12,
                    )
            ],
          );
  }

  String prettify(double d) {
    return d.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  widgetZiyaretler(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            labeltext: "giriscixis".tr,
            fontsize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                itemCount: widget.listGirisCixis.length,
                itemBuilder: (c, index) {
                  return widgetListGirisItems(widget.listGirisCixis.elementAt(index));
                }),
          )
        ],
      ),
    );
  }

  Widget widgetListGirisItems(ModelGirisCixis model) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: model.rutUygunluq == "Sef" ? Colors.red : Colors.green,
          margin: const EdgeInsets.only(left: 2, right: 2, top: 10, bottom: 5),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomText(
                          labeltext: model.cariAd,
                          fontsize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          overflow: TextOverflow.ellipsis,
                          maxline: 2,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                    CustomText(labeltext: "girisVaxt".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.girisTarix.substring(11, 19)),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Image.asset(
                      "images/externalvisit.png",
                      width: 20,
                      height: 20,
                      color: Colors.red,
                    ),
                    CustomText(labeltext: "cixisVaxt".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.cixisTarix.substring(11, 19)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: "time".tr+" : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: carculateTimeDistace(
                            model.girisTarix, model.cixisTarix)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex:8,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                            maxline: 3,
                            fontsize: 12,
                            labeltext:"qeyd".tr+" : "+ model.ziyaretQeyd),
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: CustomText(
                          labeltext: "${model.girisTarix.substring(0, 10)}"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 15,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: model.rutUygunluq == "Sef"
                          ? Colors.red
                          : Colors.green,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              child: CustomText(
                fontsize: 12,
                labeltext:  model.rutUygunluq == "Sef"
                    ? "wrong".tr
                    : "right".tr,
                color:  model.rutUygunluq == "Sef"
                    ? Colors.red
                    : Colors.green,
              ),
            ))
      ],
    );
  }
  String carculateTimeDistace(String? girisvaxt, String? cixisvaxt) {
    Duration difference =
    DateTime.parse(cixisvaxt!).difference(DateTime.parse(girisvaxt!));
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }


  void _editMercCari() {
    Get.toNamed(RouteHelper.getScreenEditMercMusteri(),arguments: [widget.modelMerc,widget.listUsers]);
  }
}
