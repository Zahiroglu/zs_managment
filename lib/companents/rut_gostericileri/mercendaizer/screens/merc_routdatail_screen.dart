import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zs_managment/companents/connected_users/model_main_inout.dart';
import 'package:zs_managment/companents/hesabatlar/widget_simplechart.dart';
import 'package:zs_managment/companents/local_bazalar/local_db_downloads.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/controller_mercpref.dart';
import 'package:zs_managment/companents/rut_gostericileri/mercendaizer/data_models/merc_data_model.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenMercRoutDatail extends StatefulWidget {

  MercDataModel modelMercBaza;
  List<ModelMainInOut> listGirisCixis;
  List<UserModel> listUsers;
  bool isMenumRutum;
  DrawerMenuController drawerMenuController;


  ScreenMercRoutDatail({required this.modelMercBaza,
    required this.listGirisCixis,
    required this.listUsers,
    required this.isMenumRutum,
    required this.drawerMenuController, super.key});

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
  int selectedRutGunu=1;
  int t=0; //Tid
  double p=0; //Position
  LocalUserServices userLocalService=LocalUserServices();
  LocalBaseDownloads localBaseDownloads = LocalBaseDownloads();

  @override
  void initState() {
    localBaseDownloads.init();
    userLocalService.init();
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
        _controllerIki.animateTo(_controller.position.pixels, duration: const Duration(milliseconds: 1000), curve:  Curves.easeOutCubic);
      });
    });
    if (controllerRoutDetailUser.initialized) {
      controllerRoutDetailUser.getAllCariler(widget.modelMercBaza, widget.listGirisCixis,widget.listUsers);
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
        selectedRutGunu=1;
        break;
      case 2:
        selectedGunIndex = "gun2".tr.toString();
        selectedRutGunu=2;
        break;
      case 3:
        selectedGunIndex = "gun3".tr.toString();
        selectedRutGunu=3;
        break;
      case 4:
        selectedGunIndex = "gun4".tr.toString();
        selectedRutGunu=4;
        break;
      case 5:
        selectedGunIndex = "gun5".tr.toString();
        selectedRutGunu=5;
        break;
      case 6:
        selectedGunIndex = "gun6".tr.toString();
        selectedRutGunu=6;
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
    if(widget.listGirisCixis.isNotEmpty) {
      if (controllerRoutDetailUser.listZiyeretEdilmeyenler.isNotEmpty) {
        listHeaderWidgets.add(infoZiyaretEdilmeyenler());
        listBodyWidgets.add(_pageViewUmumiZiyeretEdilmeyenler());
      }
      listHeaderWidgets.add(infoZiyaretTarixcesi());
      listBodyWidgets.add(_pageViewZiyaretTarixcesi());
    }}

  @override
  void dispose() {
    _animationController.dispose();
    tabController.dispose();
    _controller.dispose();
    Get.delete<ControllerMercPref>();
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
                  SliverSafeArea(
                    sliver: SliverAppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      centerTitle: false,
                      expandedHeight: tabinitialIndex == 0
                          ? 350
                          : tabinitialIndex == 1
                          ? 320
                          : 225,
                      pinned: true,
                      floating: false,
                      stretch: true,
                      leading:widget.isMenumRutum?IconButton(
                        onPressed: (){
                          widget.drawerMenuController.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ):null,
                      title: CustomText(
                          labeltext: widget.modelMercBaza.user!.name),
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
                  )
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
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listMercBaza.length,
        itemBuilder: (con, index) {
          return itemsCustomers(
              controllerRoutDetailUser.listMercBaza.elementAt(index),false);
        }));
  }

  Widget itemsCustomers(MercCustomersDatail element, bool rutSirasiGorunsun) {
    return InkWell(
      onTap: (){
        controllerRoutDetailUser.intentMercCustamersDatail(element,rutSirasiGorunsun);
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
                        labeltext: element.name!,
                        fontWeight: FontWeight.w600,
                        maxline: 2,
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
                      height: rutSirasiGorunsun?15:10,
                      width: rutSirasiGorunsun?15:10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: element.totalPlan! <
                              element.totalSelling!
                              ? Colors.green
                              : Colors.red),
                      child:rutSirasiGorunsun
                          ? Center(
                          child: CustomText(
                              color: rutSirasiGorunsun?Colors.white:Colors.black,
                              fontWeight: rutSirasiGorunsun?FontWeight.w700:FontWeight.normal,
                              labeltext:element.days!.firstWhere((e) => e.day==selectedRutGunu).orderNumber.toString())):const SizedBox(),
                    ),
                  )),
              Positioned(
                  top: 5,
                  right: 8,
                  child: Center(
                      child: CustomText(
                        labeltext: element.code.toString(),
                        fontsize: 10,
                        fontWeight: FontWeight.w700,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoMarketMotivasion(MercCustomersDatail element) {
    return DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"ziyaretSayi".tr} : ",
                                      fontsize: 12),
                                  CustomText(
                                      labeltext: element.ziyaretSayi.toString(),
                                      fontsize: 12),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    maxline: 2,
                                      labeltext: "${"marketdeISvaxti".tr} : ", fontsize: 12),
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
                        height: 65,
                        color: Colors.black,
                        width: 1,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                      ),
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
                                      labeltext: "${"plan".tr} : ", fontsize: 12),
                                  CustomText(
                                      labeltext:
                                          "${element.totalPlan} ${"manatSimbol".tr}",
                                      fontsize: 12),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"satis".tr} : ", fontsize: 12),
                                  CustomText(
                                      labeltext:
                                          "${element.totalSelling} ${"manatSimbol".tr}",
                                      fontsize: 12),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      labeltext: "${"zaymal".tr} : ", fontsize: 12),
                                  CustomText(
                                      labeltext:
                                          "${element.totalRefund} ${"manatSimbol".tr}",
                                      fontsize: 12),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 5, child: chartWidget(element)),
                    ],
                  )
                ],
              ),
             element.sellingDatas!.length>1?const Positioned(
                  bottom: -2,
                  right: -2,
                  child: Icon(Icons.expand_circle_down,color: Colors.blue,)):const SizedBox()
            ],
          ),
        ));
  }

  Widget _infoMarketRout(MercCustomersDatail element) {
    int valuMore = 0;
    if (element.days!.any((element) => element.day==1)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==2)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==3)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==4)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==5)) {
      valuMore = valuMore + 1;
    }
    if (element.days!.any((element) => element.day==6)) {
      valuMore = valuMore + 1;
    }
    return SizedBox(
      height: valuMore > 4 ? 60 : 28,
      width: 250,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          element.days!.any((element) => element.day==1)
              ? WidgetRutGunu(rutGunu: "gun1".tr,loggedUserModel: userLocalService.getLoggedUser(),)
              : const SizedBox(),
          element.days!.any((element) => element.day==2)
              ? WidgetRutGunu(rutGunu: "gun2".tr,loggedUserModel: userLocalService.getLoggedUser())
              : const SizedBox(),
          element.days!.any((element) => element.day==3)
              ? WidgetRutGunu(rutGunu: "gun3".tr,loggedUserModel: userLocalService.getLoggedUser())
              : const SizedBox(),
          element.days!.any((element) => element.day==4)
              ? WidgetRutGunu(rutGunu: "gun4".tr,loggedUserModel: userLocalService.getLoggedUser())
              : const SizedBox(),
          element.days!.any((element) => element.day==5)
              ? WidgetRutGunu(rutGunu: "gun5".tr,loggedUserModel: userLocalService.getLoggedUser())
              : const SizedBox(),
          element.days!.any((element) => element.day==6)
              ? WidgetRutGunu(rutGunu: "gun6".tr,loggedUserModel: userLocalService.getLoggedUser())
              : const SizedBox(),
          element.days!.any((element) => element.day==7)
              ? WidgetRutGunu(rutGunu: "bagli".tr,loggedUserModel: userLocalService.getLoggedUser())
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget infoSatisMenu() {
    return Obx(() => SingleChildScrollView(
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
                          labeltext: controllerRoutDetailUser.selectedMercBaza.value.user!.code,
                          fontsize: 16,
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
                          "${controllerRoutDetailUser.listMercBaza.length} ${"market".tr}",
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
                                    "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listMercBaza.fold(0.0, (sum, element) => sum + element.totalPlan!))} ${"manatSimbol".tr}",
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
                                          "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listMercBaza.fold(0.0, (sum, element) => sum + element.totalSelling!))} ${"manatSimbol".tr}",
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
                                    "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listMercBaza.fold(0.0, (sum, element) => sum + element.totalRefund!))} ${"manatSimbol".tr}",
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
    ));
  }

  Widget _widgetMotivasiya()  {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(labeltext: "motivasiya".tr, fontWeight: FontWeight.w700),
                    CustomText(labeltext: "${"sonYenilenme".tr} ${localBaseDownloads.getLastUpdatedFieldDate("enter")}", fontWeight: FontWeight.w700),
                  ],
                ),
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
                              labeltext: "netSatisdan".tr,
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
                              labeltext: "plandan".tr,
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
                              labeltext: "planFaizle".tr,
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
                              labeltext: "zayMaldan".tr,
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
                              labeltext: "zaymalFaizle".tr,
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

  Widget chartWidget(MercCustomersDatail element) {
    bool satiskecib = double.parse(element.totalSelling.toString()).round() >
        double.parse(element.totalPlan.toString()).round();
    final List<ChartData> chartData = [
      ChartData(
          "plan".tr, element.totalSelling!.round(), Colors.green),
      ChartData(
          'satis'.tr,
          satiskecib
              ? 0
              : element.totalPlan!.round() -
                  element.totalPlan!.round(),
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
              element.totalPlan ==0
                  ? const SizedBox()
                  : CustomText(
                      labeltext:
                          "${controllerRoutDetailUser.prettify(element.totalSelling!.round() / element.totalPlan!.round() * 100)} %",
                      fontsize: 12,
                    )
            ],
          );
  }

  /// info rutgunleri musteriler
  Widget _pageViewUmumiRutGunleri() {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listRutGunleri.length,
        itemBuilder: (con, index) {
          return itemsCustomers(
              controllerRoutDetailUser.listRutGunleri.elementAt(index),true);
        }));
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
                            controllerRoutDetailUser.listMercBaza
                                .where((p0) => p0.days!.any((element) => element.day==1))
                                .toList()
                                .length,1),
                        _itemIndoMenuRutGunu(
                            "gun2".tr.toString(),
                            controllerRoutDetailUser.listMercBaza
                                .where((p0) => p0.days!.any((element) => element.day==2))
                                .toList()
                                .length,2),
                        _itemIndoMenuRutGunu(
                            "gun3".tr.toString(),
                            controllerRoutDetailUser.listMercBaza
                                .where((p0) => p0.days!.any((element) => element.day==3))
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
                            controllerRoutDetailUser.listMercBaza
                                .where((p0) => p0.days!.any((element) => element.day==4))
                                .toList()
                                .length,4),
                        _itemIndoMenuRutGunu(
                            "gun5".tr.toString(),
                            controllerRoutDetailUser.listMercBaza
                                .where((p0) => p0.days!.any((element) => element.day==5))
                                .toList()
                                .length,5),
                        controllerRoutDetailUser.listMercBaza
                            .where((p0) => p0.days!.any((element) => element.day==6))
                            .toList().isEmpty?const SizedBox():_itemIndoMenuRutGunu(
                            "gun6".tr.toString(),
                            controllerRoutDetailUser.listMercBaza
                                .where((p0) => p0.days!.any((element) => element.day==7))
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
        selectedRutGunu=gunInt;
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
                  labeltext: "$length ${"market".tr}",
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
            controllerRoutDetailUser.userHasPermitionEditRutSira?selectedGunIndex.endsWith(rutGunu)?userLocalService.getLoggedUser().userModel!.permissions!.any((element) => element.id==28)?Positioned(
              top: -5,
                right: -10,
                child:IconButton(
                  onPressed: (){
                    _intentRutSirasiScreen(rutGunu,gunInt);
                  },
                  icon:  const Icon(Icons.edit,color: Colors.red,size: 18,),
                )):SizedBox():const SizedBox():const SizedBox(),
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
              .elementAt(index),false);
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
                  padding: const EdgeInsets.all(10.0),
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
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listZiyeretEdilmeyenler.fold(0, (sum, element) => sum + element.totalPlan!))} ${"manatSimbol".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"satis".tr} : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listZiyeretEdilmeyenler.fold(0, (sum, element) => sum + element.totalSelling!))} ${"manatSimbol".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"zaymal".tr} : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.prettify(controllerRoutDetailUser.listZiyeretEdilmeyenler.fold(0, (sum, element) => sum + element.totalRefund!))} ${"manatSimbol".tr}"),
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
        itemCount: controllerRoutDetailUser.listGunlukGirisCixislar.length,
        itemBuilder: (con, index) {
          return itemZiyaretGunluk(
              controllerRoutDetailUser.listGunlukGirisCixislar.elementAt(index));
        });
  }

  Widget itemZiyaretGunluk(ModelInOutDay model) {
    return InkWell(
      onTap: (){
        Get.toNamed(RouteHelper.screenZiyaretGirisCixis,arguments: [model,widget.modelMercBaza.user!.name,widget.modelMercBaza.mercCustomersDatail!]);
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
                          CustomText(labeltext: "${"isgunleri".tr} : "),
                          CustomText(
                              labeltext: "${controllerRoutDetailUser
                                      .listGunlukGirisCixislar.length} ${"gun".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"ziyaretSayi".tr} : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.listGunlukGirisCixislar.fold(0, (sum, element) => sum + element.visitedCount)} ${"market".tr}"),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(labeltext: "${"umumiIssaati".tr} : "),
                          CustomText(
                              labeltext:
                                  "${controllerRoutDetailUser.totalIsSaati} "),
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

  void _intentRutSirasiScreen(String rutGunu, int gunInt) {
    Get.toNamed(RouteHelper.getScreenMercRutSiraEdit(),arguments:[ controllerRoutDetailUser.listRutGunleri,rutGunu,gunInt,widget.modelMercBaza.user!.code]);
  }

}
