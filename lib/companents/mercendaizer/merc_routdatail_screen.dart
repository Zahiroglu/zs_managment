import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_giriscixis.dart';
import 'package:zs_managment/companents/mercendaizer/controller_mercpref.dart';
import 'package:zs_managment/companents/mercendaizer/model_mercbaza.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_gunluk_giriscixis.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';
import '../login/services/api_services/users_controller_mobile.dart';

class ScreenMercRoutDatail extends StatefulWidget {
  List<ModelMercBaza> modelMercBaza;
  List<ModelGirisCixis> listGirisCixis;
  List<UserModel> listUsers;

  ScreenMercRoutDatail({required this.modelMercBaza,required this.listGirisCixis,required this.listUsers, super.key});

  @override
  State<ScreenMercRoutDatail> createState() => _ScreenMercRoutDatailState();
}

class _ScreenMercRoutDatailState extends State<ScreenMercRoutDatail> with TickerProviderStateMixin {
  ControllerMercPref controllerRoutDetailUser = Get.put(ControllerMercPref());
  late TabController tabController;
  late PageController _controller;
  late PageController _controllerIki;
  final int _initialIndex = 0;
  var _scrollControllerNested;
  int tabinitialIndex = 0;
  List<Widget> listHeaderWidgets = [];
  List<Widget> listBodyWidgets = [];
  late AnimationController _animationController;
  String selectedGunIndex = "1-ci Gun";
  int t=0; //Tid
  double p=0; //Position

  @override
  void initState() {
    melumatlariGuneGoreDoldur();
    _scrollControllerNested = ScrollController();
    _controller = PageController(initialPage: _initialIndex, viewportFraction:  1);
    _controllerIki = PageController(initialPage: _initialIndex, viewportFraction:  1);
    _controllerIki.addListener(() {
      setState(() {
      });
    });
    _controller.addListener(() {
      setState(() {
        _controllerIki.animateTo(_controller.position.pixels, duration: Duration(milliseconds: 1000), curve:  Curves.easeOutCubic);
      });
    });
    if (controllerRoutDetailUser.initialized) {
      controllerRoutDetailUser.getAllCariler(widget.modelMercBaza, widget.listGirisCixis);
      _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 5000));
      _animationController.forward();
     fillAllPages();
    }
    tabController = TabController(
      initialIndex: tabinitialIndex,
      length: controllerRoutDetailUser.listTabItems.length,
      vsync: this,
    );
    tabController.addListener(() {});
    super.initState();
  }
  void melumatlariGuneGoreDoldur() {
    DateTime dateTime = DateTime.now();
    switch (dateTime.weekday) {
      case 1:
        selectedGunIndex = "gun1".tr.toString();
        break;
      case 2:
        selectedGunIndex = "gun2".tr.toString();
        break;
      case 3:
        selectedGunIndex = "gun3".tr.toString();
        break;
      case 4:
        selectedGunIndex = "gun4".tr.toString();
        break;
      case 5:
        selectedGunIndex = "gun5".tr.toString();
        break;
      case 6:
        selectedGunIndex = "gun6".tr.toString();
        break;
    }
    setState(() {
    });
  }

  void fillAllPages() {
    listBodyWidgets.clear();
    listHeaderWidgets.clear();
    listBodyWidgets.add(_pageViewUmumiCariler());
    listHeaderWidgets.add(infoSatisMenu());
    listBodyWidgets.add(_pageViewUmumiRutGunleri());
    listHeaderWidgets.add(infoRutGunleri());
    if (controllerRoutDetailUser.listZiyeretEdilmeyenler.isNotEmpty) {
      listHeaderWidgets.add(infoZiyaretEdilmeyenler());
      listBodyWidgets.add(_pageViewUmumiZiyeretEdilmeyenler());
    }
    listHeaderWidgets.add(infoZiyaretTarixcesi());
    listBodyWidgets.add(_pageViewZiyaretTarixcesi());
  }

  @override
  void dispose() {
    _animationController.dispose();
    tabController.dispose();
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body:  NestedScrollView(
              controller: _scrollControllerNested,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  Obx(() => SliverSafeArea(
                        sliver: SliverAppBar(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          centerTitle: false,
                          expandedHeight: tabinitialIndex == 0
                              ? 380
                              : tabinitialIndex == 1
                                  ? 320
                                  : 225,
                          pinned: true,
                          floating: false,
                          stretch: true,
                          title: CustomText(
                              labeltext: widget.modelMercBaza.first.mercadi!),
                          flexibleSpace: FlexibleSpaceBar(
                            stretchModes: const [StretchMode.blurBackground],
                            background: pagetViewInfo(),
                            collapseMode: CollapseMode.values[0],
                            centerTitle: true,
                          ),
                          bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(50),
                              child: ColoredBox(
                                color: Colors.white,
                                child: TabBar(
                                  physics: const NeverScrollableScrollPhysics(),
                                  onTap: (index) {
                                    setState(() {
                                      tabinitialIndex == index;
                                      _controller.jumpToPage(index);
                                    });
                                  },
                                  dividerColor: Colors.grey,
                                  splashBorderRadius: BorderRadius.circular(10),
                                  indicatorColor: Colors.green,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorPadding: const EdgeInsets.all(0),
                                  unselectedLabelColor: Colors.black,
                                  dividerHeight: 1,
                                  labelColor: Colors.red,
                                  controller: tabController,
                                  tabs: controllerRoutDetailUser.listTabItems
                                      .map((element) => Tab(
                                            iconMargin: const EdgeInsets.all(5),
                                            child: Text(element.label!,
                                                textAlign: TextAlign.center),
                                          ))
                                      .toList(),
                                ),
                              )),
                        ),
                      ))
                ];
              },
              body: PageView(
                onPageChanged: _onPageViewChange,
                controller: _controller,
                children: listBodyWidgets.toList(),
              ),
            ),
          ),
        ),
    );
  }

  Widget pagetViewInfo() {
    return PageView(
      onPageChanged: _onPageViewChange,
      physics: const ClampingScrollPhysics(),
      controller: _controllerIki,
      children: listHeaderWidgets.toList(),
    );
  }

  ///info Umumi cariler
  Widget _pageViewUmumiCariler() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listSelectedMercBaza.length,
        itemBuilder: (con, index) {
          return itemsCustomers(
              controllerRoutDetailUser.listSelectedMercBaza.elementAt(index));
        });
  }

  Widget itemsCustomers(ModelMercBaza element) {
    return InkWell(
      onTap: (){
        Get.toNamed(RouteHelper.screenMercMusteriDetail,arguments: [element,widget.listGirisCixis.where((e) => e.cariAd==element.cariad).toList(),widget.listUsers]);
      },
      child: Card(
        surfaceTintColor: Colors.white,
        margin: const EdgeInsets.all(10),
        elevation: 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.3)),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0).copyWith(left: 10, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        labeltext: element.cariad!,
                        fontWeight: FontWeight.w600,
                        maxline: 3,
                        fontsize: 16),
                    const SizedBox(
                      height: 2,
                    ),
                    _infoMarketMotivasion(element),
                    const SizedBox(
                      height: 5,
                    ),
                    _infoMarketRout(element)
                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  left: 5,
                  child: Center(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: double.parse(element.plan!) <
                                  double.parse(element.netsatis!)
                              ? Colors.green
                              : Colors.red),
                      child: element.rutSirasi.toString() == "null"
                          ? SizedBox()
                          : Center(
                              child: CustomText(
                                  labeltext: element.rutSirasi.toString())),
                    ),
                  )),
              Positioned(
                  top: 5,
                  right: 8,
                  child: Center(
                      child: CustomText(
                    labeltext: element.carikod.toString(),
                    fontsize: 10,
                    fontWeight: FontWeight.w700,
                  )))
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoMarketMotivasion(ModelMercBaza element) {
    return DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"temKod".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext: element.expeditor!, fontsize: 12),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"Ziyaret sayi".tr} : ",
                                  fontsize: 12),
                              CustomText(
                                  labeltext: element.ziyaretSayi.toString(),
                                  fontsize: 12),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"Vaxt".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext: element.sndeQalmaVaxti!,
                                  fontsize: 12),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.black,
                    width: 1,
                    margin: EdgeInsets.only(left: 5, right: 5),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"plan".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext:
                                      "${controllerRoutDetailUser.prettify(double.parse(element.plan!))} ${"manatSimbol".tr}",
                                  fontsize: 12),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"satis".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext:
                                      "${controllerRoutDetailUser.prettify(double.parse(element.netsatis!))} ${"manatSimbol".tr}",
                                  fontsize: 12),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                  labeltext: "${"zaymal".tr} : ", fontsize: 12),
                              CustomText(
                                  labeltext:
                                      "${controllerRoutDetailUser.prettify(double.parse(element.qaytarma!))} ${"manatSimbol".tr}",
                                  fontsize: 12),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 3, child: chartWidget(element)),
                ],
              )
            ],
          ),
        ));
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
      width: 250,
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

  Widget infoSatisMenu() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10)
                .copyWith(top: 50, bottom: 60),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.green,
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 4)
                ],
                color: Colors.white,
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            // height: MediaQuery.of(context).size.height * 0.45,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        CustomText(
                          labeltext: "${"userCode".tr} : ",
                          fontsize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          labeltext: controllerRoutDetailUser
                              .listSelectedMercBaza.first.rutadi!,
                          fontsize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0).copyWith(top: 0),
                    child: Row(
                      children: [
                        CustomText(
                          labeltext: "${"marketSayi".tr} : ",
                          fontsize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          labeltext:
                              "${controllerRoutDetailUser.listSelectedMercBaza.length} ${"market".tr}",
                          fontsize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 5,
                                      color: Colors.grey,
                                      offset: Offset(2, 2))
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0)
                                  .copyWith(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: CustomText(
                                              labeltext: "plan".tr,
                                              fontsize: 14,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold)),
                                      Image.asset(
                                        "images/plansatis.png",
                                        width: 25,
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                      height: 1,
                                      color: Colors.orange,
                                      thickness: 2),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    fontWeight: FontWeight.bold,
                                    fontsize: 18,
                                    latteSpacer: 1,
                                    labeltext:
                                        "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listSelectedMercBaza.fold(0.0, (sum, element) => sum + double.parse(element.plan.toString())))} ${"manatSimbol".tr}",
                                    color: Colors.orange,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 5,
                                      color: Colors.grey,
                                      offset: Offset(2, 2))
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0)
                                  .copyWith(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: CustomText(
                                              labeltext: "satis".tr,
                                              fontsize: 14,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold)),
                                      Image.asset(
                                        "images/dollar.png",
                                        width: 25,
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                      height: 1,
                                      color: Colors.blue,
                                      thickness: 2),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        CustomText(
                                          fontWeight: FontWeight.bold,
                                          fontsize: 16,
                                          latteSpacer: 1,
                                          labeltext:
                                              "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listSelectedMercBaza.fold(0.0, (sum, element) => sum + double.parse(element.netsatis.toString())))} ${"manatSimbol".tr}",
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 5,
                                      color: Colors.grey,
                                      offset: Offset(2, 2))
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0)
                                  .copyWith(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: CustomText(
                                              labeltext: "zaymal".tr,
                                              fontsize: 14,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.bold)),
                                      Image.asset(
                                        "images/zaymal.png",
                                        width: 25,
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                      height: 1,
                                      color: Colors.red,
                                      thickness: 2),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    fontWeight: FontWeight.bold,
                                    fontsize: 16,
                                    latteSpacer: 1,
                                    labeltext:
                                        "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listSelectedMercBaza.fold(0.0, (sum, element) => sum + double.parse(element.qaytarma.toString())))} ${"manatSimbol".tr}",
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _widgetMotivasiya(),
                  )
                ],
              ),
            ),
          ),
          controllerRoutDetailUser.planFizi >= 100
              ? Positioned(
                  top: 0,
                  bottom: 0,
                  right: 100,
                  child: Lottie.asset("lottie/tebrikler.json",
                      width: 200,
                      height: 200,
                      controller: _animationController,
                      repeat: false,
                      fit: BoxFit.fill))
              : const SizedBox(),
          Positioned(
              top: 55,
              right: 15,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: controllerRoutDetailUser.totalPrim >= 0
                          ? Colors.green
                          : Colors.red),
                  child: Center(
                    child: CustomText(
                      labeltext:
                          "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.totalPrim)} ${"manatSimbol".tr}",
                      fontWeight: FontWeight.bold,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _widgetMotivasiya() {
    return Stack(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    labeltext: "Motivasiya", fontWeight: FontWeight.w700),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          CustomText(
                              labeltext: "Net satisdan :",
                              fontWeight: FontWeight.w700),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.netSatisdanPul)} ${"manatSimbol".tr}"),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          CustomText(
                              labeltext: "Plandan :",
                              fontWeight: FontWeight.w700),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.plandanPul)} ${"manatSimbol".tr}"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          CustomText(
                              labeltext: "Plan %-le :",
                              fontWeight: FontWeight.w700),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.planFizi)} %"),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          CustomText(
                              labeltext: "Zaymaldan :",
                              fontWeight: FontWeight.w700),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.cerimePul)} ${"manatSimbol".tr}"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          CustomText(
                              labeltext: "Zaymal %-le :",
                              fontWeight: FontWeight.w700),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.zaymalFaizi)} %"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget chartWidget(ModelMercBaza element) {
    bool satiskecib = double.parse(element.netsatis!).round() >
        double.parse(element.plan!).round();
    final List<ChartData> chartData = [
      ChartData(
          "plan".tr, (double.parse(element.netsatis!).round()), Colors.green),
      ChartData(
          'satis'.tr,
          satiskecib
              ? 0
              : double.parse(element.plan!).round() -
                  double.parse(element.netsatis!).round(),
          Colors.red),
    ];
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
                          "${controllerRoutDetailUser.prettify(double.parse(element.netsatis!).round() / double.parse(element.plan!) * 100)} %",
                      fontsize: 12,
                    )
            ],
          );
  }

  /// info rutgunleri musteriler
  Widget _pageViewUmumiRutGunleri() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listRutGunleri.length,
        itemBuilder: (con, index) {
          return itemsCustomers(
              controllerRoutDetailUser.listRutGunleri.elementAt(index));
        });
  }

  Widget infoRutGunleri() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10)
                .copyWith(top: 50, bottom: 60),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.green,
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 4)
                ],
                color: Colors.white,
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            // height: MediaQuery.of(context).size.height * 0.45,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _itemIndoMenuRutGunu(
                            "gun1".tr.toString(),
                            controllerRoutDetailUser.listSelectedMercBaza
                                .where((p0) => p0.gun1 == "1")
                                .toList()
                                .length,1),
                        _itemIndoMenuRutGunu(
                            "gun2".tr.toString(),
                            controllerRoutDetailUser.listSelectedMercBaza
                                .where((p0) => p0.gun2 == "1")
                                .toList()
                                .length,2),
                        _itemIndoMenuRutGunu(
                            "gun3".tr.toString(),
                            controllerRoutDetailUser.listSelectedMercBaza
                                .where((p0) => p0.gun3 == "1")
                                .toList()
                                .length,3),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _itemIndoMenuRutGunu(
                            "gun4".tr.toString(),
                            controllerRoutDetailUser.listSelectedMercBaza
                                .where((p0) => p0.gun4 == "1")
                                .toList()
                                .length,4),
                        _itemIndoMenuRutGunu(
                            "gun5".tr.toString(),
                            controllerRoutDetailUser.listSelectedMercBaza
                                .where((p0) => p0.gun5 == "1")
                                .toList()
                                .length,5),
                        _itemIndoMenuRutGunu(
                            "gun6".tr.toString(),
                            controllerRoutDetailUser.listSelectedMercBaza
                                .where((p0) => p0.gun6 == "1")
                                .toList()
                                .length,6),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _itemIndoMenuRutGunu(String rutGunu, int length, int gunInt) {
    return InkWell(
      onTap: () {
        selectedGunIndex = rutGunu.toString();
        controllerRoutDetailUser.changeRutGunu(gunInt);
        fillAllPages();
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color:
              selectedGunIndex.endsWith(rutGunu) ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(
              selectedGunIndex.endsWith(rutGunu) ? 20 : 10),
          border: Border.all(
              color: selectedGunIndex.endsWith(rutGunu)
                  ? Colors.black
                  : Colors.black12,
              width: 1),
        ),
        height: 55,
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                CustomText(
                  labeltext: rutGunu.toString(),
                  fontWeight: selectedGunIndex.endsWith(rutGunu)
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: selectedGunIndex.endsWith(rutGunu)
                      ? Colors.white
                      : Colors.black,
                ),
                const Divider(height: 1,color: Colors.black,endIndent: 40,indent: 40),
                CustomText(
                  labeltext: length.toString()+" "+ "market".tr,
                  fontWeight: selectedGunIndex.endsWith(rutGunu)
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color: selectedGunIndex.endsWith(rutGunu)
                      ? Colors.white
                      : Colors.black,
                ),
              ],
            ),
            Positioned(
                child: Icon(
              selectedGunIndex.endsWith(rutGunu)
                  ? Icons.perm_contact_calendar_outlined
                  : Icons.calendar_month,
              color:gunInt==DateTime.now().weekday?Colors.orange:selectedGunIndex.endsWith(rutGunu)
                  ? Colors.white
                  : Colors.black,
            )),
            controllerRoutDetailUser.userHasPermitionEditRutSira?selectedGunIndex.endsWith(rutGunu)?Positioned(
              top: -5,
                right: -10,
                child:IconButton(
                  onPressed: (){
                    _intentRutSirasiScreen(rutGunu);
                  },
                  icon:  Icon(Icons.edit,color: Colors.red,size: 18,),
                )):SizedBox():SizedBox(),
          ],
        ),
      ),
    );
  }

  /// info ziyaretEdilmeyenler
  Widget _pageViewUmumiZiyeretEdilmeyenler() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listZiyeretEdilmeyenler.length,
        itemBuilder: (con, index) {
          return itemsCustomers(controllerRoutDetailUser.listZiyeretEdilmeyenler
              .elementAt(index));
        });
  }

  Widget infoZiyaretEdilmeyenler() {
    return Column(
      children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(top: 50, bottom: 60),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.red,
                          offset: Offset(0, 1),
                          spreadRadius: 0.1,
                          blurRadius: 2)
                    ],
                    color: Colors.white,
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        labeltext: "ziyaretEdilmeyen".tr,
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
                          CustomText(labeltext: "${"plan".tr} : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listZiyeretEdilmeyenler.fold(0, (sum, element) => sum + double.parse(element.plan.toString())))} ${"manatSimbol".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "satis".tr + " : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listZiyeretEdilmeyenler.fold(0, (sum, element) => sum + double.parse(element.netsatis.toString())))} ${"manatSimbol".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "zaymal".tr + " : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listZiyeretEdilmeyenler.fold(0, (sum, element) => sum + double.parse(element.qaytarma.toString())))} ${"manatSimbol".tr}"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 55,
                  right: 20,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                            labeltext:
                                "${controllerRoutDetailUser.listZiyeretEdilmeyenler.length} ${"musteri".tr}"),
                      )))
            ],
          ),
        )
      ],
    );
  }

  _onPageViewChange(int page) {
    setState(() {
      tabController.animateTo(page);
      //_controllerInfo.animateToPage(page, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      _controller.jumpToPage(page);
      _controllerIki.jumpToPage(page);
      _initialIndex==page;
      tabinitialIndex = page;
    });
  }


  ///ziyaret tarixleri
  Widget _pageViewZiyaretTarixcesi() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listTarixlerRx.length,
        itemBuilder: (con, index) {
          return itemZiyaretGunluk(
              controllerRoutDetailUser.listTarixlerRx.elementAt(index));
        });
  }

  Widget itemZiyaretGunluk(ModelGunlukGirisCixis model) {
    return InkWell(
      onTap: (){
        Get.toNamed(RouteHelper.screenZiyaretGirisCixis,arguments: [model,widget.modelMercBaza.first.mercadi,widget.modelMercBaza]);
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
                CustomText(labeltext: model.tarix,fontsize: 18,fontWeight: FontWeight.w700,),
                const SizedBox(height: 2,),
                const Divider(height: 1,color: Colors.black,),
                const SizedBox(height: 2,),
                Row(
                  children: [
                    CustomText(labeltext: "ziyaretSayi".tr+" : ",fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.girisSayi.toString()),
                  ],
                ),
                Row(
                  children: [
                    CustomText(labeltext: "isBaslama".tr+" : ",fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.iseBaslamaSaati.toString()),
                  ],
                ),
                Row(
                  children: [
                    CustomText(labeltext: "isbitme".tr+" : ",fontWeight: FontWeight.w600),
                    CustomText(labeltext: model.isiQutarmaSaati.toString()),
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
                                labeltext: "marketlerdeISvaxti".tr +" : ",
                              ),
                              CustomText(labeltext: model.sndeIsvaxti),
                            ],
                          ),
                          Row(
                            children: [
                              CustomText(
                                labeltext: "erazideIsVaxti".tr+" : ",
                              ),
                              CustomText(
                                labeltext: model.umumiIsVaxti,
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

  Widget infoZiyaretTarixcesi() {
    return Column(
      children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              Container(margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 50, bottom: 60),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 1),
                          spreadRadius: 0.1,
                          blurRadius: 2)
                    ],
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
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
                          CustomText(labeltext: "isgunleri".tr + " : "),
                          CustomText(
                              labeltext: controllerRoutDetailUser
                                      .listTarixlerRx.length
                                      .toString() +
                                  " " +
                                  "gun".tr),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "ziyaretSayi".tr + " : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.listTarixlerRx.fold(0, (sum, element) => sum + element.girisSayi)} ${"market".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "umumiIssaati".tr + " : "),
                          CustomText(
                              labeltext:
                                  controllerRoutDetailUser.totalIsSaati + " "),
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

  void _intentRutSirasiScreen(String rutGunu) {
    Get.toNamed(RouteHelper.getScreenMercRutSiraEdit(),arguments:[ controllerRoutDetailUser.listRutGunleri.value,rutGunu]);
  }

}
