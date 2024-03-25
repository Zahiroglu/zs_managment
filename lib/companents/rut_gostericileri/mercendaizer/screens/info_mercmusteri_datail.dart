import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zs_managment/companents/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/hesabatlar/cari_hesabat/marketuzre_hesabatlar.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/controller_mercpref.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenMercMusteriDetail extends StatefulWidget {
  ControllerMercPref controllerMercPref;


  ScreenMercMusteriDetail(
      {required this.controllerMercPref,
      super.key});

  @override
  State<ScreenMercMusteriDetail> createState() =>
      _ScreenMercMusteriDetailState();
}

class _ScreenMercMusteriDetailState extends State<ScreenMercMusteriDetail>
    with TickerProviderStateMixin {
  var _scrollControllerNested;
  late TabController tabController;
  List<String> listTabItems = [];
  final int _initialIndex = 0;
  int tabinitialIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    listTabItems.add("planSatis".tr);
    listTabItems.add("ziyaretler".tr);
    tabController = TabController(
      initialIndex: tabinitialIndex,
      length: listTabItems.length,
      vsync: this,
    );
    _scrollControllerNested = ScrollController();
    _controller =
        PageController(initialPage: _initialIndex, viewportFraction: 1);
    _controller.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollControllerNested,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverSafeArea(
                  sliver: SliverAppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    expandedHeight: 430,
                    pinned: true,
                    floating: false,
                    stretch: true,
                    title: CustomText(labeltext: widget.controllerMercPref.selectedMercBaza.value.user!.name),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.blurBackground],
                      background: Column(
                        children: [
                          widgetSatisInfo(context),
                          const SizedBox(
                            height: 10,
                          ),
                          widgetInfoHesabatlar(context)
                        ],
                      ),
                      collapseMode: CollapseMode.values[0],
                      centerTitle: true,
                    ),
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: ColoredBox(
                          color: Colors.white,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.teal,
                            child: TabBar(
                              physics: const NeverScrollableScrollPhysics(),
                              onTap: (index) {
                                setState(() {
                                  tabinitialIndex == index;
                                });
                              },
                              dividerColor: Colors.white,
                              splashBorderRadius: BorderRadius.circular(10),
                              indicatorColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: const EdgeInsets.all(0),
                              unselectedLabelColor: Colors.black,
                              dividerHeight: 1,
                              labelColor: Colors.white,
                              controller: tabController,
                              tabs: listTabItems
                                  .map((element) => Tab(
                                        iconMargin: const EdgeInsets.all(5),
                                        child: Text(element.toString(),
                                            textAlign: TextAlign.center),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )),
                  ),
                )
              ];
            },
            body: pagetViewInfo(),
          ),
        ),
      ),
    );
  }

  widgetSatisInfo(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(5.0).copyWith(top: 40),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0).copyWith(top: 7, right: 5),
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
                        padding: const EdgeInsets.all(0.0)
                            .copyWith(left: 5, right: 5),
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
                                          "${widget.controllerMercPref.selectedCustomers.value.totalPlan} ${"manatSimbol".tr}",
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
                                          "${prettify(widget.controllerMercPref.selectedCustomers.value.totalSelling!.round() * 1)}${"manatSimbol".tr}",
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
                                          labeltext: "${widget.controllerMercPref.selectedCustomers.value.totalRefund!.round()}${"manatSimbol".tr}",
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
                                          labeltext: widget.controllerMercPref.listGirisCixislar.length
                                              .toString(),
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
                                          labeltext:
                                          curculateTimeDistanceForVisit(widget.controllerMercPref.listGirisCixislar),
                                          fontsize: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            chartWidget(widget.controllerMercPref.selectedCustomers.value),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0)
                                .copyWith(left: 2, bottom: 2),
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: _infoMarketRout(
                                      widget.controllerMercPref.selectedCustomers.value, context),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
              child: IconButton.filled(
                onPressed: _editMercCari,
                icon: const Icon(
                  Icons.edit_note,
                ),
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(
                    maxHeight: 50, minHeight: 30, maxWidth: 50, minWidth: 30),
              ))
        ],
      ),
    ));
  }

  widgetInfoHesabatlar(BuildContext context) {
    return Obx(() => WidgetCarihesabatlar(
        cad: widget.controllerMercPref.selectedMercBaza.value.user!.name, ckod: widget.controllerMercPref.selectedMercBaza.value.user!.code, height: 100));
  }

  Widget _infoMarketRout(MercCustomersDatail element, BuildContext context) {
    int valuMore = 0;
    if (element.days!.any((element) => element.day == 1)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day == 2)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day == 3)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day == 4)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day == 5)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day == 6)) {
      valuMore = valuMore + 1;
    }
    return SizedBox(
      height: valuMore > 5 ? 60 : 28,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          element.days!.any((element) => element.day == 1)
              ? WidgetRutGunu(rutGunu: "gun1".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day == 2)
              ? WidgetRutGunu(rutGunu: "gun2".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day == 3)
              ? WidgetRutGunu(rutGunu: "gun3".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day == 4)
              ? WidgetRutGunu(rutGunu: "gun4".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day == 5)
              ? WidgetRutGunu(rutGunu: "gun5".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day == 6)
              ? WidgetRutGunu(rutGunu: "gun6".tr)
              : const SizedBox(),
          element.days!.any((element) => element.day == 7)
              ? WidgetRutGunu(rutGunu: "bagli".tr)
              : const SizedBox(),
        ],
      ),
    );
  }

  String curculateTimeDistanceForVisit(List<ModelInOut> list) {
    int hours = 0;
    int minutes = 0;
    Duration difference = Duration();
    for (var element in list) {
      difference = difference +
          DateTime.parse(element.inDate)
              .difference(DateTime.parse(element.outDate));
    }
    hours = hours + difference.inHours % 24;
    minutes = minutes + difference.inMinutes % 60;
    if (hours < 1) {
      return "$minutes deq";
    } else {
      return "$hours saat $minutes deq";
    }
  }

  Widget chartWidget(MercCustomersDatail element) {
    bool satiskecib = element.totalSelling! > 0;
    final List<ChartData> chartData = [
      ChartData("plan".tr, element.totalSelling!.round(), Colors.green),
      ChartData(
          'satis'.tr,
          satiskecib
              ? 0
              : element.totalPlan!.round() - element.totalSelling!.round(),
          Colors.red),
    ];
    return SimpleChart(listCharts: chartData, height: 130, width: 150);
  }

  Widget chartWidgetSimple(SellingData element) {
    bool satiskecib = element.selling > 0;
    final List<ChartData> chartData = [
      ChartData("plan".tr, element.selling.round(), Colors.green),
      ChartData(
          'satis'.tr,
          satiskecib ? 0 : element.plans.round() - element.selling.round(),
          Colors.red),
    ];
    return SimpleChart(listCharts: chartData, height: 135, width: 150);
  }

  String prettify(double d) {
    return d.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  Widget pagetViewInfo() {
    return PageView(
      onPageChanged: _onPageViewChange,
      physics: const ClampingScrollPhysics(),
      controller: _controller,
      children: [widgetSatisDetail(context), widgetZiyaretler(context)],
    );
  }

  widgetSatisDetail(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(10.0),
      child:widget.controllerMercPref.selectedCustomers.value.sellingDatas!.isNotEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.controllerMercPref.selectedCustomers.value.sellingDatas!.length,
                itemBuilder: (c, index) {
                  return widgetSatisDetal(
                      widget.controllerMercPref.selectedCustomers.value.sellingDatas!.elementAt(index));
                }),
          )
        ],
      )
          : Center(
        child: CustomText(labeltext: "melumattapilmadi".tr),
      ),
    ));
  }

  widgetSatisDetal(SellingData element) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
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
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          height: 80,
                          width: 80,
                          child: chartWidgetSimple(element))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  widgetZiyaretler(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:  widget.controllerMercPref.listGirisCixislar.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount:  widget.controllerMercPref.listGirisCixislar.length,
                      itemBuilder: (c, index) {
                        return widgetListGirisItems(
                            widget.controllerMercPref.listGirisCixislar.elementAt(index));
                      }),
                )
              ],
            )
          : Center(
              child: CustomText(labeltext: "melumattapilmadi".tr),
            ),
    );
  }

  Widget widgetListGirisItems(ModelInOut model) {
    return Stack(
      children: [
        Card(
          elevation: 5,
         // shadowColor: model.rutUygunluq == "Sef" ? Colors.red : Colors.green,
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
                      labeltext: model.customerName,
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
                    CustomText(labeltext: "girisVaxt".tr + " : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.inDate.substring(11, 19)),
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
                    CustomText(labeltext: "cixisVaxt".tr + " : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(labeltext: model.outDate.substring(11, 19)),
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
                    CustomText(labeltext: "time".tr + " : "),
                    const SizedBox(
                      width: 2,
                    ),
                    CustomText(
                        labeltext: carculateTimeDistace(
                            model.inDate, model.outDate)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                            maxline: 3,
                            fontsize: 12,
                            labeltext: "qeyd".tr + " : " + model.outNote),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomText(
                          labeltext: "${model.inDate.substring(0, 10)}"),
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
                  // border: Border.all(
                  //     color: model. == "Sef"
                  //         ? Colors.red
                  //         : Colors.green,
                  //     width: 0.4),
                  borderRadius: BorderRadius.circular(5)),
              // child: CustomText(
              //   fontsize: 12,
              //   labeltext: model.rutUygunluq == "Sef" ? "wrong".tr : "right".tr,
              //   color: model.rutUygunluq == "Sef" ? Colors.red : Colors.green,
              // ),
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

  Future<void> _editMercCari() async {
    String dey=await Get.toNamed(RouteHelper.getScreenEditMercMusteri(), arguments: [widget.controllerMercPref]);
    setState(() {
      print("dey :"+dey.toString());
    });
  }

  void _onPageViewChange(int value) {
    setState(() {
      tabController.animateTo(value);
    });
  }
}
