import 'package:flutter/material.dart';
import 'package:zs_managment/companents/base_downloads/models/model_cariler.dart';
import 'package:zs_managment/companents/connected_users/controller_rout_detail_user.dart';
import 'package:zs_managment/companents/connected_users/exp_rout_datail/controller_exppref.dart';
import 'package:zs_managment/companents/giris_cixis/controller_giriscixis_yeni.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/ziyaret_tarixcesi/model_gunluk_giriscixis.dart';
import 'package:zs_managment/routs/rout_controller.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:zs_managment/widgets/widget_rutgunu.dart';

class ScreenUserRoutPerform extends StatefulWidget {
  ControllerRoutDetailUser controllerRoutDetailUser;
  UserModel userModel;
  List<UserModel> listUsers;

  ScreenUserRoutPerform({required this.controllerRoutDetailUser,required this.userModel,required this.listUsers, super.key});

  @override
  State<ScreenUserRoutPerform> createState() => _ScreenUserRoutPerformState();
}

class _ScreenUserRoutPerformState extends State<ScreenUserRoutPerform>
    with TickerProviderStateMixin {
  ControllerExpPref controllerRoutDetailUser = Get.put(ControllerExpPref());
  bool mustSearch = false;
  var _scrollControllerNested;
  int tabinitialIndex = 0;
  late TabController tabController;
  late PageController _controller;
  late PageController _controllerIki;
  String selectedGunIndex = "1-ci Gun";
  final int _initialIndex = 0;
  late AnimationController _animationController;
  List<Widget> listHeaderWidgets = [];
  List<Widget> listBodyWidgets = [];

  @override
  void initState() {
    melumatlariGuneGoreDoldur();
    _scrollControllerNested = ScrollController();
    _controller =
        PageController(initialPage: _initialIndex, viewportFraction: 1);
    _controllerIki =
        PageController(initialPage: _initialIndex, viewportFraction: 1);
    _controllerIki.addListener(() {
      setState(() {});
    });
    _controller.addListener(() {
      setState(() {
        _controllerIki.animateTo(_controller.position.pixels,
            duration: Duration(milliseconds: 1000), curve: Curves.easeOutCubic);
      });
    });
    if (controllerRoutDetailUser.initialized) {
      controllerRoutDetailUser.getAllCariler(widget.controllerRoutDetailUser.listFilteredCustomers, widget.controllerRoutDetailUser.listGirisCixis,widget.listUsers);
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
    // TODO: implement initState
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
    setState(() {});
  }

  void fillAllPages() {
    listBodyWidgets.clear();
    listHeaderWidgets.clear();
    listHeaderWidgets.add(_infoUmumiCariler(widget.controllerRoutDetailUser.listFilteredCustomers.first));
    listHeaderWidgets.add(infoRutGunleri());
    listBodyWidgets.add(_pageViewUmumiCariler());
    listBodyWidgets.add(_pageViewUmumiRutGunleri());
    if (controllerRoutDetailUser.listZiyeretEdilmeyenler.isNotEmpty) {
      listHeaderWidgets.add(infoZiyaretEdilmeyenler());
      listBodyWidgets.add(_pageViewUmumiZiyeretEdilmeyenler());
    }
   listHeaderWidgets.add(infoZiyaretTarixcesi());
    listBodyWidgets.add(_pageViewZiyaretTarixcesi());
  }

  @override
  void dispose() {
    Get.delete<ControllerExpPref>;
    // TODO: implement dispose
    super.dispose();
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
                Obx(() => SliverSafeArea(
                      sliver: SliverAppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        centerTitle: false,
                        expandedHeight: tabinitialIndex == 0
                            ? 300
                            : tabinitialIndex == 1
                                ? 320
                                : tabinitialIndex == 2?180:240,
                        pinned: true,
                        floating: false,
                        stretch: true,
                        actions: [IconButton(onPressed: (){
                          Get.toNamed(RouteHelper.screenExpRoutDetailMap,arguments: controllerRoutDetailUser);
                        }, icon:Icon( Icons.map))],
                        title: CustomText(
                            labeltext: widget.userModel.name!),
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

  _onPageViewChange(int page) {
    setState(() {
      tabController.animateTo(page);
      //_controllerInfo.animateToPage(page, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      _controller.jumpToPage(page);
      _controllerIki.jumpToPage(page);
      _initialIndex == page;
      tabinitialIndex = page;
    });
  }

  /// umumi CarilerHissesi

  Widget _pageViewUmumiCariler() {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listFilteredUmumiBaza.length,
        itemBuilder: (con, index) {
          return customersListItems(
              controllerRoutDetailUser.listFilteredUmumiBaza.elementAt(index));
        }));
  }
  Widget customersListItems(ModelCariler element) {
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
    return InkWell(
      onTap: () {
        controllerRoutDetailUser.showEditDialog(element, context);
      },
      child: Card(
          elevation: 10,
          color: Get.isDarkMode ? Colors.black : Colors.white,
          margin: const EdgeInsets.all(10),
          shadowColor: Colors.blue,
          borderOnForeground: true,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 15, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      labeltext: element.name!,
                      fontWeight: FontWeight.w600,
                      maxline: 2,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        CustomText(
                          labeltext: "${"mesulsexs".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        Expanded(
                            child: CustomText(
                                labeltext: element.ownerPerson!,
                                overflow: TextOverflow.clip,
                                maxline: 2,
                                fontsize: 12)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          labeltext: "${"Rut gunu".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          height: valuMore > 4 ? 60 : 25,
                          width: 250,
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            children: [
                              element.days!.any((e) => e.day==1)
                                  ? WidgetRutGunu(rutGunu: "gun1".tr)
                                  : const SizedBox(),
                              element.days!.any((e) => e.day==2)
                                  ? WidgetRutGunu(rutGunu: "gun2".tr)
                                  : const SizedBox(),
                              element.days!.any((e) => e.day==3)
                                  ? WidgetRutGunu(rutGunu: "gun3".tr)
                                  : const SizedBox(),
                              element.days!.any((e) => e.day==4)
                                  ? WidgetRutGunu(rutGunu: "gun4".tr)
                                  : const SizedBox(),
                              element.days!.any((e) => e.day==5)
                                  ? WidgetRutGunu(rutGunu: "gun5".tr)
                                  : const SizedBox(),
                              element.days!.any((e) => e.day==6)
                                  ? WidgetRutGunu(rutGunu: "gun6".tr)
                                  : const SizedBox(),
                              element.days!.any((e) => e.day==7)
                                  ? WidgetRutGunu(rutGunu: "bagli".tr)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          labeltext: "${"borc".tr} : ",
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        Expanded(
                            child: CustomText(
                          labeltext: "${element.debt!} ${"manatSimbol".tr}",
                          overflow: TextOverflow.clip,
                          maxline: 2,
                          fontsize: 12,
                          color: element.debt.toString() == "0" ||
                                  element.debt.toString().contains("-")
                              ? Colors.blue
                              : Colors.red,
                          fontWeight: FontWeight.w700,
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: element.ziyaretSayi==0?Colors.red:Colors.blue, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    labeltext: "ziyaretSayi".tr +" : ",
                                  ),
                                  CustomText(labeltext: element.ziyaretSayi.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    labeltext: "umumiIssaati".tr+" : ",
                                  ),
                                  CustomText(
                                    labeltext: element.sndeQalmaVaxti.toString(),
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
              Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: element.action == false
                            ? Colors.red
                            : Colors.green),
                    child: element.days!.any((e) => e.orderNumber==0)
                        ? const SizedBox()
                        : Center(
                            child: CustomText(
                            labeltext: element.days!.first.orderNumber.toString() ?? "0",
                            color: Colors.white,
                          )),
                  )),
              Positioned(
                  right: 2,
                  top: 2,
                  child: Row(
                    children: [
                      CustomText(labeltext: element.code!, fontsize: 10),
                      InkWell(
                          onTap: () {
                            Get.toNamed(
                                RouteHelper.getwidgetScreenMusteriDetail(),
                                arguments: [
                                  element,
                                  widget.controllerRoutDetailUser.availableMap
                                      .value
                                ]);
                          },
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.blue,
                            size: 20,
                          )),
                    ],
                  ))
            ],
          )),
    );
  }
  Widget _infoUmumiCariler(ModelCariler element) {
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
                          labeltext: element.forwarderCode!,
                          fontsize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Obx(() => _widgetUmumiCariTapItems(
                            "umumiMusteri".tr, 0, Colors.blue),),
                       Obx(() =>  _widgetUmumiCariTapItems(
                           "passivMusteri".tr, 1, Colors.orangeAccent),),
                        Obx(() =>   _widgetUmumiCariTapItems(
                            "bagliMusteri".tr, 2, Colors.black),),
                        Obx(() => _widgetUmumiCariTapItems(
                            "rutsuzMusteri".tr, 3, Colors.red),)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  searchField(context),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget searchField(BuildContext context) {
    return SizedBox(
        height: 40,
        width: double.infinity,
        child: TextField(
          controller: controllerRoutDetailUser.ctSearch,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          onChanged: (st) {
            controllerRoutDetailUser.filterCustomersBySearchView(st);
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: "axtar".tr,
            contentPadding: const EdgeInsets.all(0),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.redAccent)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ));
  }
  _widgetUmumiCariTapItems(String s, int tip, Color color) {
    int customersCount = 0;
    if (tip == 0) {
      customersCount = controllerRoutDetailUser.listSelectedExpBaza.length;
    } else if (tip == 1) {
      customersCount = controllerRoutDetailUser.listSelectedExpBaza
          .where((p0) => p0.action == false)
          .length;
    } else if (tip == 2) {
      customersCount = controllerRoutDetailUser.listSelectedExpBaza
          .where((p0) => p0.days!.any((element) => element.day==7))
          .length;
    } else {
      customersCount = controllerRoutDetailUser.listSelectedExpBaza
          .where((p0) =>
      !p0.days!.any((element) => element.day==1)&&
          !p0.days!.any((element) => element.day==2)&&
          !p0.days!.any((element) => element.day==3)&&
          !p0.days!.any((element) => element.day==4)&&
          !p0.days!.any((element) => element.day==5)&&
          !p0.days!.any((element) => element.day==6)&&
          !p0.days!.any((element) => element.day==7))
          .length;
    }
    return InkWell(
      onTap: () {
        _changeUmumiTabItem(tip);
      },
      child: Obx(() => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            padding: const EdgeInsets.all(5),
            height: controllerRoutDetailUser.selectedUmumiMusterilerTabIndex.value == tip
                ? 65
                : 60,
            width: controllerRoutDetailUser
                        .selectedUmumiMusterilerTabIndex.value ==
                    tip
                ? 110
                : 100,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: controllerRoutDetailUser
                                  .selectedUmumiMusterilerTabIndex.value ==
                              tip
                          ? Colors.green
                          : Colors.grey,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 4)
                ],
                color: controllerRoutDetailUser
                            .selectedUmumiMusterilerTabIndex.value ==
                        tip
                    ? color
                    : Colors.white,
                border: Border.all(color: color, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    color: controllerRoutDetailUser
                                .selectedUmumiMusterilerTabIndex.value ==
                            tip
                        ? Colors.white
                        : Get.isDarkMode
                            ? Colors.white
                            : Colors.black,
                    labeltext: s,
                    fontWeight: FontWeight.w700,
                    maxline: 2,
                    textAlign: TextAlign.center,
                    fontsize: controllerRoutDetailUser
                                .selectedUmumiMusterilerTabIndex.value ==
                            tip
                        ? 14
                        : 12),
                Divider(
                  height: 1,
                  color: controllerRoutDetailUser
                              .selectedUmumiMusterilerTabIndex.value ==
                          tip
                      ? Colors.white
                      : Colors.black,
                ),
                CustomText(
                  color: controllerRoutDetailUser
                              .selectedUmumiMusterilerTabIndex.value ==
                          tip
                      ? Colors.white
                      : Get.isDarkMode
                          ? Colors.white
                          : Colors.black,
                  labeltext: customersCount.toString(),
                  fontWeight: FontWeight.bold,
                  fontsize: 14,
                )
              ],
            ),
          )),
    );
  }
  _changeUmumiTabItem(int tip) {
    controllerRoutDetailUser.changeSelectedUmumiMusteriler(tip);
    setState(() {});
  }

  /// rut gunleri baza
  Widget _pageViewUmumiRutGunleri() {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listRutGunleri.length,
        itemBuilder: (con, index) {
          return customersListItems(
              controllerRoutDetailUser.listRutGunleri.elementAt(index));
        }));
  }
  Widget infoRutGunleri() {
    return SingleChildScrollView(
      child: Stack(
        children: [
         Obx(() =>  Container(
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
                           controllerRoutDetailUser.listSelectedExpBaza
                               .where((p0) => !p0.days!.any((element) => element.day==1))
                               .toList()
                               .length,1),
                       _itemIndoMenuRutGunu(
                           "gun2".tr.toString(),
                           controllerRoutDetailUser.listSelectedExpBaza
                               .where((p0) => !p0.days!.any((element) => element.day==2))
                               .toList()
                               .length,2),
                       _itemIndoMenuRutGunu(
                           "gun3".tr.toString(),
                           controllerRoutDetailUser.listSelectedExpBaza
                               .where((p0) => !p0.days!.any((element) => element.day==3))
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
                           controllerRoutDetailUser.listSelectedExpBaza
                               .where((p0) => !p0.days!.any((element) => element.day==4))
                               .toList()
                               .length,4),
                       _itemIndoMenuRutGunu(
                           "gun5".tr.toString(),
                           controllerRoutDetailUser.listSelectedExpBaza
                               .where((p0) => !p0.days!.any((element) => element.day==5))
                               .toList()
                               .length,5),
                       _itemIndoMenuRutGunu(
                           "gun6".tr.toString(),
                           controllerRoutDetailUser.listSelectedExpBaza
                               .where((p0) => !p0.days!.any((element) => element.day==6))
                               .toList()
                               .length,6),
                     ],
                   ),
                 )
               ],
             ),
           ),
         ),)
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
  void _intentRutSirasiScreen(String rutGunu) {
    Get.toNamed(RouteHelper.getScreenExpRutSiraEdit(),arguments:[ controllerRoutDetailUser.listRutGunleri.value,rutGunu]);
  }

  /// ziyaretEdilmeyenler menu
  Widget _pageViewUmumiZiyeretEdilmeyenler() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: controllerRoutDetailUser.listZiyeretEdilmeyenler.length,
        itemBuilder: (con, index) {
          return customersListItems(controllerRoutDetailUser.listZiyeretEdilmeyenler
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
        Get.toNamed(RouteHelper.screenZiyaretGirisCixisExp,arguments: [model,controllerRoutDetailUser.listSelectedExpBaza.first.forwarderCode,controllerRoutDetailUser.listSelectedExpBaza]);
      },
      child: Card(
        margin: const EdgeInsets.all(10).copyWith(left: 15,right: 15),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(0.0).copyWith(left: 0,right: 0),
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
      ),
    );
  }
  Widget infoZiyaretTarixcesi() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
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
          )
        ],
      ),
    );
  }
}
